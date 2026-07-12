# ARCHITECTURAL_DECISIONS.md

Status: Active

Version: 2.4

Related documents:

- PROJECT_VISION.md
- PROJECT_CONTRACT.md
- EDUCATIONAL_PRINCIPLES.md
- ARCHITECTURE.md
- CURRICULUM_SPEC.md
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

Spanish Language Pack First

Context

Supporting multiple complete language packs significantly increases content creation, testing and quality assurance effort.

However, optimizing the application architecture for only one specific language would make future expansion difficult.

Decision

Generation 1 ships with Spanish as the first supported Language Pack.

Additional Language Packs are postponed.

The learning engine remains language-agnostic from the beginning.

Rationale

Reducing content scope increases the probability of delivering a polished first release.

Keeping the learning engine language-agnostic prevents future architectural rewrites.

Consequences

Generation 1 includes Spanish educational content only.

The architecture must not introduce Spanish-specific engine logic.

Multilingual content is postponed.

Multilingual architecture is not postponed.

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

Educational Planning Before Content Realization

Context

Educational planning, lesson assembly, presentation and activity evaluation solve different problems.

Combining them increases architectural complexity and reduces explainability.

Decision

The system must first determine:

- learner state;
- educational objective;
- planning request;
- planning policy;
- learner history summary.

Only afterwards may lesson assembly and presentation begin.

Rationale

Educational planning should remain deterministic.

Lesson assembly may use LessonDefinitions, Educational Content and templates.

Future procedural content realization may be added later.

Optional AI may assist content authoring or explanations, but it must not become required for lesson planning, lesson assembly, presentation or activity evaluation.

Consequences

Lesson planning, assembly, presentation and activity evaluation remain independently replaceable.

Educational planning remains independent from content realization technology.

---

# ADR-0009

Status

Accepted

Title

Language-Agnostic Learning Engine

Context

Tutor Language starts with Spanish, but the project should not become architecturally dependent on Spanish.

Language-specific assumptions inside the learning engine would make future Language Packs expensive to add and difficult to test.

Decision

The application architecture shall remain independent from any particular language.

Educational content is distributed as Language Packs.

The learning engine must not contain language-specific entities or branches.

Rationale

A language-agnostic engine allows the project to support additional languages without redesigning the pedagogical core.

It also keeps lesson execution, progress tracking, review scheduling and evaluation reusable across languages.

Consequences

There must be no engine entities such as:

- SpanishLesson
- SpanishExercise
- SpanishVocabulary

Core curriculum entities remain universal:

- Language
- Course
- Module
- LessonDefinition
- VocabularyItem
- Dialogue
- GrammarTopic
- Reading
- AudioAsset
- Exercise

Adding a new language should primarily require adding a new Language Pack.

Language-specific behaviour must be represented through data and configuration.

---

# ADR-0010

Status

Accepted

Title

Replaceability Over Optimization

Context

Educational technology evolves rapidly.

Individual components such as databases, language models, speech recognition engines, planners or assembly services may become obsolete.

Decision

Major subsystems should be designed to be replaceable without requiring architectural redesign.

Rationale

Long project lifetime depends more on adaptability than on early optimization.

Consequences

Subsystems should communicate through stable interfaces rather than implementation-specific assumptions.

Examples include:

- rule-based lesson planner;
- lesson assembly service;
- language model;
- speech recognition;
- text-to-speech;
- database.

---

# ADR-0011

Status

Accepted

Title

Canonical Educational Content Model

Context

After implementing the Spanish A0 Unit 1 Lesson 1 reference lesson, the Educational Content model was reviewed against the complete Spanish A0 curriculum.

The review concluded that Spanish A0 can be represented by the existing Educational Content model without introducing additional knowledge object types.

Decision

The canonical Educational Content model currently consists of exactly five knowledge object types:

- Vocabulary Item
- Grammar Topic
- Dialogue
- Reading Text
- Exercise Template

No additional Educational Content types are currently required.

Future architectural work should first extend existing Educational Content types before introducing new ones.

A new Educational Content type requires architectural justification. Implementation convenience alone is not sufficient.

Presentation assets such as audio, images and video represent Educational Content. They are not Educational Content types.

Rationale

The five existing types are sufficient to model beginner language learning while preserving clear boundaries between knowledge, curriculum organization, planning, assembly and runtime activity execution.

Keeping the model small reduces authoring complexity, validation complexity and migration risk.

Consequences

New content-authoring patterns should reuse the existing five types whenever educational meaning can be preserved.

Future media support should be modeled as representation or metadata for existing Educational Content unless a distinct knowledge object is architecturally justified.

