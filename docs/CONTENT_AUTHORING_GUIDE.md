# CONTENT_AUTHORING_GUIDE.md

Status: Living Document

Version: 1.0

Related documents:

- EDUCATIONAL_PRINCIPLES.md
- AUTHORING_STYLE_GUIDE.md
- CONTENT_MODEL.md
- CURRICULUM_SPEC.md
- LEARNING_MODEL.md
- PROJECT_VISION.md
- COURSE_AUTHORING_GUIDE.md
- CONTENT_REVIEW_CHECKLIST.md

---

# Purpose

This document defines how Educational Content should be authored for Tutor Language.

It owns Educational Content object responsibilities, supported content types, required fields, references, validation expectations and compatibility with deterministic lesson planning and assembly.

It does not define learner-facing writing style, Course sequencing, Module structure or publication approval.

For learner-facing tone, explanation style and example naturalness, use AUTHORING_STYLE_GUIDE.md.

For Course, Module and LessonDefinition sequencing, use COURSE_AUTHORING_GUIDE.md.

For release readiness checks, use CONTENT_REVIEW_CHECKLIST.md.

---

# Supported Content Types

Generation 1 Educational Content uses these supported content types:

- Vocabulary Item
- Grammar Topic
- Dialogue
- Reading Text
- Exercise Template

Do not introduce new Educational Content types without an architectural decision.

---

# Supported Fields

Vocabulary Items currently support:

- id
- spanish
- native_translation
- cefr
- example
- pronunciation
- notes

Grammar Topics currently support:

- id
- title
- explanation
- examples
- prerequisite_ids

Dialogues currently support:

- id
- title
- vocabulary_ids
- grammar_ids
- lines

Dialogue lines currently support:

- speaker
- spanish
- native_translation

Reading Texts currently support:

- id
- title
- vocabulary_ids
- grammar_ids
- text
- native_translation

Exercise Templates currently support:

- id
- exercise_type
- supported_goal_types
- required_object_types
- prompt_template
- answer_options
- correct_option_id
- expected_answer
- accepted_answers
- requires_exact_answer
- authored_misconceptions
- review_template_ids

Unsupported fields should not be added to content assets.

---

# References

Educational Content should reference other Educational Content by stable identifiers where the current schema supports references.

Dialogues and Reading Texts may reference Vocabulary Items and Grammar Topics.

Grammar Topics may reference prerequisite Grammar Topics.

LessonDefinition references are authored in curriculum files, not inside reusable Educational Content objects.

---

# Fundamental Principle

Educational Content exists to teach.

Every knowledge object should have one clear educational purpose.

Educational content should maximize learning efficiency while minimizing unnecessary cognitive load.

---

# General Principles

Educational content should be:

- accurate;
- concise;
- reusable;
- deterministic;
- language-appropriate;
- beginner-friendly;
- internally consistent.

Content should teach one concept at a time whenever practical.

Large conceptual jumps should be avoided.

---

# Exercise Answer Authoring

Typed and fill-gap exercises should define one canonical expected answer.

When the task checks meaning rather than an exact written form, authors should
include natural deterministic variants in `accepted_answers` when the variant
is not already covered by the controlled support normalizer.

The implementation supports a narrow, deterministic support normalizer for:

- common English full-form/contraction pairs such as `I am` / `I'm`,
  `do not` / `don't`, `he is` / `he's`;
- weak punctuation that is not usually pedagogically meaningful in short
  support-language answers or fixed phrases, such as commas and terminal
  periods.

The normalizer does not provide unrestricted paraphrase acceptance.

It does not erase Spanish accents or Spanish question punctuation. Those remain
available for orthographic feedback.

Use `requires_exact_answer` only when the exercise explicitly tests the exact
form, such as a contraction, apostrophe, comma, question mark or full written
form.

Review and checkpoint tasks must require learner action. A review task may use
typed recall, fill gaps, multiple choice or real checkable matching, but it
must not show both the prompt and answer as passive display content and then
mark success without retrieval.

---

# Cognitive Load

Every lesson should respect the learner's limited cognitive capacity.

Lesson difficulty should increase gradually.

Educational density is intentionally limited.

Generation 1 prioritizes retention over speed.

---

# Introducing Vocabulary

New vocabulary should be introduced before it is required.

Vocabulary should be presented in meaningful context whenever practical.

Words should not be introduced solely through isolated lists.

Each vocabulary item should include:

- target-language form;
- learner-language meaning;
- pronunciation;
- at least one natural example.

Example sentences should use previously introduced grammar whenever practical.

---

# Vocabulary Limits

Generation 1 recommendations:

