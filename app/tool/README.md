# Validation tools

The current release-validation surface is:

```sh
flutter analyze
flutter test
flutter test test/core/content --reporter compact --concurrency=1
dart run tool/audio_reference.dart
flutter build apk --release
```

The executable runtime uses the canonical course assets and
`assets/languages/spanish/audio/reference_audio.json`. It does not load the
historical `pronunciation/reference_slice.json` bundle.

## Historical tools

The following scripts belong to earlier pronunciation and semantic-localization
migration passes. They are retained as historical evidence and authoring
provenance, but are not release gates and must not be used as current
validation commands:

- `audit_educational_localization_reset.dart`
- `audit_foundational_russian_presentation.dart`
- `audit_localization_architecture.dart`
- `audit_pedagogical_contract.dart`
- `audit_reading_rule_prerequisites.dart`
- `audit_spanish_a0_reading_sequence.dart`
- `audit_ukrainian_content_localization.dart`
- `complete_spanish_a0_pronunciation_migration.dart`
- `generate_semantic_module_1_bundle.dart`
- `generate_semantic_pilot_bundle.dart`
- `inventory_pronunciation_content.dart`
- `report_pronunciation_coverage.dart`
- `semantic_scope/module_semantic_scope_extractor.dart`
- `spanish_a0_pronunciation_inventory_support.dart`
- `translate_content_localization_uk.dart`
- `validate_pronunciation_content.dart`
- `validate_semantic_lesson.dart`
- `validate_semantic_localization_units.dart`

They reference the former `pronunciation/reference_slice.json` source, which
was removed when the canonical Spanish A0 foundation replaced the earlier
content architecture. Recreating that file would create a second source of
truth and is intentionally not supported.

Historical reports may retain the old commands as part of their recorded
provenance. Such reports are not current release instructions.