---

# ADR-0012

Status

Accepted

Title

Rule-Based Planning Separated From Assembly, Presentation and Activity Evaluation

Context

Phase E11 introduced the first deterministic rule-based planning foundation.

The project now has separate implemented responsibilities for lesson selection, lesson content resolution, lesson presentation and interactive activity evaluation.

Combining these responsibilities would make the learning flow harder to test, harder to explain and harder to evolve.

Decision

The current learning flow is separated into these components:

- RuleBasedLessonPlanner selects the next LessonDefinition.
- LessonPlan records the planning decision and reason codes.
- LessonAssemblyService resolves LessonDefinition references into assembled lesson content.
- LessonPlayerStep flattening creates deterministic runtime steps.
- LessonSessionEngine coordinates in-session progression.
- LessonPlayer presents assembled lesson content.
- ActivityEngine evaluates supported interactive activity responses.
- ActivityResult records evaluated activity outcomes.
- Application services record durable lesson completion after a Session Engine finish decision.
- Learner History records observed learner events and progress.

Educational Content remains immutable and reusable.

Curriculum defines what can be taught.

The planner determines what should be attempted next.

The assembly layer resolves references only.

The presentation layer displays content only.

Interactive activity evaluation remains separate from presentation.

The planner must remain deterministic and explainable.

AI is not responsible for runtime lesson planning.

Rationale

This separation keeps the core learning loop testable and replaceable.

It allows E11 planning logic to evolve without changing Educational Content schemas, loaders, validators, LessonPlayer or ActivityEngine.

It also prevents fixed ready-made lessons from becoming the main adaptive mechanism while preserving LessonDefinitions as reusable curriculum inputs.

Consequences

Future planning features should extend RuleBasedLessonPlanner, PlanningRequest, PlanningPolicy, LearnerHistorySummary and LessonPlan before changing content schemas.

LessonAssemblyService must not decide educational strategy.

LessonPlayer must not own planning, answer-evaluation or session-progression policy.

ActivityEngine must not store learner progress directly.

LessonSessionEngine must not load assets, evaluate raw answers, persist progress,
route, query learner-history repositories or choose the next lesson.

Advanced adaptive review scheduling, mastery estimation, spaced repetition, dynamic content-level planning and LLM-assisted authoring remain future work unless explicitly implemented.

Adding a new Educational Content type requires an explicit architectural decision.

---

# ADR-0013

Status

Accepted

Title

Active Recall as the Default Knowledge-Formation Strategy

Context

Recognition-only exercises are easy to complete and may be passed through
guessing.

Immediate correctness is not always strong evidence of durable language
ability.

Tutor Language optimizes for practical long-term learning rather than
superficial lesson completion.

Decision

The course should progressively move learners from exposure and recognition
toward independent recall and application.

Each exercise should require the greatest reasonable degree of independent
knowledge retrieval appropriate to the learner's current stage.

Multiple choice remains available when pedagogically justified, especially for
first exposure, discrimination and scaffolding, but it should not normally be
the sole evidence that a learner can actively use a knowledge unit.

Lesson completion remains distinct from mastery.

Rationale

Retrieval practice is generally associated with stronger long-term retention
than passive restudy under many learning conditions.

Active production also provides stronger evidence about what the learner can
retrieve without visible support.

The project still remains adaptive: this decision defines a default
knowledge-formation strategy, not a rigid sequence that every lesson must
follow.

Consequences

The project will need more typed-response, recall and controlled-application
activities over time.

Content authoring requirements become stricter.

Exercise prompts must be unambiguous.

Accepted answer variants and feedback must be intentional, deterministic and
reviewable.

Multiple choice is retained, but recognition-only lessons require a
pedagogical reason.

Future implementation will need deterministic answer normalization, comparison,
difference classification and feedback.

Current Lesson Session Engine work provides deterministic in-memory session
orchestration and attempt counts. Durable attempt history, activity-level
evidence, delayed retrieval, adaptive retry scheduling and durable mastery
estimation remain future work.

Increased learner effort is intentional when it improves learning.

---

# ADR-0014

Status

Accepted

Title

Pure Deterministic Lesson Session Engine

Context

The application now has separate implemented responsibilities for lesson
selection, lesson assembly, runtime step flattening, answer evaluation,
presentation and durable progress recording.

Before the Session Engine, LessonPlayer owned too much in-session progression
logic, including whether a learner could move to the next step, retry, go back
or finish the lesson.

Combining these decisions with Flutter UI code would make the learning flow
harder to test, harder to explain and harder to evolve toward later adaptive
policies.

