# ARCHITECTURAL_DECISIONS.md

Status: Active

Version: 2.0

Related documents:

- PROJECT_VISION.md
- PROJECT_CONTRACT.md
- ARCHITECTURE.md
- LEARNING_MODEL.md

---

# Purpose

This document records the fundamental architectural decisions of Tutor Language.

An Architectural Decision Record (ADR) captures a decision that is expected to remain stable for the lifetime of the project.

The purpose of ADRs is to preserve architectural intent and prevent important decisions from being repeatedly reconsidered.

Implementation details do not belong in ADRs.

---

# ADR Policy

Every ADR should contain:

- Context
- Decision
- Rationale
- Consequences

Changing an accepted ADR should normally be done by creating a new ADR that supersedes the previous one.

Old ADRs should remain in project history.

---

# ADR-0000

Status

Accepted

Title

Deterministic First Principle

Context

Modern educational software increasingly relies on AI as the primary mechanism for solving educational problems.

While powerful, AI introduces additional complexity, unpredictable behaviour, increased hardware requirements and more difficult testing.

Tutor Language is designed to remain understandable, reproducible and explainable whenever practical.

Decision

Educational problems should first be solved using deterministic methods.

Artificial intelligence should only be introduced when it provides measurable educational value that cannot reasonably be achieved using deterministic logic.

AI is considered an enhancement, never a foundational dependency.

Rationale

Deterministic systems are:

- easier to understand;
- easier to test;
- easier to debug;
- easier to maintain;
- more predictable;
- compatible with low-end hardware;
- fully compatible with F-Droid principles.

Consequences

Core educational decisions remain deterministic.

The application remains fully usable without AI.

Future AI components remain optional and replaceable.

---

# ADR-0001

Status

Accepted

Title

Spanish Only (Generation 1)

Context

Supporting multiple languages significantly increases project complexity.

Decision

Generation 1 supports Spanish only.

Generalization for additional languages is intentionally postponed.

Rationale

Reducing scope greatly increases the probability of delivering a polished first release.

Consequences

Architecture should optimize for Spanish.

Multilingual abstractions should not be introduced prematurely.

---

# ADR-0002

Status

Accepted

Title

Offline First

Context

Educational software should remain available regardless of network connectivity.

Privacy is one of the core values of the project.

Decision

Core educational functionality must work completely offline.

Internet access may enhance functionality in future versions but must never become mandatory.

Rationale

Offline operation improves:

- privacy;
- reliability;
- independence;
- longevity;
- F-Droid compatibility.

Consequences

No core educational component may require Internet access.

---

# ADR-0003

Status

Accepted

Title

Application Controls Teaching

Context

Language models are excellent at generating educational content but poor candidates for controlling long-term educational strategy.

Decision

Teaching strategy belongs exclusively to the application.

Language models may generate educational content but never determine pedagogical decisions.

Rationale

Educational strategy should remain:

- deterministic;
- explainable;
- testable;
- reproducible.

Consequences

Replacing the language model must not require redesigning the educational engine.

---

# ADR-0004

Status

Accepted

Title

Evidence-Based Adaptation

Context

Adaptive educational systems easily overfit early learner behaviour.

Premature conclusions often reduce long-term learning quality.

Decision

The tutor adapts only after collecting sufficient supporting evidence.

Adaptation remains reversible.

Rationale

Human learning behaviour changes over time.

Educational decisions should reflect accumulated evidence rather than isolated observations.

Consequences

The application continuously refines its learner model instead of permanently classifying learners.

---

# ADR-0005

Status

Accepted

Title

Independent Learner Models

Context

Learning is multidimensional.

Knowledge, memory, motivation and learning behaviour evolve independently.

Decision

The learner is represented by multiple independent models rather than one monolithic learner profile.

Examples include:

- Knowledge Model
- Learning Model
- Memory Model
- Motivation Model
- Evidence Model

Rationale

Independent models simplify reasoning and future evolution.

Consequences

Each model may evolve independently without affecting unrelated educational components.

---

# ADR-0006

Status

Accepted

Title

Long-Term Learning Over Short-Term Performance

Context

Immediate test performance does not necessarily predict durable knowledge.

Decision

Tutor Language optimizes for long-term retention rather than immediate correctness.

Rationale

Remembering information weeks later is more valuable than answering correctly immediately after studying.

Consequences

The application may intentionally delay repetition, reinforce difficult material and evaluate long-term retention.

---

# ADR-0007

Status

Accepted

Title

Adaptive Tutor

Context

Many educational applications primarily compete by offering additional features.

Tutor Language aims to compete through better adaptation to individual learners.

Decision

Improving teaching quality has higher priority than adding educational features.

Rationale

Personal adaptation is expected to become the project's primary competitive advantage.

Consequences

When priorities conflict, improving adaptation takes precedence over adding functionality.

---

# ADR-0008

Status

Accepted

Title

Educational Planning Before Content Generation

Context

Educational planning and lesson generation solve different problems.

Combining them increases architectural complexity and reduces explainability.

Decision

The system must first determine:

- learner state;
- educational objective;
- lesson goal;
- lesson constraints.

Only afterwards may lesson generation begin.

Rationale

Educational planning should remain deterministic.

Lesson generation may later use templates, procedural generation or optional AI.

Consequences

Lesson generation becomes completely replaceable.

Educational planning remains independent from content generation technology.

---

# ADR-0009

Status

Accepted

Title

Replaceability Over Optimization

Context

Educational technology evolves rapidly.

Individual components such as databases, language models, speech recognition engines or lesson generators may become obsolete.

Decision

Major subsystems should be designed to be replaceable without requiring architectural redesign.

Rationale

Long project lifetime depends more on adaptability than on early optimization.

Consequences

Subsystems should communicate through stable interfaces rather than implementation-specific assumptions.

Examples include:

- lesson generator;
- language model;
- speech recognition;
- text-to-speech;
- database.

---

# Final Principle

Architectural decisions should be:

- few;
- fundamental;
- stable;
- technology-independent.

Implementation details belong in source code.

Architectural intent belongs in ADRs.

---

End of document.