# PEDAGOGICAL_SCENARIO_MODEL.md

Status: Active

Version: 1.0

Related documents:

- LESSON_AUTHORING_ENTRYPOINT.md
- LEARNING_STATE_MACHINE.md
- LEARNING_MODEL.md
- COURSE_AUTHORING_GUIDE.md
- CONTENT_AUTHORING_GUIDE.md
- AUTHORING_STYLE_GUIDE.md
- EDUCATIONAL_LANGUAGE_STANDARD.md
- CONTENT_REVIEW_PROTOCOL.md

---

# Purpose

This document defines how an author converts a measurable lesson objective into learner
state transitions and only then into activities and content assets.

Mandatory authoring order:

```text
Learner starting state
-> lesson outcome
-> state-transition scenario
-> learner actions
-> support plan
-> assessment plan
-> content mapping
-> JSON/assets
```

Starting from existing JSON, content categories, or a preferred activity stack is
prohibited.

This document is authoritative for lesson construction. `LEARNING_STATE_MACHINE.md` is
authoritative for learner states and transitions.

---

# Lesson-Level Contract

Every lesson must define the following before any content object is authored.

## 1. Starting capability

State what the learner can already do before the lesson.

Good:

- The learner has not yet encountered `hola`.
- The learner can already read and type `hola`.
- The learner can recognize `adios` but cannot choose an appropriate goodbye in context.

Bad:

- Beginner lesson.
- Greetings topic.
- Module 1 content.

## 2. Single measurable outcome

State what the learner can independently do after the lesson.

Good:

- The learner can read, understand, and type `hola`.
- The learner can choose and use one appropriate goodbye phrase.

Bad:

- Learn greetings.
- Study Spanish names.
- Understand polite phrases.
- Practice pronunciation.

## 3. New material budget

Define the genuinely new units required for the outcome.

Use the strictest beginner-scale budget that allows the outcome. Do not add units
because they fit a topic.

Reject overload such as introducing `n`, `j`, `ll`, `Espana`, `Jose`, `Javier`, and
`me llamo` in one beginner lesson unless a documented prerequisite chain already makes
most of those units known.

## 4. Scenario progression

Every lesson must move through a pedagogical progression such as:

```text
purpose
-> supported encounter
-> comprehension
-> guided manipulation
-> independent recall
-> meaningful use
-> concise closure
```

This is not a mandatory UI template. Authors may vary activity form, but they must not
skip necessary learner-state transitions.

## 5. Evidence of completion

Define the observable evidence that proves the learner reached the outcome.

Evidence must be stronger than passive exposure or recognition unless the outcome is
explicitly recognition-only.

---

# Scenario Step Contract

Every lesson step must use this compact contract:

```text
Current learner state:
Target learner state:
Learner action:
Visible support:
Why this step exists:
Success evidence:
Failure response:
Content/runtime mapping:
```

Every field is mandatory.

A step without a clear state transition or success evidence must be removed.

---

# Interest And Variety

Interest is not decoration. A lesson is interesting when the learner:

- understands why the material matters;
- performs changing mental actions;
- sees language used in a plausible situation;
- experiences visible progress;
- is not forced through redundant screens.

Require variation across lessons in:

- opening situation;
- task type;
- interaction pattern;
- context;
- retrieval demand.

Do not require every lesson to contain identical sections.

Do not use the same sequence merely because the data model supports it.

---

# Meaningful Context

A meaningful example:

- uses known material plus the current target;
- resembles real communication;
- can be understood immediately;
- prepares the next learner action.

Reject artificial strings such as:

```text
hola. hambre. hola. adios. hola.
```

Reject examples inserted solely to demonstrate a letter when they introduce irrelevant
vocabulary.

---

# Translation And Pronunciation

Use existing language, pronunciation, and localization standards. The scenario model
only clarifies when those supports appear.

Rules:

- Use the closest natural support-language equivalent.
- Do not replace simple translation with abstract usage commentary.
- Provide localized pronunciation support before asking the learner to read unfamiliar
  target-language material.
