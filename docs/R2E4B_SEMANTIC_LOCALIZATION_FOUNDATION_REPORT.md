# R2E4B Semantic Localization Foundation Report

Status: EVIDENCE
Scope: educational content localization phase evidence
Normative authority: EDUCATIONAL_CONTENT_LOCALIZATION.md

## Verdict

PASS WITH LIMITATIONS.

The semantic localization foundation is implemented and validated for a small
reference slice. Full Ukrainian migration, Polish localization and professional
editorial review remain deferred.

## Architecture Added

- `SemanticLocalizationUnit` model in `app/lib/core/content/semantic_localization.dart`
- typed semantic enums for semantic type, ownership, protected spans, named
  entities, grammar context and review status
- semantic bundle parser and deterministic serializer
- approved semantic overlay in `EducationalContentLocalizationResolver`
- semantic asset loader in the existing localization runtime
- grapheme-aware Spanish segmentation and ReadingRule applicability helper in
  `PronunciationCatalog`
- independent validator: `app/tool/validate_semantic_localization_units.dart`
- coverage reporter: `app/tool/report_semantic_localization_coverage.dart`
- reference asset:
  `app/assets/languages/spanish/localization/semantic_reference_slice.json`

## Reference Slice

Migrated reference cases:

1. `hola` meaning, IPA, pronunciation hint and silent-`h` applicability
2. `hambre` meaning and stressed pronunciation hint
3. `México` as country meaning and pronunciation hint
4. `Ciudad de México` as city meaning
5. `Chile` as country and `ch` digraph case with no silent-`h` rule
6. `me llamo` first-person phrase meaning
7. `se llama` third-person phrase meaning with protected target span
8. `¿Cómo es?` prompt with protected target span and explicit context
9. `simpático` / `simpática` gendered adjective meanings
10. `ll` grapheme designation and `ll`/`II` context
11. learner instruction with embedded `Soy de`
12. feedback/remediation units with protected target spans

## Coverage

Current semantic coverage report:

```text
semantic units: 18
approved units: 18
generated units: 0
migrated field keys: 18
legacy fields: 2742
legacy-only fields: 2733
validation issues: 0
```

This is intentionally not full-course localization.

## Validation

Validation run for this phase:

```text
dart run tool/validate_semantic_localization_units.dart
PASS, issues: 0

dart run tool/report_semantic_localization_coverage.dart
PASS

flutter gen-l10n
PASS

flutter analyze
PASS, no issues found

flutter test test/core/content --reporter compact --concurrency=1
PASS, 120 tests

flutter test test/features/lesson_assembly --reporter compact --concurrency=1
PASS, 9 tests

flutter test test/features/lesson_player --reporter compact --concurrency=1
PASS, 33 tests

flutter test --reporter compact --concurrency=1
PASS, 457 tests

flutter build apk --debug
PASS, built build/app/outputs/flutter-apk/app-debug.apk
```

## Legacy Compatibility

Migrated semantic fields override legacy values only when the requested locale
has an approved semantic value. Unmigrated fields continue through the legacy
support localization bundle and its deterministic English fallback.

The legacy path is transitional and is not counted as production-complete
semantic localization.

## Deferred

- full Ukrainian migration;
- Polish localization;
- professional editorial review;
- full WritingUnit runtime;
- advanced morphology;
- complete course-wide semantic coverage;
- replacing the existing Ukrainian generator.
