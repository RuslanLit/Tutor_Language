# ARCHITECTURE.md

Status: Active

Version: 2.4

Related documents:

- PROJECT_VISION.md
- PROJECT_CONTRACT.md
- EDUCATIONAL_PRINCIPLES.md
- ARCHITECTURAL_DECISIONS.md
- CURRICULUM_SPEC.md
- LEARNING_MODEL.md
- V1_TECHNICAL_SPEC.md

---

# Purpose

This document defines the conceptual software architecture of Tutor Language.

It describes the major architectural components, their responsibilities and the flow of information between them.

Educational methodology is defined in LEARNING_MODEL.md.

Curriculum structure is defined in CURRICULUM_SPEC.md.

Implementation details are intentionally excluded.

---

# Architectural Goals

The architecture should remain:

- deterministic;
- modular;
- replaceable;
- explainable;
- testable;
- offline-first;
- maintainable;
- language-agnostic;
- compatible with F-Droid.

---

# High-Level Architecture

Tutor Language consists of three conceptual layers.

```text
Educational Domain
        │
Planning Layer
        │
Execution Layer
```

Every component belongs to exactly one layer.

Responsibilities must not overlap.

The implemented learning flow is:

```text
Educational Content
        |
        v
Curriculum
        |
        v
Rule-Based Lesson Planner
        |
        v
LessonPlan
        |
        v
LessonAssemblyService
        |
        v
LessonPlayerStep flattening
        |
        v
Lesson Session Engine
        |
        v
LessonPlayer
        |
        v
ActivityEngine
        |
        v
Answer Evaluation
        |
        v
Session Decision
        |
        v
Application Progress Services
        |
        v
Learner History
```

This flow separates lesson selection, content resolution, in-session orchestration, presentation, answer evaluation and progress recording.

Educational Domain

The Educational Domain defines what may be taught.

Components:

```text
Language Packs
        │
Educational Content
        │
Curriculum
```

These components are static.

They never depend on a learner.

They never change during lessons.

Language Packs

A Language Pack contains all educational data for one supported language.

Examples:

Spanish Language Pack
English Language Pack
German Language Pack
French Language Pack

A Language Pack may contain:

language metadata;
courses;
modules;
lesson definitions;
vocabulary;
grammar topics;
dialogues;
reading texts;
listening materials;
exercises;
audio assets.

A Language Pack never contains learner progress.

Multi-Language Architecture

Tutor Language is designed as a language-agnostic learning platform.

The learning engine must not contain language-specific logic.

Every supported language is provided as a separate Language Pack containing curriculum and educational content.

Adding support for a new language should primarily require adding a new Language Pack without modifying the learning engine.

Core entities are language-independent.

Examples:

Language
Course
Module
LessonDefinition
VocabularyItem
Dialogue
GrammarTopic
Exercise
Reading
AudioAsset

Generation 1 ships only with the Spanish Language Pack.

This limits content scope, not engine architecture.

Educational-content localization is part of the Language Pack content system,
not Flutter UI localization. UI locale, support locale and target language are
distinct concepts. The runtime resolves authored support-language text through
the educational-content localization layer while preserving stable educational
IDs and target-language material. The detailed source of truth is
EDUCATIONAL_CONTENT_LOCALIZATION.md.

Pronunciation data has stricter ownership than ordinary support text.
Target-language orthography, pronunciation variety, IPA, localized learner
hints, localized pronunciation explanations and future audio references must
remain separate. English-oriented respelling is not a universal pronunciation
representation.

Pronunciation is reusable educational knowledge. Long-term architecture treats
it as PronunciationUnit objects referenced by vocabulary, grammar, readings,
dialogues, lessons and exercises rather than copied into each asset. The
conceptual model is PRONUNCIATION_MODEL.md. Authoring rules are defined in
PRONUNCIATION_AUTHORING_GUIDE.md.

The first runtime foundation is a partial reference implementation. It loads a
Spanish A0 pronunciation reference slice and resolves support-locale-safe
learner hints without changing lesson planning, answer evaluation or learner
progress.

Educational Content

Educational Content defines every educational object available to the application.

Examples:

vocabulary;
grammar;
templates;
dialogues;
reading texts;
listening texts;
audio assets;
exercises.

