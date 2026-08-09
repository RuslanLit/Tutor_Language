# First 15 Lessons Rationale

Status: PROPOSAL
Scope: first 15 lessons rationale
Normative authority: none; requires explicit adoption

This document explains why the first 15 Spanish A0 lessons are ordered as
defined in `BEGINNER_COURSE_SEQUENCE.md` and
`BEGINNER_LESSON_PROGRESSION.md`.

It is not an implementation plan and does not define JSON, assets, tests,
runtime behavior, validators, or localization.

## Why The Course Begins This Way

The course begins with `Hola` because it gives the learner an immediate,
real-world communicative action while requiring only one word and one local
reading fact.

The textbook research showed two useful but incomplete patterns:

- pronunciation/reading support often comes before ordinary lessons;
- first-contact communication appears early because it motivates the learner.

Tutor Language combines these principles:

```text
communicative purpose
-> just-in-time pronunciation support
-> recognition
-> recall
-> controlled use
```

The course does not begin with a full alphabet or pronunciation table because
offline mobile learners have no teacher to pace, skip, reassure, or correct
them. The app must create a small success first and introduce reading facts only
when they unlock the next action.

## Why Pronunciation Is Introduced Immediately

Pronunciation appears in Lesson 1 because the learner cannot safely read `Hola`
without support. This follows the textbook-derived principle:

```text
Prepare reading before unsupported Spanish.
```

However, pronunciation is not taught as a separate subject. The learner sees
only the support needed to read the current word.

The broader pronunciation system is delayed because:

- A0 learners do not need IPA or phonetic terminology to greet someone.
- Tables of sounds do not prove active recall.
- Teacher-led pronunciation courses rely on correction the app cannot improvise.

## Why Reading Is Developed Gradually

Reading starts immediately but narrowly.

Lesson 1 teaches the quiet `h` only inside `Hola`. Lesson 6 introduces the
accent in `Adiós`. Lesson 8 introduces the local reading issue needed for
`Gracias`. Lesson 13 introduces `ll` only because `Me llamo` requires it.
Lessons 3 and 14 use whole-phrase support for longer questions before any
general `qu`, accent or question-pattern rule is extracted.

This order follows the Tutor Language rule:

```text
Known symbol -> decodable word -> meaningful vocabulary
```

The alphabet is postponed because the learner first needs meaningful anchors.
Later alphabet work can organize letters the learner has already met, rather
than becoming an abstract chart at the beginning.

Postponing the alphabet does not postpone responsibility for writing-system
support. Every active reading or typing task in the first 15 lessons must
locally introduce the exact letters, punctuation marks, accents or letter
combinations needed for that task.

## Why Writing Is Introduced Early But Small

Writing begins in Lesson 1 because typing `Hola` from memory is stronger
evidence than recognition. The writing load is intentionally tiny:

- one short known word;
- supported reading before recall;
- guided recall before independent recall.

Writing is not expanded into long sentences early because that would combine
spelling, reading, meaning, punctuation, and grammar before the learner has
stable state evidence.

For accented forms such as `Adiós`, the learner must see the accented target
form and receive local support before recall. Early typed production may be
handled with corrective feedback for a missing accent, but the blueprint treats
the accented written form as the pedagogical target.

## Why Grammar Is Delayed

Grammar is not absent. It is hidden inside communicative patterns:

- a greeting can stand alone;
- a question expects an answer;
- `Me llamo ...` has a name slot;
- `por favor` modifies a request.

The course delays grammar terminology because the first learner need is action,
not classification.

This intentionally rejects the textbook pattern of early heavy grammar:

- article systems;
- noun gender and number;
- pronoun paradigms;
- verb conjugation tables;
- formal word-order explanation.

Those may be useful later, but they are not needed for the first 15 measurable
actions.

## Adopted Textbook Principles

### Concrete Before Abstract

Adopted.

Learners meet usable words and phrases before any general system.

### Pronunciation Before Unsupported Reading

Adopted.

Every unfamiliar Spanish form needs pronunciation support before active reading
or typing.

### Examples Before Rule

Adopted and adapted.

