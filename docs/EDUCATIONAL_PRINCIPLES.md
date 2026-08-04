# Educational Principles

Status: Active

Version: 1.0

Related documents:

- PROJECT_VISION.md
- LEARNING_MODEL.md
- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md
- CONTENT_AUTHORING_GUIDE.md
- CONTENT_REVIEW_CHECKLIST.md

---

# Purpose

This document defines the educational principles that guide the design of Tutor Language.

These principles are intentionally few.

They are not a complete educational theory.

They are engineering constraints.

Every new feature, exercise, lesson, and architectural decision should be evaluated against these principles.

If a proposed feature violates one of these principles, the feature should be reconsidered before implementation.

---

# Educational Objective

The objective of Tutor Language is **not** to maximize lesson completion.

The objective is **not** to maximize daily activity.

The objective is **not** to maximize correct answers.

The objective is:

> **To help the learner become capable of using the target language independently without assistance from the application.**

The application succeeds when the learner no longer needs the application for knowledge that has already been learned.

---

# Principle 1 — Learner Independence

## Statement

The purpose of every lesson is to increase the learner's ability to use the language independently.

Every exercise should reduce the amount of support that the learner requires.

The application should gradually make itself unnecessary.

---

## Engineering Consequences

New features should increase learner independence rather than dependence.

Prefer:

- recall
- production
- application

over:

- recognition
- passive reading
- repeated hints

---

## Authoring Consequences

Each lesson should gradually reduce support.

Example progression:

Recognition

↓

Cued Recall

↓

Free Recall

↓

Application

↓

Independent Use

---

## Anti-patterns

Avoid lessons that can be completed while remaining dependent on hints.

Avoid endless practice loops that never increase learner autonomy.

---

# Principle 2 — Active Retrieval

## Statement

Knowledge becomes durable when it is retrieved, not merely recognized.

Exercises should require learners to retrieve knowledge from memory whenever reasonably possible.

Recognition is useful.

Retrieval is essential.

---

## Engineering Consequences

Prefer:

typed response

fill-the-gap

translation

sentence construction

over excessive multiple-choice exercises.

---

## Authoring Consequences

Recognition may introduce new material.

Recall should normally follow recognition.

Multiple-choice exercises should not be the primary evidence of learning.

---

## Anti-patterns

Do not rely on guessing as evidence of learning.

Do not use multiple choice simply because it is easier to implement.

---

# Principle 2a — Communicative Expansion

When previously learned language is reused, authors should prefer opportunities
for it to perform an additional communicative function, appear in a new context
or combination, or support a new role or interaction. This is communicative
expansion; it is more than displaying or repeating the same phrase.

Retrieval recalls previously learned knowledge. Communicative expansion lets
that knowledge perform additional work. Each later lesson should identify a
meaningful reuse opportunity when the objective permits it. The opportunity may
be retrieval, recombination, transfer, reduced support, or controlled
application. This is a qualitative principle, not a numerical quota. Do not
force an artificial link when it would overload the lesson or distract from its
primary objective; learner-specific review scheduling remains the
Learning Engine's responsibility.

---

# Principle 3 — Productive Language

## Statement

Language is learned by producing language.

Learners should regularly:

- write
- construct
- complete
- translate
- reformulate

rather than only identify correct answers.

---

## Engineering Consequences

The platform should support increasing levels of language production.

Production demand should grow with learner ability.

---

## Authoring Consequences

Lessons should contain opportunities for learners to create language, not only recognize it.

---

## Anti-patterns

Avoid lessons consisting entirely of passive consumption.

---

# Principle 4 — Errors Are Learning Opportunities

## Statement

An incorrect answer is information.

The goal of evaluation is to identify misunderstanding and provide useful guidance.

The objective is not punishment.

---

## Engineering Consequences

Evaluation should distinguish:

correct

accepted with feedback

incorrect

Feedback should explain why.

---

## Authoring Consequences

Common learner mistakes should be anticipated.

Whenever possible, explanations should be deterministic.

---

## Anti-patterns

Avoid generic messages such as:

Wrong answer.

Try again.

without explanation.

---

# Principle 5 — Feedback Must Teach

## Statement

Evaluation is part of instruction.

The learner should leave every exercise knowing something they did not know before.

---

## Engineering Consequences

Feedback should explain:

what is correct

what is incorrect

why

what should be remembered

---

## Authoring Consequences

Content authors should prepare explanations for predictable mistakes.

---

## Anti-patterns

Avoid feedback consisting only of icons or colours.

---

# Principle 6 — Meaning Before Formal Perfection

## Statement

At beginner levels, communication is more important than orthographic perfection.

The learner should first learn to express meaning.

Precision should increase progressively.

---

## Engineering Consequences

The evaluation system should support:

accepted with feedback

for deterministic orthographic differences.

Examples:

missing accent

missing inverted question mark

capitalization

extra whitespace

when meaning remains correct.

---

## Authoring Consequences

Orthographic correction should educate rather than punish.

---

## Anti-patterns

Do not reject a meaningful beginner answer solely because of minor deterministic orthographic differences.

---

# Principle 7 — Gradual Removal of Support

## Statement

Support should decrease as competence increases.

Earlier exercises may contain strong guidance.

Later exercises should require increasing independence.

---

## Engineering Consequences

Future lesson planning may gradually reduce:

visible hints

partial answers

recognition exercises

while increasing production demand.

---

## Authoring Consequences

Support should be intentional.

It should never remain constant throughout an entire course.

---

## Anti-patterns

Avoid permanently teaching at the easiest level.

---

# Principle 8 — Deterministic Pedagogy First

## Statement

The application should rely on deterministic educational knowledge whenever possible.

Artificial intelligence is an enhancement, not a prerequisite.

---

## Engineering Consequences

Prefer:

language rules

accepted answers

pedagogical rules

common mistakes

deterministic explanations

before introducing AI evaluation.

---

## Authoring Consequences

Educational knowledge should be explicitly authored.

---

## Anti-patterns

Do not replace explicit educational knowledge with opaque AI behaviour.

---

# Principle 9 — Every Principle Must Change the Product

Educational principles exist to improve the application.

A principle that does not change:

- architecture
- content
- exercise design
- evaluation
- learner experience

does not belong in this document.

---

# Educational Success

The learner succeeds when they can:

- remember knowledge without prompts;
- produce language without visible choices;
- apply knowledge in unfamiliar situations;
- continue learning independently.

---

# Product Success

Tutor Language succeeds when learners gradually stop depending on Tutor Language for knowledge they have already mastered.

The ultimate measure of success is not:

- lessons completed;
- buttons pressed;
- streak length;
- time spent inside the application.

The ultimate measure is:

> **Independent use of the language outside the application.**
