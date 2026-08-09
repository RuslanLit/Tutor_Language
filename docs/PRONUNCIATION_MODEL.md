# PRONUNCIATION_MODEL.md

Status: NORMATIVE
Scope: language pronunciation model
Authority: primary

Version: 1.0

Related documents:

- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md
- CONTENT_MODEL.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- AUTHORING_STYLE_GUIDE.md
- EDUCATIONAL_CONTENT_LOCALIZATION.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- WRITING_SYSTEM_STANDARD.md
- WRITING_UNIT_INTRODUCTION_STANDARD.md
- READING_RULE_PREREQUISITE_STANDARD.md
- GRAPHEME_PRESENTATION_STANDARD.md
- SPANISH_LLY_PRONUNCIATION_POLICY.md
- SPANISH_A0_CURRICULUM_BLUEPRINT.md
- RELEASE_CHECKLIST.md

---

# Purpose

This document defines the conceptual pronunciation knowledge model for Tutor
Language.

Pronunciation is reusable educational knowledge. It does not belong to one
lesson, one word or one exercise.

Any educational material that needs pronunciation knowledge should reference a
PronunciationUnit instead of storing its own copied pronunciation data.

Writing-system knowledge is adjacent but distinct. A written symbol or symbol
sequence is represented conceptually as a WritingUnit, while its sound is
represented by PronunciationUnit and its reusable spelling-to-sound behavior by
ReadingRule. See WRITING_SYSTEM_STANDARD.md.

Pronunciation of a WritingUnit's conventional name is separate from
pronunciation of the unit's reading inside words. See
WRITING_UNIT_INTRODUCTION_STANDARD.md.

This document defines the long-term conceptual model and records the current
runtime status. It does not require full-course migration, an editor, IPA
database or audio system in the current phase.

Implementation status:

R2E2C introduced typed PronunciationUnit runtime integration, direct vocabulary
references for the migrated Spanish A0 release slice, deterministic validation
tools and coverage reporting. Full-course migration, complete IPA review, audio
and durable editor tooling remain deferred. See
PRONUNCIATION_R2E2C_RUNTIME_REPORT.md.

---

# Core Principle

Pronunciation is an educational knowledge object, not a localized text field.

Localized pronunciation hints are learner-facing support text, but the
underlying pronunciation knowledge is target-language educational content.

One PronunciationUnit may be reused by:

- Vocabulary;
- Grammar;
- Reading;
- Dialogue;
- Listening;
- Speaking;
- Typing;
- Review;
- Competency checks;
- future AI-assisted tutoring.

The LessonDefinition organizes references to pronunciation knowledge. It must
not duplicate pronunciation knowledge.

---

# Conceptual Diagram

```text
Vocabulary
        |
        v
PronunciationUnit
        |
   +----+-------------+
   |    |             |
  IPA  Reading       Articulation
   |    Rules         Hints
   |
Localized Learner Hints
   |
Lesson
   |
Exercise
```

The diagram shows dependency direction. Vocabulary may reference
PronunciationUnit. Lessons and exercises may reference the same unit directly
when pronunciation is the learning objective.

---

# PronunciationUnit

A PronunciationUnit represents one reusable pronunciation concept.

It may describe:

- the pronunciation of one target word or phrase;
- a target-language sound;
- a letter-to-sound reading rule;
- a stress pattern;
- a contrast such as `r` versus `rr`;
- an articulation pattern;
- a pronunciation difficulty common for a learner group.

It must have a stable ID.

It must not contain learner progress.

It must be reusable across lessons, exercises and content types.

## Production Completeness

A production PronunciationUnit for a vocabulary item is complete only when it
contains enough information for a beginner learner and a reviewer to understand
the intended pronunciation without guessing.

For pronunciation-capable vocabulary items containing two or more syllables,
the required production elements are:

- stable PronunciationUnit ID;
- target-language orthography;
- declared pronunciation variety;
- IPA transcription;
- localized learner pronunciation hint for each released support locale;
- explicit stress marking in each localized learner hint;
- localized pronunciation explanation when the spelling, stress or sound is
  not obvious for the learner group;
- natural example sentence.

One-syllable words may omit stress marking in localized learner hints when
stress is pedagogically obvious.

