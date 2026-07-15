# PRONUNCIATION_MODEL.md

Status: Proposed

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

This document is conceptual. It does not introduce a runtime model, JSON schema,
migration, editor, IPA database, audio system, generator or validator in the
current phase.

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

## localizedPronunciationExplanations

Support-locale-specific pedagogical explanations.

Examples:

- why a written letter is silent;
- why stress falls on a syllable;
- why the target form should not be pronounced literally.

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

The current Spanish assets store a single optional `pronunciation` string on
VocabularyItem.

That field is legacy plain text.

It is not a PronunciationUnit.

It is not IPA.

It is not support-locale-safe.

It must not be expanded as the long-term model.

---

# Deferred Work

This phase does not implement:

- runtime PronunciationUnit models;
- JSON schema changes;
- migrations;
- authoring editor support;
- IPA database;
- audio;
- generators;
- validation checks;
- asset rewrites.

Future implementation should migrate from copied `pronunciation` strings to
stable PronunciationUnit references.

---

End of document.