Decision

In-session lesson progression is owned by a pure deterministic
`LessonSessionEngine`.

The Session Engine uses explicit event, state and decision objects:

- `LessonSessionState`;
- `LessonSessionEvent`;
- `LessonSessionDecision`;
- `LessonSessionReasonCode`.

The engine consumes stable step identities and already evaluated
`ActivityResult` values.

It returns updated immutable state, a typed decision and a stable reason code.

The engine does not perform persistence, routing, answer evaluation, asset
loading, lesson assembly, lesson planning or UI rendering.

Rationale

A pure transition engine keeps session policy:

- deterministic;
- testable without Flutter;
- independent of Riverpod, routing and database APIs;
- independent of language-specific answer rules;
- replaceable as future session policies become richer.

It also preserves the separation between answer quality and session
consequence:

- answer evaluation determines whether a response is correct, accepted with
  feedback or incorrect;
- the Session Engine determines whether the current session should retry,
  continue, move backward or finish.

Alternatives Considered

Keep progression logic inside LessonPlayerScreen.

Rejected because UI code would continue to own pedagogical/session policy,
making policy difficult to test and easy to duplicate.

Combine answer evaluation and session progression in one engine.

Rejected because raw-answer interpretation, language rules and pedagogical
feedback are separate from session consequences.

Let Session Engine persist progress and perform routing.

Rejected because this would couple domain policy to application services,
database APIs and navigation.

Use a pure event/state/decision transition engine.

Accepted because it keeps policy deterministic, explicit and independently
testable.

Consequences

LessonPlayer must ask the Session Engine for previous, next, retry and finish
decisions instead of reproducing those rules locally.

Application services remain responsible for durable progress recording after a
`finishLesson` decision.

Course navigation remains responsible for selecting the next lesson or showing
course completion.

Session state is currently in-memory and must not be described as durable
learner progress.

Attempt counts are session-level data. Every evaluated submission increments
the attempt count. Resubmission is allowed, replaces the latest result and may
make a previously completed step incomplete if the latest result is incorrect.

The Session Engine may request authored remediation after repeated incorrect
attempts when runtime step metadata declares that remediation is available.

The engine does not own or generate the remediation content.

The Session Engine may also temporarily expand the active in-memory execution
plan with an inserted authored review step after repeated incorrect attempts.

The canonical lesson order remains immutable.

The Session Engine now distinguishes answer correctness, step completion and
current-session step mastery.

Mastery is deterministic session evidence only.

Final completed-session mastery evidence may be persisted as part of an
immutable lesson attempt, but it does not represent long-term acquisition.

Fragile steps may still be completed and may still permit lesson completion in
the current phase.

At lesson finish, the Session Engine returns a deterministic lesson outcome
derived from the session mastery summary.

The lesson outcome distinguishes:

- all canonical assessed steps mastered;
- completed with reinforcement still needed;
- incomplete lesson.

The outcome is session output and is not a planner input in the current phase.

Constraints

`LessonSessionEngine` must not depend on:

- Flutter;
- Riverpod;
- widgets;
- routes;
- database;
- asset loading;
- Lesson Planner;
- learner-history repositories;
- application navigation.

Pedagogical knowledge remains in Educational Content and evaluation-related
content structures, not in the Session Engine.

Future Implications

Future escalated remediation, optional review lessons, durable mastery,
learner-history adaptation and session persistence should extend the Session
Engine through explicit deterministic inputs and adapter boundaries.

The engine must remain persistence-agnostic even if a future adapter serializes
session state.

AI-assisted features, if ever introduced, must remain outside the authoritative
correctness and progression path unless separately specified and validated.

---

## ADR: Persist Immutable Completed Lesson Attempts

Status

Accepted

Context

The Session Engine now produces deterministic step mastery, lesson mastery
summary and lesson outcome for completed sessions.

Keeping that evidence only in memory loses useful history after restart.

At the same time, the Session Engine must remain pure and independent of Drift,
repositories, widgets, routing and learner-history projection.

Decision

The application persistence layer stores immutable completed lesson attempts
after a successful `finishLesson` decision.

Each durable attempt stores:

- one attempt row;
- canonical checkable step result rows;
- explicit attempt purpose;
- explicit stable enum codes;
- completion timestamp;
- learning policy version.

The write happens through `LearnerProgressRepository` in one transaction that
also records the existing lesson completion progress event.

Historical attempt writes are append-only.

If the same attempt ID and the same aggregate are written again, the repository
accepts the request as idempotent.

If the same attempt ID is written with different aggregate data, the repository
rejects it as an immutable-history conflict and does not update existing rows.