- 5–10 new words per beginner lesson;
- preferably 6–8 for A0 learners.

Review vocabulary does not count toward this limit.

Large vocabulary bursts should be avoided.

---

# Vocabulary Selection

Priority should be given to:

- high-frequency words;
- everyday communication;
- immediately useful expressions.

Avoid introducing:

- rare words;
- literary vocabulary;
- specialized terminology;
- culturally obscure expressions.

Generation 1 focuses on practical communication.

---

# Grammar

Grammar should explain one concept at a time.

Grammar explanations should remain concise.

Every grammar topic should include:

- explanation;
- examples;
- common usage.

Complex terminology should be avoided whenever simpler explanations are sufficient.

---

# Grammar Progression

Grammar should move from:

```text
simple
    ↓
compound
    ↓
complex
```

Every new grammar concept should build upon previously introduced concepts.

Prerequisites should always be respected.

---

# Dialogues

Dialogues demonstrate real communication.

Dialogues should sound natural.

Dialogues should reinforce lesson vocabulary and grammar.

Dialogues should avoid unnecessary complexity.

Generation 1 beginner dialogues should usually contain:

- 2–10 conversational exchanges;
- one communicative situation;
- limited unknown vocabulary.

---

# Reading Texts

Reading reinforces previously learned material.

Reading texts should primarily contain known vocabulary.

Unknown vocabulary should remain limited.

Reading should never become a vocabulary dump.

---

# Listening

Listening material should correspond to previously introduced knowledge.

Speech should initially remain clear and moderate in speed.

Natural pronunciation is preferred over exaggerated pronunciation.

---

# Exercise Design

Exercises reinforce educational objectives.

Every exercise should have one primary learning purpose.

Exercises should measure understanding rather than guessing.

Whenever practical, exercises should focus on active recall instead of recognition.

Every exercise should require the greatest reasonable degree of independent
knowledge retrieval appropriate to the learner's current stage.

This does not mean every exercise must use free text.

Recognition exercises are appropriate when they:

- introduce unfamiliar material;
- help distinguish similar concepts;
- reduce cognitive load during first exposure;
- scaffold a later recall activity;
- directly match a recognition objective.

Recognition should normally be followed by stronger retrieval.

Preferred exercise progression:

```text
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
```

The author should be able to explain why an exercise stops at recognition when
it does.

---

# Multiple Choice

Multiple choice is a recognition activity.

It may support exposure, discrimination and early confidence, but it should not
usually be the sole evidence that a learner can actively use a knowledge item.

Multiple-choice distractors should be plausible.

Avoid absurd options that allow success without understanding.

Good distractors often represent:

- a common misconception;
- a similar-looking word;
- a similar meaning in the wrong context;
- a previously learned item that must be distinguished.

Multiple choice should not introduce unsupported new knowledge through its
options.

---

# Typed Production

Typed production should be preferred when active recall or controlled
application is the learning objective and the learner has enough support to
answer fairly.

Supported implementation may be narrower than the long-term learning model.

When authoring within the current schema, use only exercise types supported by
validators and ActivityEngine.

Prompts must be unambiguous.

The learner should know:

- what language to produce;
- whether one word, a phrase or a full sentence is expected;
- whether punctuation or capitalization is being assessed;
- whether a translation, completion or response is requested.

---

# Accepted Answers and Feedback

Accepted alternatives must be intentional.

A canonical answer should represent the preferred target form.

Accepted variants may be appropriate when they are genuinely equivalent for the
exercise objective.

Some answers may be acceptable with feedback when the communicative meaning is
right but a useful correction is needed.

Examples include deterministic, high-confidence differences such as:

- capitalization;
- extra whitespace;
- punctuation;
- missing inverted Spanish punctuation;
- missing or incorrect diacritic;
- likely typographical error.

Wrong words, wrong inflection, word-order errors, missing words, extra words and
semantically different answers should not be accepted unless a specific
authored rule says they satisfy the objective.

Do not manually list every spelling variant in LessonDefinitions.

Prefer reusable deterministic language rules when a difference is systematic.

Explanations must be authored, deterministic and reviewable.

Uncertain classifications should produce neutral feedback rather than a
fabricated explanation.

Exercise-specific misconceptions may be authored only when the mistake and
feedback are valid for that exact prompt objective.

For example, `Soy Ana` is valid Spanish in some contexts, but it may be an
authored misconception for an exercise whose objective is the `me llamo`
name-introduction pattern.

Authored misconceptions must not become global language rules.

The Lesson Session Engine will not generate teaching text.

When authored remediation is available for a checkable step, the Lesson Session
Engine may decide to show it after repeated incorrect attempts.

