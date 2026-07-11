# V1_IMPLEMENTATION_CONTRACT.md

Status: Partially Superseded Implementation Contract

Superseded by:

- EDUCATIONAL_PRINCIPLES.md
- ARCHITECTURAL_DECISIONS.md
- ARCHITECTURE.md
- LEARNING_MODEL.md
- CONTENT_MODEL.md

Version: 2.2

Related documents:

- PROJECT_CONTRACT.md
- ARCHITECTURE.md
- LEARNING_MODEL.md
- CONTENT_MODEL.md
- V1_TECHNICAL_SPEC.md

---

# Purpose

This document defines the minimum implementation contract for Tutor Language Generation 1.

Its purpose is to eliminate architectural ambiguity during implementation.

This document preserves an earlier V1 implementation target.

Where this document conflicts with current active architecture, accepted ADRs,
the current Educational Content model, or the current implementation status,
the newer active documents have higher priority.

In particular, detailed mastery-score, Review Queue, Evaluation Result and
Learner State Update requirements in this document are not current
implementation claims unless also confirmed by active architecture documents
and code.

---

# Scope

This contract applies only to Generation 1.

Generation 1 supports:

- one Spanish Language Pack;
- Android only;
- offline operation only;
- deterministic educational planning;
- LessonPlan output;
- lesson assembly from LessonDefinitions and Educational Content;
- deterministic Lesson Session Engine orchestration;
- LessonPlayer presentation;
- ActivityEngine evaluation for supported activity templates.

Everything else is outside the scope of this contract.

---

# Canonical Terminology

The following names are mandatory.

Use exactly these names throughout the project.

Educational Content

Curriculum

Language Pack

Course

Module

LessonDefinition

Learner State

Review Queue

Rule-Based Lesson Planner

PlanningRequest

PlanningPolicy

LearnerHistorySummary

LessonPlan

LessonPlanReasonCode

LessonAssemblyService

LessonPlayerStep

LessonSessionEngine

LessonSessionState

LessonSessionDecision

LessonSessionReasonCode

LessonOutcome

LessonAttemptSummary

LessonPlayer

ActivityEngine

Evaluation

Evaluation Result

Learner State Update

Generated Exercise

Do not introduce synonyms.

Do not use:

- Rule Engine
- Pedagogical Rule Engine
- Learner Profile Update
- Lesson Generator when referring to planning, assembly, presentation or activity evaluation as one combined responsibility

---

# Educational Content Packaging

Educational Content is bundled with the application.

Source of truth:

```text
app/assets/languages/spanish/
```

Generation 1 uses:

```text
app/assets/languages/spanish/
├── language.json
├── curriculum/
├── vocabulary/
├── grammar/
├── templates/
├── dialogues/
└── readings/
```

The application must never require downloading educational content.

---

# Stable Identifiers

Every Educational Object must have a stable string identifier.

Recommended format:

```text
category.slug.version
```

Examples:

```text
vocab.hola.v1

grammar.ser_present.v1

dialogue.introduction_001.v1

reading.family_001.v1

template.multiple_choice_basic.v1

lesson.greetings.v1
```

Identifiers represent educational concepts.

Identifiers should remain stable across future application versions.

---

# Minimal Educational Objects

## Vocabulary Item

Required fields:

- id
- spanish
- native_translation
- cefr
- lesson_ids
- example

Optional:

- pronunciation
- notes

---

## Grammar Topic

Required:

- id
- title
- explanation
- examples
- prerequisite_ids
- lesson_ids

---

## Exercise Template

Required:

- id
- exercise_type
- supported_goal_types
- required_object_types
- prompt_template

Generation 1 required exercise types:

- multiple_choice
- fill_gap
- matching

Generation 2:

- translation
- sentence_ordering
- dialogue
- speaking

---

## Dialogue

Required:

- id
- title
- lesson_ids
- vocabulary_ids
- grammar_ids
- lines

Optional in Generation 1.

---

## Reading Text

Required:

- id
- title
- lesson_ids
- vocabulary_ids
- grammar_ids
- text
- native_translation

Optional in Generation 1.

---

# Generated Exercise

Generated Exercises are runtime objects.

