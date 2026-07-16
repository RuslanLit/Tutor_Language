# R2E5 Semantic Ukrainian Migration Report

Status: FAIL

## Verdict

FAIL.

The full Ukrainian educational layer has not been migrated from the legacy
localization bundle into approved SemanticLocalizationUnit data. The current
runtime still has valid semantic infrastructure and the R2E4C pilot remains
green, but Ukrainian is not yet a production semantic source of truth.

This is a hard production blocker, not a PASS with limitations.

## Scope Audited

The audit compares approved Ukrainian semantic units against the existing
legacy Ukrainian educational localization inventory:

```text
app/assets/languages/spanish/localization/support_localizations.json
app/assets/languages/spanish/localization/semantic_reference_slice.json
app/assets/languages/spanish/localization/semantic_pilot_lessons.json
```

The new gate is:

```text
app/tool/audit_semantic_ukrainian_migration.dart
```

It exits nonzero until Ukrainian has zero remaining legacy educational
resolutions.

## R2E5 Audit Result

Command:

```text
dart run tool/audit_semantic_ukrainian_migration.dart
```

Result:

```text
verdict: FAIL
locale: uk
legacy Ukrainian fields: 2742
approved semantic Ukrainian fields: 381
legacy fields covered by approved semantic units: 168
semantic legacy-field coverage: 6.1%
remaining legacy fields: 2574
semantic resolutions: 168
legacy resolutions: 2574
legacy fallback count: 2574
source fallback count: 0
missing count: 0
generated semantic units: 0
unapproved semantic units: 0
semantic validation issues: 0
```

## Coverage Reporter Result

Command:

```text
dart run tool/report_semantic_localization_coverage.dart
```

Result:

```text
semantic units: 381
approved units: 381
generated units: 0
migrated field keys: 381
legacy fields: 2742
legacy-only fields: 2574
validation issues: 0
ukrainian semantic migration: FAIL
```

The semantic units are valid for their current migrated scope. They do not yet
cover the full Ukrainian educational layer.

## Editorial Corrections

No new full-course Ukrainian editorial corrections were applied in R2E5.
Marking the remaining 2574 legacy Ukrainian fields as approved semantic units
without review evidence would violate CONTENT_REVIEW_PROTOCOL.md and
SEMANTIC_LOCALIZATION_UNIT_STANDARD.md.

## Device QA

Device QA was not run for R2E5. The phase fails before APK/device traversal
because the semantic migration gate reports 2574 remaining legacy resolutions.
Running representative Redmi Note 8T QA before the audit passes would not prove
production semantic Ukrainian readiness.

## Validation

Passing:

```text
dart run tool/report_semantic_localization_coverage.dart
dart run tool/validate_semantic_localization_units.dart
flutter analyze
flutter test test/core/content --reporter compact
flutter test test/core/content/semantic_localization_test.dart --reporter compact
flutter test test/features/lesson_player --reporter compact
flutter test test/features/course_navigation --reporter compact
flutter test --reporter compact --concurrency=1
PASS, 468 tests
flutter build apk --debug
PASS, built build/app/outputs/flutter-apk/app-debug.apk
git diff --check
PASS
```

Expected failing gate:

```text
dart run tool/audit_semantic_ukrainian_migration.dart
FAIL, remaining legacy fields: 2574
```

## Files Created

```text
app/tool/audit_semantic_ukrainian_migration.dart
docs/R2E5_SEMANTIC_UKRAINIAN_MIGRATION_REPORT.md
```

## Files Modified

```text
app/lib/core/content/semantic_localization.dart
app/tool/report_semantic_localization_coverage.dart
app/test/core/content/semantic_localization_test.dart
docs/EDUCATIONAL_CONTENT_LOCALIZATION.md
docs/SEMANTIC_LOCALIZATION_UNIT_STANDARD.md
docs/CONTENT_REVIEW_PROTOCOL.md
docs/RELEASE_CHECKLIST.md
```

## Deferred Work

- Migrate the remaining 2574 legacy Ukrainian fields into typed semantic units.
- Review every migrated Ukrainian unit before setting review status to
  `approved`.
- Ensure full-course Ukrainian semantic audit reports zero legacy fallback.
- Install and device-QA the debug APK only after the semantic audit passes.
- Traverse representative Redmi Note 8T lessons: foundational reading,
  Greetings, Me llamo, People, Transport and Health.
- Keep Polish localization blocked until Ukrainian reaches production quality.
