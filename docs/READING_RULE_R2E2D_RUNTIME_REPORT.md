# Reading Rule R2E2D Runtime Report

Status: EVIDENCE
Scope: language pronunciation/reading implementation evidence
Normative authority: PRONUNCIATION_MODEL.md
device was connected

Phase: R2E2D — Reusable ReadingRule Runtime Integration

## Summary

R2E2D promotes the Spanish A0 pronunciation reading rules from thin embedded
metadata into reusable runtime educational knowledge.

The implementation keeps the existing architecture intact:

- no lesson planning changes;
- no answer-evaluation changes;
- no persistence changes;
- no curriculum reordering;
- no generated or AI-created pronunciation content.

## Runtime Model

ReadingRule now represents reusable target-language reading knowledge.

The runtime model supports:

- stable rule ID;
- schema version;
- knowledge domain;
- rule kind;
- target language;
- pronunciation variety;
- orthographic pattern;
- phonetic outcome;
- optional IPA representation;
- applicability;
- exceptions;
- example PronunciationUnit IDs;
- related content IDs;
- difficulty;
- metadata.

Localized ReadingRule learner support is separate from the base rule and
supports:

- title;
- short explanation;
- detailed explanation;
- articulation hint;
- common mistakes;
- contrast note;
- metadata.

## Migrated Rules

The Spanish A0 reference slice now contains 12 migrated ReadingRules:

- silent h;
- ñ;
- j;
- ll/y;
- single r;
- rr;
- b/v;
- c/z;
- g before e/i;
- stable vowels;
- diphthong ue;
- written stress.

Each rule has:

- declared target language `es`;
- pronunciation variety `es-general`;
- orthographic pattern;
- phonetic definition;
- at least one example PronunciationUnit;
- English learner support;
- Russian learner support.

## Relationship Model

PronunciationUnits reference ReadingRules by stable ID.

ReadingRules list example PronunciationUnit IDs.

The catalog supports:

- Unit to ReadingRules lookup;
- ReadingRule to example PronunciationUnits lookup;
- localized ReadingRule presentation resolution;
- support-locale-safe fallback behavior.

Correctness and validation do not depend on localized ReadingRule titles or
explanation text.

## Validation

Implemented deterministic validation codes include:

- `readingRule.duplicateId`;
- `readingRule.missingTargetLanguage`;
- `readingRule.missingVariety`;
- `readingRule.missingOrthographicPattern`;
- `readingRule.missingPhoneticDefinition`;
- `readingRule.unknownPronunciationUnitReference`;
- `readingRule.targetLanguageMismatch`;
- `readingRule.varietyMismatch`;
- `readingRule.localizedEntryWithoutBaseRule`;
- `readingRule.missingLocalizedTitle`;
- `readingRule.missingLocalizedExplanation`;
- `readingRule.duplicateExampleReference`;
- `readingRule.noExamples`.

Deferred/documented validation categories:

- `readingRule.crossLocaleExplanationFallback`;
- `readingRule.unusedRule`;
- `readingRule.exerciseUsesLocalizedTextIdentity`.

## Coverage Snapshot

Latest pre-final coverage snapshot:

```text
readingRulesDiscovered=12
readingRulesMigrated=12
readingRulesWithVariety=12
readingRulesWithPhoneticDefinition=12
readingRulesWithEnglishLocalization=12
readingRulesWithRussianLocalization=12
readingRulesWithExamples=12
readingRulesReferencedByPronunciationUnits=12
readingRulesReferencedByLessons=4
readingRulesReferencedByExercises=2
unusedReadingRules=0
invalidReadingRuleReferences=0
crossLocaleReadingRuleFallbackAttempts=0
```

## Known Limitations

This is a runtime foundation for the migrated Spanish A0 pronunciation slice.
It does not complete pronunciation migration for all vocabulary in the Spanish
A0 course.

ReadingRules are currently resolved through the pronunciation catalog and
related content references. LessonAssemblyService remains unchanged and does
not load ReadingRules as ordinary LessonContent items.

Full direct LessonDefinition references to ReadingRules may be added in a
later content/assembly phase if needed.

Audio remains deferred.

## Validation Log

Completed:

- `dart run tool/validate_pronunciation_content.dart`
  - result: `issues=0`, `errors=0`, `warnings=0`
- `dart run tool/report_pronunciation_coverage.dart`
  - result: deterministic ReadingRule coverage reported 12 migrated rules and
    0 invalid ReadingRule references
- `flutter gen-l10n`
  - result: pass
- `flutter analyze`
  - result: pass, no issues found
- `flutter test test/core/content --reporter compact --concurrency=1`
  - result: pass
- `flutter test test/features/lesson_assembly --reporter compact --concurrency=1`
  - result: pass
- `flutter test test/features/lesson_player --reporter compact --concurrency=1`
  - result: pass
- `flutter test --reporter compact --concurrency=1`
  - result: pass, 426 tests
- `flutter build apk --debug`
  - result: pass, built `build/app/outputs/flutter-apk/app-debug.apk`
- `git diff --check`
  - result: pass

Blocked:

- `adb install -r build/app/outputs/flutter-apk/app-debug.apk`
  - not run because `adb devices -l` returned an empty device list.
