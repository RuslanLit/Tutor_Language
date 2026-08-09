# Tutor Language

Status: DERIVED
Scope: project documentation entrypoint and task routing
Canonical owner: DOCUMENTATION_AUTHORITY.md

Adaptive offline Spanish tutor.

## Project status

Early development.

## Mandatory documentation entrypoint

Before any significant implementation or authoring task, begin with:

1. [docs/PROJECT_INVARIANTS.md](docs/PROJECT_INVARIANTS.md)
2. [docs/DOCUMENTATION_AUTHORITY.md](docs/DOCUMENTATION_AUTHORITY.md)
3. [docs/AI_WORKING_CONTEXT.md](docs/AI_WORKING_CONTEXT.md)

Then use the task-specific routing in `AI_WORKING_CONTEXT.md` to load only the
additional current normative documents required by the task. Do not load the
complete documentation corpus by default.

## Historical core reading order

This broader reading order remains useful when a task genuinely spans the
whole core, but it is not a mandatory reading list for every task:

1. README.md
2. docs/PROJECT_VISION.md
3. docs/PROJECT_CONTRACT.md
4. docs/ARCHITECTURAL_DECISIONS.md
5. docs/ARCHITECTURE.md
6. docs/EDUCATIONAL_PRINCIPLES.md
7. docs/CURRICULUM_SPEC.md
8. docs/LEARNING_MODEL.md
9. docs/CONTENT_MODEL.md
10. docs/V1_TECHNICAL_SPEC.md
11. docs/V1_IMPLEMENTATION_CONTRACT.md
12. docs/TECH_STACK.md
13. docs/PROJECT_STRUCTURE.md

Applicable current NORMATIVE documentation is the project's source of truth
within its registered scope.

If implementation conflicts with applicable normative documentation, the
discrepancy must be explicitly reconciled. Evidence, proposals, reports,
historical and archived documents do not override implementation by virtue of
being documentation.

## Development workflow

Always follow docs/PROJECT_CONTRACT.md.

Architecture decisions are documented in docs/ARCHITECTURAL_DECISIONS.md.

The educational model is documented in docs/LEARNING_MODEL.md.

High-level educational principles are documented in docs/EDUCATIONAL_PRINCIPLES.md.

Never invent architecture that contradicts existing documentation.

If documentation is insufficient, ask for clarification instead of making architectural assumptions.

## Current implementation status

The Flutter application has been bootstrapped.

The project contains:

- curriculum and EducationalContent models that are not hard-coded specifically
  to Spanish but remain materially language-domain shaped and are not yet fully
  subject-independent;
- Spanish A0 content assets;
- deterministic content loading and validation;
- LessonAssemblyService for resolving LessonDefinition references;
- LessonPlayerStep flattening for deterministic exercise-level lesson steps;
- LessonSessionEngine for pure deterministic in-session progression;
- LessonPlayer for presenting assembled lesson content;
- ActivityEngine for supported interactive activity evaluation;
- RuleBasedLessonPlanner for deterministic lesson selection;
- basic learner state and progress event persistence.

The current learning flow is:

```text
Educational Content
  -> Curriculum
  -> Rule-Based Lesson Planner
  -> LessonPlan
  -> LessonAssemblyService
  -> LessonPlayerStep flattening
  -> LessonSessionEngine
  -> LessonPlayer
  -> ActivityEngine
  -> Answer Evaluation
  -> LessonSessionEngine
  -> Application Progress Services
  -> Learner History
```

AI is not part of the core runtime planning flow.
