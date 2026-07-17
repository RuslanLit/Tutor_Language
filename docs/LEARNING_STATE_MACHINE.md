# LEARNING_STATE_MACHINE.md

Status: Active

Version: 1.0

Related documents:

- LESSON_AUTHORING_ENTRYPOINT.md
- PEDAGOGICAL_SCENARIO_MODEL.md
- LEARNING_MODEL.md
- COURSE_AUTHORING_GUIDE.md
- CONTENT_AUTHORING_GUIDE.md
- CONTENT_REVIEW_PROTOCOL.md

---

# Purpose

This document defines a lesson as learner-state movement.

A lesson is not a sequence of storage categories. The following is rejected as a
pedagogical architecture:

```text
Vocabulary -> Reading -> Dialogue -> Practice
```

Those categories may exist as content storage, rendering, or mapping mechanisms. They
are not learner states. A lesson step is valid only if it moves the learner from a
defined current state to a defined target state and has observable evidence.

This document is authoritative for learner states, state transitions, support fading,
productive repetition, and remediation paths.

---

# Canonical Learner States

Use the smallest state set that explains the learner's observable capability.

## State: Not introduced

Capability:
The learner has no documented instructional encounter with the unit.

Evidence:
No prior approved lesson step has introduced the unit. Any correct answer here is
diagnostic or prior knowledge, not proof of instruction.

Support permitted:
Full teaching support may be provided in the next step.

Prohibited assumptions:
Do not assume the learner can read, understand, recognize, or type the unit.

Suitable activity types:
None for assessment. Diagnostic checks may be used only when explicitly marked as
diagnostic.

Exit condition:
The learner attends to an explicit supported presentation.

Failure condition:
The lesson asks for recognition, recall, typing, or contextual use before presentation.

Permitted next states:
Attends to the new unit.

Remediation path:
Return to supported presentation.

## State: Attends to the new unit

Capability:
The learner notices the new target unit and knows it is the focus of the current step.

Evidence:
The unit is shown with learner-safe support and the learner performs a low-risk action
such as continuing, matching visible form to visible support, or selecting the focused
unit when no recall is required.

Support permitted:
Target form, natural translation, localized pronunciation support when the target form
is unfamiliar, model example, and teacher-style explanation.

Prohibited assumptions:
Do not treat attention as meaning knowledge, reading ability, or recall.

Suitable activity types:
Supported presentation, focused observation, simple confirmation, modeled example.

Exit condition:
The learner connects the unit to meaning or reading support in a supported step.

Failure condition:
The learner cannot identify what the step is about.

Permitted next states:
Understands its meaning; Can read or decode it with support.

Remediation path:
Reduce the screen to one target unit and one immediate support cue.

## State: Understands its meaning

Capability:
The learner can connect the target form to its nearest natural equivalent in the
support language.

Evidence:
The learner selects or supplies the correct meaning in a simple context among plausible
alternatives.

Support permitted:
Pronunciation support may remain visible if pronunciation is not being tested. A model
example may remain visible if the task is meaning recognition, not recall.

Prohibited assumptions:
Do not treat passive exposure, repeated display, or copying as proof of understanding.

Suitable activity types:
Meaning choice, matching target form to support-language meaning, simple comprehension
question.

Exit condition:
Correct meaning recognition in at least one non-identical context.

Failure condition:
The learner chooses a distractor or relies on a visible answer-shaped hint.

Permitted next states:
Can read or decode it with support; Recognizes it in a changed context; Recalls it with
support.

Remediation path:
Return to direct form-meaning pairing with one plausible contrast.

## State: Can read or decode it with support

Capability:
The learner can read the target form when appropriate pronunciation or reading support
is visible.

Evidence:
The learner identifies the supported reading, matches the target form to a localized
pronunciation aid, or uses the reading support to complete a low-risk task.

Support permitted:
Localized pronunciation support, letter name, reading-rule explanation, model example,
and optional IPA after learner-facing explanation.

Prohibited assumptions:
Do not assume supported decoding proves independent reading.

Suitable activity types:
Supported reading, sound-form matching, reading-rule presentation, pronunciation-aware
recognition.

Exit condition:
The learner reads or recognizes the unit in a changed context with reduced support.

Failure condition:
The learner cannot connect the written form to the supported pronunciation.

Permitted next states:
Recognizes it in a changed context; Recalls it with support.

