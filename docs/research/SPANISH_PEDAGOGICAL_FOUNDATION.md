# Spanish Pedagogical Foundation

Status: PROPOSAL
Scope: spanish pedagogical foundation
Normative authority: none; requires explicit adoption

This document extracts pedagogical principles from local Spanish textbooks for
the Tutor Language beginner methodology. It does not define lessons, curriculum
changes, JSON content, runtime behavior, or application code.

The textbook material is treated as methodological evidence only. No textbook
dialogues, exercises, lesson wording, or extended explanations are reproduced.

## Project Frame

The existing Tutor Language documentation requires lesson design to begin from a
learner state transition, not from a content category or JSON shape.

Relevant local standards:

- `LESSON_AUTHORING_ENTRYPOINT.md`: authoring starts with learner state,
  scenario, learner action, support plan, and assessment plan.
- `LEARNING_STATE_MACHINE.md`: a lesson moves the learner through observable
  states such as attention, supported understanding, recognition, guided recall,
  independent recall, contextual use, and delayed retention.
- `PEDAGOGICAL_SCENARIO_MODEL.md`: each lesson needs one measurable outcome and
  every step must justify its existence.
- `LEARNING_MODEL.md`: active recall, practical use, feedback, and review are
  more important than exposure.
- `AUTHORING_STYLE_GUIDE.md`: beginner explanations must be clear, short,
  practical, and free of unnecessary linguistic terminology.
- `CONTENT_AUTHORING_GUIDE.md`: content exists to teach a specific learner
  action and should avoid redundant or dictionary-like material.
- `COURSE_AUTHORING_GUIDE.md`: the course is a roadmap; the teaching sequence is
  produced by the learning engine and the pedagogical scenario.

## Research Access Note

The local collection was inventoried under `Boocks/`. Four PDF files had usable
text extraction and were analyzed. One image-only PDF and one DJVU file were
detected but could not be read with the available local tools in this
environment; no conclusions in this document rely on those inaccessible files.

Readable sources analyzed:

- I. A. Dyshlevaya, `Курс испанского языка для начинающих`
  (`Испанский для начинающих.pdf`).
- M. M. Raevskaya and A. I. Kovrigina, `Испанский язык: новый самоучитель`
  (`Испанский.pdf`).
- V. S. Rodriguez-Danilevskaya, A. I. Patrushev, and I. L. Stepunina,
  `Учебник испанского языка. Практический курс для начинающих`
  (`Учебник испанского для начинающих.pdf`).
- M. V. Malinskaya, `Экспресс-самоучитель испанского языка`
  (`самоучитель испанского.pdf`).

Detected but not used as evidence:

- `Испанский для начинающих (2).pdf`: image-only PDF; local text extraction did
  not produce usable text.
- `Самоучитель испанского.djvu`: DJVU tooling was unavailable without elevated
  system installation.

Page references below refer to the visible printed pages or extracted text page
areas where the relevant section appears.

## Source Journal

### Dyshlevaya

Источник:
I. A. Dyshlevaya, `Курс испанского языка для начинающих`

Глава:
Предисловие; Вводная фонетическая часть; Урок 1

Стр.:
3-18, 19-37

Вывод:
The course separates foundational phonetics before the first normal lesson. It
then moves into a long grammar-rich classroom lesson with exercises, text,
commentary, dialogues, translation, and independent reading. The structure
assumes teacher pacing and a long study session, but the useful principle is
that reading and pronunciation support appear before full communicative work.

### Raevskaya and Kovrigina

Источник:
M. M. Raevskaya and A. I. Kovrigina, `Испанский язык: новый самоучитель`

Глава:
Предисловие; Фонетический курс; Урок 1

Стр.:
5-19, 39-59

Вывод:
The authors combine a dedicated phonetic foundation with a communicative first
lesson. The first lesson explicitly presents what the learner will be able to
say, then starts with first-contact language. However, it also introduces many
grammar and vocabulary items in one large unit. Tutor Language should preserve
the communicative orientation and split the load into deterministic micro-steps.

### Rodriguez-Danilevskaya, Patrushev, and Stepunina

