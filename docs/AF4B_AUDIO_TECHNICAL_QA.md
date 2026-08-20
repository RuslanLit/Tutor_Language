# AF4B Production Audio Technical QA

Scope: the 114 current AF4A entries with manifest QA state `generated`.
The 3 original AF1 `approved` entries were not scanned for promotion and were
not modified.

The scanner parses RIFF/WAVE headers and PCM samples directly; it does not use
ASR and cannot judge pronunciation, stress, cadence, naturalness, or
pedagogical suitability. Human listening remains mandatory.

## Summary

- scanned: 0
- technical `ok`: 0
- technical `review`: 0
- technical `error`: 0
- duration min/median/max: n/a

## Format distribution

## Conservative rules

- `error`: missing/zero-byte file, invalid RIFF/WAVE structure, missing chunks,
  unreadable data, or effectively silent signal (`rms < 0.001` or peak `< 0.005`).
- `review`: more than 10 samples at/near full scale (`abs(sample) >= 0.999`), leading/trailing or
  internal silence over 1500 ms, unusual format, or an extreme duration/text
  mismatch. These are conservative heuristics, not pronunciation judgments.
- silence uses a per-frame peak below `0.01` as the silence heuristic.
- duration heuristic is only a broad outlier check: shorter than
  `max(200 ms, words * 80 ms)` or longer than `max(10000 ms, characters * 450 ms)`.

## Suspicious files

None. This does not constitute human approval.
## Human QA

All report rows start with `human_result=pending`. A technical `ok` never
promotes an entry. Human PASS requires understandable intended Spanish,
acceptable stress, no truncation/repetition/extra speech, usable pauses and
question intonation, appropriate A0/A1 speed, reasonable batch volume, and no
severe artifact. FAIL covers defects that could teach incorrect pronunciation
or materially degrade learning. Minor synthetic character alone is not fail.

The interactive reviewer uses the already-installed external `ffplay` command
and saves each result immediately, so quitting resumes from the remaining
pending rows:

```bash
cd ~/Tutor_Language/app
dart run tool/audio_reference_qa.dart --interactive --mode suspicious-first
dart run tool/audio_reference_qa.dart --interactive --mode all
```

After human review only, apply explicit passes with:

```bash
dart run tool/audio_reference_qa.dart --apply-approved
```

This promotion command changes only generated manifest entries whose report
row is `human_result=pass`; it does not alter the three original approved
entries.