Examples:

```text
hambre
/ˈambɾe/
[а́мбре]
голод
Tengo hambre.
```

A vocabulary card is incomplete for release if any mandatory production
element is missing. Authors must not publish a new lexical item without its
complete pronunciation description when pronunciation guidance is applicable.

Language-specific pronunciation policies belong to target-course policy
documents. For example, Spanish A0 defines its `ll` and consonantal `y`
production norm in SPANISH_LLY_PRONUNCIATION_POLICY.md. That policy is not a
universal pronunciation rule for every Spanish course or every target language.

---

# Field Responsibility

## id

Stable technical identity.

Never localized.

## targetOrthography

Authentic target-language spelling.

Never localized.

Examples:

- `hola`
- `adiós`
- `España`

## ipa

International Phonetic Alphabet representation.

Locale-independent.

Never depends on UI language or support locale.

Authored against the declared pronunciation variety.

IPA is the canonical textual pronunciation representation.

It must include stress marking according to the course IPA policy whenever
stress is relevant.

## pronunciationVariety

The pronunciation norm used by the unit.

Examples:

- Castilian;
- Latin American;
- Mexican;
- Argentinian;
- German Standard;
- British English;
- General American.

This is target-language metadata, not support-language text.

## readingRules

References to reusable language reading rules.

A reading rule is not a description of one word. It is a target-language rule
that can be used by many words.

Examples:

- Spanish `h` is silent.
- `ll` -> `/ʝ/` for the selected course norm.
- `ñ` -> `/ɲ/`.
- `c + e` -> `/θ/` for a distinction norm.

One reading rule may support thousands of words.

Runtime ReadingRule objects are first-class pronunciation knowledge. A
production rule contains:

- stable ID;
- schema version;
- knowledge domain `language`;
- rule kind `reading`;
- target language;
- pronunciation variety ID;
- orthographic pattern;
- phonetic outcome and/or IPA representation when the rule describes a sound;
- applicability;
- exceptions when needed;
- example PronunciationUnit IDs;
- grapheme components and confusable graphemes when visual ambiguity is
  pedagogically relevant;
- related educational content IDs;
- difficulty;
- technical metadata.

Localized learner support for a ReadingRule is separate from the base rule and
may include:

- localized title;
- short explanation;
- detailed explanation;
- articulation hint;
- common mistakes;
- contrast note;
- localized grapheme presentation;
- localization metadata.

PronunciationUnits reference ReadingRules by stable ID. ReadingRules may list
example PronunciationUnits. Lessons and exercises may depend on ReadingRules
through stable references; correctness must never depend on localized rule
titles or explanation text.

When a ReadingRule is needed before active learner use, curriculum metadata
declares the introduction and requirements. See
READING_RULE_PREREQUISITE_STANDARD.md.

When a ReadingRule contains visually confusable graphemes, the resolved
presentation should provide decomposition, localized letter names and
accessibility semantics. See GRAPHEME_PRESENTATION_STANDARD.md.

## articulationHints

Language-neutral or target-language articulation data.

Examples:

- tongue touches alveolar ridge;
- lips rounded;
- soft palate lowered.

These are not learner-facing localized explanations by themselves. They may be
used to author localized explanations.

## localizedLearnerHints

Support-locale-specific approximate pronunciation aids.

Examples:

- `en`;
- `ru`;
- `uk`;
- `pl`;
- `de`.

Each locale is independently authored and reviewed.

English hints must not be copied into Russian, Ukrainian, Polish or German.

Localized learner hints are support text, not canonical pronunciation.

Hints for multi-syllable words must mark stress explicitly.

Examples:

- Russian: `[о́ла]`;
- German: `[óla]`;
- Polish: `[óla]`.

## localizedPronunciationExplanations

Support-locale-specific pedagogical explanations.

Examples:

- why a written letter is silent;
- why stress falls on a syllable;
- why the target form should not be pronounced literally.

Pronunciation explanations are learner support. They do not replace IPA,
pronunciation variety or reading-rule references.

## audioReferenceId

Stable reference to future audio.

Never localized unless the audio itself is support-language narration.

Audio is deferred.

## difficulty

Educational difficulty for pronunciation learning.

