# GRAPHEME_PRESENTATION_STANDARD.md

Status: Active

Version: 1.0

Related documents:

- PRONUNCIATION_MODEL.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- READING_RULE_PREREQUISITE_STANDARD.md
- EDUCATIONAL_CONTENT_LOCALIZATION.md
- SPANISH_LLY_PRONUNCIATION_POLICY.md

---

# Purpose

This document defines how Tutor Language presents visually confusable
graphemes to beginner learners.

Some writing systems contain characters or combinations that are difficult to
distinguish in ordinary fonts. A learner must not be expected to infer the
difference from typography alone.

The standard begins with Spanish `ll` versus uppercase `II`, but the model must
support future cases such as `rn` versus `m`, `I` versus `l`, `O` versus `0`,
German `ß` versus `B`, Polish `ł` versus `l`, and Cyrillic `а` versus Latin
`a`.

---

# Grapheme Presentation

A grapheme presentation may include:

- canonical grapheme;
- letter-by-letter decomposition;
- localized letter names;
- confusable graphemes;
- visual comparison;
- accessible spoken description;
- optional typography override.

Locale-independent data belongs to ReadingRule metadata. Localized letter
names and learner explanations belong to localized pronunciation support.

Do not store Russian, English or other support-language words in
locale-independent fields.

---

# A0 Presentation Standard

The first learner-facing presentation of a confusable grapheme must be
structured, not buried in dense prose.

For Spanish `ll`, Russian support should convey:

```text
Изучаем: ll

l + l -> ll
строчная «эль» + строчная «эль»

Не путайте:

I + I -> II
заглавная «и» + заглавная «и»

В этом курсе ll перед гласной звучит примерно как русский «й».
llamo
/ˈʝamo/
я́мо
```

Technical terms such as `yeismo`, `phoneme`, `palatal approximant` and
`digraph` do not belong in the first A0 learner explanation.

---

# Typography

Grapheme comparison content should:

- use a platform-safe style that visibly distinguishes lowercase `l` from
  uppercase `I`;
- use sufficiently large text;
- show component letters with spacing;
- show the combined grapheme separately;
- avoid relying on color as the only distinction;
- remain legible in monochrome screenshots;
- preserve layout at large text scale.

An external proprietary font must not be added only to solve this problem.

---

# Accessibility

Screen-reader semantics must describe the distinction explicitly.

Example:

```text
Две строчные латинские буквы эль: эль плюс эль, образуют ll.
Не путайте с двумя заглавными латинскими буквами и: I плюс I, образуют II.
```

The accessibility description must not leave the learner with a sequence of
visually or aurally ambiguous glyphs.

---

# Validation

Validation should report deterministic issues such as:

- `readingRule.missingGraphemePresentation`
- `readingRule.missingAccessibleGraphemePresentation`
- `pronunciation.ambiguousGraphemeExplanation`
- `grapheme.confusableWithoutLocalizedLetterNames`
- `grapheme.presentationUsesColorOnly`

For the migrated Spanish A0 release scope, `ll` versus `II` must have explicit
visual decomposition, localized Russian letter names, and accessibility text.

---

# Current Implementation Status

R2E2D2 adds runtime presentation support for the Spanish `ll` ReadingRule. The
model is intentionally reusable, but only the Spanish `ll`/`II` case is
populated and validated in this phase.
