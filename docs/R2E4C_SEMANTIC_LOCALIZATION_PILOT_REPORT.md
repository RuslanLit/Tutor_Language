# R2E4C Semantic Localization Pilot Report

Status: EVIDENCE
Scope: educational content localization phase evidence
Normative authority: EDUCATIONAL_CONTENT_LOCALIZATION.md

## Verdict

The R2E4C semantic localization pilot passes automated architecture,
coverage, validation, analyzer, test, debug build and Redmi Note 8T manual QA
gates for the declared five-lesson pilot scope.

This is not a broad Ukrainian course-localization release sign-off. The phase
validates complete semantic localization behavior for the selected pilot
lessons only; legacy-only fields outside the pilot remain expected.

## Pilot Scope

The migrated pilot lessons are:

| Requested lesson | Production lesson ID | Production title |
| --- | --- | --- |
| Silent h and Stable Vowels | `es.a0.m06.l016` | Spanish Vowels, h, and First Sounds |
| Greetings | `es.a0.m01.l001` | Hello and Goodbye |
| ñ, j and ll | `es.a0.m06.l017` | ñ, j and ll in Names |
| Me llamo | `es.a0.m02.l004` | My Name Is |
| Transport or Health | `es.a0.m06.l036` | Transport |

The generated semantic pilot bundle is:

```text
app/assets/languages/spanish/localization/semantic_pilot_lessons.json
```

The bundle is generated deterministically by:

```text
app/tool/generate_semantic_pilot_bundle.dart
```

It is loaded alongside the existing R2E4B reference slice:

```text
app/assets/languages/spanish/localization/semantic_reference_slice.json
```

## Architecture Result

The runtime semantic loader supports multiple semantic localization assets and
combines them into one `SemanticLocalizationBundle`.

The educational-content resolver prefers approved semantic units before legacy
string overlays for migrated fields. For the pilot, semantic resolution covers
support-language fields and learner-visible target-language fields that must
remain unchanged, including vocabulary terms, example sentences, dialogue
target lines, reading target text and answer-option labels.

Legacy localization remains loadable for unmigrated course content only. It is
not counted as completed semantic localization.

## QA Access Path

A narrow debug-only QA route was added for this phase:

```text
/debug/semantic-pilot
/debug/semantic-pilot/lesson/:lessonId
```

The route and Settings entry are available only when both conditions are true:

```text
kDebugMode
--dart-define=SEMANTIC_QA=true
```

The QA path is limited to the exact five pilot lesson IDs. Unknown lesson IDs
and non-pilot lesson IDs are rejected. QA lesson completion uses
`persistCompletion: false`, so it does not execute the durable lesson completion
command, does not invalidate production progress providers, and does not unlock
later lessons.

Production course navigation is unchanged. Locked production lessons remain
locked from the course screen.

## Complete-Lesson Coverage

The R2E4C lesson validator checks expected learner-visible fields collected
from the selected production lessons and referenced production content assets.

Result:

```text
lessons migrated: 5
expected learner-visible fields: 369
semantic covered fields: 369
coverage: 100.0%
legacy fallback: 0
generated: 0
issues: 0
```

This means every expected learner-visible field for the five pilot lessons has
an approved semantic unit for the migrated scope.

## Combined Semantic Inventory

The combined semantic scope contains the R2E4B reference slice plus the R2E4C
complete-lesson pilot.

Result:

```text
semantic units: 381
approved units: 381
generated units: 0
migrated field keys: 381
legacy fields: 2742
legacy-only fields: 2574
validation issues: 0
```

The `legacy-only fields` value is expected. It represents unmigrated content
outside the pilot and must not be interpreted as semantic localization failure
inside the R2E4C pilot scope.

## Validation Evidence

Commands run from `app/`:

```text
dart run tool/generate_semantic_pilot_bundle.dart
PASS, semantic units: 363

dart run tool/validate_semantic_localization_units.dart
PASS, issues: 0

dart run tool/validate_semantic_lesson.dart
PASS, coverage: 100.0%, legacy fallback: 0, issues: 0

dart run tool/report_semantic_localization_coverage.dart
PASS, validation issues: 0

flutter analyze
PASS, no issues found

flutter test --reporter compact --concurrency=1
PASS, 467 tests

flutter build apk --debug
PASS, built build/app/outputs/flutter-apk/app-debug.apk

flutter build apk --debug --dart-define=SEMANTIC_QA=true
PASS, built build/app/outputs/flutter-apk/app-debug.apk
```

## Device QA Evidence

Device QA was completed on:

```text
Device: Xiaomi Redmi Note 8T
Device codename: willow
Android: 13
ADB serial: a131f5c9
APK path: app/build/app/outputs/flutter-apk/app-debug.apk
Install command: adb install -r build/app/outputs/flutter-apk/app-debug.apk
Install result: Success
App data: preserved; no clear-data/delete-app step was used
```

The QA APK exposed the Settings QA entry and the semantic pilot launcher. The
launcher listed exactly the five pilot lesson IDs with semantic diagnostics and
`legacy fallback: 0`.

Each pilot lesson was opened through the gated QA route:

```text
es.a0.m06.l016
es.a0.m01.l001
es.a0.m06.l017
es.a0.m02.l004
es.a0.m06.l036
```

Observed QA result:

```text
All five lessons opened with the QA banner:
QA ONLY - semantic pilot, progress is not saved

Ukrainian semantic titles and descriptions were visible for all five lessons.
Spanish target text, IPA and learner answer content remained preserved.
Transport (`es.a0.m06.l036`) was opened through QA while still locked in
production course navigation.
Transport was traversed through all 8 steps and finished in QA mode.
```

After finishing Transport in QA mode, production course navigation was checked:

```text
Course progress remained: Виконано 21 з 70 уроків
Transport remained: Транспорт / Урок 36 · Заблоковано
```

This confirms the QA path did not mutate production lesson progress or unlock
state.

## Device-Discovered Fixes

Manual device traversal found and fixed Ukrainian pilot-scope editorial issues
in the generated semantic sources, including:

```text
испанскими -> іспанськими
мягким -> мʼяким
русскоязичного ученьа -> україномовного учня
самостоятельний -> окремий
Ударение / второй склад / последний склад -> Наголос / другий склад / останній склад
идти / ехать -> рух пішки
intercity -> міжміський
movement -> руху
Частотний місто транспорт -> Поширений міський транспорт
```

The semantic pilot bundle was regenerated after these source fixes and the
semantic validation gates were rerun.

Manual traversal also exposed a landscape keyboard bottom overflow in the
lesson navigation controls. The controls now remove the extra bottom inset while
the keyboard is visible, and focused lesson-player tests pass after the fix.

## Follow-Up Gates

- Keep broad Ukrainian course translation gates open until the full Spanish A0
  Ukrainian scope is migrated and approved.
- Re-run full localized course device QA when the full Ukrainian course scope is
  ready, not just the five-lesson semantic pilot.
