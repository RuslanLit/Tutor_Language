#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"
output_dir="${2:-/tmp/tutor_audio_voice_eval}"
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
inventory="${repo_dir}/../docs/AF4A1_AUDIO_EVALUATION.tsv"
piper="${PIPER_COMMAND:-${repo_dir}/../.venv-piper/bin/piper}"
voice_dir="${PIPER_VOICE_DIR:-/home/master/.local/share/piper-voices}"
profile_b_config="${repo_dir}/tool/audio_reference_profile_b.json"
final_inventory="${repo_dir}/../docs/AF4A2_AUDIO_PROFILE_B_VALIDATION.tsv"

die() {
  echo "error: $*" >&2
  exit 1
}

profile_model() {
  case "$1" in
    A) printf '%s/es_ES-sharvard-medium.onnx' "$voice_dir" ;;
    B) printf '%s/%s.onnx' "$voice_dir" "$(jq -r '.voice' "$profile_b_config")" ;;
    C) printf '%s/es_ES-davefx-medium.onnx' "$voice_dir" ;;
    *) die "unknown profile: $1" ;;
  esac
}

profile_b_args() {
  jq -r '
    [
      "--length-scale", (.parameters.lengthScale | tostring),
      "--noise-scale", (.parameters.noiseScale | tostring),
      "--noise-w-scale", (.parameters.noiseWScale | tostring),
      "--sentence-silence", (.parameters.sentenceSilence | tostring),
      "--volume", (.parameters.volume | tostring)
    ] | .[]' "$profile_b_config"
}

generate_profile() {
  local profile="$1"
  local model
  model="$(profile_model "$profile")"
  mkdir -p "${output_dir}/profile_${profile}"
  while IFS=$'\t' read -r number audio_id transcript category; do
    [[ "$number" == "number" ]] && continue
    local target="${output_dir}/profile_${profile}/${audio_id}.wav"
    local -a args=(--model "$model" --sentence-silence 0.2)
    case "$profile" in
      B) mapfile -t profile_args < <(profile_b_args); args+=("${profile_args[@]}") ;;
    esac
    printf '%s\n' "$transcript" |
      "$piper" "${args[@]}" --output-file "$target" >/dev/null
  done < "$inventory"
}

final_b_generate() {
  [[ -f "$final_inventory" ]] || die "final validation inventory not found: $final_inventory"
  mkdir -p "$output_dir"
  local model
  model="$(profile_model B)"
  local -a profile_args
  mapfile -t profile_args < <(profile_b_args)
  while IFS=$'\t' read -r id source_text source_location category test_reason wav_path human_result notes; do
    [[ "$id" == "id" ]] && continue
    local target="${output_dir}/$(basename "$wav_path")"
    printf '%s\n' "$source_text" |
      "$piper" --model "$model" "${profile_args[@]}" \
      --output-file "$target" >/dev/null
  done < "$final_inventory"
  echo "generated 20 Profile-B validation WAV files under $output_dir"
}

final_b_playlist() {
  [[ -d "$output_dir" ]] || die "run final-b-generate first: $output_dir"
  local playlist_file="${output_dir}/profile_B_final_playlist.txt"
  local silence="${output_dir}/.silence.wav"
  ffmpeg -hide_banner -loglevel error -y -f lavfi \
    -i anullsrc=r=22050:cl=mono -t 0.7 -c:a pcm_s16le "$silence"
  : > "$playlist_file"
  while IFS=$'\t' read -r id source_text source_location category test_reason wav_path human_result notes; do
    [[ "$id" == "id" ]] && continue
    printf "file '%s'\nfile '%s'\n" \
      "${output_dir}/$(basename "$wav_path")" "$silence" \
      >> "$playlist_file"
  done < "$final_inventory"
  local output="${output_dir}/profile_B_final_continuous.wav"
  ffmpeg -hide_banner -loglevel error -y -f concat -safe 0 \
    -i "$playlist_file" -c copy "$output"
  echo "$output"
}

play_file() {
  local profile="$1"
  local audio_id="$2"
  ffplay -nodisp -autoexit -loglevel error \
    "${output_dir}/profile_${profile}/${audio_id}.wav"
}

interactive() {
  [[ -d "$output_dir/profile_A" ]] || die "run generate first: $output_dir"
  while IFS=$'\t' read -r number audio_id transcript category; do
    [[ "$number" == "number" ]] && continue
    while true; do
      printf '\n[%s/10] %s\n%s\n' "$number" "$audio_id" "$transcript"
      printf '[1] A  [2] B  [3] C  [a/b/c] preference  [n] next  [q] quit: '
      IFS= read -r -n 1 action
      printf '\n'
      case "$action" in
        1) play_file A "$audio_id" ;;
        2) play_file B "$audio_id" ;;
        3) play_file C "$audio_id" ;;
        a|b|c)
          printf '%s\t%s\t%s\n' "$audio_id" "$action" "$transcript" \
            >> "${output_dir}/preferences.tsv"
          echo "recorded preference: $action" ;;
        n) break ;;
        q) exit 0 ;;
        *) echo "use 1, 2, 3, a, b, c, n or q" ;;
      esac
    done
  done < "$inventory"
}

playlist() {
  local profile="$1"
  [[ "$profile" =~ ^[ABC]$ ]] || die "playlist profile must be A, B or C"
  local playlist_file="${output_dir}/profile_${profile}_playlist.txt"
  local silence="${output_dir}/.silence.wav"
  mkdir -p "$output_dir"
  ffmpeg -hide_banner -loglevel error -y -f lavfi \
    -i anullsrc=r=22050:cl=mono -t 0.7 -c:a pcm_s16le "$silence"
  : > "$playlist_file"
  while IFS=$'\t' read -r number audio_id transcript category; do
    [[ "$number" == "number" ]] && continue
    printf "file '%s'\nfile '%s'\n" \
      "${output_dir}/profile_${profile}/${audio_id}.wav" "$silence" \
      >> "$playlist_file"
  done < "$inventory"
  local output="${output_dir}/profile_${profile}_continuous.wav"
  ffmpeg -hide_banner -loglevel error -y -f concat -safe 0 \
    -i "$playlist_file" -c copy "$output"
  echo "${output}"
  ffplay -nodisp -autoexit -loglevel error "$output"
}

case "$mode" in
  generate)
    command -v "$piper" >/dev/null || die "Piper not found: $piper"
    [[ -f "$inventory" ]] || die "evaluation inventory not found: $inventory"
    rm -rf "$output_dir"
    mkdir -p "$output_dir"
    generate_profile A
    generate_profile B
    generate_profile C
    echo "generated 30 evaluation WAV files under $output_dir"
    ;;
  interactive)
    interactive
    ;;
  playlist)
    playlist "${3:-}"
    ;;
  final-b-generate)
    command -v "$piper" >/dev/null || die "Piper not found: $piper"
    rm -rf "$output_dir"
    final_b_generate
    ;;
  final-b-playlist)
    final_b_playlist
    ;;
  *)
    echo "usage: $0 generate [output-dir]"
    echo "       $0 interactive [output-dir]"
    echo "       $0 playlist [output-dir] A|B|C"
    echo "       $0 final-b-generate [output-dir]"
    echo "       $0 final-b-playlist [output-dir]"
    exit 2
    ;;
esac