The course uses course words as the example. A rule exists only because the next
word needs it.

### Recognition Before Recall

Adopted.

Every new unit moves from supported encounter to recognition before typed
recall, unless the lesson objective is comprehension-only.

### Communication Before Grammar Explanation

Adopted.

Grammar is presented as a useful action before it is named.

### Review Through Changed Task

Adopted.

Review changes context, support, or response type. The learner does not simply
tap the same answer again.

## Rejected Textbook Principles

### Full Alphabet At The Start

Rejected for the first 15 mobile lessons.

Reason:
The alphabet is useful reference knowledge but a poor first learner action. It
does not by itself let the learner greet, answer, or introduce themselves.

### Full Phonetic Course At The Start

Rejected as a mobile opening.

Reason:
Traditional phonetic sections assume teacher pacing, audio correction, and long
study time. Tutor Language keeps the principle of early pronunciation support
but makes it just-in-time.

### Large First Lesson

Rejected.

Reason:
Textbook first lessons can span hours and contain many words, grammar points,
and exercises. Tutor Language sessions should produce one measurable state
transition.

### Dictionary-Like Vocabulary Groups

Rejected.

Reason:
Vocabulary is introduced only when it enables a communicative action.

### Early Grammar System

Rejected.

Reason:
The learner can perform the first-contact actions without grammar labels.
Explaining the system early increases cognitive load without improving the
nearest action.

## Review Architecture

The first 15 lessons use three review layers:

1. Immediate micro-review inside the next lesson.
2. Integration checkpoints at Lessons 5 and 15.
3. Future delayed review after interference from later content.

Lesson 5 checks greeting exchange control.

Lesson 10 is not a zero-new-language checkpoint after repair. It introduces
`Por favor` with limited review of the `Gracias` and `De nada` courtesy pair so
Lesson 12 can reuse `por favor` without violating prerequisites.

Lesson 15 checks first-contact communication across greeting, recognized name
question, name response and courtesy pair. Classroom-survival repair phrases
remain available for later review but are not part of this first-contact
checkpoint.

## Teacher Replacement Strategy

The blueprint assigns each missing teacher function to a course-design rule.

| Teacher function | Course-design replacement |
| --- | --- |
| Motivation | Start each lesson with one immediate communicative purpose. |
| Pronunciation modeling | Provide support-language pronunciation before unsupported reading. |
| Pacing | Limit new material to one word, phrase, or function per lesson. |
| Correction | Define failure state and remediation during implementation. |
| Encouragement | End each lesson with a visible capability gain. |
| Exercise selection | Use deterministic progression from encounter to recall. |
| Context creation | Use tiny plausible social situations with known language. |
| Review timing | Place checkpoints after several micro-skills. |

## Why This Blueprint Is Implementable

Another author can implement these lessons without inventing methodology
because every lesson specifies:

- the single measurable objective;
- the communicative gain;
- the exact new knowledge categories;
- the cognitive load budget;
- the pedagogical progression;
- the review role;
- the reason for its position.

The implementation phase still must design exact screens, content references,
localized learner text, answer checking, and remediation. Those are engineering
and authoring tasks after the course blueprint, not new course-design decisions.

## Required Quality Check

Result:
PASS.

Evidence:

- Every lesson introduces only the minimum necessary new material.
- Every lesson has one primary educational objective.
- Every lesson ends with a measurable communicative gain or an explicitly
  bounded comprehension gain that prepares a later productive lesson.
- Reading, pronunciation, grammar, and communication develop together through
  immediate need rather than through isolated catalogues.
- The sequence follows textbook-derived principles: pronunciation support before
  unsupported reading, concrete before abstract, recognition before recall,
  communication as motivation, and review through changed demand.
- The sequence rejects textbook patterns that do not fit offline mobile A0:
  large first chapters, full front-loaded phonetics, early grammar systems, and
  dictionary-like word groups.
- The blueprint is precise enough for a later implementation phase to map each
  lesson to Tutor Language content assets and deterministic runtime behavior,
  provided implementation preserves the local WritingUnit and support-fading
  requirements.
