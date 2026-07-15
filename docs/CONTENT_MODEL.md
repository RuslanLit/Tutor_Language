# CONTENT_MODEL.md

Status: Active

Version: 3.3

Related documents:

- PROJECT_VISION.md
- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md
- PRONUNCIATION_MODEL.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- CURRICULUM_SPEC.md
- LEARNING_MODEL.md
- V1_TECHNICAL_SPEC.md

---

# Purpose

This document defines the educational knowledge model of Tutor Language.

It describes educational objects, their relationships and the principles governing educational content.

Implementation details, databases and serialization formats are outside the scope of this document.

---

# Fundamental Principle

Educational Content represents knowledge.

Learner State represents learning.

These concepts are completely independent.

Educational Content:

- is immutable;
- contains no learner information.

Learner State:

- is mutable;
- never modifies Educational Content.

---

# Conceptual Domains

Tutor Language consists of two independent domains.

## Knowledge Domain

Contains:

- Educational Content
- Curriculum

## Learner Domain

Contains:

- Learner State
- Review Queue
- Evidence
- Statistics
- Motivation

Educational planning connects these domains.

---

# Curriculum Structure

Educational Content is organized by the following hierarchy:

```text
Language Pack
    │
Course
    │
Module
    │
LessonDefinition
```

This hierarchy organizes learning only.

It is not educational knowledge itself.

A Language Pack may contain multiple Courses.

The learning engine remains language-independent.

---

# Educational Content

Educational Content consists of reusable knowledge objects.

Generation 1 defines:

- Vocabulary Item
- Grammar Topic
- Dialogue
- Reading Text
- Exercise Template

Every knowledge object:

- has a stable identifier;
- may be referenced by multiple LessonDefinitions;
- is reusable;
- never stores learner progress.

Educational Content may contain target-language material and support-language
presentation text. Support-language presentation text is localized through the
educational-content localization system, not through application UI ARB files.
Stable identifiers and target-language forms remain locale-independent.

---

# Course

Represents one educational program.

Responsibilities:

- organize Modules;
- define educational scope.

A Course never stores learner information.

---

# Module

Groups related LessonDefinitions.

Responsibilities:

- organize LessonDefinitions;
- improve navigation.

Modules contain no learner information.

---

# LessonDefinition

LessonDefinition is the smallest educational unit.

A LessonDefinition is reusable curriculum data.

It is not a generated Lesson Session.

A LessonDefinition references:

- Vocabulary Items;
- Grammar Topics;
- Dialogues;
- Reading Texts;
- Exercise Templates.

LessonDefinition files contain:

- metadata;
- objectives;
- sections;
- activities;
- summary;
- completion criteria;
- references.

LessonDefinitions organize knowledge.

LessonDefinitions never duplicate knowledge.

LessonDefinitions must reference Educational Content by stable identifiers or asset references.

LessonDefinitions must not embed educational knowledge directly.

LessonDefinitions provide source references and structural requirements for deterministic lesson planning and assembly.

Generated Exercises and learner interaction state exist only at runtime and are never stored inside LessonDefinitions.

LessonPlan is not Educational Content.

LessonPlan is the runtime planning output that selects a LessonDefinition for a learner and records the reason for that selection.

LessonPlan must not store reusable educational knowledge.

---

# Vocabulary Item

Represents one lexical concept.

Contains:

- stable identifier;
- target-language form;
- learner-language meaning;
- pronunciation;
- CEFR level;
- example usage.

Current implementation note:

The `pronunciation` field is a legacy plain-text learner hint. It must not be
treated as IPA or as a universal hint for every support locale.

Target architecture:

Pronunciation concepts are modelled separately:

- PronunciationUnit: reusable pronunciation knowledge object with stable ID.
- PronunciationData: pronunciation information associated with a target form or
  pronunciation concept.
- PronunciationVariety: the declared course or content pronunciation norm.
- IpaTranscription: locale-independent IPA for the declared variety.
- LocalizedPronunciationHint: support-locale-specific learner approximation.
- LocalizedPronunciationExplanation: support-locale-specific sound or reading
  explanation.
- AudioReference: stable reference to future target-language pronunciation
  audio.

