# AF4A1 Spanish Reference Voice Evaluation
Status: EVIDENCE
Scope: Spanish audio production / AF4 evidence
Normative authority: AUDIO_LEARNING_STANDARD.md

This is a temporary naturalness comparison before any AF4A corpus
regeneration. The canonical AF4A WAV files remain untouched.

## QA reset

The three AF1 baseline IDs verified from Git history are preserved as
`approved`:

* `es.audio.phrase.hola`
* `es.audio.phrase.me_llamo`
* `es.audio.question.como_te_llamas`

The 114 AF4A IDs remain `generated`. No AF4A asset is approved by this pass.

## Piper capabilities

The installed Piper supports `--speaker`, `--length-scale`, `--noise-scale`,
`--noise-w-scale`, `--sentence-silence`, `--volume`, `--cuda`, and
`--no-normalize`, in addition to model/config/input/output options. Both
installed Spanish models report `speaker: null`, so no speaker variation was
used.

## Evaluation profiles

| Profile | Voice | Parameters | Reason |
| --- | --- | --- | --- |
| A | `es_ES-sharvard-medium` | sentence silence `0.2` | Current AF4A baseline/default voice |
| B | `es_ES-sharvard-medium` | sentence silence `0.2`, length scale `1.08`, noise width `0.75` | Modestly slower, slightly steadier prosody |
| C | `es_ES-davefx-medium` | sentence silence `0.2` | Required alternative Spanish candidate |

## Listening set

The exact 10 course utterances are listed in
[`AF4A1_AUDIO_EVALUATION.tsv`](AF4A1_AUDIO_EVALUATION.tsv). They cover short
greetings, a word/name, statements, questions, dialogue turns, names/places,
coordination, and a longer declarative sentence.

## Temporary files and listening

Generation created 30 WAV files under `/tmp/tutor_audio_voice_eval` and one
continuous playlist per profile. The files are not application assets.

Interactive comparison:

```bash
cd ~/Tutor_Language/app
bash tool/audio_voice_eval.sh interactive /tmp/tutor_audio_voice_eval
```

The controls are `1/2/3` to replay A/B/C, `a/b/c` to record a preference in
the temporary directory, `n` for the next utterance, and `q` to quit.

Continuous playlists:

```bash
ffplay -nodisp -autoexit /tmp/tutor_audio_voice_eval/profile_A_continuous.wav
ffplay -nodisp -autoexit /tmp/tutor_audio_voice_eval/profile_B_continuous.wav
ffplay -nodisp -autoexit /tmp/tutor_audio_voice_eval/profile_C_continuous.wav
```

The reviewer should judge naturalness, rhythm, connected speech, question
intonation, sentence prosody, pronunciation, beginner clarity, and repeated
listening fatigue. No automatic winner is selected.

## Future full regeneration

After explicit human profile selection, the AF1 staging command for the
baseline/default profile is:

```bash
cd ~/Tutor_Language/app
dart run tool/audio_reference.dart --generate \
  --piper-command ../.venv-piper/bin/piper \
  --voice-dir /home/master/.local/share/piper-voices \
  --output-dir /tmp/af4a-full-regeneration
```

This command is intentionally not run by AF4A1. A non-default profile must
first be wired into the authoring command with its selected supported Piper
parameters; stable IDs and content wiring stay unchanged.

The eventual course QA should be lesson-oriented and continuous: play all
references in lesson order, print ID/transcript before each file, and record
only problematic IDs for later targeted handling. Batch approval must happen
only after the human has completed that listening pass.
