# AUDIO_LEARNING_STANDARD.md

Status: Active architectural and pedagogical standard

Version: 1.0

Related documents:

- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md
- LEARNING_MODEL.md
- CONTENT_MODEL.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- CURRICULUM_SPEC.md
- COMMUNICATIVE_COMPETENCY_MAP.md
- RELEASE_CHECKLIST.md

---

# Purpose and scope

This is the canonical cross-cutting specification for listening, authored
reference audio and non-AI spoken practice. AF2 implements local playback of
approved bundled reference audio; recording, speech recognition and
pronunciation evaluation remain deferred.

Tutor Language remains offline-first, deterministic, privacy-first,
Android-only, F-Droid compatible and free of runtime cloud, AI, TTS and ASR
requirements.

Three layers remain distinct:

1. **Generic learning-platform capability:** local media playback, temporary
   learner recording, activity modality, practice/assessment semantics, attempt
   lifecycle, deterministic evaluation and temporary-media privacy lifecycle.
2. **Language-learning pedagogy:** listening, pronunciation, imitation, delayed
   imitation, shadowing, spoken retrieval, formulaic sequences, oral
   interaction, phonological noticing and speech automaticity.
3. **Spanish authoring tooling:** Piper and the selected Spanish reference
   voice are authoring/build-preparation tools, not application dependencies.

Language-specific pedagogy must not be placed in generic platform contracts.

# Learning progression

Language learning must not be modeled only as:

```
explanation -> written exercise -> correctness
```

Important language units may progress through:

```
EXPOSURE -> COMPREHENSION -> IMITATION -> RETRIEVAL ->
CONTROLLED PRODUCTION -> VARIATION -> INTERACTION -> AUTOMATICITY -> TRANSFER
```

This is a pedagogical capability/progression model, not a mandatory rigid
runtime state machine. Not every unit uses every stage in one lesson.

## Communicative chunks

Communicatively useful multiword sequences may be first-class learning targets.
Examples include `Me llamo ___`, `¿Cómo te llamas?`, `No entiendo` and
`¿Puedes repetir, por favor?`. Vocabulary must not be limited to isolated-word
memorization. Grammar and vocabulary may support a communicative construction,
but a chunk does not replace productive grammar.

Preferred progression:

```
fixed chunk -> comprehension -> controlled recall -> slot variation ->
contextual reuse -> independent use
```

No new runtime content type or schema is implied by this semantic requirement.

## Automaticity

Correctness and automaticity are different dimensions. A learner who eventually
reconstructs `Me llamo Ana` and one who retrieves it immediately may both be
correct without having equal practical fluency. Automaticity is an important
long-term dimension, but this project does not define an `automaticityScore`,
database field, arbitrary threshold or latency-only proof. Possible future
evidence includes repeated successful retrieval, reduced hesitation,
varied-context retrieval and spoken evidence; measurement design is deferred.

## Deliberate practice

The general loop is:

```
narrow target -> attempt -> feedback or comparison -> correction -> retry
```

For deterministic tasks:

```
task -> learner response -> deterministic evaluation -> feedback or
misconception -> remediation -> retry
```

For non-evaluable pronunciation practice:

```
target -> reference -> learner production -> self-comparison -> retry
```

The system must not invent feedback when it has no evaluator.

# Listening

Listening is more than exposure to sound:

```
audio + visible text -> reduced textual support -> audio-only recognition ->
audio-only comprehension -> audio-triggered response
```

If complete Spanish text is visible during every task, the task may measure
reading rather than listening. Later activities may intentionally withhold
learner-facing Spanish text.

Potentially objectively evaluable tasks include identifying meaning, selecting
a response, distinguishing phrases, transcription, deterministic comprehension
questions and identifying a known communicative function. When the response is
deterministically evaluated, it may contribute to mastery under existing rules.

# Spoken and pronunciation practice

Pronunciation practice supports intelligibility, phonological awareness,
articulation, stress, rhythm, prosody and connected speech. Its goal is not
removal of all accent, and similarity to one reference voice is not equivalent
to correct pronunciation. Regional variation remains valid where appropriate.

Authors should direct attention to a narrow target such as stress, vowel
quality, a consonant, question intonation, rhythm, linking or contrast between
two sounds. Do not introduce fake automated pronunciation scoring.

**Listen and repeat** is `listen -> repeat aloud`; recording is not required
for every pronunciation activity.

**Self-record and compare** is `reference -> record learner -> playback learner
-> replay reference -> retry or continue`. The learner performs the perceptual
comparison.

**Delayed imitation** is `listen -> reference stops/text removed -> short delay
-> reproduce from memory`; it introduces retrieval.

**Shadowing** is speaking nearly simultaneously with the reference. It can
target rhythm, stress, connected speech, intonation and timing, but is not
spontaneous speaking and is only a supporting technique.