Educational Content never stores learner information.

Educational Content belongs to a Language Pack.

Curriculum

Curriculum defines the recommended learning order.

The curriculum determines:

prerequisites;
lesson order;
educational dependencies;
lesson sequence;
module structure.

Generation 1 uses a mostly linear curriculum.

Future versions may replace it with a knowledge graph without changing the remaining architecture.

Curriculum structure is specified in CURRICULUM_SPEC.md.

Planning Layer

The Planning Layer determines what should happen next.

Components:

```text
Learner History
        |
        v
LearnerHistorySummary
        |
        v
Rule-Based Lesson Planner
        |
        v
LessonPlan
```

Planning is deterministic.

Planning never generates lessons.

Learner Profile

Represents everything currently known about one learner.

The Learner Profile is composed of independent models.

Learner Profile
│
├── Learner State
├── Knowledge Model
├── Learning Model
├── Memory Model
├── Motivation Model
└── Evidence Model

Only the Learner State Update component may modify the profile.

The Learner Profile may reference language, course, lesson and content identifiers.

It does not own curriculum or educational content.

Review Queue

Maintains educational priorities.

Responsibilities:

schedule repetitions;
prioritize weak knowledge;
prevent forgetting.

The Review Queue never generates lessons.

The Review Queue may reference educational content identifiers.

It does not duplicate educational content.

Lesson Planner

The Lesson Planner is the educational decision-making component.

Its responsibility is to determine the next lesson selection.

The implemented planner is `RuleBasedLessonPlanner`.

Inputs:

Curriculum
PlanningRequest
PlanningPolicy
LearnerHistorySummary

Outputs:

LessonPlan

The Lesson Planner:

never assembles lesson content;
never evaluates learner answers;
never modifies learner data.

Its decisions must remain deterministic and explainable.

`LessonPlan` is the planner output. It identifies the selected
LessonDefinition, the plan type, launch attempt purpose, reinforcement metadata
and reason codes explaining the selection.

The planner consumes durable completed lesson attempts through
`LearnerHistorySummary`.

For completed lessons, durable `LessonOutcomeStatus` is authoritative when it is
available:

- `mastered` advances to the next canonical lesson;
- `completedWithReinforcement` from `normal` or `manual_repeat` selects one
  immediate reinforcement repeat of the same lesson;
- `completedWithReinforcement` from `reinforcement_repeat` advances to the next
  canonical lesson while preserving `reinforcementRecommended`;
- legacy completion without durable attempt detail advances to the next
  canonical lesson without fabricating mastery.

Current incomplete lessons have higher priority than reinforcement of another
completed lesson.

The existing low-recent-accuracy rule remains only as a fallback when no
durable completed-lesson outcome applies. Durable lesson outcomes must not
compete with the older accuracy rule.

Lesson Goal

Defines the primary educational objective.

Examples:

introduce vocabulary;
reinforce grammar;
consolidate knowledge;
review forgotten material;
practice listening;
practice reading.

Every lesson has exactly one primary goal.

Lesson Constraints

Translate educational decisions into measurable boundaries.

Examples:

duration;
number of new words;
review items;
grammar focus;
exercise mix;
difficulty;
required activity types.

The Lesson Planner must respect these constraints when they are implemented by policy.

Execution Layer

The Execution Layer performs learning activities.

Components:

```text
LessonAssemblyService
        |
        v
LessonPlayerStep flattening
        |
        v
Lesson Session Engine
        |
        v
LessonPlayer
        |
        v
ActivityEngine
        |
        v
Answer Evaluation
        |
        v
Application Progress Services
```

Execution never changes planning decisions.

Lesson Assembly

`LessonAssemblyService` resolves a selected LessonDefinition into assembled lesson content.

Inputs:

Educational Content
Curriculum
LessonDefinition

Outputs:

LessonContent

Lesson assembly must not decide what the learner should study next.

Lesson assembly must not mutate Curriculum or Educational Content.

Lesson assembly must not store Generated Exercises in LessonDefinitions.

Lesson Step Flattening

Assembled lesson content is flattened into ordered `LessonPlayerStep` objects
before in-session orchestration.

`LessonPlayerStep` is a runtime presentation/session step, not authored
Educational Content and not Curriculum.