Remediation content may include:

- a concise explanation;
- a grammar reminder;
- a vocabulary hint;
- a worked example;
- a focused correction of an authored misconception.

Remediation must remain deterministic, reviewable and directly relevant to the
current exercise objective.

It must not introduce unrelated material, invent new examples at runtime or
replace the authored answer key.

Exercise templates may declare authored review references with
`review_template_ids`.

Review references must point to existing authored exercise templates.

They should be used only when the referenced template gives focused practice
for the same knowledge weakness.

The Session Engine may insert one referenced review step into the active
session after repeated incorrect attempts.

Authors must not use review references to smuggle unrelated lessons, new
objectives or generated content into a session.

Authors do not assign mastery.

Mastery is a deterministic current-session judgment made by the Lesson Session
Engine from attempts, accepted corrections, remediation and review evidence.

Content may provide focused remediation and review material, but it must not
store learner mastery, confidence, progress or long-term acquisition state.

Prompts, canonical answers, accepted alternatives, authored misconceptions and
correction guidance must be deterministic, authored and reviewable in the
content or evaluation-related structures that support them.

One checkable exercise template becomes one runtime LessonPlayerStep.

Authors should therefore keep each exercise template focused on one clear,
checkable task with one unambiguous objective.

Do not rely on the Session Engine to split an overloaded exercise, infer
missing instructions, create explanations or decide what the answer key should
mean.

---

# Exercise Variety

Generation 1 currently supports these exercise-template types:

- multiple choice;
- fill gap;
- matching;

Exercise diversity should increase gradually.

New exercise-template types require validator and ActivityEngine support before they are documented as supported.

---

# Lesson Composition

A typical beginner lesson should include:

1. introduction;
2. new vocabulary;
3. grammar;
4. guided examples;
5. dialogue or reading;
6. exercises;
7. review summary.

Not every lesson requires every activity type.

The lesson should remain coherent.

---

# Unknown Material

Educational content should avoid overwhelming learners.

Recommended principles:

- introduce new vocabulary before using it;
- avoid multiple new grammar concepts simultaneously;
- keep unknown material to the minimum necessary.

Context should aid comprehension.

---

# Repetition

Important knowledge should appear multiple times.

Typical progression:

```text
Introduction

↓

Example

↓

Dialogue

↓

Exercise

↓

Review

↓

Future lessons
```

Repetition should occur naturally rather than mechanically.

---

# Examples

Examples should:

- sound natural;
- demonstrate actual usage;
- remain concise;
- reinforce lesson objectives.

Artificial examples should be avoided whenever practical.

---

# Translations

Translations exist to support understanding.

Translations should preserve educational meaning rather than literal word order whenever appropriate.

---

# Difficulty Progression

Difficulty should increase gradually.

The curriculum should avoid sudden jumps in:

- vocabulary;
- grammar;
- reading complexity;
- dialogue length;
- exercise complexity.

---

# Content Reuse

Knowledge should be introduced once.

Future lessons should reference existing knowledge rather than duplicate it.

Educational consistency is preferred over content duplication.

---

# Writing Style Reference

Educational explanations, examples, dialogue naturalness and learner-facing tone should follow AUTHORING_STYLE_GUIDE.md.

---

# Cultural Content

Generation 1 focuses on universal communication.

Cultural notes may be included when they improve understanding.

Culture should support learning rather than distract from it.

---

# CEFR Alignment

Generation 1 targets beginner learners.

Educational content should remain compatible with:

- A0;
- early A1.

Future language packs may extend beyond this level.

---

# Deterministic Planning and Assembly

Educational content should support deterministic lesson planning and assembly.

Content should never assume:

- learner progress;
- learner memory;
- previous mistakes.

These responsibilities belong to the Learning Engine.

---

# Validation Checklist

Before release, educational content should satisfy the following questions:

- Is the educational objective clear?
- Is the vocabulary appropriate?
- Is the grammar introduced gradually?
- Is the dialogue natural?
- Is cognitive load reasonable?
- Are examples correct?
- Are references valid?
- Can this content be reused?
- Does it fit the intended CEFR level?

---

# Generation 1 Scope

Generation 1 prioritizes:

- clarity;
- simplicity;
- consistency;
- deterministic lesson planning and assembly;
- high educational quality.

Advanced pedagogy is intentionally postponed.

---

# Final Principle

Educational Content should make learning easier.

Every knowledge object should justify its existence by helping the learner progress toward real communication.

Content quality is measured not by the amount of information it contains, but by how effectively it supports long-term learning.

---

End of document.
