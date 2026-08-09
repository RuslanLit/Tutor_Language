# Spanish A0 Complete Pronunciation Report

Status: EVIDENCE
Scope: language pronunciation/reading implementation evidence
Normative authority: PRONUNCIATION_MODEL.md

Phase: R2E2G

Date: 2026-07-15

## Scope

This report covers the complete Spanish A0 production course pronunciation
migration.

The release gate now audits learner-facing Spanish forms across:

- 70 Spanish A0 lessons;
- vocabulary presentations and examples;
- grammar examples;
- dialogues;
- readings;
- exercise expected answers;
- accepted answers;
- authored misconception answers;
- Spanish answer options;
- quoted Spanish prompt fragments.

## Inventory Result

| Metric | Result |
| --- | ---: |
| Lessons audited | 70 |
| Learner-facing Spanish forms inventoried | 738 |
| Forms with complete pronunciation coverage | 738 |
| Missing or incomplete forms | 0 |
| Unique forms | 738 |
| Missing unique forms | 0 |

The detailed inventory is maintained in
`docs/SPANISH_A0_PRONUNCIATION_INVENTORY.md`.

## Migration Result

The Spanish pronunciation catalog now contains complete production
PronunciationUnit coverage for the inventoried Spanish A0 learner-facing forms.

Each covered production form has:

- stable PronunciationUnit identity;
- target orthography;
- declared `es-general` pronunciation variety;
- broad IPA;
- Russian localized learner hint;
- stress marking where required;
- reading rule references;
- release metadata;
- localized explanation where the spelling, stress or sound may mislead A0
  learners.

## Validation Gate

The following tools now use the same production inventory:

- `tool/inventory_spanish_a0_pronunciation.dart`;
- `tool/validate_pronunciation_content.dart`;
- `tool/report_pronunciation_coverage.dart`.

`validate_pronunciation_content.dart` fails if any inventoried production form
is missing complete pronunciation coverage.

`report_pronunciation_coverage.dart` reports production inventory metrics
before legacy or catalog-only metrics.

## Latest Tool Results

Inventory:

```text
lessonsAudited=70
learnerFacingForms=738
coveredForms=738
missingForms=0
uniqueForms=738
missingUniqueForms=0
```

Validation:

```text
issues=0
errors=0
warnings=0
productionLessonsAudited=70
productionLearnerFacingForms=738
productionPronunciationCovered=738
productionPronunciationMissing=0
```

Coverage:

```text
productionLessonsAudited=70
productionLearnerFacingForms=738
productionPronunciationCovered=738
productionPronunciationMissing=0
productionUniqueForms=738
productionMissingUniqueForms=0
invalidUnits=0
unknownReferences=0
crossLocaleFallbackAttempts=0
llYVarietyMismatches=0
nonYeistaHintsInYeistaProfile=0
```

Catalog-level supporting metrics:

```text
pronunciationUnits=751
unitsWithDeclaredVariety=751
unitsWithRussianLearnerHint=751
unitsRequiringExplanation=425
unitsWithRequiredExplanation=425
llYPronunciationUnits=113
llYUnitsConsistentWithSelectedVariety=113
```

## Policy Notes

The Spanish A0 course uses `es-general` broad-phonemic pronunciation data.

The course policy for `ll` and consonantal `y` remains yeismo. Production
PronunciationUnits using this rule use `/ʝ/` and Russian hints that avoid
non-yeista `ль` explanations.

Russian learner hints are authored as Russian support-language pronunciation
guidance. English-oriented respelling is not used as a Russian fallback.

## Remaining Non-Blocking Notes

Ukrainian, Polish and German pronunciation hints are still future localization
work. They are not part of the Russian-support Spanish A0 release gate.

Audio remains future work.

## Release Gate Verdict

Spanish A0 Russian-support pronunciation migration is complete for the
inventoried production course.
