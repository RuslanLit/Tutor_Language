# R2E2D2_READING_RULE_SEQUENCE_REPORT.md

Status: Active

Version: 1.0

---

# Purpose

This report records the R2E2D2 correction for ReadingRule prerequisites and
Spanish `ll` grapheme presentation.

---

# Initial Violation

Before R2E2D2, the Spanish A0 course required active use of `me llamo` in
`es.a0.m02.l004` while the explicit `ll` explanation was available only in a
later pronunciation-focused lesson.

This inverted the required order:

```text
use llamo
-> later explain ll
```

The learner also saw prose explaining `ll` as `l + l`, but without a structured
visual contrast against uppercase `II`.

---

# Chosen Correction

The stable lesson ID `es.a0.m02.l004` remains unchanged.

The lesson now begins with a ReadingRule introduction activity:

```text
activity.reading_rule.ll_y_intro
introducedReadingRuleIds:
  - pronunciation.es.rule.ll_y.v1
```

Existing vocabulary, grammar, dialogue, reading and practice activities now
declare:

```text
requiredReadingRuleIds:
  - pronunciation.es.rule.ll_y.v1
```

The later `es.a0.m06.l017` lesson remains in the course as review and
consolidation for `ll/y` and introduction/practice for `ñ` and `j` in names.

---

# Before / After

Before:

```text
es.a0.m02.l004
  vocabulary: me llamo
  practice: type Me llamo...

es.a0.m06.l017
  grammar: ñ, j and ll in names
```

After:

```text
es.a0.m02.l004
  reading rule: introduce ll/y
  vocabulary: me llamo
  practice: type Me llamo...

es.a0.m06.l017
  reading rule: consolidate ñ, j and ll
```

No stable lesson IDs were renamed.

---

# Metadata Added

Lesson/activity metadata now supports:

- `introducedReadingRuleIds`
- `requiredReadingRuleIds`
- `reviewedReadingRuleIds`

The metadata uses stable ReadingRule IDs. It does not use localized titles or
visible text as identity.

---

# Validator Results

Latest R2E2D2 audit:

```text
readingRulesWithExplicitFirstIntroduction=5
readingRulesActivelyUsedBeforeIntroduction=0
lessonsWithDeclaredPrerequisites=3
activitiesWithDeclaredPrerequisites=12
unclassifiedActiveFirstUses=0
unknownReadingRuleReferences=0
crossLanguagePrerequisiteReferences=0
rulesIntroducedAndAppliedInSameLesson=3
rulesIntroducedOnlyAfterFirstUse=0
visuallyConfusableGraphemesWithPresentation=1
confusableGraphemesMissingAccessibility=0
```

---

# UI Behavior

The first `ll/y` card now resolves from ReadingRule data and presents:

```text
l + l -> ll
I + I -> II
```

Russian support explicitly names:

- lowercase `l` as `«эль»`;
- uppercase `I` as `«и»`.

The accessibility label describes both decompositions in words.

---

# Remaining Limitations

The full Spanish A0 course has not yet been exhaustively classified for every
passive grapheme appearance.

Only the migrated ReadingRule release scope is release-validated in R2E2D2.

Future phases should add dependency metadata for all remaining ReadingRules and
additional confusable graphemes as they become release-relevant.
