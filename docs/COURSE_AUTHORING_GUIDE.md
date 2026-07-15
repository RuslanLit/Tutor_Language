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

Course, module and lesson titles are authored educational metadata. Their
support-language localization is defined in
EDUCATIONAL_CONTENT_LOCALIZATION.md and must not be moved into application UI
ARB files.

Pronunciation is reusable educational knowledge. The conceptual model is
PRONUNCIATION_MODEL.md. Pronunciation variety, IPA policy, learner-hint policy,
regional variant policy and audio policy are defined in
PRONUNCIATION_AUTHORING_GUIDE.md. Every future target-language course that
teaches pronunciation must declare these policies.

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
- pronunciation variety, IPA policy, learner-hint policy, regional variant
  policy and audio policy when pronunciation is part of the course.
- how course vocabulary, reading rules, lessons and exercises reference
  reusable PronunciationUnit knowledge.

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

LessonDefinitions organize authored content for later assembly and session
execution.

At runtime, assembled content is flattened into ordered `LessonPlayerStep`
objects. A single checkable exercise template becomes one runtime step.

Course authors should keep LessonDefinition activities coherent and avoid
bundling unrelated checkable tasks into one exercise template.

The Lesson Session Engine coordinates retry, previous, next and finish
eligibility, but it does not generate prompts, explanations, answer keys or
new teaching content.

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

# Communicative Lesson Design

Every lesson should teach one measurable communicative capability.

Good lesson objectives describe what the learner can do:

- greet someone;
- ask a name;
- state origin;
- request help;
- answer a simple question;
- understand a tiny profile.

Grammar supports communication.

Do not introduce grammar solely because it is convenient to explain.

Introduce a grammar pattern when the learner needs it to perform the lesson's communicative task.

Vocabulary should appear in realistic situations.

Do not introduce vocabulary only as an isolated list.

New vocabulary should later reappear in at least one communicative context such as:

- dialogue;
- reading;
- typed recall;
- controlled application;
- review;
- checkpoint.

Reading, dialogue, recall and application activities in a lesson should support the same learner goal.

Avoid isolated grammar demonstrations that cannot be used in a realistic exchange.

Avoid vocabulary that is not reused communicatively later in the course.

Important patterns should reappear across multiple activity modes:

- recognition;
- guided recall;
- free recall;
- dialogue;
- reading;
- review;
- checkpoint.

Do not introduce language just because it completes a grammar table or expands a word category.

Introduce it because the learner now needs it.

---

# Communicative Competency Checks

A module may end with a communicative competency check.

The check should assess whether the learner can perform the module's promised
real-life communication task independently.

Authors should declare:

- the module-level communicative competency;
- a stable definition fingerprint or authored version;
- the diagnostic tasks used to assess it;
- the micro-competencies assessed by each task;
- prerequisite content references;
- authored recovery step references;
- the retry task after recovery;
- finite retry policy;
- whether a task is central/integrated;
- any final integrated task.

Each diagnostic task should assess one explicit micro-competency unless it is
intentionally marked as an integrated task.

Recovery mappings must be authored.

Do not rely on the runtime to infer missing knowledge from answer text.

Multi-component diagnostics must state whether order is required. If the task
only checks that several communicative components are present, authors may
provide bounded accepted-with-feedback alternatives for less natural but valid
orders. Those alternatives should count as task success and must not create a
competency gap.

If the sequence is itself the skill, such as a dialogue exchange or a
question-answer sequence, the prompt must say that the answer should be written
in that order.

Recovery should target the smallest meaningful missing communicative
capability, not an isolated word.

Valid recovery targets include:

- a name-introduction pattern;
- an origin statement pattern;
- a question form;
- a short profile-building pattern;
- a dialogue move previously taught in the same or an earlier module.

Recovery may reference earlier modules.

For example, a Module 3 personal-profile check may recover a Module 2
introduction pattern before retrying the Module 3 diagnostic task.

Recovery must not introduce unrelated language.

The retry must remain a genuine recall or application attempt. Do not show the
full answer immediately before the retry.

Small Module 3 example:

```text
Competency:
competency.es.a0.m03.describe_basic_personal_identity

Diagnostic tasks:
- task.es.a0.introduce_self
- task.es.a0.state_origin
- task.es.a0.state_residence
- task.es.a0.state_languages
- task.es.a0.ask_origin_and_languages
- task.es.a0.build_personal_identity_profile

Recovery:
micro.es.a0.introduce_self failure
    -> template.es.a0.m02.l004.name_pattern_choice.v1
    -> retry task.es.a0.introduce_self

micro.es.a0.state_origin failure
    -> template.es.a0.m03.l013.origin_choice.v1
    -> retry task.es.a0.state_origin
```

Small Module 4 example:

```text
Competency:
competency.es.a0.m04.describe_person_and_hold_basic_conversation

Diagnostic tasks:
- task.es.a0.m04.identify_person
- task.es.a0.m04.state_person_role
- task.es.a0.m04.describe_person_basic
- task.es.a0.m04.state_person_facts
- task.es.a0.m04.ask_about_person
- task.es.a0.m04.everyday_exchange

Recovery:
micro.es.a0.state_person_residence failure
    -> template.es.a0.m03.l015.residence_choice.v1
    -> retry task.es.a0.m04.state_person_facts

micro.es.a0.describe_person_basic failure
    -> template.es.a0.m04.l022.description_question_choice.v1
    -> retry task.es.a0.m04.describe_person_basic
```

Competency outcomes are distinct from lesson completion.

A module can be content-complete while its communicative competency remains
partially achieved or not yet achieved.

Executable step references must resolve before the competency check is offered
to the learner.

Malformed competency definitions should fail validation before launch.

When a competency check is implemented in the runtime, it should appear in the
normal course flow only after the module's authored content is complete. The
learner should be able to start a new check, continue an active attempt or retry
after a partial or unsuccessful outcome without changing lesson completion
history.

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