- Do not require pronunciation support in every later prompt.
- Withhold pronunciation support when it would leak the tested answer.
- Use letter names when the lesson teaches the alphabet or a reading rule.
- Explain unfamiliar sounds through the learner's language before optional IPA.
- Do not expose author, validator, localization, or implementation language.

Learner-facing blockers include:

- `написання зберігається без перекладу`
- `вимовляйте іспанську форму`
- `ключова форма`
- `канонічна форма`

These are content-review blockers under existing learner-language standards.

---

# Assessment Design

Every lesson must distinguish teaching, guided practice, and assessment.

Teaching:
May show the answer. Its purpose is to create first understanding or supported reading.

Guided practice:
May provide partial support. Its purpose is to move from recognition toward recall.

Independent assessment:
Must not reveal the answer. Its purpose is to prove the target learner state.

An independent assessment must not reveal the answer through:

- target-language transcription;
- partial spelling;
- identical previous prompt;
- model answer;
- answer-shaped hints;
- options that make recall unnecessary when recall is being assessed.

Every exercise must identify the learner state it assesses.

Reject exercises whose only purpose is to fill a lesson step count.

---

# Lesson Closure

The final step confirms the acquired capability. It must not repeat the first teaching
card as if nothing changed.

Good:

```text
Тепер ви можете прочитати й написати hola.
```

Keep closure brief and tied to the measurable outcome.

---

# Content And Runtime Mapping

Only after the scenario is approved may the author map steps to existing Tutor Language
mechanisms.

Allowed mapping targets include:

- Lesson metadata for objective, summary, and structural order.
- Existing educational content assets for target forms, meanings, examples, and
  explanations.
- Pronunciation and reading-rule assets for supported decoding.
- Exercise templates for recognition, guided recall, independent recall, and controlled
  application.
- Runtime answer evaluation for correct, accepted-with-feedback, incorrect, retry, and
  authored remediation.

Mapping must not change the pedagogical scenario. If the current implementation cannot
represent a necessary step, mark the gap instead of weakening the lesson.

---

# Scenario A: First Spanish Lesson

Outcome:
The learner independently reads, understands, and types `hola`.

Starting state:
The learner has not encountered `hola` and cannot be assumed to read Spanish.

New material budget:
One target word: `hola`. One reading fact: in this word, initial `h` is not pronounced.

## Step A1

Current learner state:
Not introduced.

Target learner state:
Attends to the new unit.

Learner action:
Notice `hola` as the first useful Spanish word.

Visible support:
Target form, support-language motivation, pronunciation support, natural translation.

Why this step exists:
The learner needs a reason and a first safe encounter before any task.

Success evidence:
The learner can continue knowing this screen is about `hola`.

Failure response:
Reduce to the target form, pronunciation, and meaning.

Content/runtime mapping:
Lesson introduction plus localized educational support.

## Step A2

Current learner state:
Attends to the new unit.

Target learner state:
Understands its meaning.

Learner action:
Connect `hola` to the closest natural support-language equivalent.

Visible support:
`hola`, pronunciation support, translation.

Why this step exists:
Meaning must be established before recognition or recall.

Success evidence:
The learner selects the correct meaning among plausible alternatives.

Failure response:
Return to direct form-meaning pairing.

Content/runtime mapping:
Meaning recognition exercise.

## Step A3

Current learner state:
Understands its meaning.

Target learner state:
Can read or decode it with support.

Learner action:
Read `hola` using localized pronunciation support.

Visible support:
Target form and pronunciation support. A short note may explain that the written `h`
does not sound in this word.

Why this step exists:
The learner must not be forced to decode unfamiliar Spanish spelling unsupported.

Success evidence:
The learner matches `hola` to its supported reading.

Failure response:
Restore the simplest reading support.

Content/runtime mapping:
Reading-rule or pronunciation support presentation.

## Step A4

Current learner state:
Can read or decode it with support.

