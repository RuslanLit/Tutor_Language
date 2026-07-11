# ARCHITECTURE.md

Status: Active

Version: 2.3

Related documents:

- PROJECT_VISION.md
- PROJECT_CONTRACT.md
- EDUCATIONAL_PRINCIPLES.md
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

The implemented learning flow is:

```text
Educational Content
        |
        v
Curriculum
        |
        v
Rule-Based Lesson Planner
        |
        v
LessonPlan
        |
        v
LessonAssemblyService
        |
        v
LessonPlayer
        |
        v
ActivityEngine
        |
        v
Assessment / Completion Evaluation
        |
        v
Learner History
```

This flow separates educational decision-making, content resolution, presentation, activity execution and progress recording.

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

```text
Learner History
        |
        v
LearnerHistorySummary
        |
        v
Rule-Based Lesson Planner
        |
        v
LessonPlan
```

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

Its responsibility is to determine the next lesson selection.

The implemented planner is `RuleBasedLessonPlanner`.

Inputs:

Curriculum
PlanningRequest
PlanningPolicy
LearnerHistorySummary

Outputs:

LessonPlan

The Lesson Planner:

never assembles lesson content;
never evaluates learner answers;
never modifies learner data.

Its decisions must remain deterministic and explainable.

`LessonPlan` is the planner output. It identifies the selected LessonDefinition, the plan type and reason codes explaining the selection.

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

The Lesson Planner must respect these constraints when they are implemented by policy.

Execution Layer

The Execution Layer performs learning activities.

Components:

```text
LessonAssemblyService
        |
        v
LessonPlayer
        |
        v
ActivityEngine
        |
        v
Assessment / Completion Evaluation
        |
        v
Learner State Update
```

Execution never changes planning decisions.

Lesson Assembly

`LessonAssemblyService` resolves a selected LessonDefinition into assembled lesson content.

Inputs:

Educational Content
Curriculum
LessonDefinition

Outputs:

LessonContent

Lesson assembly must not decide what the learner should study next.

Lesson assembly must not mutate Curriculum or Educational Content.

Lesson assembly must not store Generated Exercises in LessonDefinitions.

Lesson Rendering

`LessonPlayer` presents assembled lesson content to the learner.

Responsibilities:

present activities;
present exercises;
collect answers;
preserve session state;
record timing.

The LessonPlayer does not choose lesson content and does not own educational strategy.

Activity Execution

`ActivityEngine` evaluates supported interactive activity templates.

Responsibilities:

render activity-specific controls;
check learner answers;
return deterministic activity results.

The ActivityEngine does not plan lessons and does not mutate educational content.

Assessment / Completion Evaluation

Determines learning results.

Responsibilities:

compare answers;
classify mistakes;
calculate statistics;
determine completion status.

The current implementation records activity outcomes and uses completion evaluation to decide whether a learning session is complete.

Advanced mastery changes and spaced-repetition scheduling are future work.

Future answer evaluation should keep these responsibilities separate:

```text
Learner answer
        |
        v
Normalization
        |
        v
Comparison with accepted answers
        |
        v
Difference classification
        |
        v
Pedagogical result
        |
        v
Learner feedback
        |
        v
Progress or session consequence
```

Normalization prepares an answer for comparison.

Comparison determines whether the response matches a canonical answer or an
accepted alternative.

Difference classification identifies deterministic, high-confidence differences
such as capitalization, whitespace, punctuation, missing inverted punctuation,
diacritics or likely typographical errors.

Pedagogical result determines whether the response is correct, accepted with
feedback or incorrect.

Learner feedback explains useful distinctions.

Progress or session consequence records what happened without storing
linguistic rules inside learner progress.

LessonPlayer must not own this full evaluation policy.

Current implementation note:

- a reusable answer-evaluation layer owns typed-answer normalization,
  comparison, limited Spanish A0 orthographic difference classification and
  structured feedback metadata;
- exercise templates may provide explicitly authored misconception definitions
  for narrow, deterministic pedagogical feedback;
- LessonPlayer and activity widgets render the result but do not contain
  Spanish orthographic rules;
- broader grammar diagnosis, fuzzy spelling correction, semantic inference and
  session-level progress consequences remain future work.

Assessment never plans lessons.

Assessment never modifies educational content.

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

```text
Language Pack
        |
        v
Educational Content
        |
        v
Curriculum
        |
        v
Rule-Based Lesson Planner
        |
        v
LessonPlan
        |
        v
LessonAssemblyService
        |
        v
LessonPlayer
        |
        v
ActivityEngine
        |
        v
Assessment / Completion Evaluation
        |
        v
Learner History
        |
        +--------------------> Rule-Based Lesson Planner
```

The learning cycle repeats indefinitely.

There are no other feedback loops.

Terminology Boundaries

The term "Lesson Generator" is not used for the current implemented flow because it hides separate responsibilities.

Current canonical terms are:

- Rule-Based Lesson Planner: decides which LessonDefinition should be attempted next.
- LessonPlan: records the deterministic planning decision and reasons.
- LessonAssemblyService: resolves LessonDefinition references into assembled lesson content.
- LessonPlayer: presents assembled content.
- ActivityEngine: evaluates interactive activity responses.
- Assessment / Completion Evaluation: interprets outcomes and completion.
- Learner History: records observed learner events and progress.

Future procedural lesson generation may be added later, but it must remain separate from planning, rendering and assessment.

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

Rule-Based Lesson Planner;
LessonAssemblyService;
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
