# Beginner Course Repair Report

Status: EVIDENCE
Scope: Spanish course design or implementation evidence
Normative authority: SPANISH_A0_CURRICULUM_BLUEPRINT.md

This report records the prerequisite repairs applied to the canonical beginner
course blueprint after `BEGINNER_COURSE_BLUEPRINT_AUDIT.md`.

Files edited in this phase:

- `docs/research/BEGINNER_COURSE_SEQUENCE.md`
- `docs/research/BEGINNER_LESSON_PROGRESSION.md`
- `docs/research/FIRST_15_LESSONS_RATIONALE.md`

File added in this phase:

- `docs/research/BEGINNER_COURSE_REPAIR_REPORT.md`

No code, runtime, assets, validators, tests, curriculum JSON or localization
files were modified.

## Executive Summary

R2E12B repaired prerequisite gaps without redesigning the course. The overall
15-lesson progression remains intact: immediate greeting success, gradual
reading support, delayed grammar terminology, controlled writing, courtesy and
survival phrases, then a narrow first-contact checkpoint.

The main repairs were:

- `Por favor` is now explicitly introduced in Lesson 10 before Lesson 12 reuses
  it in `Repite, por favor`.
- The first-15 scope no longer claims independent production of `¿Cómo te
  llamas?`; Lesson 14 remains recognition-only and Lesson 15 uses it as a known
  prompt for a `Me llamo ...` response.
- A just-in-time WritingUnit policy now reconciles postponed alphabet study with
  active reading and typing.
- Hidden reading load for `¿Qué tal?`, `¿Cómo te llamas?`, accents and phrase
  chunks is now explicit.
- Lesson 15 was narrowed to greeting, name response and courtesy; classroom
  repair phrases are no longer part of that checkpoint.

## Critical Findings Addressed

### C1. `por favor` Required Before Introduction

Original problem:
Lesson 12 reused `por favor`, but no earlier lesson introduced it. Lesson 10
was inconsistent: the sequence referenced `Por favor`, while the detailed
progression treated Lesson 10 as a zero-new-language checkpoint.

Repair performed:
Lesson 10 was redefined as `Please`: the learner reads, understands and types
`Por favor.` as one fixed courtesy phrase. Lesson 12 now explicitly reuses it as
known language and introduces only `Repite`.

Affected lessons:
Lessons 10 and 12.

Remaining risk:
None at blueprint level. Implementation must still provide support-language
pronunciation and local writing support for `Por favor`.

### C2. Name-Question Production Claimed But Not Taught

Original problem:
The beginning scope claimed the learner could ask someone else's name, but
Lesson 14 only taught recognition of `¿Cómo te llamas?` and Lesson 15 did not
define production evidence for the question.

Repair performed:
The scope now says the learner recognizes when someone asks their name and
responds with a supported name phrase. Lesson 14 remains recognition-only.
Lesson 15 now uses `¿Cómo te llamas?` as a recognized prompt and assesses the
learner's `Me llamo ...` response, not production of the long question.

Affected lessons:
Lessons 14 and 15.

Remaining risk:
Independent production of `¿Cómo te llamas?` remains a future lesson objective.

## Major Findings Addressed

### M1. Writing-System Prerequisites Underspecified

Repair:
Added a `Just-In-Time WritingUnit Policy` to
`BEGINNER_COURSE_SEQUENCE.md`. Updated lesson-level writing entries to state
local support for letters, comma, accents, phrase words, `ll`, and controlled
name slots before active use.

Affected lessons:
Lessons 1, 2, 4, 6, 8, 9, 10, 12, 13 and 15.

### M2. `¿Qué tal?` Reading Load Understated

Repair:
Lesson 3 now treats `¿Qué tal?` as a whole supported phrase. Inverted question
marks are introduced as visible question support; `qu` and accented `é` are
noticed inside the phrase but not generalized into reusable rules yet.

Affected lesson:
Lesson 3.

### M3. Lesson 2 Skipped Guided Recall

Repair:
Lesson 2 progression now includes a non-leaking guided recall step before
independent production of `Hola, Ana`.

