# EDUCATIONAL_LANGUAGE_STANDARD.md

Status: NORMATIVE
Scope: educational language quality
Authority: primary

Version: 1.2

Related documents:

- EDUCATIONAL_PRINCIPLES.md
- AUTHORING_STYLE_GUIDE.md
- CONTENT_AUTHORING_GUIDE.md
- EDUCATIONAL_CONTENT_LOCALIZATION.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- WRITING_SYSTEM_STANDARD.md
- WRITING_UNIT_INTRODUCTION_STANDARD.md
- READING_RULE_PREREQUISITE_STANDARD.md
- GRAPHEME_PRESENTATION_STANDARD.md
- CONTENT_REVIEW_PROTOCOL.md
- CONTENT_REVIEW_CHECKLIST.md

---

# Purpose

This document defines the mandatory educational language standard for Tutor
Language.

Educational language quality is a first-class architectural concern because
learner-facing text is part of the learning system. Poorly written educational
content damages learner trust, increases cognitive load, obscures the learning
objective and can make correct educational design feel unreliable.

Every learner-facing educational sentence must support learning.

This document is not a data schema, UI style guide or localization inventory.
It is a normative quality standard for educational text in every target
language and support language.

---

# Scope

This standard applies to all educational text presented to learners, including:

- vocabulary cards;
- grammar explanations;
- pronunciation explanations;
- reading passages;
- dialogues;
- lesson introductions;
- exercise prompts;
- hints;
- remediation;
- review lessons;
- competency assessments;
- checkpoint assessments;
- localized educational support text.

The standard is language-independent. It applies to Spanish, German, Polish,
English, French, Japanese and any future target language or support language.

This document must not be used to define language-specific grammar rules.

When learner-facing text introduces a reading rule or visually confusable
grapheme, it must be beginner-safe and must not expose authoring terminology
such as regional policy names unless that terminology is itself the teaching
objective. See READING_RULE_PREREQUISITE_STANDARD.md and
GRAPHEME_PRESENTATION_STANDARD.md.

ReadingRule cards must be immediate pronunciation aids. A learner must be able
to use the card to read the next course word or phrase. The card must teach the
Spanish symbol, its name, an approximate support-language pronunciation, real
examples and optional IPA in that order. Authoring, validator, localization,
implementation and writing-system safety explanations must not appear in the
card unless the current lesson explicitly teaches that contrast. See
PRONUNCIATION_AUTHORING_GUIDE.md.

Educational information priority is mandatory. When learner comprehension
conflicts with linguistic precision, learner comprehension always has priority.
The first explanation shown to a beginner must be the simplest explanation that
enables the nearest correct action; scientific terminology may follow only as
supplementary information.

Zero linguistic prerequisites are mandatory. Learner-facing text must not rely
on IPA, phonetics, articulation terminology, linguistic jargon, orthographic
theory or writing-system terminology unless those concepts are themselves the
lesson objective.

When learner-facing text introduces a new written symbol, the learner must
know how the symbol looks, what it is called or designated, how that name is
pronounced where applicable, how the unit is read in meaningful language, and
how it sounds in the taught context before being asked to read, type, recall or
apply it. This is a mandatory educational quality requirement. See
WRITING_SYSTEM_STANDARD.md and WRITING_UNIT_INTRODUCTION_STANDARD.md.

Learner-facing writing-system explanations must:

- state clearly whether a parenthetical form is a name, reading or learner
  hint;
- avoid unexplained linguistic terminology;
- avoid implying that a localized approximation is exact;
- avoid ambiguous phrasing such as "h reads as hache";
- use consistent terminology for letter name, sound, reading, pronunciation,
  character, syllable, component, tone and stress.

Poor:

```text
Німа h (аче).
```

Better:

```text
Німа літера h. Іспанською вона називається «аче».
```

A compact title such as `Німа h («аче») і сталі голосні` is acceptable only
when the surrounding lesson immediately explains that `аче` is the letter's
name, not its sound inside a word.

---

# Quality Dimensions

Educational text must satisfy four different quality dimensions.

## Educational Correctness

The text must teach the intended concept accurately at the learner's current
stage.

It must not introduce unsupported concepts, misleading shortcuts or premature
exceptions.

## Linguistic Correctness

The text itself must be grammatically correct in the language in which it is
written.

Target-language examples must be authentic and correct.

Support-language explanations must be correct, natural and idiomatic.

## Editorial Quality

The text must read as if prepared for a professionally edited beginner language
course.

It must not contain machine-translation artifacts, awkward wording, accidental
ambiguity or inconsistent terminology.

## Learner Readability

The learner must be able to understand what is expected without extra effort
caused by the wording.

The text must reduce cognitive load rather than add to it.

---

# Editorial Quality Principle

Educational content must read as if written by an experienced human language
teacher.

Machine-translated text is unacceptable.

Literal translation is unacceptable.

Awkward wording is unacceptable.

Generated or assisted drafts may be used only if the final text meets this
standard after human-level editorial review.

---

# Native Teacher Principle

Every learner-facing sentence must sound natural to a native speaker of the
support language or target language in which it appears.

The reader must never suspect that the text was generated automatically,
translated mechanically or assembled from software fragments.

If a sentence sounds technically understandable but unnatural, it is not ready.

---

# Educational Clarity Principle

Prefer the simplest explanation that is pedagogically correct.

Avoid unnecessary terminology.

Introduce only one new concept at a time.

When terminology is necessary, explain it briefly before relying on it.

Do not make the learner solve the wording before learning the language point.

---

# Cognitive Load Principle

Do not overload explanations.

Each educational card should teach exactly one primary concept.

