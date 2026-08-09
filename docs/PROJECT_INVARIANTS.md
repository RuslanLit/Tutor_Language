# PROJECT_INVARIANTS.md

Status: NORMATIVE
Scope: project-wide durable constraints

## 1. Purpose

This document contains only durable project invariants. It is intentionally
smaller than the project contract and the architecture specification. A rule
belongs here only when violating it would materially change project identity,
learner safety, data integrity, core architecture or the subject boundary.

## 2. Authority

These invariants have project-wide authority. Narrower normative documents may
detail them but may not contradict them. Topic ownership and conflict handling
are defined in `docs/DOCUMENTATION_AUTHORITY.md`.

`docs/PROJECT_CONTRACT.md` remains the broader project contract: it defines
priorities, engineering commitments and definition-of-done behavior. It is not
duplicated here. If a contract detail is not an invariant, the contract and its
topic owner apply.

## 3. Product / Platform Invariants

1. Tutor Language is an adaptive learning product whose core learning loop is
   usable offline. Optional online functionality must not make core learning
   depend on Internet access.
2. Core educational decisions must be deterministic, explainable,
   reproducible and testable wherever practical.
3. Educational strategy remains under application and learning-system control.
   AI may assist only where explicitly authorized and must not silently become
   a mandatory controller of progression or assessment.
4. Core platform responsibilities have explicit ownership boundaries between
   content, curriculum, learning state, runtime/session, persistence and
   subject-specific evaluation.
5. Stable identifiers and explicit references define persistent content,
   curriculum and learner-history identity.

## 4. Learning-System Invariants

6. Learning decisions about mastery, adaptation or remediation must use
   observable learner evidence rather than arbitrary UI completion alone.
7. Support, assessment, feedback and remediation must preserve the declared
   learning purpose and must not silently reveal an answer during an
   independent assessment.
8. The learning system must preserve the distinction between authored
   canonical content and runtime/session state. Runtime behavior must not
   silently invent or rewrite canonical educational content.

## 5. Data and Runtime Invariants

9. Learner progress and history must not be silently destroyed or rewritten.
   Destructive migrations require explicit architectural authorization and
   recovery consideration.
10. Runtime/session orchestration, persistence and content loading must respect
    the ownership boundaries of the active architecture and remain explainable.
11. A change that affects stable identity, persisted learner data, canonical
    ordering or runtime educational control requires validation appropriate to
    that boundary.

## 6. Subject-Boundary Invariants

12. Subject-specific concepts must not silently become platform invariants. A
    language-learning rule does not apply to mathematics, physics, chemistry
    or another subject unless explicitly promoted through an architectural
    decision.
13. Tutor Language currently uses language learning, especially Spanish, as
    its reference implementation. The learning platform is not defined by the
    Spanish course.
14. Generic learning-platform rules and subject-domain rules are separate
    authority scopes. Subject-specific requirements apply only to their
    declared subject scope unless explicitly promoted through an architectural
    decision.
15. The platform may support explicit subject specialization, but this does
    not require speculative abstractions for hypothetical subjects before
    evidence requires them.
16. Application/UI localization, cross-subject educational content
    localization, and language-learning target/support semantics are distinct
    responsibilities.

## 7. AI / Automation Invariants

17. AI or automation must not bypass a current normative human-approval gate.
18. Agents must not infer a platform rule from a subject-specific
    implementation, phase report or research proposal.
19. Automation must preserve deterministic identity, declared validation rules
    and learner-data integrity.

## 8. Application / Distribution Constraints

20. Project-wide privacy, offline and distribution constraints in
    `PROJECT_CONTRACT.md` and the active architecture remain applicable.
21. Temporary release-phase details, particular content counts, lesson
    durations, exercise types or one subject's production configuration are not
    project invariants unless explicitly promoted.

## 9. What Is NOT a Project Invariant

The following are deliberately owned by narrower documents unless explicitly
promoted: CEFR, Spanish A0, target/support language policy, IPA, pronunciation
sequencing, grapheme introduction, vocabulary, grammar, dialogue, linguistic
accepted variants, punctuation or accent normalization, Ukrainian or Russian
educational localization workflow, particular lessons, asset counts and
subject-specific activity types.

## 10. Change Policy

Changing an invariant requires an explicit documentation/architecture decision,
an explanation of affected scopes and verification of learner-data and runtime
consequences. Do not weaken an invariant implicitly in a task-specific guide.
