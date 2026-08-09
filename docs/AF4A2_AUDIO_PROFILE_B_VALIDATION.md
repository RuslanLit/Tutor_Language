# AF4A2 Profile B Validation — PASS
Status: EVIDENCE
Scope: Spanish audio production / AF4 evidence
Normative authority: AUDIO_LEARNING_STANDARD.md

Human listening validation passed for all 20 rows in
[`AF4A2_AUDIO_PROFILE_B_VALIDATION.tsv`](AF4A2_AUDIO_PROFILE_B_VALIDATION.tsv).
The reviewer heard no obvious pronunciation, stress, truncation, pause,
cadence, question-intonation, or fatigue defects.

Profile B is now the canonical Spanish Piper production profile:

```text
voice: es_ES-sharvard-medium
speaker: none
length-scale: 1.08
noise-scale: 0.667
noise-w-scale: 0.75
sentence-silence: 0.2
volume: 1.0
```

The source of truth is
[`app/tool/audio_reference_profile_b.json`](../app/tool/audio_reference_profile_b.json).
Profile A (`es_ES-sharvard-medium` default/slightly faster settings) remains
fallback/reference only. Profile C (`es_ES-davefx-medium`) is rejected and is
not a production candidate.

## Coverage

The 20-item validation set covers isolated vocabulary, short phrases,
declarative sentences, questions, sentence-final interrogative intonation,
punctuation, accented vowels, `ñ`, `ll/y`, `que/qui`, proper names, places,
coordination, and longer beginner sentences. Two diagnostic-only items cover
`j/ge/gi` and `rr`, which are not represented adequately in the current
course. No diagnostic item is added to production content.

## Human QA result

All rows are marked `human_result=pass`. PASS required:

* no obvious pronunciation error;
* understandable stress and no word truncation;
* no unnatural internal silence;
* usable question intonation;
* speed appropriate for A0/A1;
* clear isolated words;
* longer phrases not unnaturally slow;
* consistent voice over a continuous sequence;
* no recurring artifact teaching an incorrect pronunciation pattern.

FAIL would be recorded for any recurring pronunciation, stress, truncation,
pause, cadence, question-contour, speed, artifact, or listening-fatigue defect.

## Listening files

The individual validation WAVs and continuous playlist are temporary:

```text
/tmp/tutor_audio_voice_eval_b_final/
/tmp/tutor_audio_voice_eval_b_final/profile_B_final_continuous.wav
```

To replay the continuous validation sequence:

```bash
ffplay -nodisp -autoexit \
  /tmp/tutor_audio_voice_eval_b_final/profile_B_final_continuous.wav
```

## Production regeneration

The 114 AF4A generated entries can now be regenerated into staging with:

```bash
cd ~/Tutor_Language/app
dart run tool/audio_reference.dart --generate \
  --profile-config tool/audio_reference_profile_b.json \
  --piper-command ../.venv-piper/bin/piper \
  --voice-dir /home/master/.local/share/piper-voices \
  --output-dir /tmp/af4a-profile-b-regeneration
```

The three original AF1 approved assets remain excluded from regeneration by
the existing approved-asset skip rule. This document records the human gate;
the regeneration is performed separately by AF4A3.
