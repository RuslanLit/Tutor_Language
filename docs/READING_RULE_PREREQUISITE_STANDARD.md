# READING_RULE_PREREQUISITE_STANDARD.md

Status: Active

Version: 1.0

Related documents:

- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md
- CONTENT_MODEL.md
- CURRICULUM_SPEC.md
- WRITING_SYSTEM_STANDARD.md
- WRITING_UNIT_INTRODUCTION_STANDARD.md
- PRONUNCIATION_MODEL.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- GRAPHEME_PRESENTATION_STANDARD.md
- SPANISH_LLY_PRONUNCIATION_POLICY.md

---

# Purpose

This document defines the curriculum dependency standard for reusable
ReadingRules.

The standard prevents a learner from being asked to recognize, read, type,
recall or apply an unseen grapheme, digraph, orthographic pattern or reading
rule before that rule has been explicitly introduced.

It specializes WRITING_SYSTEM_STANDARD.md for reusable spelling-to-sound
behavior. WritingUnit introduction covers the symbol itself; ReadingRule
introduction covers the rule governing how the symbol or symbol sequence is
read.

First WritingUnit introductions, including name versus reading distinctions,
are defined in WRITING_UNIT_INTRODUCTION_STANDARD.md.

The rule is target-language neutral. Spanish `ll` before `llamo`, German `sch`
before `Schule`, French `eau` before `beau`, Polish `sz` before `szkola`, and
English `th` before `think` are the same kind of curriculum dependency.

---

# Core Invariant

```text
FIRST_REQUIRED_USE(rule) > INTRODUCTION(rule)
```

In plain language:

The first active use of a ReadingRule must occur after an explicit
introduction of that same stable ReadingRule ID.

Localized titles and learner-facing text are never dependency identity.

---

# Terms

Introduction

An authored lesson activity that explicitly teaches a ReadingRule before
practice. It may include explanation, grapheme presentation, pronunciation,
examples, and guided recognition.

Passive Preview

A target form appears before formal study, but the learner is not expected to
decode, type, recall or apply the rule. A preview must show immediate
pronunciation support and must not be treated as learned.

Active Use

Any activity that expects the learner to use the rule to complete the task:
typing a word, completing a word, choosing pronunciation, distinguishing a
grapheme, recalling a target form, interpreting spelling, or applying the form
in dialogue.

Requirement

An authored declaration that a lesson or activity requires an already available
ReadingRule.

Review

Intentional reinforcement of an already introduced ReadingRule. Review never
counts as introduction.

---

# Authored Metadata

LessonDefinitions and activities may declare:

- `introducedReadingRuleIds`
- `requiredReadingRuleIds`
- `reviewedReadingRuleIds`

All values must be stable ReadingRule IDs.

Lesson-level metadata describes the lesson as a whole. Activity-level metadata
controls same-lesson sequencing and is required when a lesson introduces and
then applies a rule during the same session.

Existing legacy lessons may remain loadable without metadata, but release
validation must distinguish validated lessons from legacy or unclassified
coverage.

---

# Validation Algorithm

Validation traverses the canonical curriculum order:

```text
Course
-> Modules in declared order
-> lessonIds in declared order
-> LessonDefinition activities in Lesson Player order
```

For each lesson:

1. Start with ReadingRules introduced by earlier ordered lessons.
2. Validate lesson-level required rules against that set.
3. Traverse activities in runtime order.
4. For each activity, validate required rules against the current available
   set.
5. Add activity-level introduced rules only after that activity is reached.
6. Treat reviewed rules as reinforcement only.
7. Report unknown IDs, target-language mismatch, duplicate introductions and
   active use before introduction.

The validator must not infer prerequisites from localized prose. Authoring
audit tools may scan visible target text to identify likely missing metadata,
but they must report candidates rather than silently mutating content.

---

# Relationship With PronunciationUnit

PronunciationUnits may reference ReadingRules through stable IDs.

If an activity uses a PronunciationUnit for active learner work, the relevant
ReadingRules should be available before that activity unless the same activity
is an explicit introduction.

The Session Engine and Lesson Player do not load assets to decide whether a
rule is known. Curriculum validation owns the static order check.

---

# Target-Language Boundary

ReadingRule prerequisites are target-language specific.

A Spanish lesson may satisfy only Spanish ReadingRules. A German `sch` rule
does not satisfy a Polish `sz` dependency, even if a localized explanation
uses similar support-language words.

Validators must check the target language of referenced rules where that
metadata is available.

---

# Release Metrics

Coverage reports should include:

- ReadingRules with explicit first introduction;
- ReadingRules actively used before introduction;
- lessons with declared ReadingRule prerequisites;
- activities with declared ReadingRule prerequisites;
- unclassified active first uses;
- unknown ReadingRule references;
- cross-language prerequisite references;
- rules introduced and applied in the same lesson;
- rules introduced only after first use.

For migrated release scope, active uses before introduction and unknown
references must be zero.

---

# Current Implementation Status

R2E2D2 introduces optional lesson/activity ReadingRule dependency metadata,
pure deterministic validation, and an audit tool for the Spanish A0 migrated
reference scope.

R2E2D3 adds a deterministic Spanish A0 reading-sequence audit for Modules 1-2.
That audit checks the learner-visible course order, verifies that active target
forms use only previously introduced ReadingRules, and confirms that `ll/y`
foundation appears before active `me llamo` recall.

The full Spanish A0 course is not yet fully audited for every possible passive
appearance of every rule. That broader audit remains deferred.
