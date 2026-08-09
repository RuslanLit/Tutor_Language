# Beginner Course Sequence

Status: PROPOSAL
Scope: beginner course sequence
Normative authority: none; requires explicit adoption

This document defines the canonical beginning sequence for Spanish A0 in Tutor
Language. It is a design artifact only. It does not create lessons, JSON,
templates, dialogues, readings, vocabulary assets, grammar assets, Flutter code,
validators, tests, or localization.

The previous Lesson 1 implementation is treated as a useful prototype, not as
the final model.

## Design Basis

This sequence follows:

- `LEARNING_STATE_MACHINE.md`
- `PEDAGOGICAL_SCENARIO_MODEL.md`
- `LESSON_AUTHORING_ENTRYPOINT.md`
- `LEARNING_MODEL.md`
- `SPANISH_PEDAGOGICAL_FOUNDATION.md`
- `SPANISH_TEACHING_PRINCIPLES.md`
- `TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md`
- `AUTHORING_STYLE_GUIDE.md`
- `CONTENT_AUTHORING_GUIDE.md`
- `COURSE_AUTHORING_GUIDE.md`
- `PRONUNCIATION_AUTHORING_GUIDE.md`
- `WRITING_SYSTEM_STANDARD.md`

## Course Opening Decision

The beginner course should begin with a real communicative success:

```text
The learner can read, understand, and use Hola.
```

It should not begin with:

- the full alphabet;
- a complete pronunciation course;
- a vocabulary list;
- a grammar category;
- a dialogue that assumes many unknown words.

Reason:
The textbook research shows that pronunciation and reading support are needed
early, but full phonetic tables and long first chapters overload a mobile A0
learner. Tutor Language should adapt the textbook pattern into just-in-time
reading support tied to the next communicative action.

## Beginning Scope

The first 15 lessons should bring the learner from zero Spanish to the ability
to:

- greet someone;
- respond to a simple greeting question;
- say their name;
- recognize when someone asks their name and respond with a supported name
  phrase;
- recognize a few Spanish names;
- read simple beginner words with known pronunciation support;
- type short known expressions from memory;
- handle basic courtesy and classroom survival phrases;
- complete a tiny first-contact exchange.

## Canonical Lesson Order

| Lesson | Primary capability after lesson | Why here |
| --- | --- | --- |
| 1 | Read, understand, and type `Hola.` | First immediate communicative success; introduces silent `h` only because `Hola` needs it. |
| 2 | Use `Hola` to greet a named person. | Adds address/name context after the single word is stable. |
| 3 | Understand `¿Qué tal?` as a greeting question. | Adds question comprehension before requiring an answer. |
| 4 | Answer `¿Qué tal?` with `Bien.` | Adds response only after the question is understood. |
| 5 | Complete the mini exchange `Hola. ¿Qué tal? Bien.` | Integrates Lessons 1-4 and checks controlled use after interference. |
| 6 | Say goodbye with `Adiós.` | Adds one farewell after greeting is stable; introduces written accent only as needed. |
| 7 | Choose between greeting and farewell in context. | Prevents phrasebook memorization by requiring communicative discrimination. |
| 8 | Understand and type `Gracias.` | Introduces first courtesy word after greeting/farewell base. |
| 9 | Respond to thanks with `De nada.` | Adds paired exchange only after `Gracias` is stable. |
| 10 | Read, understand, and type `Por favor.` | Introduces `por favor` before any later request uses it; no full grammar explanation. |
| 11 | Understand `No entiendo.` | Adds survival comprehension before asking for repetition. |
| 12 | Ask for repetition with `Repite, por favor.` | Reuses `por favor`; introduces one classroom action. |
| 13 | Say `Me llamo ...` with a supported name slot. | Introduces self-introduction after enough reading confidence. |
| 14 | Recognize `¿Cómo te llamas?` as a name question. | Adds question comprehension before the learner answers with `Me llamo ...`. |
| 15 | Complete a first-contact exchange with greeting, name response, and courtesy. | Integrates prior skills in a narrow checkpoint. |

