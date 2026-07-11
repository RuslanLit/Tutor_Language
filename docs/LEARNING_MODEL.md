# LEARNING_MODEL.md

Status: Active

Version: 3.3

Related documents:

- EDUCATIONAL_PRINCIPLES.md
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

# Knowledge Formation Strategy

The primary objective is durable active language ability.

The application should optimize for:

- long-term retention;
- active recall;
- independent production;
- practical use of learned knowledge;
- accurate feedback;
- efficient correction of weaknesses.

The application should not optimize primarily for:

- ease of lesson completion;
- high numbers of correct taps;
- superficial engagement;
- artificial progress;
- recognition-only testing.

Meaningful mental effort is intentional when it improves learning.

This is a project policy informed by learning science, not a claim that one
exercise mode is always best. Retrieval practice is generally associated with
stronger long-term retention than passive restudy under many learning
conditions, but task choice must still respect learner level, cognitive load
and lesson objective.

---

# Retrieval Progression

Learning should normally reduce support over time.

Preferred progression:

```text
Exposure
        |
        v
Recognition
        |
        v
Cued Recall
        |
        v
Free Recall
        |
        v
Controlled Application
        |
        v
Independent Application
```

These stages are not mandatory sections in every LessonDefinition.

They describe increasing retrieval demand:

- Exposure: the learner first sees and understands the material.
- Recognition: the correct answer is visible or strongly implied among alternatives.
- Cued Recall: the learner retrieves the answer with partial support.
- Free Recall: the learner retrieves the answer from memory without visible options.
- Controlled Application: the learner uses known material in a constrained context.
- Independent Application: the learner uses known material in a new practical context.

The application must not treat all correct answers as equally strong evidence.

The mode by which an answer was produced matters.

A correct multiple-choice answer and a correct typed answer from memory are
different evidence even when the expected language is identical.

Lesson completion is not mastery.

Completion means the learner completed the required lesson structure or session
criteria. Mastery requires stronger and repeated evidence over time.

---

# Feedback Principle

Feedback should help the learner improve the next attempt.

Answer evaluation should distinguish, when supported:

- correct;
- accepted with feedback;
- incorrect.

Names may differ in implementation, but the educational distinction should
remain.

For example, an A0 learner who types `que tal` for `¿Qué tal?` has likely
retrieved the right words but missed orthographic information. That should be
eligible for corrective feedback rather than being treated as equivalent to a
semantically unrelated answer when deterministic rules can identify the
difference.

Uncertain error classification must fall back to neutral feedback.

The application must not fabricate linguistic explanations.

Current implementation note:

- deterministic typed-answer evaluation supports correct, accepted-with-feedback
  and incorrect outcomes;
- Spanish A0 orthographic tolerance is limited to high-confidence accent and
  Spanish boundary punctuation differences;
- explicitly authored misconceptions can provide narrow pedagogical
  explanations for known conceptual mistakes;
- semantic evaluation, broad grammar diagnosis, fuzzy typo handling and mastery
  estimation remain future work.

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

Only after these questions have deterministic answers may lesson planning and assembly begin.

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
LessonPlan
        │
        ▼
Lesson Assembly
        │
        ▼
LessonPlayerStep Flattening
        │
        ▼
Lesson Session Engine
        │
        ▼
LessonPlayer
        │
        ▼
ActivityEngine
        │
        ▼
Answer Evaluation
        │
        ▼
Session Consequence
        │
        ▼