They:

- are created during lesson execution when needed;
- exist only during a lesson session;
- are discarded after Evaluation.

Generated Exercises must never become Educational Content.

Only learning outcomes remain persistent.

---

# Learner State

Generation 1 stores learner state independently from Educational Content.

Every tracked educational object contains:

- object_id
- state
- mastery_score
- correct_count
- incorrect_count
- last_seen_at

Allowed states:

- unseen
- learning
- reviewing
- mastered

mastery_score range:

0.0 → 1.0

---

# Review Queue

Every Review Queue item contains:

- object_id
- object_type
- priority
- reason
- due_at

Allowed object types:

- vocabulary
- grammar

Allowed reasons:

- mistake
- scheduled_review
- low_mastery
- declining_retention

Priority range:

0 → 100

Higher priority means earlier review.

---

# Planning Policy

Every planning decision must be deterministic and explainable.

Generation 1 uses PlanningPolicy to control simple rule-based selection.

Current policy fields are implementation-defined by the planner and may include thresholds for accuracy, recent answer counts, incomplete-lesson preference and low-accuracy review behavior.

Future versions may introduce richer lesson goals and lesson constraints, but they must remain separate from Educational Content, LessonDefinitions, LessonAssemblyService, LessonSessionEngine and LessonPlayer.

---

# Evaluation Result

Every answered exercise produces exactly one Evaluation Result.

Required fields:

- exercise_id
- is_correct
- user_answer
- expected_answer
- related_object_ids
- error_category
- timestamp

Generation 1 error categories:

- vocabulary
- grammar
- spelling
- accent
- word_order
- missing_answer
- unknown

Generation 1 evaluation supports:

- exact match;
- lowercase normalization;
- whitespace normalization;
- predefined accepted alternatives.

---

# Learner State Update

Generation 1 update rules.

Correct answer:

- correct_count += 1
- mastery_score += 0.10
- update last_seen_at
- reduce review priority
- if mastery_score ≥ 0.80 → mastered

Incorrect answer:

- incorrect_count += 1
- mastery_score -= 0.15
- update last_seen_at
- state → reviewing
- create or update Review Queue item
- increase review priority

Clamp rule:

mastery_score always remains within:

0.0 → 1.0

---

# Rule-Based Lesson Planner Rules

Generation 1 intentionally keeps the planner simple.

Current implemented rules:

1. No learner history → first curriculum LessonDefinition.
2. Current incomplete lesson → continue current LessonDefinition.
3. Low recent accuracy → repeat or review.
4. Completed current lesson → select next LessonDefinition.
5. Invalid current lesson → fall back deterministically.
6. Completed course with no next lesson → review.

Future planner rules may add review pressure, richer prerequisites, mastery and cognitive-load constraints.

Generation 1 should remain below twenty deterministic planning rules.

---

# Content Loading

Generation 1 loads Educational Content from bundled JSON assets.

Educational Content is immutable.

Learner State is stored separately.

Educational Content must never be modified during learning.

---

# Persistence Principle

The following information is persistent:

- Educational Content
- Learner State
- Review Queue
- Evaluation Results
- Learning Statistics

The following information is temporary:

- Generated Exercises
- lesson sessions
- Runtime lesson objects

Educational interactions are temporary.

Learning outcomes are permanent.

---

# Acceptance Criteria

Generation 1 implementation satisfies this contract only if:

- the application runs fully offline;
- Educational Content loads from bundled assets;
- Educational Content and Learner State are stored separately;
- all Educational Objects use stable identifiers;
- Rule-Based Lesson Planner produces LessonPlan with deterministic reason codes;
- LessonAssemblyService resolves LessonDefinition references without choosing strategy;
- every exercise produces one Evaluation Result;
- Learner State Update is the only component allowed to modify Learner State;
- Review Queue influences future lesson planning;
- no AI is required;
- no Internet connection is required.

---

# Final Principle

Generation 1 prioritizes correctness over sophistication.

The goal is not to build the smartest tutor.

The goal is to build a deterministic educational system that can evolve safely over many years.

Future versions may increase intelligence.

They must not weaken architectural clarity.

---

End of document.
