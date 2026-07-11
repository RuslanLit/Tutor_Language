# COURSE_AUTHORING_GUIDE.md

Status: Living Document

Version: 1.0

Related documents:

- EDUCATIONAL_PRINCIPLES.md
- PROJECT_VISION.md
- AUTHORING_STYLE_GUIDE.md
- CONTENT_MODEL.md
- CURRICULUM_SPEC.md
- LEARNING_MODEL.md
- CONTENT_AUTHORING_GUIDE.md
- CONTENT_REVIEW_CHECKLIST.md

---

# Purpose

This document defines how language courses should be designed for Tutor Language.

It specifies how educational content is organized into complete learning programs independently of any particular language.

It does not define implementation details, lesson planning or lesson assembly.

For learner-facing writing style, use AUTHORING_STYLE_GUIDE.md.

For Educational Content object authoring, use CONTENT_AUTHORING_GUIDE.md.

For release readiness checks, use CONTENT_REVIEW_CHECKLIST.md.

---

# Fundamental Principle

A course is an educational roadmap.

It organizes knowledge into a logical sequence that minimizes cognitive load while maximizing long-term retention.

A course does not contain learner state.

A course does not perform teaching.

Teaching is performed by the Learning Engine.

---

# Design Goals

Every course should be:

- language-independent;
- deterministic;
- modular;
- reusable;
- extensible;
- pedagogically consistent;
- compatible with offline learning.

---

# Educational Hierarchy

Every language course follows the same hierarchy.

```text
Language
    │
Course
    │
Module
    │
LessonDefinition
```

Each level has exactly one responsibility.

---

# Course

A Course represents one complete educational program.

Examples:

- Spanish A0
- Spanish A1
- English A0
- German A2

A Course should define:

- educational scope;
- target proficiency;
- progression strategy;
- module order.

A Course never contains learner progress.

---

# Course Objectives

Every course should define:

- target learner;
- expected entry level;
- expected completion level;
- estimated course size;
- primary educational goals.

Example:

```text
Entry:
No prior knowledge

Completion:
Basic everyday communication
```

---

# CEFR Alignment

Whenever practical, courses should align with CEFR.

Typical progression:

```text
A0

↓

A1

↓

A2

↓

B1

↓

B2
```

Generation 1 focuses on:

- A0
- early A1

---

# Modules

Modules group lessons around one educational theme.

Examples:

- Greetings
- Family
- Numbers
- Food
- Shopping
- Travel
- Daily Routine

Modules should remain focused.

A module should introduce one broad communication domain.

---

# Module Size

Recommended size:

- 5–12 LessonDefinitions.

Large modules should be divided.

Small modules should remain coherent.

---

# Lesson Progression

Lessons should introduce knowledge gradually.

Typical progression:

```text
Lesson 1

↓

Lesson 2

↓

Lesson 3

↓

Review Lesson

↓

Next Module
```

Difficulty should increase smoothly.

# LessonDefinition Assets

Language-specific LessonDefinition assets live with their curriculum data.

For Spanish A0, standalone LessonDefinitions are stored in:

```text
app/assets/languages/spanish/curriculum/lessons/
```

LessonDefinition scaffolds may be authored before their Educational Content
assets exist. In that case, activities should remain structurally valid and may
use empty `references` arrays until stable vocabulary, grammar, dialogue,
reading, or exercise-template assets are created.

---

# Review Lessons

Review lessons consolidate previously introduced knowledge.

Recommended frequency:

- every 4–6 lessons.

Review lessons should introduce little or no new material.

Primary objectives include:

- vocabulary recall;
- grammar reinforcement;
- reading practice;
- dialogue reconstruction;
- mixed exercises.

---

# Vocabulary Progression

Vocabulary should grow gradually.

Approximate recommendations:

| Level | Active Vocabulary |
|--------|------------------:|
| A0 | 400–700 |
| A1 | 1000–1500 |
| A2 | 2000–2500 |
| B1 | 3500–5000 |
| B2 | 6000+ |

These values are educational recommendations rather than strict limits.

---

# Grammar Progression

Grammar should follow increasing complexity.

Recommended order:

```text
Basic sentence structure

↓

Present tense

↓

Questions

↓

Negation

↓

Possession

↓

Past

↓

Future

↓

Complex structures
```

Languages may require different ordering.

Prerequisites should always be respected.

---

# Communication Progression

The learner should progressively acquire communicative ability.

Typical sequence:

```text
Greetings

↓

Introducing oneself

↓

Personal information

↓

Family

↓

Numbers

↓

Time

↓

Food

↓

Shopping

↓

Travel

↓

Daily life

↓

Opinions

↓

Plans

↓

Narration
```

The exact order may vary by language.

---

# Difficulty Progression

Each lesson should introduce only a small increase in complexity.

Complexity may increase through:

- vocabulary;
- grammar;
- dialogue length;
- reading difficulty;
- exercise complexity.

Sudden jumps should be avoided.

Learner-facing wording, examples and explanation style should follow AUTHORING_STYLE_GUIDE.md.

---

# Lesson Independence

Every LessonDefinition should have one primary educational objective.

Lessons should remain understandable without requiring excessive future knowledge.

Knowledge dependencies should be explicit.

---

# Spiral Learning

Knowledge should return repeatedly throughout the course.

Concepts should evolve according to the following model:

```text
Introduce

↓

Practice

↓

Reuse

↓

Review

↓

Master
```

Important concepts should appear in multiple modules.

---

# Cultural Progression

Culture supports communication.

Generation 1 introduces cultural elements only when they improve understanding.

Culture should never dominate the curriculum.

---

# Assessment Distribution

Assessment should occur continuously.

The curriculum should naturally alternate between:

- introducing knowledge;
- reinforcing knowledge;
- reviewing knowledge.

Assessment should never become the primary purpose of the course.

---

# Module Completion

A module should conclude when its educational objective has been achieved.

Completion should prepare the learner for the next module.

Modules should not overlap excessively.

---

# Course Completion

Course completion should indicate that the learner has achieved the intended proficiency.

Completion does not imply perfect mastery.

Long-term retention remains the responsibility of the Learning Engine.

---

# Language Independence

This guide applies equally to:

- Spanish;
- English;
- German;
- French;
- Italian;
- Japanese;
- Ukrainian;
- any future language.

Language-specific differences should be reflected in educational content, not in course architecture.

---

# Future Expansion

Future versions may introduce:

- elective modules;
- branching curricula;
- specialization tracks;
- pronunciation courses;
- writing courses;
- business language;
- placement tests.

These additions should extend the model rather than replace it.

---

# Validation Checklist

Before approving a course, verify:

- Is the progression logical?
- Are modules clearly separated?
- Does vocabulary grow gradually?
- Is grammar introduced progressively?
- Are review lessons included?
- Is cognitive load reasonable?
- Does the course align with its target level?
- Can the course be extended in future versions?

---

# Final Principle

A course is not a collection of lessons.

A course is a carefully designed progression of communicative competence.

Every module, lesson and knowledge object should contribute to one long-term objective:

Helping the learner use the language confidently in real communication.

---

End of document.