The Lesson Player creates one pending completion attempt ID for one finished
in-memory session and reuses it across save retries.

Malformed durable attempt detail is isolated so one unreadable attempt does not
erase unrelated legacy progress or other valid durable attempts.

Inserted runtime review steps, remediation displays and informational steps are
not persisted as canonical step rows.

Raw learner answers are not newly persisted.

Legacy completions remain valid but do not receive fabricated mastery evidence.

Consequences

Multiple attempts for one lesson remain queryable.

Future learner-history and planner layers can consume a clean domain summary
without importing Drift models.

Historical outcomes are preserved as originally decided instead of being
recalculated by future mastery policies.

Active unfinished session persistence remains future work.

Rejected alternatives:

- upserting historical attempts;
- generating a fresh attempt ID for each save retry;
- returning empty learner history when one durable detail row is malformed;
- mapping unknown persisted enum codes to arbitrary defaults.

---

## ADR: Persist Explicit Lesson Attempt Purpose

Status

Accepted

Context

Future outcome-aware planning needs to distinguish ordinary course progression,
planner-triggered reinforcement repeats and learner-triggered manual repeats
after application restart.

Attempt count, timestamps and repeated lesson IDs are not reliable provenance.

Decision

The application persists explicit immutable attempt purpose on completed lesson
attempts.

The supported purpose values are:

- `normal`;
- `reinforcementRepeat`;
- `manualRepeat`.

The stable persisted codes are:

- `normal`;
- `reinforcement_repeat`;
- `manual_repeat`.

Schema version 6 adds non-null `attempt_purpose` to `lesson_attempts`.

Rows migrated from schema version 5 receive `normal`, meaning no explicit
special-purpose provenance was available.

Launch ownership is:

- planner/course progression and incomplete continuation: `normal`;
- planner-selected reinforcement repeat: `reinforcementRepeat`;
- explicit learner repeat of completed lessons: `manualRepeat`.

The Session Engine remains unaware of attempt purpose.

The Lesson Planner consumes purpose for bounded immediate reinforcement policy.

Consequences

Purpose participates in immutable aggregate equality and duplicate-conflict
detection.

Unknown persisted purpose codes remain invalid and are isolated like other
malformed durable attempt detail.

Rejected alternatives:

- infer purpose from attempt sequence;
- infer purpose from timestamp proximity;
- infer purpose from lesson completion state;
- keep purpose only in provider memory;
- treat all repeats as equivalent.

---

## ADR: Use Durable Outcomes and Attempt Purpose for Bounded Reinforcement

Status

Accepted

Context

Lesson completion alone does not show whether the learner demonstrated strong
mastery or completed with fragile evidence.

The application now persists immutable durable lesson outcomes and explicit
attempt purpose.

Without bounded policy, fragile outcomes could either be ignored or repeat
indefinitely.

Decision

The Rule-Based Lesson Planner uses durable lesson outcomes and attempt purpose
to select one immediate deterministic reinforcement repeat when the latest
course-position lesson was completed with reinforcement still needed.

Policy:

- `mastered` advances to the next canonical lesson;
- `completedWithReinforcement` from `normal` launches the same lesson once with
  `reinforcementRepeat`;
- `completedWithReinforcement` from `manualRepeat` also launches one
  `reinforcementRepeat`;
- any `reinforcementRepeat` attempt consumes the immediate repeat opportunity;
- if a consumed reinforcement attempt is still fragile, the planner advances
  and preserves reinforcement as informational metadata;
- legacy completion without durable outcome detail advances without fabricated
  mastery;
- current incomplete lesson continuation has priority over reinforcement.

The planner remains pure. It consumes planner-ready learner history and does
not query Drift, inspect raw answers, recalculate persisted outcomes, mutate
session state or persist attempts.

The Lesson Launch layer executes the planner's selected lesson and explicit
attempt purpose. It must not reinterpret planner reason codes into a different
purpose.

Consequences

Fragile completions receive one immediate reinforcement opportunity.

Planner-triggered repeats cannot create an infinite repeat loop.

Learner-triggered manual repeats remain distinct from planner-triggered
reinforcement and may create fresh evidence.

Legacy completion behavior remains compatible.

Delayed review, spaced repetition, mastery decay, cross-lesson weakness
planning and step-level adaptation remain future work.

Rejected alternatives:

- repeat every fragile result indefinitely;
- infer repeat consumption from attempt counts;
- treat manual and planner repeats as identical;
- use timestamps to infer purpose;
- put outcome policy in Lesson Launch;
- schedule delayed reviews in this initial integration.

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
