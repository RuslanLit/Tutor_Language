# ARCHITECTURE.md

Status: Active

Version: 2.2

Related documents:

- PROJECT_VISION.md
- PROJECT_CONTRACT.md
- ARCHITECTURAL_DECISIONS.md
- CURRICULUM_SPEC.md
- LEARNING_MODEL.md
- V1_TECHNICAL_SPEC.md

---

# Purpose

This document defines the conceptual software architecture of Tutor Language.

It describes the major architectural components, their responsibilities and the flow of information between them.

Educational methodology is defined in LEARNING_MODEL.md.

Curriculum structure is defined in CURRICULUM_SPEC.md.

Implementation details are intentionally excluded.

---

# Architectural Goals

The architecture should remain:

- deterministic;
- modular;
- replaceable;
- explainable;
- testable;
- offline-first;
- maintainable;
- language-agnostic;
- compatible with F-Droid.

---

# High-Level Architecture

Tutor Language consists of three conceptual layers.

```text
Educational Domain
        │
Planning Layer
        │
Execution Layer
```

Every component belongs to exactly one layer.

Responsibilities must not overlap.

Educational Domain

The Educational Domain defines what may be taught.

Components:

```text
Language Packs
        │
Educational Content
        │
Curriculum
```

These components are static.

They never depend on a learner.

They never change during lessons.

Language Packs

A Language Pack contains all educational data for one supported language.

Examples:

Spanish Language Pack
English Language Pack
German Language Pack
French Language Pack

A Language Pack may contain:

language metadata;
courses;
modules;
lesson definitions;
vocabulary;
grammar topics;
dialogues;
reading texts;
listening materials;
exercises;
audio assets.

A Language Pack never contains learner progress.

Multi-Language Architecture

Tutor Language is designed as a language-agnostic learning platform.

The learning engine must not contain language-specific logic.

Every supported language is provided as a separate Language Pack containing curriculum and educational content.

Adding support for a new language should primarily require adding a new Language Pack without modifying the learning engine.

Core entities are language-independent.

Examples:

Language
Course
Module
LessonDefinition
VocabularyItem
Dialogue
GrammarTopic
Exercise
Reading
AudioAsset

Generation 1 ships only with the Spanish Language Pack.

This limits content scope, not engine architecture.

Educational Content

Educational Content defines every educational object available to the application.

Examples:

vocabulary;
grammar;
templates;
dialogues;
reading texts;
listening texts;
audio assets;
exercises.

Educational Content never stores learner information.

Educational Content belongs to a Language Pack.

Curriculum

Curriculum defines the recommended learning order.

The curriculum determines:

prerequisites;
lesson order;
educational dependencies;
lesson sequence;
module structure.

Generation 1 uses a mostly linear curriculum.

Future versions may replace it with a knowledge graph without changing the remaining architecture.

Curriculum structure is specified in CURRICULUM_SPEC.md.

Planning Layer

The Planning Layer determines what should happen next.

Components:

Learner Profile
        │
Review Queue
        │
Lesson Planner

Planning is deterministic.

Planning never generates lessons.

Learner Profile

Represents everything currently known about one learner.

The Learner Profile is composed of independent models.

Learner Profile
│
├── Learner State
├── Knowledge Model
├── Learning Model
├── Memory Model
├── Motivation Model
└── Evidence Model

Only the Learner State Update component may modify the profile.

The Learner Profile may reference language, course, lesson and content identifiers.

It does not own curriculum or educational content.

Review Queue

Maintains educational priorities.

Responsibilities:

schedule repetitions;
prioritize weak knowledge;
prevent forgetting.

The Review Queue never generates lessons.

The Review Queue may reference educational content identifiers.

It does not duplicate educational content.

Lesson Planner

The Lesson Planner is the educational decision-making component.

Its responsibility is to determine the objective of the next lesson.

Inputs:

Curriculum
Learner Profile
Review Queue

Outputs:

