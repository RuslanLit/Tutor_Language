# LEARNING_MODEL.md

Status: Active

Version: 3.0

Related documents:

- PROJECT_VISION.md
- ARCHITECTURE.md
- V1_TECHNICAL_SPEC.md

---

# Purpose

This document defines the conceptual learning model used by Tutor Language.

It explains how educational knowledge is organized, how learning progresses, how repetition is scheduled and how educational decisions are made.

This document intentionally avoids implementation details.

Software architecture is described in ARCHITECTURE.md.

---

# Core Principle

Learning is a continuous optimization process.

The application does not generate lessons arbitrarily.

Every lesson is the result of deterministic educational planning based on the learner's current educational state.

---

# Fundamental Learning Question

The application should never begin with:

> "What lesson should I generate?"

Instead it should answer the following questions in order:

1. What educational content exists?
2. Where is the learner within the curriculum?
3. What does the learner currently know?
4. What knowledge requires review?
5. What educational objective has the highest priority?
6. What constraints follow from that objective?
7. What lesson satisfies those constraints?

Only after these questions have deterministic answers may lesson generation begin.

---

# Learning Pipeline

```text
Educational Content
        │
        ▼
Curriculum
        │
        ▼
Learner State
        │
        ▼
Review Queue
        │
        ▼
Lesson Planner
        │
        ▼
Lesson Goal
        │
        ▼
Lesson Constraints
        │
        ▼
Lesson Generator
        │
        ▼
Lesson Session
        │
        ▼
Evaluation
        │
        ▼
Learner State Update
```

Every completed lesson represents one iteration of this learning cycle.

The cycle repeats continuously throughout the learner's lifetime.

---

# Learning Objects

The learning system operates on several conceptual objects.

Each object has exactly one responsibility.

---

## Educational Content

Educational Content defines everything that may eventually be taught.

Examples:

- vocabulary;
- grammar;
- dialogues;
- reading texts;
- exercises;
- cultural notes.

Educational Content is static.

It never depends on an individual learner.

---

## Curriculum

The Curriculum defines the recommended educational order.

Generation 1 uses a mostly linear curriculum.

Future versions may evolve into a graph of educational dependencies without changing the surrounding learning model.

The Curriculum defines:

- learning topics;
- prerequisites;
- progression order;
- recommended vocabulary;
- recommended grammar.

The Curriculum defines **what may be learned**.

It never decides **what should be taught next**.

---

## Learner State

Learner State represents the learner's current educational position.

It changes after every lesson.

Examples:

- current curriculum position;
- vocabulary mastery;
- grammar mastery;
- completed lessons;
- learning statistics.

Learner State represents observations.

It never contains assumptions.

---

## Review Queue

The Review Queue contains knowledge requiring future repetition.

Items enter the queue because of:

- incorrect answers;
- scheduled review;
- low confidence;
- declining retention;
- incomplete mastery.

Review scheduling always competes with introducing new material.

The objective is long-term retention rather than maximum speed.

---

## Lesson Goal

Every lesson has exactly one primary educational objective.

Examples:

- introduce vocabulary;
- reinforce grammar;
- consolidate knowledge;
- reduce review backlog.

Secondary goals may exist.

The primary goal always has priority.

---

## Lesson Constraints

Lesson Constraints translate educational objectives into measurable lesson boundaries.

Typical constraints include:

- lesson duration;
- new vocabulary limit;
- review vocabulary limit;
- grammar focus;
- exercise mix;
- maximum cognitive load.

Lesson generation must remain inside these boundaries.

---

# Learning Progression

Knowledge progresses through educational states.

```text
Unseen
        │
        ▼
Learning
        │
        ▼
Reviewing
        │
        ▼
Mastered
```

These states apply independently to:

- vocabulary;
- grammar;
- educational concepts.

Knowledge may move backward.

For example:

```text
Mastered
      │
      ▼
Reviewing
```

when later evidence indicates declining retention.

Mastery is therefore provisional rather than permanent.

---

# Review Scheduling

Review scheduling is one of the central educational mechanisms.

The planning system continuously balances:

- introducing new material;
- reinforcing previous knowledge;
- preventing forgetting;
- avoiding learner overload.

Review has priority whenever accumulated review pressure becomes excessive.

Generation 1 intentionally uses a simple review model.

Minimum required behaviour:

- mistakes increase review priority;
- repeated mistakes delay mastery;
- successful reviews reduce review priority;
- excessive review backlog slows introduction of new material.

---

# Cognitive Load

Every learner has limited cognitive capacity.

Lesson planning should respect this limitation.

Possible contributors include:

- new vocabulary;
- review vocabulary;
- grammar complexity;
- lesson duration;
- exercise diversity.

Educational planning should favour sustainable long-term progress rather than maximum information density.

---

# Adaptation

Adaptation occurs only through accumulated evidence.

The application never permanently classifies the learner.

Observed behaviour produces hypotheses.

Future observations may strengthen or weaken those hypotheses.

Adaptation therefore remains:

- evidence-based;
- reversible;
- incremental.

---

# Evidence

Every educational conclusion should be supported by observable evidence.

Examples include:

- correct answers;
- incorrect answers;
- review success;
- response time;
- lesson completion;
- long-term retention.

Insufficient evidence should never trigger strong adaptation.

Evidence influences planning only through deterministic rules.

---

# Separation of Educational Responsibilities

Educational Content defines what exists.

Curriculum defines the recommended learning order.

Learner State represents current learner knowledge.

Review Queue determines educational priorities.

Lesson Planner selects the educational objective.

Lesson Constraints define lesson boundaries.

Lesson Generator creates the lesson.

Lesson Session records learner interaction.

Evaluation measures learning outcomes.

Learner State Update records educational progress.

Each concept has exactly one educational responsibility.

---

# Generation 1 Simplification

Generation 1 intentionally limits educational complexity.

Included:

- Spanish only;
- static educational content;
- simple curriculum;
- deterministic planning;
- template-based lesson generation;
- deterministic evaluation;
- review scheduling;
- learner state tracking.

Postponed:

- knowledge graph;
- advanced motivation model;
- advanced evidence model;
- pronunciation training;
- speech recognition;
- local language model;
- multiple languages.

Reducing educational scope increases the probability of delivering a high-quality first release.

---

# Future Evolution

Future versions may extend the learning model through:

- adaptive memory strategies;
- advanced evidence accumulation;
- richer learner models;
- pronunciation assessment;
- conversational practice;
- local AI assistance.

Future extensions should enhance the existing learning model rather than replace it.

---

# Final Principle

Learning is not the generation of lessons.

Learning is the controlled evolution of learner knowledge.

Every lesson should improve both:

- the learner's knowledge;
- the system's understanding of the learner.

The quality of the tutor is measured not by the number of generated lessons, but by its ability to continuously make better educational decisions.

---

End of document.