Источник:
V. S. Rodriguez-Danilevskaya, A. I. Patrushev, and I. L. Stepunina,
`Учебник испанского языка. Практический курс для начинающих`

Глава:
Предисловие; Урок 1; Урок 2

Стр.:
3-5, 8-18, 20-21

Вывод:
The course starts with sounds, listening, repetition, reading aloud, stress, and
intonation before heavier communicative production. It relies strongly on a
teacher or audio model. The useful principle is a progression from perception
and supported decoding toward question-answer work and retelling; Tutor Language
must replace teacher/audio mediation with deterministic support and feedback.

### Malinskaya

Источник:
M. V. Malinskaya, `Экспресс-самоучитель испанского языка`

Глава:
От автора; Вводный урок; Урок 1

Стр.:
3-12, 13-58

Вывод:
The self-study course begins with an introductory pronunciation and reading
lesson, then moves into first phrases and grammar. It asks the learner to read
with support and then repeat without the table. The useful principle is support
fading inside self-study; the risky pattern is a very large first lesson with
many functions and grammar points.

## Textbook Analysis

### Course Opening

The analyzed books use two main opening strategies.

Phonetic-first opening:

- Dyshlevaya and Malinskaya begin with an introductory phonetic or pronunciation
  section before normal lessons.
- Raevskaya and Kovrigina also provide a phonetic course before Lesson 1.
- The opening goal is to prevent the beginner from treating Spanish spelling as
  if it were Russian or another known language.

Sound-first opening:

- Rodriguez-Danilevskaya, Patrushev, and Stepunina begin with sounds and
  reading behavior inside Lesson 1, rather than making the alphabet the first
  educational object.
- This makes the first learner action auditory and oral: listen, repeat, read.

Communicative-first opening:

- Raevskaya and Kovrigina and Malinskaya quickly move into greetings and first
  contact phrases after pronunciation preparation.
- The opening communicative theme is socially immediate: greeting, saying
  goodbye, identifying oneself, or asking simple first-contact questions.

Tutor Language implication:

The app should not start with a full alphabet table. It should start with one
immediate communicative success, while giving just enough pronunciation and
reading support for the next word or sentence.

### Reading Instruction

Across the readable sources, reading rules are usually introduced by:

1. Showing the written Spanish symbol or spelling pattern.
2. Giving a support-language approximation or comparison.
3. Providing several examples.
4. Asking the learner to read, repeat, classify, or apply the rule immediately.

Common early reading targets:

- Spanish vowels.
- Silent `h`.
- `ll`.
- `ñ`.
- single `r` and `rr`.
- `c` and `z`.
- `g`, `j`, `gue`, and `gui`.
- `qu`.
- stress and intonation.

Terminology use varies. Classroom-oriented textbooks use more phonetic and
grammatical terminology; self-study books often still use tables and technical
comments, but pair them with practical reading tasks.

Tutor Language implication:

Reading rules should be micro-rules connected to an immediate course word, not a
reference catalogue. Each rule should enable the learner to read the next item
and then be tested by recognition or recall.

### Vocabulary Introduction

The analyzed books often introduce more vocabulary than a mobile A0 lesson
should carry. Some classroom units introduce large lists connected to professions,
countries, family, classroom objects, or everyday social functions. The
Rodriguez-Danilevskaya course explicitly expects large vocabulary volume in a
full lesson text.

However, the stronger shared principle is contextual reuse:

- New words are connected to a topic.
- Vocabulary appears in exercises after introduction.
- Later material reuses earlier vocabulary to reduce the burden of new grammar.

Tutor Language implication:

For offline mobile A0, vocabulary should be introduced in very small sets. Every
new word needs pronunciation support, a natural translation, and an immediate
use case. Reuse should happen through changed learner actions, not through
repeated lists.

### Grammar Introduction

The analyzed books often explain grammar explicitly early: articles, gender,
number, pronouns, word order, and high-frequency verbs appear in early lessons.
This is compatible with classroom courses and long self-study chapters, but not
with short mobile beginner sessions.

The useful underlying principle is sequencing:

- Grammar is easier when examples are already meaningful.
- New grammar is often practiced with previously seen vocabulary.
- Full paradigms are not always necessary for the first communicative action.

