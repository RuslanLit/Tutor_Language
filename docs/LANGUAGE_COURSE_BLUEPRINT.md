# LANGUAGE_COURSE_BLUEPRINT.md

Status: Active

Version: 1.1

Related documents:

- PROJECT_VISION.md
- CONTENT_MODEL.md
- CURRICULUM_SPEC.md
- LEARNING_MODEL.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md

---

# Purpose

This document defines the Language Course Blueprint model used by Tutor Language.

A Language Course Blueprint describes the educational intent of a language course.

It specifies educational goals, progression, constraints and allowed educational content.

It does not define implementation.

It does not define learner state.

It does not define generated lessons.

---

# Fundamental Principle

A Language Course Blueprint defines educational intent, not lesson content.

It specifies what the learning engine is allowed to teach.

It never specifies exactly what will be taught during an individual Lesson Session.

Lesson Sessions are assembled dynamically according to the learner's current educational state.

---

# Educational Responsibility

The Language Course Blueprint is responsible for:

- defining course progression;
- organizing modules;
- defining lesson blueprints;
- specifying educational goals;
- defining allowed content pools;
- defining lesson constraints;
- defining expected learning outcomes.

The Language Course Blueprint never stores learner information.

---

# Position in the Architecture

The educational planning pipeline is:

```text
Educational Content
        │
        ▼
Curriculum
        │
        ▼
Language Course Blueprint
        │
        ▼
Lesson Planner
        │
        ▼
LessonPlan
        │
        ▼
LessonAssemblyService
        │
        ▼
Lesson Session
```

Educational Content defines what exists.

Curriculum defines educational order.

Language Course Blueprint defines educational intent.

The Learning Engine decides what should happen next.

The Rule-Based Lesson Planner selects the next LessonDefinition.

The LessonPlan records that decision.

The LessonAssemblyService resolves the selected LessonDefinition into assembled lesson content.

---

# Blueprint Hierarchy

Every Language Course Blueprint follows the same structure.

```text
Course Blueprint
        │
        ▼
Module Blueprints
        │
        ▼
Lesson Blueprints
```

Blueprints describe educational planning.

They are not runtime objects.

---

# Course Blueprint

A Course Blueprint represents one complete educational program.

Examples:

- Spanish A0
- Spanish A1
- English A0
- German A2

Every Course Blueprint should define:

- educational scope;
- target learner;
- entry level;
- completion level;
- module progression;
- overall educational objectives.

---

# Module Blueprint

A Module Blueprint groups related Lesson Blueprints.

Each module should define:

- communication domain;
- educational objectives;
- expected vocabulary;
- expected grammar;
- review strategy.

Examples:

- Greetings
- Family
- Travel
- Shopping

Modules should remain educationally coherent.

---

# Lesson Blueprint

A Lesson Blueprint defines one educational objective.

It is not a Lesson Session.

It specifies:

- primary goal;
- secondary goals;
- allowed educational content;
- lesson constraints;
- expected learner outcomes.

The Rule-Based Lesson Planner uses this information when selecting a LessonDefinition.

The LessonAssemblyService uses the selected LessonDefinition and referenced Educational Content to assemble lesson content.

---

# Content Pools

Lesson Blueprints reference Educational Content through Content Pools.

Typical pools include:

- Vocabulary;
- Grammar;
- Dialogues;
- Readings;
- Listening;
- Exercise Templates.

Content Pools define which educational content may be selected.

They do not determine the final lesson.

---

# Lesson Constraints

Lesson Blueprints define lesson boundaries.

Examples:

- maximum lesson duration;
- number of new vocabulary items;
- review vocabulary limit;
- grammar complexity;
- dialogue length;
- exercise count;
- cognitive load.

The Rule-Based Lesson Planner and LessonAssemblyService must remain within these constraints as their implemented responsibilities require.

---

# Expected Outcomes

Every Lesson Blueprint defines observable educational outcomes.

Examples:

- greet another person;
- introduce oneself;
- ask simple questions;
- understand numbers;
- describe family members.

Outcomes describe educational capability.

They do not evaluate learner performance.

---

# Dynamic Lesson Planning and Assembly

Lesson Sessions are generated at runtime.

Planning and assembly use:

- Educational Content;
- Curriculum;
- Language Course Blueprint;
- Learner State;
- Review Queue;
- Lesson Goal;
- Lesson Constraints.

Different learners may receive different Lesson Sessions while following the same Course Blueprint.

---

# Personalization

Personalization is deterministic.

The Rule-Based Lesson Planner may select different LessonDefinitions based on:

- learner progress;
- review priorities;
- completed lessons;
- cognitive load;
- prerequisite satisfaction.

The Language Course Blueprint defines the boundaries within which personalization may occur.

Future dynamic content-level planning may select individual content references within those boundaries, but this is not part of the current implemented planner.

---

# AI Independence

The runtime learning system must operate entirely without AI.

Artificial Intelligence may be used:

- during content creation;
- during curriculum design;
- during educational review.

Artificial Intelligence must not be required for:

- lesson planning;
- lesson assembly;
- lesson presentation;
- activity evaluation;
- learner evaluation;
- review scheduling.

Offline operation remains a fundamental design requirement.

---

# Validation

Every Language Course Blueprint should be validated before release.

Validation should verify:

- module order;
- lesson order;
- prerequisite consistency;
- valid content pools;
- valid references;
- achievable outcomes;
- reasonable lesson constraints.

Blueprint validation is deterministic.

---

# Generation 1

Generation 1 includes:

- one Spanish course;
- linear module progression;
- deterministic rule-based lesson planning;
- LessonPlan output;
- LessonAssemblyService content resolution;
- static Educational Content;
- template-based exercises.

Future versions may introduce:

- multiple educational pathways;
- elective modules;
- adaptive blueprint variants;
- richer educational constraints.

These additions should extend the model rather than replace it.

---

# Final Principle

A Language Course Blueprint defines educational intent.

It does not define fixed lessons.

Every Lesson Session is a deterministic realization of the Blueprint based on the learner's current educational state.

This separation allows Tutor Language to provide personalized offline learning while preserving deterministic behaviour and complete independence from Artificial Intelligence at runtime.

---

End of document.
