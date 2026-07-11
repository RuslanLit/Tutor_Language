# V1_TECHNICAL_SPEC.md

Status: Partially Superseded Implementation Scope

Superseded by:

- EDUCATIONAL_PRINCIPLES.md
- ARCHITECTURAL_DECISIONS.md
- ARCHITECTURE.md
- LEARNING_MODEL.md

Version: 3.2

Related documents:

- PROJECT_VISION.md
- PROJECT_CONTRACT.md
- ARCHITECTURAL_DECISIONS.md
- ARCHITECTURE.md
- LEARNING_MODEL.md
- CONTENT_MODEL.md
- V1_IMPLEMENTATION_CONTRACT.md

---

# Purpose

This document originally defined the implementation scope of Tutor Language Generation 1.

It specified the original implementation target, not **how the architecture works**.

This document preserves the V1 target scope. Some details are partially
superseded by later architecture decisions and current implementation status.
When this document claims features such as Review Queue influence, Evaluation
Results, advanced Learner State updates or mastery as Generation 1 requirements,
read those claims as historical target scope unless confirmed by current active
architecture documents and code.

Architectural decisions belong to:

- ARCHITECTURE.md
- LEARNING_MODEL.md
- CONTENT_MODEL.md
- V1_IMPLEMENTATION_CONTRACT.md

---

# Generation 1 Goal

Generation 1 must deliver a fully usable offline Spanish learning application.

The objective is to validate the educational architecture using a real learning product.

Generation 1 should already provide practical value for everyday study.

---

# Success Criteria

Generation 1 is successful if a learner can:

- install the application;
- study completely offline;
- complete daily lessons;
- receive immediate feedback;
- review previous mistakes;
- continue learning from previous progress.

Educational usefulness has higher priority than feature completeness.

---

# Scope

Generation 1 includes:

- Android application;
- offline operation;
- Spanish Language Pack;
- deterministic lesson planning;
- LessonPlan output;
- lesson assembly from LessonDefinitions and Educational Content;
- deterministic Lesson Session Engine orchestration;
- LessonPlayer presentation;
- ActivityEngine evaluation for supported activity templates;
- learner progress tracking;
- basic review-oriented planning rules;
- local persistence.

Everything else is outside the scope of Generation 1.

---

# Explicitly Out of Scope

Generation 1 does not implement:

- cloud synchronization;
- user accounts;
- online AI;
- mandatory local LLM;
- speech recognition;
- pronunciation analysis;
- text-to-speech;
- multiple languages;
- social features;
- advertisements;
- analytics;
- monetization.

These features must not influence the V1 architecture.

---

# Supported Language

Language:

Spanish

Target learner:

Adult beginner.

Target level:

A0 → early A1.

---

# Educational Scope

Generation 1 focuses on practical beginner Spanish.

Subject areas include:

- greetings;
- introductions;
- nationality;
- family;
- numbers;
- colours;
- days;
- months;
- time;
- food;
- shopping;
- travel;
- home;
- everyday activities.

Grammar includes:

- ser;
- estar (basic);
- llamarse;
- tener;
- present tense;
- articles;
- gender;
- adjective agreement;
- simple questions;
- negation.

Vocabulary target:

100–300 carefully selected high-frequency words.

Educational quality is preferred over vocabulary quantity.

---

# Lesson Flow

Every lesson should contain:

1. Review
2. New Material
3. Practice
4. Evaluation
5. Lesson Summary

Generation 1 intentionally keeps lessons short and focused.

---

# Exercise Types

The minimum exercise set required for Generation 1 is defined in:

V1_IMPLEMENTATION_CONTRACT.md

Generation 1 should implement only that minimum set.

Additional exercise types may be introduced in future generations without changing the educational architecture.

---

# Educational Core

The educational core implemented in Generation 1 follows the architecture defined in:

- ARCHITECTURE.md
- LEARNING_MODEL.md
- V1_IMPLEMENTATION_CONTRACT.md

This document does not redefine the educational core.

It defines only the implementation scope of Generation 1.

Generation 1 must not introduce AI into educational decision making.

---

# Educational Content

Educational Content is defined in:

CONTENT_MODEL.md

