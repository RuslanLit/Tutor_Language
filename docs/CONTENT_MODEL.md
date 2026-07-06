# CONTENT_MODEL.md

Status: Active

Version: 3.0

Related documents:

- PROJECT_VISION.md
- ARCHITECTURE.md
- LEARNING_MODEL.md
- V1_TECHNICAL_SPEC.md

---

# Purpose

This document defines the educational content model of Tutor Language.

It describes the educational knowledge available to the learning system, the relationships between educational objects, and the principles governing educational content.

This document intentionally avoids implementation details.

Database schema, JSON representation and software classes are outside the scope of this document.

---

# Fundamental Principle

Educational Content represents knowledge.

Learner State represents learning.

These concepts are fundamentally different and must remain completely independent.

Educational Content is immutable.

Learner State is mutable.

Educational Content must never contain learner-specific information.

Learner State must never modify Educational Content.

---

# Two Independent Worlds

Tutor Language consists of two independent conceptual domains.

## Knowledge Domain

Contains:

- Educational Content
- Educational Structure

## Learner Domain

Contains:

- Learner State
- Review Queue
- Evidence
- Statistics
- Motivation

Educational planning is the only bridge between these domains.

Neither domain owns the other.

---

# Educational Content

Educational Content consists of reusable knowledge objects.

Knowledge objects represent educational concepts rather than lessons.

Generation 1 defines the following knowledge objects:

- Vocabulary Item
- Grammar Topic
- Dialogue
- Reading Text
- Exercise Template

Every knowledge object:

- has a stable identifier;
- may be referenced by multiple educational objects;
- is reusable;
- never stores learner progress.

---

# Educational Structure

Educational Structure organizes educational knowledge.

Generation 1 uses the following hierarchy:

```text
Course
    │
    ▼
Unit
    │
    ▼
Topic
```

This hierarchy exists only to organize learning.

It does not represent educational knowledge itself.

Future versions may replace this hierarchy without changing the underlying knowledge objects.

---

# Course

Purpose

Represents one educational program.

Generation 1 contains exactly one Course.

Responsibilities

- organize Units;
- define the educational scope.

A Course never stores learner information.

---

# Unit

Purpose

Groups related Topics.

Responsibilities

- organize Topics;
- improve navigation.

Units are organizational objects.

They never contain learner information.

---

# Topic

Purpose

Groups related knowledge objects.

A Topic references:

- Vocabulary Items;
- Grammar Topics;
- Dialogues;
- Reading Texts;
- Exercise Templates.

Topics organize knowledge.

Topics never duplicate knowledge.

---

# Vocabulary Item

Purpose

Represents one lexical concept.

Contains:

- stable ID;
- Spanish form;
- native translation;
- pronunciation;
- CEFR level;
- example sentence.

Vocabulary Items may belong to multiple Topics.

Vocabulary Items never store:

- learner mastery;
- review history;
- statistics.

---

# Grammar Topic

Purpose

Represents one grammatical concept.

Contains:

- stable ID;
- explanation;
- examples;
- prerequisites.

Grammar Topics may belong to multiple Topics.

Grammar Topics never store learner performance.

---

# Dialogue

Purpose

Represents conversational educational material.

Dialogues reference existing Vocabulary Items and Grammar Topics.

Dialogues never duplicate educational knowledge.

---

# Reading Text

Purpose

Represents educational reading material.

Reading Texts reference existing knowledge objects whenever practical.

Reading Texts never store learner information.

---

# Exercise Template

Purpose

Defines a reusable exercise structure.

Examples:

- Multiple Choice;
- Fill Gap;
- Matching;
- Translation.

Templates define educational structure.

Templates never contain learner progress.

---

# Generated Exercises

Generated Exercises are **not** Educational Content.

Generated Exercises are temporary runtime objects.

They are created during lesson generation.

They exist only during a Lesson Session.

After evaluation they may be discarded.

Only learning outcomes remain persistent.

Educational interactions are temporary.

Educational knowledge is permanent.

---

# Knowledge Relationships

Knowledge objects reference one another using stable identifiers.

Relationships should always use references.

Educational knowledge should never be duplicated.

Example:

```text
Vocabulary Item
        │
        ▼
Grammar Topic
        │
        ▼
Exercise Template
        │
        ▼
Generated Exercise
```

Generated Exercises reference knowledge.

Generated Exercises never become knowledge.

---

# Content Identity

Every knowledge object must have a stable identifier.

Identifiers represent educational concepts rather than implementation details.

Stable identifiers should remain unchanged across application versions whenever possible.

Stable identifiers allow:

- learner progress preservation;
- reliable references;
- future content improvements;
- backward compatibility.

---

# Content Versioning

Educational Content may evolve over time.

Examples, explanations and exercises may be improved.

Whenever possible, existing identifiers should remain stable.

Breaking educational changes should introduce new identifiers rather than changing the meaning of existing knowledge objects.

---

# Content Integrity

Educational Content should remain internally consistent.

Every knowledge object should have:

- a stable identifier;
- clearly defined relationships;
- one educational meaning.

Broken references should be treated as educational content defects.

---

# Content Sources

Educational Content should preserve its educational origin whenever practical.

Examples include:

- original author;
- grammar reference;
- dictionary source;
- public domain source;
- license information.

Source information exists for transparency only.

Tutor Language never automatically interacts with external educational sources.

---

# Educational Independence

Educational Content is completely independent from:

- Learner Profile;
- Learner State;
- Statistics;
- Review Queue;
- Evidence;
- Motivation;
- Lesson History.

Knowledge remains constant.

Learners evolve.

---

# Generation 1 Simplification

Generation 1 intentionally limits educational complexity.

Included:

- one language;
- one Course;
- static Educational Content;
- linear Educational Structure;
- template-based Exercises.

Postponed:

- multiple Courses;
- multiple languages;
- knowledge graph;
- procedural educational content;
- AI-assisted content authoring.

Reducing educational complexity increases implementation quality.

---

# Future Evolution

Future versions may introduce:

- semantic knowledge graphs;
- richer relationships between knowledge objects;
- adaptive curricula;
- AI-assisted content authoring;
- multiple educational pathways.

These extensions should build upon the existing Educational Content model rather than replace it.

---

# Educational Stability

Educational knowledge changes much more slowly than software.

Software should evolve around Educational Content.

Educational Content should never evolve merely to satisfy implementation details.

Educational Content is one of the most stable assets of the project.

---

# Final Principles

Educational knowledge is permanent.

Educational interactions are temporary.

Learning outcomes are permanent.

The application should preserve learner progress rather than generated lessons.

Educational Content defines what exists.

The Learning Model defines what should happen next.

The Architecture defines who is responsible for making that happen.

These responsibilities should remain permanently separated.

---

End of document.