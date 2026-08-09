# AUTHORING_STYLE_GUIDE.md

Status: DERIVED
Scope: learner-facing authoring style
Canonical owner: EDUCATIONAL_LANGUAGE_STANDARD.md

Version: 2.3

Related documents:

- EDUCATIONAL_PRINCIPLES.md
- EDUCATIONAL_LANGUAGE_STANDARD.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- CONTENT_REVIEW_PROTOCOL.md
- CONTENT_REVIEW_CHECKLIST.md
- AUTHORING_DECISIONS.md
- CONTENT_MODEL.md
- CURRICULUM_SPEC.md
- WRITING_SYSTEM_STANDARD.md
- WRITING_UNIT_INTRODUCTION_STANDARD.md

---

# Purpose

This document defines the learner-facing writing style for Tutor Language educational material.

It owns:

- pedagogical writing style;
- learner-facing tone;
- explanation clarity;
- cognitive load in examples and explanations;
- vocabulary presentation style;
- grammar explanation style;
- dialogue naturalness;
- consistency of the learner experience.

It does not define JSON structure, Educational Content schemas, curriculum topology, LessonDefinition structure, validation rules or publication review steps.

For Educational Content authoring rules, use CONTENT_AUTHORING_GUIDE.md.

For Course, Module and LessonDefinition sequencing, use COURSE_AUTHORING_GUIDE.md.

For publication readiness checks, use CONTENT_REVIEW_CHECKLIST.md.

For the mandatory educational-language quality bar, use
EDUCATIONAL_LANGUAGE_STANDARD.md.

For the mandatory editorial review workflow, use CONTENT_REVIEW_PROTOCOL.md.

For pronunciation respelling, IPA, localized learner hints and reading-rule
explanations, use PRONUNCIATION_AUTHORING_GUIDE.md. The reusable pronunciation
knowledge model is PRONUNCIATION_MODEL.md. Learner-facing pronunciation hints
must sound natural for the learner's support language and must not assume
English spelling conventions outside English support mode.

ReadingRule cards must follow the Learner Presentation Standard in
PRONUNCIATION_AUTHORING_GUIDE.md: symbol, name, support-language pronunciation,
real examples, then optional IPA. Do not place authoring, validator,
localization or writing-system discussion in a pronunciation card unless that
discussion is the explicit lesson objective.

Educational information priority is mandatory: the first explanation must help
the learner perform the nearest learning action immediately. Scientific or
technical precision may follow only after the learner-facing explanation is
clear.

Zero linguistic prerequisites are mandatory for pronunciation content. Do not
assume the learner knows IPA, phonetics, articulation terminology or
writing-system terminology. Every new term shown to the learner increases
cognitive load and must have immediate educational value.

For visually confusable graphemes, use GRAPHEME_PRESENTATION_STANDARD.md.
Beginner explanations must name the letters and show decomposition instead of
expecting the learner to distinguish glyphs from the font alone.

For new written symbols in any script, use WRITING_SYSTEM_STANDARD.md. The
learner-facing explanation must show how the symbol looks, what it is called
and how it sounds before asking the learner to use it.

Use WRITING_UNIT_INTRODUCTION_STANDARD.md to keep symbol, conventional name,
name pronunciation, reading and pronunciation distinct. Avoid phrasing such as
`h is pronounced hache`; write that Spanish `h` is called `hache`, and that
the letter is silent in most modern Spanish words.

---

# Core Style Principle

Every authored educational asset should make communication easier.

The learner should feel that each lesson gives them one clear, usable improvement in real-world language ability.

Prefer clarity over completeness.

Prefer useful examples over abstract explanation.

Prefer a small successful step over a large impressive one.

---

# Learner-Facing Tone

The tone should be:

- clear;
- calm;
- encouraging;
- direct;
- respectful;
- practical.

Avoid:

- academic density;
- exaggerated enthusiasm;
- jokes that distract from learning;
- condescension;
- unexplained terminology.

The learner should feel guided, not tested by the writing itself.

---

# Clarity

Write short explanations.

Use plain language before technical terminology.

Introduce terminology only when it helps the learner understand or reuse a pattern.

If a sentence explains more than one idea, split it.

If an example requires a second explanation before it makes sense, simplify the example.

---

# Cognitive Load

Increase difficulty one dimension at a time.

Avoid simultaneously increasing:

- vocabulary quantity;
- grammar complexity;
- sentence length;
- task complexity;
- cultural or contextual assumptions.

Beginner content should feel controlled and predictable.

Challenge should come from the target learning objective, not from surrounding noise.

---

# Vocabulary Style

Vocabulary presentation should be concrete, useful and reusable.

Prefer high-frequency words and expressions.

Prefer vocabulary that can quickly appear in sentences, dialogues, readings and exercises.

When possible, show vocabulary in a natural short example rather than only as an isolated item.

Avoid:

- archaic language;
- literary vocabulary;
- slang unless explicitly targeted;
- regionalisms unless the course targets that region;
- vocabulary chosen only because it is amusing.

Reusable vocabulary modelling rules belong in CONTENT_AUTHORING_GUIDE.md and AUTHORING_DECISIONS.md.

---

# Grammar Explanation Style

Grammar should support communication.

Explain only what the learner needs right now.

For beginners:

- use examples before theory;
- keep terminology minimal;
- show the pattern in familiar words;
- avoid long exception lists;
- avoid teaching a full grammar system when one usable pattern is enough.

Grammar modelling decisions belong in CONTENT_AUTHORING_GUIDE.md and AUTHORING_DECISIONS.md.

---

# Example Style

Examples should be:

- natural;
- short;
- plausible;
- level-appropriate;
- connected to the lesson objective.

Prefer:

```text
I need coffee.
```

over:

```text
The elephant drinks orange juice.
```

unless an unusual example is required by a specific lesson goal.

Examples should not introduce unnecessary vocabulary or grammar just to make the sentence interesting.

---

# Dialogue Style

Dialogues should sound like real conversations at the learner's level.

They should have a clear communicative purpose.

Good beginner dialogues are:

- short;
- natural;
- focused on one situation;
- built mostly from known or target material;
- easy to imagine in real life.

Avoid textbook stiffness and overloaded exchanges.

Dialogue content modelling rules belong in CONTENT_AUTHORING_GUIDE.md.

---

# Reading Style

Readings should reinforce known or target material.

They should be understandable from context and should not become vocabulary dumps.

Beginner readings should be short, concrete and repetitive enough to build confidence without feeling mechanical.

Reading content modelling rules belong in CONTENT_AUTHORING_GUIDE.md.

---

# Exercise Wording Style

Exercise prompts should be unambiguous.

The learner should understand what to do before they start answering.

For multi-sentence answers, prompt wording should make order explicit:

- flexible order: "Include a greeting and introduce yourself as Marta."
- preferred order: "Greet the person and introduce yourself as Marta."
- required order: "First greet the person. Then introduce yourself as Marta."

Do not make learners guess whether sentence order is being assessed.

When a common wrong response type is predictable, prefer specific feedback over
generic failure. For example, if a prompt asks for a question and a learner may
write the answer, author a deterministic misconception whose feedback explains:

- this exercise asks for a question;
- the learner wrote an answer;
- what kind of response to try next.

Keep feedback about task intent concise and non-punitive.

Prompts should test the intended educational goal, not the learner's ability to interpret confusing instructions.

Keep instructions shorter than the task whenever practical.

Meaning-based translation and comprehension prompts should accept natural
authored equivalents unless the exact form is the learning objective.

Examples:

- `I do not understand` and `I don't understand`;
- `I am from Ukraine` and `I'm from Ukraine`;
- `He is my friend` and `He's my friend`.

If punctuation, apostrophes, contractions or a full written form are the point
of the exercise, the prompt must say so explicitly.

Reviews should require active recall, discrimination or application. Do not
display both sides of a pair and then treat the activity as completed learning.

Supported exercise-template structure and validation rules belong in CONTENT_AUTHORING_GUIDE.md.

---

# Cultural Tone

Culture should support communication.

Unless a course explicitly targets a region, prefer culturally neutral everyday situations.

Avoid political topics, stereotypes and examples that require cultural knowledge unrelated to the lesson objective.

---

# Motivation

A lesson should begin with an accessible success and end with achievable success.

The writing should reinforce learner confidence.

Avoid implying that one lesson creates permanent mastery.

Long-term retention, mastery models and adaptive review belong to the Learning Model and future learner-state work, not to style guidance.

---

# Consistency

Use similar wording for similar tasks.

Do not rename the same educational idea casually across assets.

Keep tone and difficulty consistent within a lesson.

When a lesson changes mode, such as moving from vocabulary to dialogue, make the transition feel natural.

---

# AI-Assisted Authoring Style

AI may assist with drafting examples, explanations or alternatives.

AI-assisted text must still follow this guide and the project architecture documents.

AI output should be reviewed for:

- naturalness;
- correctness;
- CEFR fit;
- originality;
- reusable wording;
- unsupported assumptions.

Do not present AI-generated suggestions as accepted content until they pass the same authoring and review process as human-written material.

---

# Golden Questions

Every authored educational asset should answer:

1. What does the learner gain?
2. Why is this appropriate now?
3. Is the language natural?
4. Is the difficulty controlled?
5. Does it support communication?
6. Can it be reused without lesson-specific wording?

If any answer is unclear, revise the asset or consult CONTENT_AUTHORING_GUIDE.md, COURSE_AUTHORING_GUIDE.md or CONTENT_REVIEW_CHECKLIST.md.

---

# Final Principle

The best educational style is quiet, precise and useful.

It helps the learner focus on the language instead of fighting the explanation.

---

End of document.