Remediation path:
Restore localized pronunciation support and the simplest relevant example.

## State: Recognizes it in a changed context

Capability:
The learner can identify the unit or its meaning when the surrounding context changes.

Evidence:
The learner selects the correct form, meaning, or reading when the prompt is not an
identical replay of the teaching card.

Support permitted:
Answer options, known context, and non-answer-leaking pronunciation support when the
task is not testing independent decoding.

Prohibited assumptions:
Do not treat recognition as independent recall or contextual use.

Suitable activity types:
Multiple choice, matching, discrimination, simple comprehension in a changed sentence.

Exit condition:
Correct recognition with plausible distractors and no identical prior prompt.

Failure condition:
The learner succeeds only because options are absurd, repeated, or answer-shaped.

Permitted next states:
Recalls it with support; Recalls it independently.

Remediation path:
Return to meaning or supported reading, depending on which evidence failed.

## State: Recalls it with support

Capability:
The learner can produce the target unit when partial support remains.

Evidence:
The learner completes or types the unit with a cue that narrows the answer but does not
fully reveal it.

Support permitted:
Support-language prompt, partial phrase, known context, first-letter cue, or limited
choice only when the answer is not fully visible.

Prohibited assumptions:
Do not treat copied text, visible model answers, or answer-shaped transcription as
recall.

Suitable activity types:
Fill gap, cued typing, ordered phrase reconstruction, guided response.

Exit condition:
Correct production with partial support.

Failure condition:
The learner cannot produce the unit unless the answer is visible.

Permitted next states:
Recalls it independently; Uses it in a meaningful context.

Remediation path:
Return to changed-context recognition, then repeat supported recall with a weaker cue.

## State: Recalls it independently

Capability:
The learner can produce the target unit without visible answer support.

Evidence:
The learner types, says, selects from memory, or constructs the target response from a
support-language or situational prompt that does not reveal the target form.

Support permitted:
Task instruction, support-language meaning, situation, known interlocutor, and
non-answer-leaking feedback after submission.

Prohibited assumptions:
Do not show target transcription, partial spelling, model answer, identical previous
prompt, or answer options that make recall unnecessary.

Suitable activity types:
Typed recall, free response within a controlled target, short production check.

Exit condition:
Correct or accepted-with-feedback production under independent conditions.

Failure condition:
Incorrect response, no response, or success caused by answer leakage.

Permitted next states:
Uses it in a meaningful context; Retains it after interference or delay.

Remediation path:
If meaning failed, return to direct form-meaning pairing. If reading failed, restore
pronunciation support. If spelling failed but sound was correct, accept with feedback
when authored, then retry without leaking the answer.

## State: Uses it in a meaningful context

Capability:
The learner can use the unit to complete a small communicative or comprehension task.

Evidence:
The learner chooses or produces the unit appropriately in a plausible situation, not
only as an isolated item.

Support permitted:
Situation, interlocutor, known surrounding words, and task goal. Support must not reveal
the target response when the step assesses independent use.

Prohibited assumptions:
Do not treat isolated word recall as contextual use.

Suitable activity types:
Controlled application, short response, exchange completion, contextual choice,
meaningful comprehension.

Exit condition:
The learner completes the contextual task correctly or with accepted feedback.

Failure condition:
The learner recalls the form but uses it in the wrong situation, or cannot choose the
appropriate response.

Permitted next states:
Retains it after interference or delay; Needs remediation.

Remediation path:
Return to a simpler modeled example in the same communicative function.

## State: Retains it after interference or delay

Capability:
The learner can recall or use the unit after another task, another unit, or a time gap.

Evidence:
The learner succeeds in a later review, mixed task, checkpoint, or delayed context with
reduced support.

Support permitted:
Task instruction, situation, and review context. Support must match the state being
assessed and must not reveal the answer.

Prohibited assumptions:
Do not treat immediate repetition as retention.

Suitable activity types:
Review, mixed recall, checkpoint, delayed controlled application.

Exit condition:
Correct recall or use after interference or delay.

Failure condition:
The learner succeeds immediately but fails after interruption, mixed material, or time.

Permitted next states:
Uses it in a meaningful context; Needs remediation.

Remediation path:
Return to the weakest failed state, not to the start of the whole lesson.

## State: Needs remediation

Capability:
The learner has shown a specific failed state that requires targeted recovery.