## Global Sequencing Rules

1. Communication appears first as the reason to learn.
2. Pronunciation appears before every unfamiliar Spanish form that must be read.
3. Reading rules appear only when needed for the next word or phrase.
4. Alphabet knowledge is postponed until several letters have already become
   meaningful through words.
5. Vocabulary appears in tiny communicative sets, not topic lists.
6. Grammar is implicit until naming a pattern helps the next action.
7. Writing begins with short known forms after recognition and supported reading.
8. Recall follows recognition and guided recall.
9. Review is built into later lessons by changing context, support, or response
   type.

## Just-In-Time WritingUnit Policy

The full alphabet remains postponed, but each lesson must introduce the exact
writing units needed for its learner action before the learner reads, types,
recognizes or recalls them.

For the first 15 lessons this means:

- single letters are introduced locally inside the word that needs them;
- punctuation marks such as comma, period and inverted question marks are
  introduced only as local reading or sentence-boundary support;
- accented letters are introduced as local stress or recognition support before
  the learner is asked to type or choose the accented form;
- digraphs and letter combinations are introduced only when the current word
  requires them;
- free typing of names or unseen words is deferred until their writing units are
  already known or the task uses a controlled supported slot.

Postponing the alphabet never permits an unknown symbol to appear in an active
reading or typing task without local support.

## Early Reading Rule Order

The first reading facts should appear in this order:

1. Silent `h` in `Hola`.
2. Stable vowel reading as distributed word-level support inside already known
   words; no broad vowel table yet.
3. Whole-phrase support and inverted question marks for `¿Qué tal?`; `qu` and
   accented `é` are noticed inside the phrase but not generalized yet.
4. Written accent as stress support in `Adiós`.
5. `c` in `Gracias` only as needed for that word.
6. Simple syllable support in `De nada`.
7. `ll` in `llamo`.
8. Whole-phrase support and inverted question marks for `¿Cómo te llamas?`;
   accent in `Cómo` and `ll` are reviewed locally.
9. `qu` as a general reusable rule only when a future word needs it.
10. `j`, `ñ`, `rr`, `g/e/i`, and broader alphabet work after first-contact
   expressions create a reason to read names and new words.

This order is not an alphabet order. It is a learner-action order.

## Early Grammar Order

Grammar should remain mostly unnamed in the first 15 lessons.

Allowed implicit patterns:

- a greeting can stand alone;
- a question expects an answer;
- `Me llamo ...` has a name slot;
- `¿Cómo te llamas?` asks for the name;
- `por favor` makes a request polite.

Forbidden early grammar load:

- subject pronoun paradigms;
- full verb conjugation;
- article/gender/number systems;
- formal/informal explanation beyond what the immediate phrase requires;
- punctuation theory beyond recognizing question marks in a question.

## Review Cadence

Micro-review:
Every lesson from Lesson 2 onward should review at least one previous item in a
changed task.

Integration review:
Lessons 5 and 15 are integration checkpoints. Lesson 10 is a courtesy
expansion with limited cumulative review, not a zero-new-language checkpoint.

Checkpoint targets:

- Lesson 5 reviews `Hola`, `¿Qué tal?`, and `Bien` through ordered greeting
  exchange control.
- Lesson 10 reviews `Gracias` and `De nada` while introducing `Por favor`; it
  must not require classroom-survival language.
- Lesson 15 reviews greeting, name response, and courtesy pairing only. It does
  not review the full classroom-survival sequence.

Delayed review:
Later modules should return to Lessons 1-15 after interference from new names,
numbers, places, and classroom instructions.

## Blueprint Boundary

This sequence defines what should be taught and why. It does not define:

- exact UI screens;
- exact exercise templates;
- exact localized text;
- exact JSON references;
- exact answer options;
- exact validator behavior.

Implementation phases must map each lesson scenario to existing Tutor Language
mechanisms after the pedagogical scenario is approved.