This is target-course metadata. It is not learner progress.

## commonMistakes

Authored common pronunciation mistakes.

Mistakes may be scoped by support-language background when justified.

Examples:

- Russian speakers;
- Polish speakers;
- English speakers.

Common mistakes are educational knowledge. They must not imply that every
learner with that support locale will make the mistake.

## relatedVocabulary

Stable references to vocabulary items that use this pronunciation unit.

The relationship may also be represented in the opposite direction by
VocabularyItem references. The model does not require duplication.

## relatedGrammar

Stable references to grammar or reading topics related to the unit.

Example:

A reading rule may be related to a grammar topic when pronunciation supports a
grammar pattern or orthographic distinction.

## metadata

Technical and review metadata.

Examples:

- source;
- reviewer;
- license;
- version;
- last reviewed date;
- confidence;
- notes for migration.

Metadata is not learner-facing by default.

---

# Ownership Classes

| Field | Owner | Localized |
| --- | --- | --- |
| `id` | technical metadata | no |
| `targetOrthography` | target-language content | no |
| `ipa` | locale-independent pronunciation data | no |
| `pronunciationVariety` | target-language/course policy | no |
| `readingRules` | target-language pronunciation knowledge | no, but explanations may be localized |
| `articulationHints` | pronunciation knowledge | no, unless rendered as explanation |
| `localizedLearnerHints` | support-language educational content | yes |
| `localizedPronunciationExplanations` | support-language educational content | yes |
| `audioReferenceId` | technical asset reference | no |
| `difficulty` | educational metadata | no |
| `commonMistakes` | educational knowledge | may include localized explanations |
| `relatedVocabulary` | content relationship | no |
| `relatedGrammar` | content relationship | no |
| `metadata` | technical/review metadata | no |

---

# Reuse

PronunciationUnit prevents duplication.

For example, the Spanish silent `h` unit can be reused by:

- vocabulary: `hola`, `hambre`, `hospital`;
- grammar or reading-rule lessons;
- readings that introduce silent `h` words;
- dialogues containing affected vocabulary;
- listening or speaking activities;
- typing exercises that check spelling with silent `h`;
- review lessons;
- competency checks;
- future AI tutor explanations.

The pronunciation unit remains one source of truth. Educational activities
decide how to use it pedagogically.

---

# Authoring Workflow

```text
Word or pronunciation concept
        |
        v
PronunciationUnit
        |
        v
IPA
        |
        v
Reading Rule
        |
        v
Localized learner hints
        |
        v
Lesson Assembly
```

Detailed authoring rules live in PRONUNCIATION_AUTHORING_GUIDE.md.

---

# Current Implementation

Historical Spanish pronunciation assets were removed during the course reset.
Future Spanish pronunciation content must use the PronunciationUnit runtime
foundation and must not reintroduce legacy plain-text pronunciation hints as
the long-term model.

---

# Deferred Work

This phase does not implement:

- complete production PronunciationUnit migration;
- durable JSON schema changes for all language packs;
- migrations;
- authoring editor support;
- IPA database;
- audio;
- complete generator integration beyond the pronunciation CLI tools;
- full-course asset rewrites.

Future implementation should continue migrating copied `pronunciation` strings
to stable PronunciationUnit references.

## Spanish A0 Alphabet Preparation

The Spanish A0 course may expose one optional Spanish Alphabet / Reading
Preparation screen before Lesson 1. It is a compact scrollable reference, not
Lesson 0, a pronunciation course or a prerequisite. It does not count toward
the five canonical lessons. The learner may skip it or reopen it later; using
the Continue action marks only the preparation as completed before opening
canonical Lesson 1.

The screen presents the 27 modern Spanish letters with learner-language
approximations for letter names and beginner reading orientation, followed by
the common `ch` and `ll` digraphs. Spanish target forms remain unchanged and
the support explanations are authored independently for each supported locale.
There are no word examples, recognition questions, retry exercises, audio,
ASR, pronunciation scoring, runtime AI or cloud dependency in this screen.

Skipping or completing the preparation never changes the canonical 0/5 lesson
progress or competency state. More detailed spelling and pronunciation support
belongs just in time inside later lessons.

---

End of document.