Evidence:
Incorrect answer, repeated hesitation where represented by runtime behavior, accepted
with correction on a fragile item, or failed review.

Support permitted:
Only the support needed for the failed state.

Prohibited assumptions:
Do not restart the whole lesson when the failure is local. Do not give generic review
when the failed state is known.

Suitable activity types:
Targeted explanation, supported contrast, simpler model, focused retry, inserted
authored review step.

Exit condition:
The learner succeeds at the failed state with appropriate support and can reattempt the
original target state.

Failure condition:
The learner repeats the same error after targeted remediation.

Permitted next states:
The state that failed, or the immediately preceding state when the learner needs more
support.

Remediation path:
Use the deterministic remediation map in this document.

---

# Valid Transitions

The standard instructional path is:

```text
Not introduced
-> Attends to the new unit
-> Understands its meaning
-> Can read or decode it with support
-> Recognizes it in a changed context
-> Recalls it with support
-> Recalls it independently
-> Uses it in a meaningful context
-> Retains it after interference or delay
```

The order may vary when justified by the lesson objective. For example, a reading-rule
lesson may move from attention to supported decoding before meaning. A communication
lesson may teach meaning before spelling. The author must still name the current state,
target state, and evidence for every step.

Valid transition families:

- Unknown to attended: supported presentation.
- Attended to meaning: direct form-meaning connection.
- Attended to supported decoding: localized pronunciation or reading support.
- Meaning to changed-context recognition: plausible contrast or changed example.
- Supported decoding to changed-context recognition: reduced pronunciation support or
  changed word context.
- Recognition to supported recall: cue remains, answer hidden.
- Supported recall to independent recall: cue fades, answer remains hidden.
- Independent recall to meaningful use: isolated production becomes situational action.
- Meaningful use to retention: delay, mixed context, or later review.
- Any failed state to needs remediation: failure evidence is specific.
- Needs remediation to prior failed state: support targets the failure.

---

# Invalid Transitions

These transitions are invalid unless the step is explicitly diagnostic:

- Not introduced -> independent typed recall.
- Not introduced -> contextual use.
- Attends to the new unit -> independent recall.
- Passive exposure -> understands meaning.
- Recognition -> retention.
- Copying a visible answer -> recall.
- Immediate repetition -> retention.
- Isolated form recall -> meaningful contextual use.

Invalid transitions cannot be justified by saying the content category exists or the
schema permits it.

---

# Support Fading

Support exists to move the learner to the next state. It must fade when it would prevent
evidence of the target state.

## Support Types

Translation:
Shows meaning in the support language.

Support-language transcription:
Shows a learner-facing pronunciation aid.

Example:
Shows the unit in a short understood context.

Partial phrase:
Shows some target-language material while hiding the assessed part.

Answer options:
Make recognition possible but do not prove recall.

Correction:
Appears after an answer and explains the useful distinction.

Model answer:
Shows the full target response.

## Mandatory Rules

- Support may appear during teaching and guided practice.
- Support must not reveal the answer during independent recall.
- Pronunciation support is mandatory before the learner is expected to decode unfamiliar
  target-language material.
- Pronunciation support is not automatically required in every later exercise.
- Pronunciation support must be withheld when it would leak the tested answer.
- Previously mastered words may appear without transcription when the lesson
  intentionally checks independent reading.
- A model answer may be shown before guided practice, but not inside an independent
  recall prompt.

---

# Productive Repetition

Repetition is valid only when it changes the learner's mental operation.

Bad repetition:

```text
Choose hola.
Complete hola.
Type hola.
Choose hola again.
```

Better progression:

```text
Recognize meaning
-> read in a name greeting
-> recall from support-language prompt
-> use in a short greeting
```

Every repetition must change at least one of:

- support level;
- context;
- response type;
- retrieval demand;
- communicative purpose.

If a repeated step does not change any of these, it is filler and should be removed.

---

# Deterministic Remediation Map

Meaning failure:
Return to direct form-meaning pairing with one plausible contrast.

Reading failure:
Restore localized pronunciation support and the smallest relevant reading example.

Spelling failure with correct sound:
Use accepted-with-feedback when authored, name the spelling issue briefly, then retry
without leaking the full answer.

Recognition failure:
Return to supported meaning or supported decoding, then retry with better distractors.

Supported recall failure:
Return to changed-context recognition, then repeat recall with a weaker cue.

Independent recall failure:
Return to supported recall. Do not reveal the answer in the independent recall prompt.