Current stable step identity is derived from:

```text
lessonId::sourceActivityId::contentId
```

For exercise templates, the template position within the source activity is
included:

```text
lessonId::sourceActivityId::templateId.templateIndex
```

This identity is deterministic for a given assembled lesson.

Known limitation:

- template position participates in identity;
- reordering templates may change step IDs;
- this is acceptable for current in-memory session state;
- durable step-level persistence should eventually use authored stable
  exercise or template-step identifiers.

Lesson Session Engine

`LessonSessionEngine` is the pure deterministic in-session orchestration
component.

It owns:

- ordered step identity;
- current step identity and index;
- completed step identifiers;
- attempt counts per step;
- latest evaluated `ActivityResult` per step;
- session status;
- deterministic retry, previous, next and finish eligibility.

It consumes:

- stable `LessonSessionStep` definitions derived from `LessonPlayerStep`;
- already evaluated `ActivityResult` values;
- explicit session events.

It returns:

- immutable `LessonSessionState`;
- a typed `LessonSessionDecision`;
- a stable `LessonSessionReasonCode`.

The Session Engine must not:

- load assets;
- assemble lessons;
- evaluate raw answers;
- normalize learner text;
- invent explanations;
- generate exercises;
- inspect learner history in the current phase;
- access Flutter, Riverpod, routing or database APIs;
- record learner or course progress;
- choose the next lesson.

The Session Engine may depend on the evaluated activity-result domain model
because session consequences depend on answer quality. It must not depend on
answer normalization, language rules or learner-facing feedback generation.

Lesson Rendering

`LessonPlayer` presents assembled lesson content to the learner.

Responsibilities:

- render the current `LessonPlayerStep`;
- own transient widget state such as text controllers, focus, scrolling and
  presentation details;
- collect learner input;
- send evaluated results to the Session Engine;
- render authored feedback and explanations;
- invoke progress/application services after a finish decision;
- route to the next lesson, course screen or course-completion view.

The LessonPlayer does not choose lesson content, evaluate answer correctness or
independently reproduce Session Engine progression policy.

Activity Execution

`ActivityEngine` evaluates supported interactive activity templates.

Responsibilities:

render activity-specific controls;
return deterministic activity results.

The ActivityEngine delegates typed-answer quality to the answer-evaluation
layer where applicable and returns an `ActivityResult`.

The ActivityEngine does not plan lessons, mutate educational content, route,
persist progress or decide session progression.

Answer Evaluation

Determines answer quality.

Responsibilities:

compare answers;
classify supported mistakes;
produce deterministic feedback metadata;
return correct, accepted-with-feedback or incorrect outcomes where supported.

The answer evaluator and the Session Engine are separate peers in execution:

- answer evaluation determines answer quality;
- the Session Engine determines the session consequence.

The Session Engine must not reinterpret canonical answers.

Durable mastery changes and spaced-repetition scheduling are future work.

Future answer evaluation should keep these responsibilities separate:

```text
Learner answer
        |
        v
Normalization
        |
        v
Comparison with accepted answers
        |
        v
Difference classification
        |
        v
Pedagogical result
        |
        v
Learner feedback
        |
        v
Progress or session consequence
```

Normalization prepares an answer for comparison.

Comparison determines whether the response matches a canonical answer or an
accepted alternative.

Difference classification identifies deterministic, high-confidence differences
such as capitalization, whitespace, punctuation, missing inverted punctuation,
diacritics or likely typographical errors.

Pedagogical result determines whether the response is correct, accepted with
feedback or incorrect.

Learner feedback explains useful distinctions.

Progress or session consequence records what happened without storing
linguistic rules inside learner progress.

LessonPlayer must not own this full evaluation policy.

Current implementation note:

- a reusable answer-evaluation layer owns typed-answer normalization,
  comparison, limited Spanish A0 orthographic difference classification and
  structured feedback metadata;
- exercise templates may provide explicitly authored misconception definitions
  for narrow, deterministic pedagogical feedback;
- LessonPlayer and activity widgets render the result but do not contain
  Spanish orthographic rules;
- the Session Engine owns current session consequences such as retry, previous,
  next and finish eligibility;
