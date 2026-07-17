# PROJECT_STRUCTURE.md

Status: Active

Version: 3.2

Related documents:

- LESSON_AUTHORING_ENTRYPOINT.md
- PROJECT_VISION.md
- PROJECT_CONTRACT.md
- ARCHITECTURE.md

---

# Purpose

This document defines the structural principles of the Tutor Language project.

Its purpose is not to freeze a directory layout.

Its purpose is to ensure that the project remains understandable, maintainable and easy to evolve throughout its lifetime.

The project structure should reflect the current complexity of the application.

It must never anticipate hypothetical future requirements.

---

# Fundamental Principle

The directory structure exists to simplify development.

The project must never become more complicated than the problem it solves.

Architecture serves the application.

The application does not serve the architecture.

---

# Growth Philosophy

The project should evolve gradually.

Every structural change should solve an existing problem.

Do not introduce architectural concepts before they become necessary.

Simple code is preferred over sophisticated architecture.

---

# Root Structure

The project root should remain minimal.

Example:

```text
Tutor_Language/
├── app/
├── docs/
└── README.md
```

Only project-level directories belong here.

---

# Application Directory

The Flutter application lives inside:

```text
app/
```

The application directory contains everything required to build the Android application.

No documentation should be duplicated here.

---

# Source Code

Application source code is located in:

```text
app/lib/
```

Recommended top-level structure:

```text
lib/
├── app/
├── core/
├── features/
├── shared/
└── main.dart
```

This structure is intentionally small.

New top-level directories require architectural justification.

---

# app/

Contains application initialization.

Typical responsibilities:

- application startup;
- dependency initialization;
- routing;
- themes.

Business logic must never live here.

---

# core/

Contains infrastructure shared by the entire application.

Examples:

- database;
- constants;
- utilities;
- common services;
- common error handling.

Core should remain independent from individual features.

Feature-specific logic must never migrate into core simply because it is convenient.

---

# features/

Every business capability belongs to a feature.

Examples:

```text
features/
├── activity_engine/
├── curriculum/
├── lesson_assembly/
├── lesson_player/
├── lesson_planning/
├── learning_session/
├── learner_history/
└── settings/
```

Current feature responsibilities:

- `lesson_planning/` selects the next LessonDefinition and produces a LessonPlan.
- `lesson_assembly/` resolves LessonDefinition references into assembled lesson content.
- `lesson_player/` presents assembled lesson content.
- `activity_engine/` evaluates supported interactive activity templates.
- `learning_session/` records session progress and completion flow.
- `learner_history/` projects persisted progress into planner-ready history.
- `core/learner/` stores learner progress events and learner state.

Every feature owns:

- its business logic;
- its presentation;
- its data.

Feature boundaries should remain explicit.

Cross-feature dependencies should be minimized.

---

# Feature Evolution

Features should begin small.

Example:

```text
settings/
├── settings_page.dart
├── settings_controller.dart
└── settings_repository.dart
```

Only when a feature becomes difficult to understand should it be reorganized.

Possible evolution:

```text
lesson_planning/
├── data/
├── domain/
├── presentation/
└── widgets/
```

These directories are optional.

Architecture should emerge naturally from complexity.

Never create empty folders.

Never create architectural layers "for the future".

---

# Shared Code

Shared code should remain genuinely shared.

Typical examples:

```text
shared/
├── widgets/
├── dialogs/
├── extensions/
└── formatting/
```

Feature-specific code must remain inside its feature.

Moving code into shared should reduce duplication, not increase coupling.

---

# Assets

Application assets are stored inside:

```text
app/assets/
├── app/
└── languages/
    └── spanish/
        ├── language.json
        ├── curriculum/
        ├── vocabulary/
        ├── grammar/
        ├── templates/
        ├── dialogues/
        └── readings/
```

Assets should reflect Language Pack educational content rather than implementation details.

Generation 1 includes one Spanish Language Pack only.

No empty Language Pack placeholders should be created.

---

# Tests

Tests belong to the application.

Recommended structure:

```text
test/
├── core/
├── features/
└── shared/
```

Every important business rule should be testable independently from Flutter widgets whenever practical.

---

# Documentation

Project documentation belongs exclusively inside:

```text
docs/
```

Documentation should never be duplicated.

Architecture documentation belongs to documents.

Implementation details belong to source code.

---

# Module Independence

Every feature should remain as independent as practical.

Communication between features should occur through clearly defined interfaces.

Avoid hidden dependencies.

Avoid circular dependencies.

---

# Replaceability

Every subsystem should be replaceable.

Replacing:

- the database;
- the rule-based lesson planner;
- the lesson assembly service;
- the language model;
- speech recognition;
- text-to-speech;

should not require redesigning the rest of the application.

Replaceability is preferred over tight integration.

---

# Structural Stability

Directory names should remain stable.

Files may evolve.

Modules may evolve.

Responsibilities may evolve.

Large structural reorganizations should be exceptional.

---

# Refactoring Policy

Refactoring should solve an existing maintenance problem.

Refactoring must not be performed simply to satisfy architectural preferences.

Working code should not be reorganized without measurable benefit.

---

# Simplicity Rule

Whenever multiple structures are possible:

Choose the one that:

- contains fewer directories;
- contains fewer abstractions;
- requires less explanation;
- is easier to understand for a new contributor.

Complexity should always require justification.

---

# V1 Restriction

Version 1 ships Spanish content only.

Project structure may support Language Pack boundaries.

Additional Language Pack content is intentionally postponed.

---

# Final Principle

The structure of the project should make the code easier to understand.

If maintaining the structure becomes harder than maintaining the code itself,

the structure is too complicated.

---

End of document.
