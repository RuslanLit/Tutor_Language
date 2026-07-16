# CONTENT_REVIEW_PROTOCOL.md

Status: Active

Version: 1.0

Related documents:

- EDUCATIONAL_LANGUAGE_STANDARD.md
- EDUCATIONAL_PRINCIPLES.md
- AUTHORING_STYLE_GUIDE.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- EDUCATIONAL_CONTENT_LOCALIZATION.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- WRITING_SYSTEM_STANDARD.md
- WRITING_UNIT_INTRODUCTION_STANDARD.md
- READING_RULE_PREREQUISITE_STANDARD.md
- GRAPHEME_PRESENTATION_STANDARD.md
- CONTENT_REVIEW_CHECKLIST.md
- RELEASE_CHECKLIST.md

---

# Purpose

This document defines the mandatory editorial review process for Tutor Language
educational content.

Content creation and content review are different activities.

Authors create.

Editors verify.

Review is mandatory. Skipping review is prohibited.

Content must not be released merely because it loads, validates structurally or
passes automated tests. Educational content must also pass human-level
educational, linguistic, editorial, pronunciation and localization review.

---

# Relationship To Educational Language Standard

Every review stage validates compliance with
EDUCATIONAL_LANGUAGE_STANDARD.md.

The Educational Language Standard defines the quality bar.

This protocol defines the deterministic process used to verify that the quality
bar has been met.

---

# Review Pipeline

Educational content must pass the following review stages before release:

1. Author Pass
2. Technical Validation
3. Educational Review
4. Language Review
5. Pronunciation Review
6. Localization Review
7. Beginner Review
8. Read Aloud Review
9. Textbook Simulation
10. Release Review

Each stage has a distinct responsibility.

Passing one stage does not replace another stage.

No partial approval is allowed for release content.

---

# Author Pass

The Author Pass is performed by the content author before formal review.

The author verifies:

- lesson objective;
- pedagogical correctness;
- internal consistency;
- curriculum alignment;
- correct target level;
- one primary concept per learning activity;
- appropriate knowledge density;
- reuse of existing educational content where possible;
- every new WritingUnit is introduced before active use;
- WritingUnit symbol, designation, conventional name, reading and
  pronunciation are not conflated;
- no active use of a ReadingRule before its explicit introduction;
- structured grapheme presentation when a symbol is visually confusable;
- no placeholders;
- no TODO markers;
- no knowingly ambiguous prompts;
- examples support the lesson objective.

The Author Pass asks:

- Does the content teach what it claims to teach?
- Does every activity serve the learning objective?
- Does the lesson build only on previously introduced knowledge?
- Is the content ready for another person to review?

If the answer is no, the content remains in authoring.

---

# Technical Validation

Technical Validation verifies that the content can be loaded and checked by the
implemented system.

This stage verifies:

- schema compatibility;
- valid JSON or asset format;
- stable IDs;
- no duplicate IDs;
- valid references;
- supported exercise types;
- checkable answers;
- localization completeness where required;
- pronunciation completeness where required;
- WritingUnit references and introduction order where required;
- WritingUnit name pronunciations, readings, contrastive features and
  confusable-symbol metadata where required;
- ReadingRule and PronunciationUnit references;
- validator tools;
- lesson assembly compatibility;
- no broken asset paths.

Technical Validation does not prove educational quality.

Content that passes Technical Validation may still fail educational review,
language review or localization review.

---

# Educational Review

Educational Review is performed from the perspective of an experienced language
teacher.

Review questions include:

- Does every activity teach or assess exactly one primary concept?
- Is the difficulty appropriate for the learner level?
- Is the progression correct?
- Does the lesson introduce too much new knowledge?
- Does the material support recognition, recall and application?
- Does the lesson introduce new written symbols before requiring active use?
- Is the visible unit correctly identified?
- Does it have a conventional name where applicable?
- Is the name distinct from its reading?
- Is pronunciation of the name available where taught?
- Are all taught readings represented?
- Are pronunciation and reading contextually correct?
- Is meaning or function separated from pronunciation?
- Are stress, tone, length or other contrastive features preserved where
  relevant?
- Can a screen reader distinguish the unit from its confusables?
- Are examples pedagogically useful?
- Does remediation explain a real learner problem?
- Does review content combine prior knowledge rather than repeat a lesson
  mechanically?
- Does checkpoint content assess rather than teach?
- Is there any hidden grammar or vocabulary burden?

The reviewer may ignore implementation details except where they affect the
learner's educational experience.

---

# Language Review

Language Review is performed from the perspective of a professional editor.

The reviewer ignores JSON, architecture and implementation.

The reviewer focuses only on learner-facing language quality.

Review areas:

- fluency;
- grammar;
- agreement;
- punctuation;
- spelling;
- wording;
- ambiguity;
- readability;
- naturalness;
- rhythm;
- terminology consistency;
- absence of machine-translation artifacts.

Language Review must apply EDUCATIONAL_LANGUAGE_STANDARD.md directly.

If a sentence sounds unnatural, awkward or software-generated, it fails.

---

# Pronunciation Review

Pronunciation Review verifies all pronunciation-related educational content.

This stage verifies:

- IPA;
- pronunciation variety;
- stress marking;
- localized pronunciation hints;
- localized pronunciation explanations;
- ReadingRule references;
- ReadingRule learner support;
- articulation hints where present;
- example pronunciation;
- no cross-locale pronunciation fallback;
- no English-style respelling in non-English support modes.