- broader grammar diagnosis, fuzzy spelling correction, semantic inference,
  durable session persistence and adaptive retry scheduling remain future work.

Answer evaluation never plans lessons.

Answer evaluation never modifies educational content.

Application Progress Services

Application services record durable outcomes after the Session Engine returns a
finish decision.

The completion boundary is:

```text
Session Engine finishLesson decision
        |
        v
LessonPlayer / application service
        |
        v
record lesson completion
        |
        v
Course navigation selects next lesson or course-complete state
```

The Session Engine may decide that the active lesson session is eligible to
finish. It must not write learner progress, mark a course complete, choose the
next lesson or navigate.

Session State Ownership

`LessonSessionState` is authoritative for:

- current step;
- completed session steps;
- attempts;
- latest evaluated result;
- session status;
- whether previous, next, retry and finish are allowed.

LessonPlayer UI state is authoritative only for transient presentation details,
including:

- current unsubmitted text;
- selected option before submission;
- controller state;
- focus;
- scroll position;
- expanded explanation presentation.

Learner progress persistence is authoritative for durable cross-session and
cross-launch records, including:

- completed lessons;
- course progress;
- learner history;
- durable performance summaries.

In-memory Lesson Session state is not durable learner progress.

The current provider-backed session adapter preserves state within the active
application session. It must not be described as persistent across application
restarts.

Session Event and Decision Protocol

The implemented event types are:

| Event | Purpose | Input | State effect | Invalid action |
| --- | --- | --- | --- | --- |
| `StartLessonSession` | Initialize a session for one lesson. | `lessonId`, ordered `LessonSessionStep` list. | Creates `LessonSessionState` with first step current and zero attempts. | Empty step list returns `rejectAction` with `emptyStepList`. |
| `SubmitLessonStepResult` | Submit an already evaluated result for the current step. | `ActivityResult`. | Increments current-step attempts, stores latest result, updates completion from result status. | Unknown current step returns `rejectAction` with `unknownStep`; completed session returns `lessonAlreadyCompleted`. |
| `RequestPreviousLessonStep` | Move to the previous step. | Current `LessonSessionState`. | Updates current step index and ID only. | First step returns `rejectAction` with `alreadyAtFirstStep`; completed session returns `lessonAlreadyCompleted`. |
| `RequestNextLessonStep` | Move to the next step. | Current `LessonSessionState`. | Moves to next step when current step is eligible. | Incomplete checkable step returns `nextStepLocked`; final eligible step returns `lastStepCompleted`; completed session returns `lessonAlreadyCompleted`. |
| `FinishLessonSession` | Ask whether the current lesson session may finish. | Current `LessonSessionState`. | Marks session `completed` only when final step is eligible. | Early finish returns `finalStepIncomplete`; completed session returns `lessonAlreadyCompleted`. |
| `RestartCurrentLessonStep` | Clear the latest result for the current step without changing attempts. | Current `LessonSessionState`. | Removes current step result and completion flag. | Missing current step returns `unknownStep`; completed session returns `lessonAlreadyCompleted`. |

The implemented decision types are:

| Decision type | Meaning | Side effects allowed inside Session Engine |
| --- | --- | --- |
| `showCurrentStep` | The caller should display the current step. | None. |
| `showFeedback` | The caller should display the latest accepted feedback/result. | None. |
| `showRemediation` | The caller should show authored remediation for the current step, when available. | None. |
| `insertReviewStep` | The caller should display an inserted authored review step from the active execution plan. | None. |
| `retryCurrentStep` | The current answer was not accepted and the learner should retry the same step. | None. |
| `moveToNextStep` | The caller may display the next step using the updated state. | None. |
| `moveToPreviousStep` | The caller may display the previous step using the updated state. | None. |
| `finishLesson` | The active lesson session is eligible to finish. | None; persistence and routing happen outside the engine. |
| `rejectAction` | The requested event is not allowed in the current state. | None. |

Reason codes are stable machine-readable diagnostics.

They:

- are not learner-facing text;
- must not be localized directly;
- may support tests, diagnostics, analytics and future policy inspection;
- must remain semantically stable;
- should not contain dynamic prose.

