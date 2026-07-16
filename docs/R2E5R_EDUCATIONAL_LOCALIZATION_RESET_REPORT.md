# R2E5R Educational Localization Reset Report

Status: PASS for automated reset gates and narrow uk-UA device smoke.

## Verdict

PASS for repository reset, automated validation, debug APK build and narrow
uk-UA device smoke.

Ukrainian and Russian educational localization were reset to a fail-closed,
semantic-only rebuilding foundation. Ukrainian and Russian Flutter UI
localization remain available. Educational content for `uk` and `ru` now uses
the explicit temporary policy `englishSourceFallback`; no Ukrainian/Russian
legacy educational values, production semantic values, or pronunciation support
hints remain active.

## Starting State

Starting HEAD:

```text
4898f408075bc30f4b466b45be1c901d11ff3b75
```

The worktree contained uncommitted R2E5A work. R2E5A was treated as historical
work and superseded where it declared Module 1 Ukrainian semantic production
completion. No commit was created.

## Reset Inventory

Inventory:

```text
docs/EDUCATIONAL_LOCALIZATION_RESET_INVENTORY.md
```

Preserved Spanish target content, English source, course order, lesson IDs,
canonical answers, accepted answers, IPA, PronunciationUnit IDs, ReadingRule
IDs, semantic architecture, validators, QA tooling and Ukrainian/Russian UI
localization.

Cleared or deactivated:

```text
Ukrainian legacy educational fields: 2742
Russian legacy educational fields: 2742
Previously approved Ukrainian semantic values: 589
Ukrainian/Russian pronunciation localized fields: all active fields
Completed semantic modules for uk/ru: 0
```

Retired production generators:

```text
app/tool/translate_content_localization_uk.dart
app/tool/translate_content_localization_ru.dart
app/tool/generate_semantic_module_1_bundle.dart
app/tool/generate_semantic_pilot_bundle.dart
```

Archived:

```text
docs/archive/UKRAINIAN_TRANSLATION_MEMORY_LEGACY.md
```

## Runtime State

| Locale | UI | Educational content | Readiness | Fallback | Completed modules |
| --- | --- | --- | --- | --- | --- |
| `en` | available | available | production-ready | none | none required |
| `uk` | available | rebuilding | not production-ready | English source only | none |
| `ru` | available | rebuilding | not production-ready | English source only | none |

Readiness source:

```text
app/assets/languages/spanish/localization/semantic/manifests/educational_locales.json
```

Clean semantic bundles:

```text
app/assets/languages/spanish/localization/semantic/uk/shared.json
app/assets/languages/spanish/localization/semantic/ru/shared.json
```

## Integrity

```text
legacy uk active fields: 0
legacy ru active fields: 0
production uk semantic units: 0
production ru semantic units: 0
uk pronunciation localized fields: 0
ru pronunciation localized fields: 0
uk->ru fallback paths: 0
ru->uk fallback paths: 0
mixed partial lessons: 0
invalid approved units: 0
Spanish target mutations: 0
English source mutations: 0
canonical answer mutations: 0
accepted answer mutations: 0
lesson ID mutations: 0
course order mutations: 0
IPA mutations: 0
pronunciation ID mutations: 0
reading-rule ID mutations: 0
writing-unit ID mutations: 0
reset violations: 0
```

## New Workflow

```text
dart run tool/create_semantic_localization_scaffold.dart \
  --locale uk \
  --module es.a0.m01 \
  --output /tmp/r2e5r_scaffold.json
```

The scaffold tool derives canonical lesson IDs from `Course.modules[]`, writes
draft/generated units, includes English source and protected spans, leaves
localized values empty and never sets `approved`.

## Automated Validation

Passing:

```text
dart run tool/audit_educational_localization_reset.dart
dart run tool/audit_localization_architecture.dart
dart run tool/validate_semantic_localization_units.dart
dart run tool/report_semantic_localization_coverage.dart
dart run tool/audit_semantic_russian_migration.dart
flutter gen-l10n
flutter analyze
flutter test test/core/content --reporter compact --concurrency=1
flutter test test/features/lesson_assembly --reporter compact --concurrency=1
flutter test test/features/lesson_player --reporter compact --concurrency=1
flutter test test/features/course_navigation --reporter compact --concurrency=1
flutter test test/features/settings --reporter compact --concurrency=1
flutter test --reporter compact --concurrency=1
flutter build apk --debug
```

Full Flutter suite result:

```text
473 tests passed
```

Expected not-ready gate:

```text
dart run tool/audit_semantic_ukrainian_migration.dart
verdict: FAIL
source fallback count: 2742
```

## Device QA

Completed narrow smoke on Redmi Note 8T (`model: Redmi_Note_8T`, system
locales `uk-UA,ru-UA,en-US`) using:

```text
adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell monkey -p org.tutorlanguage.app -c android.intent.category.LAUNCHER 1
```

Observed:

```text
package installed successfully
org.tutorlanguage.app/.MainActivity focused
process alive after navigation
home UI: Налаштування, Відкрити курс
settings/about UI: Про застосунок і налаштування
course UI: Курс, Виконано 21 з 70 уроків
course educational titles: First Words and Reading; Spanish Vowels, h, and First Sounds
lesson UI: Урок; Назад до курсу; Крок 1 / 7; Далі
lesson educational text: English source fallback, IPA and Spanish target preserved
```

No app `FATAL`, `FlutterError` or `AndroidRuntime` crash was observed in the
smoke log slice. `AndroidRuntime` lines present in the log slice were from the
ADB shell tools (`monkey` and `uiautomator`), not from the application process.

ru-RU device smoke was not run because it would require changing the connected
phone's primary system locale. Russian reset behavior is covered by automated
readiness, coverage and runtime tests in this report.
