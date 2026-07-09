# Tutor Language

Adaptive offline Spanish tutor.

## Project status

Early development.

## Required reading order

Before implementation, read documents in this order:

1. README.md
2. docs/PROJECT_VISION.md
3. docs/PROJECT_CONTRACT.md
4. docs/ARCHITECTURAL_DECISIONS.md
5. docs/ARCHITECTURE.md
6. docs/CURRICULUM_SPEC.md
7. docs/LEARNING_MODEL.md
8. docs/CONTENT_MODEL.md
9. docs/V1_TECHNICAL_SPEC.md
10. docs/V1_IMPLEMENTATION_CONTRACT.md
11. docs/TECH_STACK.md
12. docs/PROJECT_STRUCTURE.md

Development should begin only after these documents have been read.
The documentation is the project's source of truth.

If implementation conflicts with the documentation, the documentation has higher priority.

## Development workflow

Always follow docs/PROJECT_CONTRACT.md.

Architecture decisions are documented in docs/ARCHITECTURAL_DECISIONS.md.

The educational model is documented in docs/LEARNING_MODEL.md.

Never invent architecture that contradicts existing documentation.

If documentation is insufficient, ask for clarification instead of making architectural assumptions.

## Current implementation status

The Flutter application has been bootstrapped.

The project contains:

- language-agnostic curriculum and educational content models;
- Spanish A0 content assets;
- deterministic content loading and validation;
- LessonAssemblyService for resolving LessonDefinition references;
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
  -> LessonPlayer
  -> ActivityEngine
  -> Assessment / Completion Evaluation
  -> Learner History
```

AI is not part of the core runtime planning flow.
