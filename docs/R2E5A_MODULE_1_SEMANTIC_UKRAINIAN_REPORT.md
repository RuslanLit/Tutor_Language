# R2E5A Module 1 Semantic Ukrainian Report

Status: SUPERSEDED by R2E5R

R2E5R reset Ukrainian and Russian educational localization after this report.
The Module 1 semantic bundle and completion declaration described here are no
longer active production localization.

## Verdict

FAIL.

Shared course title and canonical Module 1 now pass the semantic Ukrainian
module audit with zero legacy educational resolutions. The subphase still
cannot receive a PASS because required Redmi Note 8T device QA was not
completed in this run.

## Canonical Scope

Shared metadata included:

- course title;
- Module 1 title.

Canonical module:

```text
module ID: es.a0.m01
module title: First Words and Reading
```

Canonical lesson IDs from `Course.modules[]`:

```text
es.a0.m06.l016
es.a0.m01.l001
es.a0.m06.l017
es.a0.m01.l002
es.a0.m01.l003
es.a0.m01.l006
es.a0.m04.l010
```

The scope uses canonical course order, not historical lesson ID numbering.

## Migration Totals

```text
Module 1 semantic units: 415
Combined semantic units: 589
Module 1 identities in audit scope: 420
Module 1 semantic-covered identities: 420
Module 1 coverage: 100.0%
Module 1 legacy resolutions: 0
Module 1 source fallback: 0
Module 1 missing: 0
generated: 0
duplicate identities: 0
semantic validation issues: 0
```

Full-course Ukrainian remains incomplete:

```text
legacy Ukrainian fields: 2742
approved semantic Ukrainian fields: 589
legacy fields covered by approved semantic units: 285
semantic legacy-field coverage: 10.4%
remaining legacy fields: 2457
legacy resolutions outside completed scope: 2457
```

## Assets

Created stable Module 1 semantic asset:

```text
app/assets/languages/spanish/localization/semantic/module_1.uk.json
```

The older pilot asset remains for QA regression, but overlapping Module 1
identities were consolidated out of the pilot bundle. The runtime loader now
loads:

```text
semantic_reference_slice.json
semantic/module_1.uk.json
semantic_pilot_lessons.json
```

## Runtime Gate

The Module 1 semantic bundle declares `requiredSemanticFields`. For Ukrainian,
the semantic resolver throws instead of falling back when a completed-scope
field is missing or unapproved. Unmigrated modules retain the transitional
legacy path.

## Editorial Method

Values were migrated from canonical English source, Spanish target content,
semantic role, existing Ukrainian migration memory and existing reviewed pilot
work. The generated corpus records the old Ukrainian value and final semantic
value for later human review:

```text
docs/generated/UKRAINIAN_MODULE_1_SEMANTIC_CORPUS.md
```

This was a Codex editorial pass, not a separate native-editor review.

## Validation

Passing gates run:

```text
dart run tool/generate_semantic_module_1_bundle.dart
dart run tool/generate_semantic_pilot_bundle.dart
dart run tool/validate_semantic_localization_units.dart
dart run tool/audit_semantic_ukrainian_module.dart --module es.a0.m01
dart run tool/report_semantic_localization_coverage.dart
dart run tool/validate_semantic_lesson.dart
flutter gen-l10n
flutter analyze
flutter test test/core/content/semantic_localization_test.dart --reporter compact
flutter test test/core/content --reporter compact --concurrency=1
flutter test test/features/lesson_assembly --reporter compact --concurrency=1
flutter test test/features/lesson_player --reporter compact --concurrency=1
flutter test test/features/course_navigation --reporter compact --concurrency=1
flutter test --reporter compact --concurrency=1
flutter build apk --debug
flutter build apk --debug --dart-define=SEMANTIC_QA=true
```

Expected failing full-course gate:

```text
dart run tool/audit_semantic_ukrainian_migration.dart
FAIL, remaining legacy fields: 2457
```

## Device QA

Not completed. Because device traversal of all Module 1 lessons is a required
PASS criterion for R2E5A, the final subphase verdict is FAIL even though the
automated Module 1 semantic gate passes.

## Files Created

```text
app/assets/languages/spanish/localization/semantic/module_1.uk.json
app/tool/audit_semantic_ukrainian_module.dart
app/tool/generate_semantic_module_1_bundle.dart
docs/R2E5A_MODULE_1_SEMANTIC_UKRAINIAN_REPORT.md
docs/generated/UKRAINIAN_MODULE_1_SEMANTIC_CORPUS.md
```

## Overall R2E5 Status

Full R2E5 remains FAIL until all remaining Ukrainian legacy educational fields
are migrated into approved semantic units and device QA passes for the complete
release scope. Polish localization remains blocked.