Generation 1 implements only the subset of Educational Content required for beginner Spanish.

Educational Content must remain immutable.

---

# Learner State

Generation 1 implements only the minimum Learner State required by:

V1_IMPLEMENTATION_CONTRACT.md

Future versions may extend the learner representation without changing the educational architecture.

---

# Persistence

Generation 1 stores all learner information locally.

Persistent data includes:

- Learner State;
- Review Queue;
- Evaluation Results;
- Learning Statistics.

Educational Content remains immutable.

Learner State is the only mutable educational data.

---

# Database

Generation 1 uses:

- SQLite
- Drift ORM

Database migrations must preserve learner progress.

Current local schema version: 5.

Schema version 5 adds durable completed lesson attempts:

- `lesson_attempts`;
- `lesson_attempt_step_results`.

These tables store immutable completed-session evidence after a successful
`finishLesson` decision.

Historical attempt rows are not upserted.

The first valid write creates the attempt and canonical step rows.

An exact duplicate write is accepted as idempotent.

A duplicate attempt ID with different aggregate data is rejected and does not
modify existing attempt, step or completion-progress rows.

They do not store active unfinished session state.

They do not newly store raw learner answers.

Legacy completion progress remains valid when no durable attempt row exists.

Malformed durable attempt detail is isolated from legacy completion progress
and other readable attempts.

---

# Offline Requirements

Generation 1 must function completely offline.

Internet access must never be required for:

- educational content;
- lesson planning;
- lesson assembly;
- lesson presentation;
- activity evaluation;
- evaluation;
- learner progress;
- review scheduling.

---

# Optional Local LLM

Generation 1 must remain fully usable without any language model.

Future local LLM support may provide:

- additional explanations;
- alternative examples;
- mnemonic stories;
- conversational practice.

The Lesson Planner must remain deterministic.

AI must not be required for lesson planning, lesson assembly, lesson presentation or activity evaluation.

---

# Performance Targets

Application startup:

< 3 seconds

Lesson planning and assembly:

< 300 ms

Lesson loading:

< 1 second

No background network activity.

---

# F-Droid Compatibility

Generation 1 must:

- use open-source dependencies;
- avoid proprietary SDKs;
- avoid Google Play Services;
- avoid telemetry;
- avoid mandatory online APIs.

---

# Quality Requirements

Every implementation must:

- compile successfully;
- pass static analysis;
- avoid regressions;
- include tests where practical;
- update documentation when behaviour changes.

---

# Recommended Implementation Order

## Phase 1

- Flutter Android project
- Navigation
- Theme
- Settings
- SQLite / Drift

## Phase 2

- Educational Content Loader
- Curriculum Loader
- Learner State

## Phase 3

- Review Queue
- Rule-Based Lesson Planner
- PlanningRequest
- PlanningPolicy
- LearnerHistorySummary
- LessonPlan

## Phase 4

- LessonAssemblyService
- LessonPlayerStep
- LessonSessionEngine
- LessonPlayer
- ActivityEngine
- Learning Session

## Phase 5

- Evaluation
- Learner State Update
- Lesson Summary

## Phase 6

- Progress
- Statistics
- Review Scheduling

## Phase 7

- Testing
- Optimization
- Documentation

---

# Acceptance Criteria

Generation 1 is complete when:

✓ Android application builds successfully.

✓ Educational Content loads from bundled assets.

✓ Curriculum loads successfully.

✓ Educational Content remains immutable during runtime.

✓ Lessons are planned and assembled completely offline.

✓ Rule-Based Lesson Planner produces deterministic LessonPlans.

✓ LessonAssemblyService resolves LessonDefinition references without deciding strategy.

✓ User answers are evaluated locally.

✓ Learner State is updated after every evaluation.

✓ Review Queue influences future lessons.

✓ Learner progress survives application updates.

✓ No Internet connection is required.

✓ No user account is required.

✓ No cloud dependency exists.

✓ The application provides useful daily Spanish practice.

---

# Final Principle

Generation 1 is intentionally conservative.

Its objective is to validate a deterministic educational architecture rather than maximize the number of features.

Every feature added to Generation 1 should improve educational quality without increasing unnecessary architectural complexity.

---

End of document.