Contextual-use failure:
Return to a simpler modeled example of the same communicative function.

Retention failure:
Return to the weakest failed prior state and schedule later reduced-support review.

Remediation must target the failed state. It must not restart the entire lesson unless
the lesson cannot identify the failed state.

---

# Conflict Resolution Table

| Existing rule | Source document | Ambiguity or conflict | Resolution | Authoritative location |
|---|---|---|---|---|
| Lesson goals may include "introduce vocabulary" or "reinforce grammar". | `LEARNING_MODEL.md` | These describe teaching activity, not observable learner capability. | Lesson goals for authored lessons must be learner-state outcomes. Content functions may remain metadata only. | `PEDAGOGICAL_SCENARIO_MODEL.md` |
| A typical beginner lesson includes introduction, vocabulary, grammar, examples, dialogue/reading, exercises, review. | `CONTENT_AUTHORING_GUIDE.md` | Can be misread as a mandatory stack and produce repetitive lessons. | Activity categories are selected only after the state-transition scenario is approved. | `PEDAGOGICAL_SCENARIO_MODEL.md` |
| Important knowledge should appear multiple times. | `CONTENT_AUTHORING_GUIDE.md` | Can be misread as duplicate exposure. | Repetition is productive only when support, context, response type, retrieval demand, or communicative purpose changes. | `LEARNING_STATE_MACHINE.md` |
| Pronunciation support is required before unfamiliar target-language reading. | `EDUCATIONAL_LANGUAGE_STANDARD.md`, `PRONUNCIATION_AUTHORING_GUIDE.md` | Can be misread as transcription everywhere. | Pronunciation support is mandatory before unfamiliar decoding, optional later, and prohibited when it leaks independent recall. | `LEARNING_STATE_MACHINE.md` |
| Examples should be natural and useful. | `AUTHORING_STYLE_GUIDE.md`, `EDUCATIONAL_LANGUAGE_STANDARD.md` | Does not define when an example is meaningful enough for a lesson step. | A meaningful example must use known material plus the current target, resemble real communication, be immediately understandable, and prepare the next learner action. | `PEDAGOGICAL_SCENARIO_MODEL.md` |
| Reading, dialogue, recall and application should support the same goal. | `COURSE_AUTHORING_GUIDE.md` | Correct but still category-centered. | Each mapped activity must state current state, target state, learner action, support, evidence, and failure response. | `PEDAGOGICAL_SCENARIO_MODEL.md` |
| Support-to-recall stages are named but not mandatory sections. | `LEARNING_MODEL.md` | Can be misread as optional progression. | Section names are optional; state transitions from support toward recall/use are mandatory when teaching a new usable skill. | `LEARNING_STATE_MACHINE.md` |
| Every exercise should have one primary learning purpose. | `CONTENT_AUTHORING_GUIDE.md` | Does not require a named learner state. | Every exercise must identify the learner state it assesses. | `PEDAGOGICAL_SCENARIO_MODEL.md` |
| Content must pass human-level review. | `CONTENT_REVIEW_PROTOCOL.md` | Review can focus on local text quality without checking lesson movement. | Review must reject any step without a clear state transition and evidence. | `PEDAGOGICAL_SCENARIO_MODEL.md` |

---

# Duplicate Guidance Consolidation

Authoritative topics:

- Learner states, state transitions, support fading, repetition, remediation:
  `LEARNING_STATE_MACHINE.md`.
- Lesson construction order, scenario contracts, assessment design, meaningful context:
  `PEDAGOGICAL_SCENARIO_MODEL.md`.
- Learner-facing wording and tone: `AUTHORING_STYLE_GUIDE.md` and
  `EDUCATIONAL_LANGUAGE_STANDARD.md`.
- Pronunciation and reading-rule presentation: `PRONUNCIATION_AUTHORING_GUIDE.md`.
- Content object fields and storage responsibilities: `CONTENT_AUTHORING_GUIDE.md` and
  `CONTENT_MODEL.md`.
- Course/module sequencing: `COURSE_AUTHORING_GUIDE.md` and `CURRICULUM_SPEC.md`.
- Review process: `CONTENT_REVIEW_PROTOCOL.md`.
- Runtime implementation: `ARCHITECTURE.md` and `ARCHITECTURAL_DECISIONS.md`.

Secondary documents should reference these authorities instead of restating their rules.