Supporting details must remain secondary and must not compete with the main
objective.

If a learner must remember several unrelated ideas to understand one card, the
card should be split or rewritten.

---

# Progressive Knowledge Principle

Do not explain concepts the learner has not yet encountered unless the current
lesson is explicitly introducing them.

Avoid forward references that require future lessons.

Do not use advanced terminology to explain beginner material.

When a future distinction exists but is not useful yet, state only what the
learner needs now and leave the full distinction for the later lesson.

---

# Reading Aloud Principle

Every learner-facing sentence should remain natural when read aloud.

Awkward rhythm, unnatural pauses, overloaded clauses or software-like phrasing
should trigger rewriting.

If a teacher would not comfortably say the sentence to a beginner learner, the
sentence is not ready.

---

# Translation Principle

Support-language text must communicate meaning rather than reproduce
source-language syntax.

Avoid grammatical calques.

Avoid word-for-word translation.

Natural language always takes precedence over preserving source sentence shape.

The localized text should sound as if it was originally written in the support
language by a careful teacher.

---

# Terminology Consistency

The same educational term must use the same wording throughout a course unless
the lesson intentionally teaches synonyms or contrasts.

Do not alternate between multiple translations of the same concept by accident.

Terminology consistency applies to:

- grammar terms;
- activity instructions;
- answer feedback;
- pronunciation labels;
- review and checkpoint language;
- competency and remediation wording.

When a terminology decision changes, update all affected educational text
together.

---

# Example Sentence Principle

Examples are teaching material, not decoration.

Every example must:

- sound natural;
- be grammatically correct;
- match the learner level;
- reinforce the lesson objective;
- avoid unsupported grammar or vocabulary unless explicitly scaffolded;
- be useful for future recognition, recall or application.

An example that is technically correct but unnatural should be rewritten.

An example that distracts from the objective should be replaced.

---

# Textbook Principle

Every educational card must satisfy this question:

Could this page be printed unchanged inside a professionally edited beginner
textbook?

If the answer is no, the content is not ready.

This does not mean the app must sound old-fashioned or academic. It means the
text must meet professional educational publishing standards.

---

# Human Editorial Standard

Generated content must imitate professional educational publishing standards,
not software-generated documentation.

Avoid:

- broken phrasing;
- mixed languages where not pedagogically intentional;
- raw internal terminology;
- placeholder language;
- overly literal translation;
- unnatural collocations;
- explanations that sound like database labels;
- prompts that sound like implementation instructions.

Prefer:

- clear teacher-like wording;
- direct instructions;
- concise explanations;
- natural examples;
- stable terminology;
- learner-friendly feedback.

---

# Quality Checklist

Before publication, every learner-facing educational text must pass this
checklist.

- Natural wording.
- Correct grammar.
- No machine-translation artifacts.
- Correct agreement, case, tense, punctuation and spelling.
- No accidental ambiguity.
- Consistent terminology.
- Beginner readability.
- Pedagogical clarity.
- One primary concept per educational card.
- No unsupported forward references.
- Example sentences are useful and natural.
- Hints and remediation explain what to do next.
- The text reads naturally aloud.
- The page could appear in a professionally edited beginner textbook.

Every item must pass before release.

---

# Non-Normative Examples

These examples illustrate the standard. They are not language-specific rules.

## Example 1: Literal Translation

Poor:

```text
Use introduction naturally.
```

Better:

```text
Use a short introduction naturally.
```

Excellent:

```text
Introduce yourself with a short, natural phrase.
```

Reason:

The excellent version sounds like a teacher speaking to a learner. It explains
the action, not the database category.

## Example 2: Overloaded Explanation

Poor:

```text
This form is used for identity, origin, profession and many permanent states,
but later you will contrast it with another verb.
```

Better:

```text
Use this form here to say where someone is from.
```

Excellent:

```text
To say origin, use this pattern: I am from...
```

Reason:

The excellent version teaches the current concept without pulling in future
grammar.

## Example 3: Machine-Like Prompt

Poor:

```text
Complete target-language lexical item.
```

Better:

```text
Complete the Spanish word.
```

Excellent:

```text
Type the missing Spanish word.
```

Reason:

The excellent version is direct, natural and clear for a learner.

## Example 4: Unnatural Support-Language Wording

Poor:

```text
Name sounds.
```

Better:

```text
Sounds in names.
```

Excellent:

```text
Pronunciation in names.
```

Reason:

The excellent version uses a natural educational phrase rather than a literal
fragment.

## Example 5: Ambiguous Feedback

Poor:

```text
Incorrect.
```

Better:

```text
Not correct yet.
```

Excellent:

```text
Not correct yet. This exercise asks for a question, but you wrote an answer.
```

Reason:

The excellent version distinguishes a task misunderstanding from lack of
knowledge and gives the learner a next step.

---

# Relationship To Other Documents

AUTHORING_STYLE_GUIDE.md defines learner-facing tone and writing style.

CONTENT_AUTHORING_GUIDE.md defines educational content object responsibilities,
supported fields, references and validation expectations.

EDUCATIONAL_CONTENT_LOCALIZATION.md defines how educational support text is
localized.

PRONUNCIATION_AUTHORING_GUIDE.md defines pronunciation-specific authoring,
localization and rendering rules.

CONTENT_REVIEW_PROTOCOL.md defines the mandatory editorial review workflow.

This document governs educational language quality. It does not define JSON
structure, runtime behavior, Flutter UI implementation, database persistence or
content loading.

---

# Reviewer Use

A reviewer must be able to evaluate educational language quality using this
document without opening Flutter code or JSON assets.

When a learner-facing sentence fails this standard, the content must return to
editing before release.

---

End of document.