Target learner state:
Recognizes it in a changed context.

Learner action:
Recognize `hola` in a tiny greeting context such as greeting a named person, using only
known or transparent material.

Visible support:
Context and non-leaking support. Translation may remain if meaning, not recall, is
being checked.

Why this step exists:
The learner must see the word functioning beyond the first card.

Success evidence:
Correct recognition in a changed context.

Failure response:
Return to supported meaning or supported reading, depending on error.

Content/runtime mapping:
Short example plus recognition exercise.

## Step A5

Current learner state:
Recognizes it in a changed context.

Target learner state:
Recalls it with support.

Learner action:
Produce `hola` from a support-language cue with partial support that does not reveal
the whole answer.

Visible support:
Support-language cue. No full model answer.

Why this step exists:
The lesson must move beyond recognition.

Success evidence:
The learner completes or types the target with partial support.

Failure response:
Return to changed-context recognition, then retry with a weaker cue.

Content/runtime mapping:
Guided recall exercise.

## Step A6

Current learner state:
Recalls it with support.

Target learner state:
Recalls it independently.

Learner action:
Type `hola` from a support-language prompt with no visible target answer or
answer-shaped pronunciation support.

Visible support:
Task instruction and support-language meaning only.

Why this step exists:
The measurable outcome requires independent typing.

Success evidence:
Correct typed answer, or accepted-with-feedback for an authored minor spelling issue.

Failure response:
Meaning failure returns to meaning pairing. Spelling failure with correct sound uses
accepted-with-feedback when authored, then retry.

Content/runtime mapping:
Typed recall exercise and answer evaluation.

## Step A7

Current learner state:
Recalls it independently.

Target learner state:
Uses it in a meaningful context.

Learner action:
Use `hola` as a greeting in a tiny communicative situation.

Visible support:
Situation only. No answer leakage.

Why this step exists:
The word should become usable language, not a memorized entry.

Success evidence:
The learner chooses or types `hola` appropriately as a greeting.

Failure response:
Return to a simpler modeled greeting.

Content/runtime mapping:
Controlled application exercise.

## Step A8

Current learner state:
Uses it in a meaningful context.

Target learner state:
Uses it in a meaningful context.

Learner action:
Read a brief closure confirming the acquired capability.

Visible support:
Short support-language summary.

Why this step exists:
The learner should see visible progress.

Success evidence:
Lesson completion after prior assessment success.

Failure response:
No remediation; closure is not assessment.

Content/runtime mapping:
Lesson summary.

Support fading:
Full support appears in A1-A3. Translation or pronunciation can remain during meaning
and supported reading. A5 removes the full answer. A6 removes pronunciation and target
form support because independent recall is assessed.

Assessment:
A6 is the independent recall assessment. A7 checks meaningful use if supported by the
current lesson scope.

Remediation:
Failures return to the failed state only: meaning, reading, spelling, recall, or context.

Why it is not dictionary-like:
The lesson teaches one action through changing learner states. It does not present a
word list, repeat the same operation, or add unrelated examples.

---

# Scenario B: Later Beginner Lesson With A Different Skill

Outcome:
The learner can choose and type one appropriate goodbye phrase in a simple leaving
situation.

Starting state:
The learner can already read, understand, and type `hola`. The learner has not yet
learned to end a simple exchange.

New material budget:
One goodbye phrase, unless the curriculum has already introduced another. The scenario
must not add several farewell variants merely to complete a category.

## Step B1

Current learner state:
Not introduced for the goodbye phrase.

Target learner state:
Attends to the new unit.

Learner action:
Notice that the situation has changed from meeting someone to leaving.

Visible support:
Short support-language situation and target phrase with pronunciation and translation.

Why this step exists:
The lesson opens with communicative need, not a category label.

Success evidence:
The learner understands that this phrase is for leaving.

Failure response:
Simplify the situation and show one phrase only.

Content/runtime mapping:
Lesson introduction plus localized support.

## Step B2

Current learner state:
Attends to the new unit.