| Reason code | Trigger | Result | State effect |
| --- | --- | --- | --- |
| `sessionStarted` | Non-empty session start. | `showCurrentStep`. | Initializes in-progress session on first step. |
| `emptyStepList` | Session start with no steps. | `rejectAction`. | Returns not-started state. |
| `informationalStepMayContinue` | Next requested from an informational step. | `moveToNextStep`. | Marks informational step complete and advances. |
| `correctAnswerAccepted` | Current `ActivityResult` is correct. | `showFeedback`. | Increments attempts, stores result, marks step complete. |
| `acceptedWithCorrection` | Current `ActivityResult` is accepted with feedback. | `showFeedback`. | Increments attempts, stores result, marks step complete. |
| `firstIncorrectAttempt` | First incorrect result for the current step. | `retryCurrentStep`. | Increments attempts, stores result, marks step incomplete. |
| `remediationRequested` | Repeated incorrect result and the current step has authored remediation available. | `showRemediation`. | Increments attempts, stores result, marks step incomplete and records remediation visibility. |
| `remediationUnavailable` | Second incorrect result and the current step has no authored remediation available. | `retryCurrentStep`. | Increments attempts, stores result, marks step incomplete. |
| `repeatedIncorrectAttempt` | Later repeated incorrect result with no authored remediation available. | `retryCurrentStep`. | Increments attempts, stores result, marks step incomplete. |
| `retryAfterRemediation` | Current step result is cleared after remediation was shown. | `showCurrentStep`. | Removes current result and completion flag without incrementing attempts. |
| `reviewInserted` | Third incorrect result and authored review is available for the current step. | `insertReviewStep`. | Expands active execution plan with an inserted review step and a return to the originating step. |
| `reviewUnavailable` | Third incorrect result and no authored review is available for the current step. | `retryCurrentStep`. | Increments attempts, stores result, marks step incomplete. |
| `previousStepAvailable` | Previous requested from a non-first step. | `moveToPreviousStep`. | Moves current step backward. |
| `alreadyAtFirstStep` | Previous requested from first step. | `rejectAction`. | No state change. |
| `nextStepLocked` | Next requested from incomplete checkable step. | `rejectAction`. | No state change. |
| `lastStepCompleted` | Next requested from final eligible step. | `rejectAction`. | No state change; caller should request finish instead. |
| `movedToNextStep` | Next requested from a completed checkable step. | `moveToNextStep`. | Moves current step forward. |
| `finalStepIncomplete` | Finish requested before final eligible step. | `rejectAction`. | No state change. |
| `lessonFinished` | Finish requested from final eligible step. | `finishLesson`. | Marks session completed. |
| `lessonAlreadyCompleted` | Event requested after session completion. | `rejectAction`. | No state change. |
| `unknownStep` | Current step is absent or not part of the session. | `rejectAction`. | No state change. |
| `currentStepRestarted` | Current step result is cleared. | `showCurrentStep`. | Removes current result and completion flag without incrementing attempts. |

Attempt and Resubmission Policy

The current policy is:

- every evaluated submission increments the attempt count;
- informational navigation does not increment attempts;
- previous and next navigation do not increment attempts;
- attempts remain attached to stable step IDs;
- resubmission is allowed;
- resubmission replaces the latest stored result;
- completion eligibility follows the latest result.

Therefore, a previously completed step may become incomplete if its latest
resubmission is incorrect.

Remediation Policy

The Session Engine owns only the deterministic remediation decision policy.

Educational content owns the remediation content.

For the current implementation:

- first incorrect attempt retries the current step without remediation;
- second and later incorrect attempts request remediation when the runtime step
  declares authored remediation availability;
- if remediation is unavailable, the learner retries the same step;
- showing remediation does not complete the step;
- viewing or clearing remediation does not increment attempts;
- retry remains on the same step and lesson order is unchanged.

The engine receives remediation availability as runtime metadata on
`LessonSessionStep`.

The engine must not load assets, inspect grammar content, generate explanations
or contain target-language teaching prose.

Session Execution Plan

The Session Engine separates the immutable canonical step list from the active
execution plan.

`canonicalStepIds` represents the assembled lesson order.

`orderedStepIds` represents the active session order and may temporarily expand
with inserted authored review steps.

Inserted review steps:

- originate only from authored review references resolved before the engine
  receives runtime metadata;