Affected lesson:
Lesson 2.

### M4. Lesson 7 Productive Demand Ambiguous

Repair:
Lesson 7 is now explicitly contextual recognition/discrimination only. It has
no writing requirement and assesses independent contextual choice from known
options.

Affected lesson:
Lesson 7.

### M5. Lesson 10 Contradicted Its Checkpoint Role

Repair:
Lesson 10 is no longer described as a zero-new-language integration checkpoint.
It is a courtesy expansion lesson introducing `Por favor` with limited review of
`Gracias` and `De nada`.

Affected lesson:
Lesson 10.

### M6. Review Strategy Too Directional

Repair:
The sequence now defines review targets:

- Lesson 5 reviews `Hola`, `¿Qué tal?` and `Bien` through ordered greeting
  exchange control.
- Lesson 10 reviews `Gracias` and `De nada` while introducing `Por favor`.
- Lesson 15 reviews `Hola`, `¿Cómo te llamas?` recognition, `Me llamo ...`
  production and the `Gracias`/`De nada` courtesy pair.

Affected lessons:
Lessons 5, 10 and 15.

### M7. Lesson 15 Overreached

Repair:
Lesson 15 no longer includes classroom-survival repair phrases. It is narrowed
to greeting, recognized name question, name response and courtesy pair.

Affected lesson:
Lesson 15.

## Cross-Document Synchronization

Synchronized changes:

- Beginning scope now says the learner recognizes a name question and responds;
  it no longer claims asking someone else's name.
- Lesson 10 is named and described consistently as the `Por favor` introduction
  lesson across all three blueprint documents.
- Lesson 12 consistently treats `por favor` as known from Lesson 10.
- Lesson 14 consistently remains recognition-only for `¿Cómo te llamas?`.
- Lesson 15 consistently assesses a narrow first-contact exchange and excludes
  classroom-survival repair phrases.
- Review architecture consistently uses Lessons 5 and 15 as integration
  checkpoints, with Lesson 10 as a courtesy expansion with limited review.
- Whole-phrase support for `¿Qué tal?` and `¿Cómo te llamas?` is now explicit.
- Postponed alphabet instruction is consistently paired with local WritingUnit
  support before active reading or typing.

## Remaining Open Questions

1. When should the learner independently produce `¿Cómo te llamas?`?
   This is intentionally deferred beyond the repaired first-15 scope.

2. When should broad alphabet organization occur?
   The first 15 lessons use local writing support only; a later blueprint should
   decide when to consolidate known letters into alphabet knowledge.

3. When should classroom-survival phrases receive an integration checkpoint?
   Lessons 11-12 introduce survival language, but Lesson 15 now excludes it to
   keep first-contact integration narrow.

## Repair Statistics

- Lessons modified: 8 directly (`2`, `3`, `7`, `10`, `12`, `13`, `14`, `15`);
  additional writing-prerequisite clarifications affect Lessons `1`, `4`, `6`,
  `8` and `9`.
- Objectives changed: 3 (`7`, `10`, `15`).
- Communicative outcomes updated: 4 (`7`, `10`, `14` by scope alignment, `15`).
- Vocabulary introduction changes: 1 (`Por favor` introduced in Lesson 10).
- Production timing changes: 3 (`Hola, Ana` guided recall added; `¿Cómo te
  llamas?` production deferred; Lesson 7 production removed).
- Reading prerequisite fixes: 4 (`¿Qué tal?`, `Adiós`, `Por favor`,
  `¿Cómo te llamas?`).
- Writing prerequisite fixes: 10 lesson-level entries plus global WritingUnit
  policy.
- Review strategy adjustments: 3 (`5`, `10`, `15`).

## Validation Notes

This report must be validated with:

```text
git diff --check
git status --short
git diff --stat
```

Expected result:

- only the three blueprint documents are modified;
- this repair report is added;
- `BEGINNER_COURSE_BLUEPRINT_AUDIT.md` remains unchanged;
- no code, runtime, assets, validators, tests, curriculum JSON or localization
  files are modified by this phase;
- no files are staged;
- no commit is created.