Tutor Language implication:

Grammar should remain hidden inside a meaningful learner action until naming the
pattern helps the next action. The app should teach one grammar behavior at a
time and postpone full explanation.

### Exercise Progression

The common exercise sequence can be normalized as:

1. Observation or listening.
2. Repetition or supported reading.
3. Recognition.
4. Controlled transformation or guided recall.
5. Independent recall.
6. Context use.
7. Dialogue, retelling, writing, or translation.
8. Review.

The books differ in how quickly they move from one stage to the next. Classroom
texts can rely on a teacher to slow down, skip tasks, or correct pronunciation.
Self-study books include more explanation and tables because the teacher is
absent.

Tutor Language implication:

Tutor Language must encode this progression explicitly through the learning
state machine. The app cannot assume a teacher will decide when support should
fade.

### Teacher Behavior

The analyzed books assume a human teacher or a teacher-like function for:

- Motivation: explaining why the learner is doing the task.
- Pronunciation modeling: giving a sound before the learner reads.
- Encouragement: making early success feel possible.
- Error anticipation: warning before common beginner mistakes.
- Correction: identifying what failed and why.
- Pacing: deciding whether to repeat, skip, or advance.
- Transition phrases: moving from sound to word to sentence to use.
- Exercise selection: choosing which optional exercises matter for this learner.
- Confidence building: turning small answers into visible progress.
- Context creation: making examples feel like communication, not a list.

Tutor Language implication:

The application must perform these functions deterministically. If a textbook
step depends on teacher judgment, Tutor Language needs an explicit support,
feedback, or remediation rule before that step can be used.

### Lesson Pacing and Cognitive Load

Traditional textbooks are designed for long sessions. Raevskaya and Kovrigina
explicitly frame lessons as multi-hour units. Rodriguez-Danilevskaya and
colleagues expect large text and vocabulary work. Malinskaya compresses many
communicative functions into one self-study lesson.

For Tutor Language, these are not acceptable lesson sizes. The extracted
principle is not the volume; it is the order:

- prepare reading,
- introduce meaning,
- practice recognition,
- fade support,
- require recall,
- use in context,
- review later.

Tutor Language implication:

A mobile A0 lesson should contain one measurable skill and only the minimum new
pronunciation, vocabulary, and grammar needed to complete that skill.

## Common Principles

The following principles appear across most readable sources:

- Concrete before abstract.
- Sound and reading support before unsupported reading.
- Examples before or immediately with a rule.
- Immediate exercise after a new reading rule.
- Recognition before productive use.
- Reuse earlier vocabulary when introducing new grammar.
- Communication gives motivation to technical work.
- Review and repeated use matter more than one-time exposure.
- Teacher mediation is expected in traditional courses.

## Disagreements

Alphabet first vs sound first:

- Several books begin with the alphabet and reading tables.
- One course foregrounds sounds and reading behavior before the alphabet as a
  system.
- Possible reason: alphabet tables are useful as references, while sound-first
  teaching is more classroom-like and action-oriented.

Phonetics before communication vs communication immediately:

- Some books establish pronunciation first.
- Others move quickly toward first-contact language.
- Possible reason: classroom courses can spend time on preparation; self-study
  books need early motivation.

Grammar explicitness:

- Traditional courses explain grammar early.
- Communicative sections often hide grammar in phrases first.
- Possible reason: adult learners and classroom exams require metalanguage, but
  immediate communication requires usable patterns.

Vocabulary load:

- Long textbook units may introduce many words.
- Mobile offline lessons need fewer words because there is no live teacher to
  rescue overload.

## Failure Risk for Tutor Language

If Tutor Language copies textbook surface structure, it will produce boring or
dictionary-like lessons:

- alphabet or reading-rule catalogues instead of learner actions;
- vocabulary lists instead of meaningful use;
- explanations that replace teacher speech without teacher timing;
- grammar sections that do not answer the next learner question;
- repetition without changed retrieval demand;
- examples that are readable only because the author already knows the lesson.

The correct adaptation is to extract the teacher's pedagogical function and
implement that function through scenario design, support fading, feedback, and
state-specific remediation.