- use stable runtime IDs in the form
  `review::<encoded-origin-step-id>::<encoded-authored-review-step-id>`;
- preserve maps from inserted review step to originating step and authored
  source step;
- exist only inside the active in-memory session;
- do not mutate curriculum, LessonDefinitions or asset files.

The default insertion policy is:

- first incorrect attempt: retry current step;
- second incorrect attempt: show authored remediation when available;
- third incorrect attempt: insert one authored review step when available;
- completing the inserted review returns to the originating step;
- completing review does not complete the originating step;
- each originating step may receive at most one inserted review step in a
  session.

If no authored review reference exists, the engine continues the remediation
and retry behavior without inserting placeholders.

Step Mastery

The Session Engine separates:

- answer correctness;
- step completion;
- step mastery.

Answer correctness comes from `ActivityResult`.

Step completion controls whether the learner may continue.

Step mastery is a deterministic session-level assessment stored in
`StepMasteryAssessment`.

The implemented mastery statuses are:

- `notAssessed`;
- `notMastered`;
- `fragile`;
- `mastered`.

The implemented mastery reason codes are:

- `noAssessmentEvidence`;
- `incorrectEvidenceOnly`;
- `firstAttemptCorrect`;
- `acceptedWithCorrection`;
- `recoveredAfterIncorrect`;
- `recoveredAfterRemediation`;
- `recoveredAfterReview`;
- `confirmationRequired`;
- `confirmationSucceeded`;
- `latestSubmissionIncorrect`.

The implemented evidence model includes:

- attempt count;
- correct submission count;
- accepted-with-correction count;
- incorrect submission count;
- whether the first attempt was correct;
- whether remediation was shown;
- whether review was required.

Mastery belongs to stable step IDs.

Inserted review steps may have their own mastery assessment, but their mastery
does not replace mastery of the originating canonical step.

At lesson finish, the engine returns a `LessonMasterySummary` for the active
session.

The summary counts canonical checkable steps only and excludes inserted review
steps from the denominator.

Lesson Outcome

At lesson finish, the engine also returns a deterministic `LessonOutcome`.

Lesson outcome is a lesson-level interpretation of the session mastery summary,
not a replacement for step mastery.

The implemented outcome statuses are:

- `mastered`;
- `completedWithReinforcement`;
- `incomplete`.

The implemented outcome reason codes are:

- `allStepsMastered`;
- `fragileMasteryPresent`;
- `lessonNotCompleted`;
- `noAssessableSteps`.

The outcome policy is pure and deterministic:

- incomplete sessions produce `incomplete`;
- completed sessions with no assessable steps produce
  `completedWithReinforcement`;
- completed sessions with fragile, not-mastered or unassessed canonical
  checkable steps produce `completedWithReinforcement`;
- completed sessions where all canonical assessed checkable steps are mastered
  produce `mastered`.

Lesson outcome is produced by the Session Engine as session output.

After a successful `finishLesson` decision, the application persistence layer
stores an immutable completed lesson attempt containing:

- the explicit attempt purpose;
- the lesson outcome;
- the lesson mastery summary;
- canonical checkable step mastery evidence;
- completion timestamp;
- learning policy version.

The Session Engine remains persistence-agnostic.

Durable completed lesson attempts are projected into planner-ready history. The
Lesson Planner uses them for bounded outcome-aware reinforcement policy.

Active in-progress `LessonSessionState` is still not persisted.

Durable Lesson Attempts

The database schema version is 6.

The durable attempt schema adds:

- `lesson_attempts`;
- `lesson_attempt_step_results`.

`lesson_attempts` stores one immutable row per completed lesson run.

It also stores `attempt_purpose`, using stable string codes:

- `normal`;
- `reinforcement_repeat`;
- `manual_repeat`.

Rows migrated from schema version 5 receive `normal`, because no explicit
special-purpose provenance existed before schema version 6.

`lesson_attempt_step_results` stores final evidence for canonical checkable
steps in that attempt.

The persistence boundary is:

```text
finishLesson decision
        |
        v
LessonAttemptSnapshotFactory
        |
        v
LearnerProgressRepository transaction
        |
        v
lesson attempt + attempt purpose + step results + existing completion event
```

Persistence rules:

- every repeated lesson run may create a distinct attempt ID;
- retrying the same completion request reuses the same pending completion
  attempt ID and completion timestamp;
- duplicate attempt IDs with the same aggregate are idempotent;
- duplicate attempt IDs with different aggregate data are rejected and never
  update existing rows;
- attempt purpose is immutable and participates in duplicate-conflict checks;
- attempt and step rows are written transactionally with the existing lesson
  completion progress event;
- step rows are persisted only for canonical checkable lesson steps;
- informational steps, inserted runtime review steps and remediation displays do
  not become durable learning-objective rows;
- remediation and inserted-review provenance is stored on the originating
  canonical step evidence;
- raw learner answers are not newly persisted;
- enum values are stored through explicit stable string codes, not ordinal
  positions.

Launch provenance ownership:

- ordinary planner/course launch, sequential next lesson and incomplete-lesson
  continuation use `normal`;
- planner-triggered immediate reinforcement repeats use `reinforcement_repeat`;
- explicit learner repeats of completed lessons use `manual_repeat`.

The Session Engine does not inspect or infer attempt purpose.

The Lesson Planner applies a bounded immediate reinforcement policy:

- a fragile `normal` or `manual_repeat` attempt may trigger one
  `reinforcement_repeat`;
- a `reinforcement_repeat` attempt consumes that immediate opportunity even if
  it remains fragile;
- a fragile consumed reinforcement advances to the next lesson with
  `reinforcementRecommended`;
- final lessons follow the same bounded policy before course completion.

The planner does not schedule delayed review, scan the whole course for weak
lessons, use time-based spacing or perform step-level cross-session adaptation.

Legacy completions created before durable attempts remain valid completion
progress.

No synthetic mastery or lesson outcome is fabricated for legacy completions.

Malformed durable attempt detail is isolated locally. A bad detailed attempt may
make that attempt's outcome unavailable, but it must not erase valid legacy
completion progress, learner state or other readable attempts.

Runtime Dependency Direction

The runtime dependency direction is:

```text
Educational Content
        |
        v
Lesson Assembly
        |
        v
LessonPlayerStep flattening
        |
        v
Lesson Session domain
        |
        v
Provider / controller adapter
        |
        v
Lesson Player UI
```

The pure Session Engine must have no dependency on:

- Flutter;
- Riverpod;
- widgets;
- routes;
- database;
- asset loading;
- Lesson Planner;
- learner-history repository;
- application navigation.

Relationship to Educational Content

Pedagogical knowledge belongs in authored Educational Content, not in the
Session Engine.

The Session Engine may react to typed evaluation outcomes, but it must not
contain:

- target-language phrases;
- grammar explanations;
- correction prose;
- accepted spelling variants;
- lesson-specific rules;
- answer keys.

Examples, explanations, prompts, canonical answers and mistake guidance remain
in content assets and evaluation-related content structures.

Future Session Extension Points

These are future work and are not implemented:

- Escalated remediation: a later policy may react to additional repeated
  incorrect attempts by offering an authored review lesson. The engine must not
  generate remediation text.
- Review insertion: a later session policy may insert authored review steps
  through explicit deterministic rules while preserving stable identity and
  provenance.
- Learner-history adaptation: a future policy may receive a summarized learner
  model. The engine must not query repositories directly.
- Session persistence: a future adapter may serialize session state. The pure
  engine should remain persistence-agnostic.
- Dynamic planning: the Lesson Planner may choose a different lesson before
  launch. It must not mutate an active session directly.
- AI-assisted features: any future AI component must remain outside the
  authoritative correctness and progression path unless separately specified
  and validated.

Learner State Update

Updates learner information after evaluation.

Responsibilities:

update learner state;
update review priorities;
accumulate evidence;
update motivation statistics;
update mastery information.

This is the only component allowed to modify the Learner Profile.

Information Flow

The architecture follows a single direction.

```text
Language Pack
        |
        v
Educational Content
        |
        v
Curriculum
        |
        v
Rule-Based Lesson Planner
        |
        v
LessonPlan
        |
        v
LessonAssemblyService
        |
        v
LessonPlayerStep flattening
        |
        v
Lesson Session Engine
        |
        v
LessonPlayer
        |
        v
ActivityEngine
        |
        v
Answer Evaluation
        |
        v
Lesson Session Engine
        |
        v
Application Progress Services
        |
        v
Learner History
        |
        +--------------------> Rule-Based Lesson Planner
```