Lesson Goal
Lesson Constraints

The Lesson Planner:

never generates lesson content;
never evaluates learner answers;
never modifies learner data.

Its decisions must remain deterministic and explainable.

Lesson Goal

Defines the primary educational objective.

Examples:

introduce vocabulary;
reinforce grammar;
consolidate knowledge;
review forgotten material;
practice listening;
practice reading.

Every lesson has exactly one primary goal.

Lesson Constraints

Translate educational decisions into measurable boundaries.

Examples:

duration;
number of new words;
review items;
grammar focus;
exercise mix;
difficulty;
required activity types.

The Lesson Generator must never violate these constraints.

Execution Layer

The Execution Layer performs learning activities.

Components:

Lesson Generator
        │
Lesson Session
        │
Evaluation
        │
Learner State Update

Execution never changes planning decisions.

Lesson Generator

Builds a lesson session.

Inputs:

Educational Content
Curriculum
LessonDefinition
Lesson Goal
Lesson Constraints

Outputs:

Lesson Session

The generator may use deterministic randomization internally.

Randomization changes presentation only.

Educational objectives never change.

Lesson generation may use predefined LessonDefinitions, templates or optional future generators.

The generator assembles a runtime Lesson Session.

It must not mutate Curriculum or Educational Content.

It must not store Generated Exercises in LessonDefinitions.

The generator never controls long-term teaching strategy.

Lesson Session

Represents learner interaction.

Responsibilities:

present activities;
present exercises;
collect answers;
preserve session state;
record timing.

The Lesson Session never evaluates answers.

Evaluation

Determines learning results.

Responsibilities:

compare answers;
classify mistakes;
calculate statistics;
determine mastery changes;
determine completion status.

Evaluation never plans lessons.

Evaluation never modifies educational content.

Learner State Update

Updates learner information after evaluation.

Responsibilities:

update learner state;
update review priorities;
accumulate evidence;
update motivation statistics;
update mastery information.

This is the only component allowed to modify the Learner Profile.

Information Flow

The architecture follows a single direction.

Language Pack
        │
Educational Content
        │
Curriculum
        │
Learner Profile
        │
Review Queue
        │
Lesson Planner
        │
Lesson Goal
        │
Lesson Constraints
        │
Lesson Generator
        │
Lesson Session
        │
Evaluation
        │
Learner State Update
        │
        └──────────────► Learner Profile

The learning cycle repeats indefinitely.

There are no other feedback loops.

Component Boundaries

Every component owns exactly one responsibility.

Components communicate only through defined outputs.

A component must never modify another component's internal data directly.

Responsibilities should remain explicit.

Language-specific data must remain inside Language Packs.

Learner-specific data must remain inside learner models.

Optional AI Components

Artificial intelligence is outside the pedagogical core.

Possible future components include:

Local LLM;
Speech Recognition;
Text-to-Speech;
Pronunciation Analysis.

These components assist learning.

They never determine educational strategy.

The architecture must remain fully functional without them.

Replaceability

Major subsystems should remain replaceable.

Examples:

Lesson Generator;
Local LLM;
Speech Recognition;
Text-to-Speech;
Database;
Language Pack loader.

Replacing one subsystem must not require redesigning the architecture.

Failure Isolation

Optional components should fail independently.

Examples:

no speech recognition → continue using text;
no TTS → continue silently;
no LLM → use predefined explanations;
missing optional audio → continue with text-only lesson.

Core learning must always remain available.

Architecture Principles

The architecture should evolve through extension rather than replacement.

New components should improve an existing information flow rather than introduce parallel flows.

Every new feature should strengthen at least one stage of the learning cycle.

The engine should not be specialized for a single language.

Language-specific differences should be represented through Language Pack data and configuration.

Final Principle

Architecture defines responsibilities.

Curriculum Specification defines educational structure.

Learning Model defines educational behaviour.

Implementation defines software behaviour.

These concerns should remain independent.

End of document.
