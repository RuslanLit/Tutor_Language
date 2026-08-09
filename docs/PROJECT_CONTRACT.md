# PROJECT_CONTRACT.md

Status: NORMATIVE
Scope: project priorities and engineering contract
Authority: primary

Version: 1.1

---

# Purpose

This document defines the mandatory engineering rules for developing Tutor Language.

Every implementation task must comply with this contract.

If any implementation conflicts with this document, this contract has higher priority than implementation convenience.

---

# Project

Working name:

Tutor Language

Purpose:

An adaptive offline Spanish tutor designed for Android devices.

---

# Core Principles

The application must always remain:

- Android-only.
- Offline-first.
- Compatible with F-Droid principles.
- Focused on education.
- Respectful of user privacy.
- Designed for long-term maintainability.
- Safe for user data.
- Conceptually consistent.

---

# Engineering Philosophy

The objective is not to produce code quickly.

The objective is to preserve the architecture while gradually improving the application.

Implementation may evolve.

Architecture should remain stable.

---

# Mandatory Requirements

Codex must NEVER:

- introduce cloud dependencies;
- require user registration;
- require Internet access for core functionality;
- introduce advertisements;
- introduce analytics or telemetry;
- introduce paid subscriptions;
- introduce Google Play Services unless explicitly requested;
- remove user data;
- modify unrelated modules while implementing a task;
- silently change application behaviour.

---

# Scope Protection

The first generation of the application ships Spanish content only.

Codex must not add other Language Packs unless explicitly requested.

The learning engine remains language-agnostic as defined by ARCHITECTURAL_DECISIONS.md.

Avoid abstractions that are not required by the current project scope.

---

# Architectural Integrity

Codex must preserve the conceptual architecture.

Temporary implementation shortcuts are acceptable.

Conceptual shortcuts are not.

Features may evolve.

Architecture should remain understandable.

---

# AI Decision Rules

Artificial Intelligence is an implementation tool.

It must never become the decision maker of the application.

The application controls:

- teaching strategy;
- learner models;
- adaptation logic;
- progress tracking.

AI may assist content authoring.

The application makes educational decisions.

---

# Architecture Rules

Codex must:

- keep modules loosely coupled;
- keep responsibilities separated;
- avoid duplicate implementations;
- avoid unnecessary dependencies;
- extend existing interfaces whenever practical;
- preserve backward compatibility whenever possible.

Large rewrites require explicit approval.

---

# Single Responsibility

Every module should have one primary responsibility.

If a module starts solving unrelated problems, it should be split.

Large files should be reduced rather than continuously expanded.

---

# Data Safety

User data is valuable.

Codex must never:

- delete user data;
- reset databases;
- silently migrate incompatible formats;
- remove settings;
- invalidate user progress.

Database migrations must always preserve existing information.

---

# Evidence Preservation

The learner profile is valuable.

Codex must preserve:

- learning history;
- learner models;
- statistics;
- adaptation history;
- future evidence collected by the tutor.

Features must never invalidate previously collected observations without explicit migration.

---

# Development Rules

Every completed task must:

- compile successfully;
- pass static analysis;
- avoid regressions;
- preserve existing functionality unless explicitly changed;
- update documentation when behaviour changes;
- include tests whenever practical.

---

# Testing Philosophy

Every new feature should be testable.

Business logic should remain independent from the user interface whenever practical.

Hidden behaviour should be minimized.

---

# Performance Philosophy

Correctness has higher priority than optimization.

Optimization should only follow measurement.

Premature optimization should be avoided.

---

# Explainability

The application should remain understandable.

Whenever practical:

- decisions should be explainable;
- adaptation should be transparent;
- hidden behaviour should be minimized.

---

# Human Control

The learner always remains in control.

The application may:

- recommend;
- explain;
- adapt.

The learner may override recommendations.

No learning strategy should ever be forced.

---

# Documentation Rules

Architecture changes require documentation updates.

Implementation changes that do not affect architecture should not require architectural documentation changes.

Documentation is part of the project.

It is not optional.

---

# AI Behaviour Rules

If architecture is documented:

Codex must follow it.

If architecture is unclear:

Codex must ask for clarification.

Codex must never invent architecture that contradicts existing documentation.

---

# Code Style

Code should be:

- readable;
- modular;
- deterministic whenever practical;
- maintainable;
- easy to review;
- documented where necessary.

Correctness is preferred over cleverness.

---

# Out of Scope

Until explicitly approved, Codex must not implement:

- cloud synchronization;
- online AI services;
- account systems;
- social networking;
- monetization;
- advertisements;
- telemetry;
- unnecessary abstractions.

---

# Priority Order

If multiple requirements conflict, use the following priority:

1. User safety.
2. User data preservation.
3. Architectural integrity.
4. Offline functionality.
5. F-Droid compatibility.
6. Correctness.
7. Simplicity.
8. Performance.
9. New functionality.

---

# Definition of Done

A task is considered complete only if:

- the application builds successfully;
- static analysis passes;
- existing functionality is preserved;
- documentation is updated when required;
- tests pass or new tests are added where practical;
- the implementation complies with PROJECT_CONTRACT.md.

---

End of document.