The learning cycle repeats indefinitely.

There are no other feedback loops.

Terminology Boundaries

The term "Lesson Generator" is not used for the current implemented flow because it hides separate responsibilities.

Current canonical terms are:

- Rule-Based Lesson Planner: decides which LessonDefinition should be attempted next.
- LessonPlan: records the deterministic planning decision and reasons.
- LessonAssemblyService: resolves LessonDefinition references into assembled lesson content.
- LessonPlayerStep: represents one ordered runtime step inside an assembled lesson.
- Lesson Session Engine: decides in-session retry, previous, next and finish consequences from explicit events and evaluated results.
- LessonPlayer: presents assembled content.
- ActivityEngine: evaluates interactive activity responses.
- ActivityResult: records the evaluated result of one interactive activity.
- Learner History: records observed learner events and progress.

Future procedural lesson generation may be added later, but it must remain
separate from planning, session orchestration, rendering and answer evaluation.

Component Boundaries

Every component owns exactly one responsibility.

Components communicate only through defined outputs.

A component must never modify another component's internal data directly.

Responsibilities should remain explicit.

Language-specific data must remain inside Language Packs.

Learner-specific data must remain inside learner models.

Optional AI Components

Artificial intelligence is outside the pedagogical core.

Possible future components include:

Local LLM;
Speech Recognition;
Text-to-Speech;
Pronunciation Analysis.

These components assist learning.

They never determine educational strategy.

The architecture must remain fully functional without them.

Replaceability

Major subsystems should remain replaceable.

Examples:

Rule-Based Lesson Planner;
LessonAssemblyService;
LessonSessionEngine;
Local LLM;
Speech Recognition;
Text-to-Speech;
Database;
Language Pack loader.

Replacing one subsystem must not require redesigning the architecture.

Failure Isolation

Optional components should fail independently.

Examples:

no speech recognition → continue using text;
no TTS → continue silently;
no LLM → use predefined explanations;
missing optional audio → continue with text-only lesson.

Core learning must always remain available.

Communicative Competency Runtime

Module-level communicative competency checks are coordinated by a dedicated
competency runtime layer.

The responsibility flow is:

```text
authored competency definition
        │
        ▼
CompetencySessionController
        │
        ▼
CommunicativeCompetencyCoordinator
        │
        ▼
LessonSessionEngine
        │
        ▼
CompetencyAttemptRepository
        │
        ▼
Drift competency tables
```

The competency runtime:

- starts and resumes competency attempts;
- records diagnostic task results;
- records typed competency gaps;
- records authored recovery executions;
- retries the originating diagnostic task;
- persists final competency outcomes.

It does not generate content, evaluate answer correctness, mutate curriculum,
rewrite lesson attempts or replace the Lesson Session Engine.

Course navigation may expose a competency check after the module content and
checkpoint requirements are complete. The learner-facing competency screen
loads authored diagnostic and recovery steps through normal content repository
interfaces, delegates answer checking to existing activity evaluation and uses
the competency runtime only for attempt, gap, recovery and outcome decisions.

Schema version 7 stores competency state in dedicated tables:

- `competency_attempts`;
- `competency_task_results`;
- `competency_gaps`;
- `competency_recovery_executions`.

Competency attempts are distinct from lesson attempts.

Module projection may expose states such as:

- content incomplete;
- competency not started;
- competency in progress;
- achieved;
- achieved with reinforcement;
- partially achieved;
- not yet achieved.

Learner-facing UI should hide internal competency IDs, micro-competency IDs,
reason codes and database identifiers.

Architecture Principles

The architecture should evolve through extension rather than replacement.

New components should improve an existing information flow rather than introduce parallel flows.

Every new feature should strengthen at least one stage of the learning cycle.

The engine should not be specialized for a single language.

Language-specific differences should be represented through Language Pack data and configuration.

Final Principle

Architecture defines responsibilities.

Curriculum Specification defines educational structure.

Learning Model defines educational behaviour.

Implementation defines software behaviour.

These concerns should remain independent.

End of document.