Learner History
```

Every completed lesson represents one iteration of this learning cycle.

The cycle repeats continuously throughout the learner's lifetime.

The answer evaluator and the Lesson Session Engine answer different learning
questions:

- answer evaluation determines the quality of a learner response;
- the Lesson Session Engine determines the immediate session consequence.

For example, an accepted-with-feedback result may count as accepted for moving
through an A0 lesson while still preserving the correction as evidence that the
canonical written form was not fully reproduced.

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

- LessonDefinitions;
- prerequisites;
- progression order;
- recommended vocabulary;
- recommended grammar.

The Curriculum defines **what may be learned**.

It never decides **what should be taught next**.

Curriculum Lessons are LessonDefinitions.

They are static inputs to planning and assembly, not generated Lesson Sessions.

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

## Lesson Planner

The Lesson Planner decides what should be attempted next.

The implemented planner is `RuleBasedLessonPlanner`.

It consumes:

- available curriculum;
- a PlanningRequest;
- a PlanningPolicy;
- a LearnerHistorySummary.

It produces:

- a LessonPlan;
- a selected LessonDefinition identifier;
- a plan type;
- deterministic reason codes.

The Lesson Planner does not assemble content, render UI, evaluate answers or mutate learner history.

---

## LessonPlan

LessonPlan is the deterministic output of lesson planning.

It describes the lesson selection decision.

It is not Educational Content.

It is not Curriculum.

It is not a LessonDefinition.

It is not a rendered Lesson Session.

Current LessonPlan information includes:

- selected LessonDefinition identifier;
- plan type;
- reason codes;
- optional selected content references;
- diagnostic explanation.

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

Lesson planning and assembly must remain inside these boundaries.

The Lesson Planner uses policy constraints to select a LessonPlan.

Lesson Assembly uses the selected LessonDefinition and referenced Educational Content to produce assembled lesson content.

It does not create educational knowledge.

It does not modify LessonDefinitions.

---

## Lesson Assembly

Lesson Assembly resolves references after planning.

The implemented service is `LessonAssemblyService`.

It consumes:

- a selected LessonDefinition identifier;
- Curriculum;
- Educational Content assets.

It produces assembled lesson content for presentation.

Lesson Assembly does not decide what should be taught next.

---

## LessonPlayerStep

LessonPlayerStep is a runtime step produced from assembled lesson content.

It gives the Lesson Session Engine stable ordered step identities for one
launched lesson.

It is not Educational Content.

It is not Curriculum.

It is not durable learner progress.

---

## Lesson Session Engine

The Lesson Session Engine coordinates progression inside one launched lesson.

It consumes:

- ordered LessonPlayerStep identities;
- authored review-step references resolved before launch;
- explicit session events;
- already evaluated ActivityResult values.

It tracks in-memory session state:

- current step;
- canonical lesson step order;
- active session step order;
- completed session steps;
- latest evaluated result per step;
- attempts per step;
- authored remediation availability per step;
- whether remediation has been shown for a step;
- inserted review-step provenance;
- step mastery assessments;
- lesson mastery summary at finish;
- session status.

It determines immediate session consequences:

- retry current step;
- show authored remediation;
- insert an authored review step;
- show feedback;
- move to previous step;
- move to next step;
- allow lesson finish;
- reject an invalid action.

It does not evaluate raw answers, invent feedback, choose lessons, record
durable learner progress or query learner history in the current phase.

---

## LessonPlayer

LessonPlayer presents assembled lesson content.

It renders the current LessonPlayerStep, owns transient UI state and delegates
interactive activities to the activity layer.

It does not plan lessons, own Educational Content, evaluate answer correctness
or independently reproduce Session Engine progression policy.

---

## ActivityEngine

ActivityEngine evaluates supported interactive activity templates.

Current supported activity types are implementation-defined and validator-controlled.

The ActivityEngine checks learner responses and returns deterministic results.

It does not plan lessons, modify Educational Content or decide whether the
session should retry, continue or finish.

---

## Answer Evaluation and Session Consequence

Answer evaluation interprets learner responses.

The current implementation includes deterministic activity results, typed-answer
evaluation, accepted-with-feedback outcomes and authored misconception feedback
where supported.

The Session Engine consumes evaluated results and decides the immediate session
consequence.

Correctness, completion and mastery are distinct.

- Correctness describes one submitted answer.
- Completion describes whether the learner may continue past the current step.
- Mastery describes the quality of evidence for the current session.

Current session policy:

- correct results complete the step and permit progression;
- accepted-with-feedback results complete the step and permit progression while
  preserving the correction result;
- the first incorrect result keeps the step incomplete and requires retry;
- repeated incorrect results show authored remediation when the current step
  declares remediation availability;
- a later repeated incorrect result may insert one authored review step when
  the current step declares an authored review reference;
- repeated incorrect results without remediation availability require retry;
- informational steps may continue without a submission;
- finish is allowed only at the final eligible step.

Current session mastery policy:

- no evaluated submission is `notAssessed`;
- first-attempt correct evidence is `mastered`;
- accepted-with-feedback evidence is `fragile`;
- incorrect-only evidence is `notMastered`;
- incorrect followed by correct is complete but `fragile`;
- remediation followed by correct is complete but `fragile`;
- inserted review followed by correct on the originating step is complete but
  `fragile`;
- a later correct resubmission of the same fragile step confirms mastery;
- a latest incorrect resubmission makes completion false and mastery
  `notMastered`.

The confirmation policy is revisit-and-resubmit within the active session.

The engine does not force an extra confirmation activity in this phase.

Attempt tracking is in-memory session state:

- every evaluated submission increments the attempt count;
- showing remediation does not increment attempts;
- informational navigation does not increment attempts;
- previous and next navigation do not increment attempts;
- attempts remain attached to stable step IDs;
- remediation visibility remains attached to stable step IDs;
- inserted review state remains isolated from the originating step;
- resubmission is allowed;
- resubmission replaces the latest stored result;
- completion eligibility follows the latest result.

A previously completed step may become incomplete if its latest resubmission is
incorrect.

Mastery is owned by the canonical checkable step.

Inserted review steps may have local completion and mastery evidence, but they
do not replace mastery of the originating step.

Lesson mastery summaries count canonical checkable steps only.

Informational steps are not treated as mastered merely because the learner
pressed Next.

Lesson outcome is a deterministic lesson-level result derived from the current
session state and `LessonMasterySummary`.

Current lesson outcome policy:

- an unfinished lesson is `incomplete`;
- a completed lesson with no assessable steps is
  `completedWithReinforcement`;
- a completed lesson with any fragile, not-mastered or unassessed canonical
  checkable step is `completedWithReinforcement`;
- a completed lesson where all canonical assessed checkable steps are mastered
  is `mastered`.

After a lesson is successfully finished, the application layer persists the
lesson outcome as part of an immutable completed lesson attempt.

Durable attempt evidence preserves:

- the lesson outcome;
- the lesson mastery summary;
- canonical checkable step mastery status and reason codes;
- attempt counts and accepted submission counts;
- remediation and inserted-review provenance;
- the learning policy version used for the decision.

Durable attempts are historical evidence from completed lesson sessions.

They do not prove long-term acquisition and do not by themselves schedule
future review.

The Lesson Planner does not consume durable outcomes yet.

Legacy lesson completions that predate durable attempts remain completed, but
their detailed outcome is unavailable.

The Session Engine does not generate remediation content.

It only decides whether authored remediation associated with the current runtime
step should be shown.

Authored remediation may explain a known misconception, show a focused reminder
or point back to a previously authored explanation, but it must not introduce
unrelated material.

The Session Engine may temporarily expand the active session order with an
inserted authored review step.

Inserted review steps exist only in the active session.

They do not change curriculum, LessonDefinitions or authored lesson order.

Completing an inserted review step returns the learner to the originating step
and does not complete the originating exercise.

Advanced mastery estimation, spaced repetition, adaptive retry scheduling,
optional review lessons and long-term review scheduling remain future work.

Session mastery is evidence from the current lesson session only.

Completed-session mastery evidence may be persisted as a historical lesson
attempt, but it is not durable proof of long-term acquisition.

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

Learner State represents current learner position.

Learner History records observed progress and activity events.

LearnerHistorySummary projects history into the compact input used by the current planner.

Review Queue determines educational priorities when implemented.

Rule-Based Lesson Planner selects the next LessonDefinition.

LessonPlan records the deterministic decision and reason codes.

LessonAssemblyService resolves LessonDefinition references into assembled lesson content.

LessonPlayerStep represents one ordered runtime session step.

Lesson Session Engine determines in-session consequences from explicit events
and evaluated results.

LessonPlayer presents assembled content.

ActivityEngine checks interactive activity answers.

Answer Evaluation determines answer quality.

Application services record durable progress after the Session Engine returns a
finish decision.

Learner State Update records educational progress.

Each concept has exactly one educational responsibility.

---

# Generation 1 Simplification

Generation 1 intentionally limits educational complexity.

Included:

- one Spanish Language Pack;
- static educational content;
- simple curriculum;
- deterministic rule-based lesson planning;
- LessonPlan output;
- LessonAssemblyService content resolution;
- LessonPlayerStep flattening;
- deterministic in-memory Lesson Session Engine;
- LessonPlayer presentation;
- ActivityEngine evaluation for supported activity templates;
- deterministic evaluation;
- basic learner state and progress event tracking.

Postponed:

- knowledge graph;
- advanced motivation model;
- advanced evidence model;
- adaptive review scheduler;
- durable mastery model;
- spaced repetition;
- durable session persistence;
- durable attempt history;
- adaptive retry scheduling;
- dynamic content-level planning;
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