Target learner state:
Understands its meaning.

Learner action:
Match the goodbye phrase to its natural support-language equivalent.

Visible support:
Target phrase, pronunciation support, translation.

Why this step exists:
Meaning must be secure before use.

Success evidence:
Correct meaning recognition among plausible alternatives.

Failure response:
Return to direct phrase-meaning pairing.

Content/runtime mapping:
Recognition exercise.

## Step B3

Current learner state:
Understands its meaning.

Target learner state:
Recognizes it in a changed context.

Learner action:
Choose whether a tiny situation needs `hola` or the goodbye phrase.

Visible support:
Known `hola`, new goodbye phrase, short situation.

Why this step exists:
The lesson contrasts two communicative functions instead of repeating a word card.

Success evidence:
Correct choice in the leaving situation.

Failure response:
Return to the two situations: meeting versus leaving.

Content/runtime mapping:
Contextual recognition or matching exercise.

## Step B4

Current learner state:
Recognizes it in a changed context.

Target learner state:
Recalls it with support.

Learner action:
Complete the goodbye phrase with partial support.

Visible support:
Support-language cue and partial target form if it does not reveal the whole answer.

Why this step exists:
The learner moves from choosing to producing.

Success evidence:
Correct guided production.

Failure response:
Return to contextual recognition, then retry with reduced support.

Content/runtime mapping:
Guided recall exercise.

## Step B5

Current learner state:
Recalls it with support.

Target learner state:
Recalls it independently.

Learner action:
Type the goodbye phrase from a leaving prompt.

Visible support:
Situation and support-language prompt only.

Why this step exists:
The outcome requires independent production.

Success evidence:
Correct typed answer or authored accepted-with-feedback result.

Failure response:
Target spelling, meaning, or context failure using the remediation map.

Content/runtime mapping:
Typed recall exercise.

## Step B6

Current learner state:
Recalls it independently.

Target learner state:
Uses it in a meaningful context.

Learner action:
Finish a tiny exchange that begins with known greeting material and ends with the
goodbye phrase.

Visible support:
Known surrounding context. No answer leakage for the goodbye.

Why this step exists:
The learner applies the phrase to a different communicative moment than Lesson A.

Success evidence:
Appropriate phrase chosen or typed for leaving.

Failure response:
Return to the meeting/leaving contrast.

Content/runtime mapping:
Controlled application exercise.

## Step B7

Current learner state:
Uses it in a meaningful context.

Target learner state:
Retains prior material after interference or delay.

Learner action:
Recognize or use `hola` again after learning the goodbye phrase.

Visible support:
Situation only, if `hola` is mastered.

Why this step exists:
The lesson introduces interference between greeting and goodbye.

Success evidence:
Correctly distinguishes greeting from goodbye after both appear.

Failure response:
Return to the simpler contrast.

Content/runtime mapping:
Mixed review or short contextual check.

Support fading:
The new phrase receives full support first. Known `hola` may appear without
pronunciation if independent reading is intentionally checked. The final task removes
support for the assessed goodbye.

Assessment:
B5 assesses independent recall of the new phrase. B6 assesses contextual use. B7 checks
retention/interference for prior material.

Remediation:
Meaning failures return to phrase-meaning pairing. Context failures return to the
meeting/leaving contrast. Spelling failures use authored accepted-with-feedback when
available.

Why it is not dictionary-like or repetitive:
This scenario does not reuse Scenario A's exact rhythm. It begins from a different
communicative need, contrasts two situations, uses prior knowledge as interference, and
requires a different mental action: choosing the appropriate phrase for leaving.

---

# Documentation Sufficiency Check

If a proposed lesson scenario collapses into:

```text
Vocabulary -> Reading -> Practice
```

then the scenario is not yet valid. Rewrite the learner-state transitions before
mapping to content assets.

If a necessary step cannot be mapped to current runtime/content mechanisms, keep the
scenario intact and record an implementation or documentation gap. Do not weaken the
lesson objective to match a convenient content category.