**Spoken recall** is `communicative intent or support-language prompt -> retrieve
target expression -> say it aloud -> optional temporary recording -> reveal
reference after attempt -> self-compare`. It is more demanding than imitation.

**Scripted oral interaction** may use authored deterministic dialogue branches.
At beginner levels this is preferred over unconstrained generative conversation
because scope, vocabulary, grammar and targets remain reviewable. The
application must not claim to understand a spoken response unless an actual
evaluator exists.

Speaking is supported from A0/pre-A1 through controlled production, then A1
guided interaction, later semi-open interaction and eventually open interaction.
Open conversation is not required at the beginning.

# Practice versus assessment

Objectively evaluable activities may affect mastery when an existing
deterministic evaluator supports them:

```
audio -> choose meaning
audio -> deterministic question
audio -> typed transcription
audio -> choose appropriate response
typed recall
```

Practice-only activities unless a valid separate evaluator is added:

```
listen and repeat; self-record and compare; shadowing; spoken recall without
ASR; scripted spoken response without ASR; pronunciation imitation
```

These must not claim pronunciation or speaking mastery, spoken-answer
correctness or a percentage score without supporting evidence. Recording
completion, if needed later, is not proof of pronunciation mastery.

# Recording privacy and microphone policy

Learner recordings are local only, temporary, not uploaded, not cloud-analyzed,
not used for analytics or model training, not persisted as learner history, not
exported, not backed up and not included in course data:

```
record -> temporary local file/buffer -> playback -> retry or continue -> delete
```

Future implementations should clean stale temporary recordings after
interrupted sessions where technically appropriate. No permanent voice archive
is required initially.

Microphone permission is requested just-in-time when recording is first needed,
never at application startup. Explain the need before or alongside the system
request. Denial must not break the course; continue without recording wherever
pedagogically possible. Speaking aloud without recording remains valid practice.

# Authored reference audio

Reference audio is authored educational content, not dynamic runtime output.
Conceptually each asset has a stable identity, target transcript,
language/locale, voice or speaker provenance, pedagogical purpose and asset
path. Purposes include word, phrase, communicative chunk, dialogue turn,
listening stimulus and pronunciation reference. No JSON schema or runtime model
is finalized here.

One canonical utterance may reuse one canonical asset when context and prosody
permit. Separate assets are appropriate when prosody, emotion, dialogue context
or pedagogical focus differs. Clear natural speech, natural stress, intonation,
connected speech and intelligibility are preferred over syllable-by-syllable
segmentation.

AF1 selects WAV for the initial canonical reference assets because it is a
broad, predictable Android-compatible representation and requires no runtime
transcoding. This does not freeze future distribution choices: bitrate,
sample-rate policy, storage optimization and any later packaged representation
remain implementation/QA decisions. Packaged audio must be locally playable on
supported Android targets while balancing quality and size.

## Spanish Reference Voice v1

```
Engine: Piper
Voice: es_ES-sharvard-medium
Locale: es_ES
Role: Spanish Reference Voice v1
Generation: authoring/build preparation only
Runtime generation: none
```

The boundary is:

```
Spanish source text -> local Piper authoring tool -> human QA ->
generated audio asset -> application asset bundle
```

At runtime there is no Piper invocation, model, API key, network dependency,
cloud TTS or runtime AI. Other authored voices and regional varieties remain
possible later.

Generated audio requires human listening review for wording, stress,
pronunciation, unexpected realization, question intonation, pauses, rhythm,
intelligibility and synthesis artifacts. TTS success is not proof that an asset
is a valid pronunciation reference. Do not claim a model license; before public
distribution, verify the exact voice-model license and redistribution terms
from authoritative project/model metadata.

# Scope boundary and future architecture

**Audio Foundation** currently covers local approved-reference playback. Future
work may add listening activities, temporary learner recording, learner
playback, self-comparison, spoken-recall practice and deterministic scripted
interaction.

**Speech Intelligence** is explicitly deferred: ASR, phoneme scoring,
pronunciation diagnostics, automatic spoken-answer correctness, free-form
conversational AI and cloud speech services.

Do not pre-decide a Flutter player/recorder package, codec, filesystem,
database representation, activity enum, JSON schema, latency threshold,
automaticity measurement or ASR engine in this phase.

# Authoring variation

Audio modalities should support varied cognitive action:

```
hear -> understand -> notice -> repeat -> distinguish -> retrieve -> vary ->
use in microinteraction -> encounter in another context
```

The same target should not become `repeat` indefinitely. Multimodal lessons
may combine reading, listening, typed recall, pronunciation practice, spoken
recall and dialogue when pedagogically justified; this is not a separate audio
course architecture.

End of document.