These concepts are documented in PRONUNCIATION_MODEL.md and
PRONUNCIATION_AUTHORING_GUIDE.md. Runtime schema migration is deferred; current
assets should not add more universal pronunciation hints.

For new pronunciation-capable vocabulary, the target architecture requires a
complete PronunciationUnit before release. Multi-syllable items must include
target orthography, declared pronunciation variety, IPA, localized learner
hints with explicit stress marking, localized explanations where needed and an
example sentence. A vocabulary item is not release-complete if any mandatory
pronunciation element is missing.

PronunciationUnit is reusable Educational Content in the target architecture.
Vocabulary, Grammar Topics, Dialogues, Reading Texts, Exercise Templates and
LessonDefinitions should reference it when pronunciation knowledge is needed.

R2E2B implements a runtime reference slice for PronunciationUnit without
removing legacy vocabulary `pronunciation` fields.

Vocabulary Items may be referenced by multiple LessonDefinitions.

Vocabulary Items never store learner progress.

---

# Grammar Topic

Represents one grammatical concept.

Contains:

- stable identifier;
- explanation;
- examples;
- prerequisites.

Grammar Topics may be referenced by multiple LessonDefinitions.

Grammar Topics never store learner performance.

---

# Dialogue

Represents conversational educational material.

Dialogues reference existing Vocabulary Items and Grammar Topics.

---

# Reading Text

Represents educational reading material.

Reading Texts reference existing knowledge whenever practical.

---

# Exercise Template

Defines reusable exercise structure.

Examples:

- Multiple Choice
- Fill Gap
- Matching
- Translation

Templates never contain learner progress.

---

# Generated Exercises

Generated Exercises are runtime objects.

They:

- are created during lesson execution when needed;
- exist only during a Lesson Session;
- may be discarded after evaluation.

Only learning outcomes remain persistent.

---

# Knowledge Relationships

Knowledge objects reference one another using stable identifiers.

Relationships should use references rather than duplication.

Generated Exercises reference Educational Content.

Generated Exercises never become Educational Content.

---

# Content Identity

Every knowledge object must have a stable identifier.

Stable identifiers preserve:

- learner progress;
- references;
- backward compatibility;
- future content evolution.

Identifiers should never change unless educational meaning changes.

---

# Content Versioning

Educational Content may improve over time.

Existing identifiers should remain stable whenever possible.

Breaking educational changes should introduce new identifiers.

---

# Content Integrity

Educational Content should remain internally consistent.

Every knowledge object should have:

- one stable identifier;
- one educational meaning;
- valid references.

Broken references are content defects.

---

# Content Sources

Educational Content may preserve origin metadata, including:

- author;
- dictionary source;
- grammar reference;
- public domain source;
- license.

Source metadata is informational only.

Tutor Language never automatically communicates with external sources.

---

# Educational Independence

Educational Content is independent from:

- Learner Profile;
- Learner State;
- Review Queue;
- Evidence;
- Statistics;
- Motivation;
- Lesson History.

Knowledge remains constant.

Learners evolve.

---

# Generation 1

Included:

- one Language Pack (Spanish);
- one Course;
- linear Curriculum;
- static Educational Content;
- template-based Exercises.

Postponed:

- additional Language Packs;
- multiple Courses;
- knowledge graph;
- procedural content;
- AI-assisted content authoring.

---

# Known Technical Debt

The canonical curriculum hierarchy is:

```text
Language Pack
    │
Course
    │
Module
    │
LessonDefinition
```

Legacy runtime names such as:

- TopicProgress
- topicId
- TopicRoute

remain temporarily for compatibility.

They should be migrated to Lesson terminology in a future compatibility phase.

---

# Future Evolution

Future versions may introduce:

- semantic knowledge graphs;
- richer relationships;
- adaptive curricula;
- AI-assisted authoring;
- multiple educational pathways.

These extensions should extend the model rather than replace it.

---

# Final Principles

Educational Content defines what exists.

Curriculum defines how Educational Content is organized.

Learning Model defines what should happen next.

Architecture defines responsibilities.

Implementation defines software behaviour.

---

End of document.
