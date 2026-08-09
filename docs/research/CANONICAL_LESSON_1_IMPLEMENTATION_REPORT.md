# Canonical Lesson 1 Implementation Report

Status: EVIDENCE
Scope: Spanish course/pedagogical review evidence
Normative authority: PEDAGOGICAL_SCENARIO_MODEL.md

This phase implements only the canonical first Spanish A0 lesson defined by the
repaired R2E12 beginner blueprint. No runtime architecture, validators,
curriculum sequencing beyond Lesson 1 content references, or Lesson 2+ material
were changed.

## Canonical Lesson Contract

Lesson ID:
`es.a0.m06.l016`

Rationale:
This is the first visible Spanish A0 lesson in the current bundled course and
is already referenced by navigation, lesson player, assembly and content tests.
The stable ID was preserved to avoid unnecessary persistence and reference
migration.

Lesson title:
`First Spanish Hello`

Primary objective:
Learner reads, understands, and types `Hola.`

Communicative outcome:
Learner can produce a first Spanish hello.

New target-language units:
`Hola.`

Recognition requirement:
The learner recognizes `Hola.` as the Spanish form for `hello` and recognizes it
again in a changed meeting context.

Guided-production requirement:
The learner types the Spanish word for `hello` after supported encounter,
meaning recognition, supported decoding and changed-context recognition.

Independent-production requirement:
The learner types `Hola` from memory from a prompt that does not display the
answer.

Reading requirement:
Silent `h` in `Hola`; reading support is local to this word.

Writing requirement:
The learner types the known short form `Hola`. Final period and capitalization
are not the assessed target and are accepted deterministically.

Pronunciation requirement:
Support-language reading of `Hola` as `ola`.

Grammar requirement:
None.

Explicit exclusions:
`Ana`, `Hola, Ana.`, `Adios`, `Hasta luego`, `Gracias`, `Por favor`,
`Que tal?`, name questions, courtesy exchanges, greeting/farewell
discrimination, alphabet tables, broad vowel rules, grammar terminology and
reading-rule catalogues.

Expected completion evidence:
Correct independent recall of `Hola` in the final text-entry task, with `Hola.`
accepted as equivalent and predictable incorrect responses such as `ola` and
`hello` routed through authored feedback.

## Existing Content Classification

KEEP:

- `grammar.es.a0.m01.l001.first_encounter.v1`: introduces the communicative
  situation, target form, support-language reading and meaning.
- `grammar.es.a0.m01.l001.read_hola.v1`: gives the only required reading fact,
  quiet written `h` in `Hola`.
- `template.es.a0.m01.l001.focus_hola.v1`: supported encounter.
- `template.es.a0.m01.l001.meaning_hola.v1`: meaning recognition.
- `template.es.a0.m01.l001.decode_hola.v1`: supported decoding.
- `template.es.a0.m01.l001.context_arrival_hola.v1`: changed-context
  recognition after wording repair.
- `template.es.a0.m01.l001.guided_type_hola.v1`: guided recall after wording
  repair.
- `template.es.a0.m01.l001.independent_type_hola.v1`: independent recall.

ADAPT:

- Lesson metadata, objective, communicative outcome and summary were aligned to
  the repaired blueprint.
- The changed-context prompt was changed from arrival/farewell language to a
  meeting context so the lesson does not introduce Lesson 6-7 concepts early.

REMOVE FROM LESSON 1:

- `template.es.a0.m01.l001.interference_greeting_or_farewell.v1`

Reason:
Greeting/farewell discrimination is not part of Lesson 1. It is later-course
material and cannot be assessed before a farewell has been taught.

MOVE TO LATER LESSON:

- Greeting/farewell contrast belongs after a farewell unit exists.
- Named-person greeting belongs to Lesson 2.
- Greeting questions, courtesy phrases, accents, `ll`, broad vowels and
  classroom repair phrases remain deferred according to the blueprint.

## Implemented Progression

```text
Purpose
-> supported encounter
-> meaning recognition
-> supported decoding
-> changed-context recognition
-> guided recall
-> independent recall
-> closure
```

This maps to existing Tutor Language mechanisms as grammar-topic presentation
and deterministic exercise templates. No new runtime step type was required.

## Feedback And Remediation

The existing deterministic answer evaluator is used unchanged.

- `Hola` is canonical.
- `Hola.` is an accepted answer.
- `ola` remains an authored misconception for silent-`h` remediation.
- `hello` remains an authored misconception for source-language copying.

## Localization

Support-localization entries and Ukrainian semantic units were updated for the
changed Lesson 1 learner-facing strings. The Spanish target form `Hola` remains
unchanged.

## Scope Notes

The legacy greeting/farewell template remains in the shared template asset
because deleting it would be a broader cleanup outside Lesson 1 implementation.
The canonical first lesson no longer references it.

No commit was created by this phase.