Pronunciation Review must use PRONUNCIATION_AUTHORING_GUIDE.md and
PRONUNCIATION_MODEL.md.

Pronunciation content that is structurally complete but pedagogically
misleading fails this stage.

---

# Localization Review

Localization Review verifies support-language quality independently of the
source language.

The reviewer must not approve text merely because it corresponds word-for-word
to the source.

Reject:

- literal translation;
- machine translation;
- unnatural wording;
- grammar mistakes;
- mixed-language text where not pedagogically intentional;
- inconsistent terminology;
- source-language syntax copied into the support language;
- support text that sounds unlike a native teacher.

Localization Review applies to:

- vocabulary meanings;
- grammar explanations;
- exercise prompts;
- hints;
- remediation;
- feedback;
- dialogue translations;
- reading translations;
- pronunciation explanations;
- ReadingRule learner support.

---

# Beginner Review

Beginner Review checks whether an absolute beginner can understand the content
without external help.

Every lesson should answer:

Would an absolute beginner understand what to do and why?

Review questions include:

- Is the instruction clear without knowing internal project terminology?
- Does the learner know what kind of answer is expected?
- Is the explanation short enough for the current level?
- Are examples familiar enough?
- Is there any hidden dependency on future lessons?
- Does feedback tell the learner what to improve?

If the beginner would be confused by the wording, the content must be rewritten.

---

# Read Aloud Review

Every explanation, example and prompt must be read mentally as if spoken by a
teacher.

Awkward text must be rewritten.

The reviewer checks:

- natural rhythm;
- sentence length;
- overloaded phrasing;
- unnatural pauses;
- unclear emphasis;
- software-like wording;
- whether the sentence would sound respectful and clear in a lesson.

If a teacher would not comfortably say the sentence aloud, the sentence fails.

---

# Textbook Simulation

The reviewer imagines the content printed inside a commercial beginner
language textbook.

If anything feels unfinished, provisional, awkward or machine-generated, the
content returns to editing.

The Textbook Simulation is not about making the app old-fashioned. It is a
quality bar:

- professional language;
- coherent pedagogy;
- polished examples;
- clear instructions;
- stable terminology;
- no visible implementation residue.

---

# Release Review

Release Review is the final gate.

Content cannot be released until every previous review stage passes.

Release Review verifies:

- all review stages completed;
- all blocking issues resolved;
- no known placeholder content remains;
- no unresolved localization quality issues remain;
- no unresolved pronunciation quality issues remain;
- no content contradicts the educational model;
- automated validation results are recorded where applicable;
- manual review notes are resolved or explicitly deferred as non-release
  issues.

No partial approval is allowed.

If any mandatory stage fails, the content is not release-ready.

---

# Review Checklist

Every release content review must cover the following checklist.

## Educational Quality

- Lesson objective is clear.
- Each activity has one primary educational purpose.
- Difficulty matches learner level.
- Progression is coherent.
- Examples reinforce the objective.
- Review and checkpoint content behave according to their purpose.

## Language Quality

- Text is grammatically correct.
- Wording is natural.
- Punctuation and spelling are correct.
- No ambiguity blocks the learner.
- Text reads naturally aloud.
- The page meets textbook quality.

## Localization Quality

- Support-language text is idiomatic.
- No machine-translation artifacts remain.
- No mixed-language fragments remain unless pedagogically intentional.
- Terminology is consistent.
- Source-language syntax has not been copied mechanically.

## Pronunciation Quality

- IPA is present where required.
- Stress is marked where required.
- Localized pronunciation hints are appropriate for the support locale.
- Pronunciation explanations are correct and learner-friendly.
- ReadingRule references are stable.
- No cross-locale pronunciation fallback is visible.

## Terminology Consistency

- Educational terms use stable wording.
- Prompt verbs are consistent.
- Feedback categories are learner-friendly.
- Pronunciation and grammar labels are consistent.

## Naturalness

- Dialogues sound like real communication.
- Examples are plausible.
- Instructions sound teacher-like.
- Remediation is helpful rather than punitive.

## Readability

- Sentences are short enough for the learner level.
- Cards are not overloaded.
- The learner can identify the expected action.
- Text does not require outside explanation.

## Beginner Friendliness

- No unsupported future concepts.
- No unexplained technical terminology.
- No hidden grammar burden.
- Feedback tells the learner what to try next.

## Consistency

- IDs and references are stable where inspected.
- Content matches curriculum position.
- Localized text matches the intended educational meaning.
- Pronunciation support matches the declared target-language variety.

## Publication Readiness

- No placeholders.
- No TODO text.
- No raw implementation terminology.
- No known blocking defects.
- All mandatory review stages passed.

---

# Future Automation

Future validation tools may automate parts of this protocol.

Possible automated checks:

- schema validation;
- reference resolution;
- duplicate IDs;
- unsupported exercise types;
- missing localization fields;
- mixed-language detection;
- missing pronunciation data;
- ReadingRule coverage;
- prompt-answer ambiguity heuristics;
- repeated phrase limits;
- content density metrics.

Automation may support review, but it does not replace mandatory human-style
editorial judgment.

Naturalness, pedagogical clarity, beginner readability and textbook quality
remain review responsibilities even when tooling improves.

---

# Reviewer Use

A reviewer should be able to follow this protocol for any supported language
without opening Flutter code.

The protocol applies to all future target languages and support languages.

When in doubt, return content to editing rather than approving weak learner-
facing educational text.

---

End of document.
