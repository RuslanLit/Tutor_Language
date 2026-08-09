# PRONUNCIATION_R2E2B_IMPLEMENTATION_REPORT.md

Status: EVIDENCE
Scope: language pronunciation/reading implementation evidence
Normative authority: PRONUNCIATION_MODEL.md

Phase: R2E2B - Pronunciation Model Foundation and Russian Pronunciation Recovery

---

# Purpose

This report records the first runtime foundation for pronunciation as reusable
educational knowledge.

R2E2B implements a production reference slice only. It does not claim full
Spanish A0 pronunciation migration.

---

# Current Legacy Inventory

Inventory tool:

```text
app/tool/inventory_pronunciation_content.dart
```

Current inventory:

| Metric | Count |
| --- | ---: |
| legacy pronunciation fields | 166 |
| unique target forms | 154 |
| duplicate pronunciation strings | 8 |
| English-oriented legacy hints | 146 |
| pronunciation units migrated | 18 |
| reading rules | 12 |
| units with IPA | 15 |
| units with English hints | 18 |
| units with Russian hints | 18 |
| unmigrated legacy entries | 148 |

Current legacy `pronunciation` strings are classified as
`LEGACY_ENGLISH_LEARNER_HINT` unless reviewed otherwise.

No legacy pronunciation string is treated as IPA.

---

# Current Pronunciation State

Content types with pronunciation-like data:

- Vocabulary: legacy `pronunciation` field.
- Grammar: reading-rule explanations such as silent `h` and stable vowels.
- Readings: reading-rule reinforcement texts.
- Exercise templates: pronunciation/reading prompts.
- Curriculum lessons: pronunciation-focused lesson metadata and references.

Current production render path:

- `LessonPlayerScreen` -> `VocabularyItemView`.

The older topic vocabulary card does not currently render pronunciation.

Answer evaluation does not depend on pronunciation display text.

Persisted learner records do not store pronunciation display strings.

---

# Storage Structure

Reference slice asset:

```text
app/assets/languages/spanish/pronunciation/reference_slice.json
```

The asset contains:

- locale-independent pronunciation units;
- reusable reading rules;
- support-locale learner hints and explanations for the migrated slice.

This is intentionally separate from the existing educational-content
localization overlay. Target orthography, IPA, rule IDs and pronunciation
variety are not support-language translations.

---

# Runtime Architecture

Files added:

- `app/lib/core/content/pronunciation_models.dart`
- `app/lib/core/content/pronunciation_catalog.dart`
- `app/lib/core/content/pronunciation_loader.dart`
- `app/lib/core/content/pronunciation_providers.dart`

Implemented concepts:

- `PronunciationUnit`
- `PronunciationUnitId`
- `PronunciationVariety`
- `IpaTranscription`
- `LocalizedPronunciationHint`
- `LocalizedPronunciationExplanation`
- `PronunciationReadingRule`
- `PronunciationValidationIssue`
- `PronunciationCoverageReport`
- `ResolvedPronunciationPresentation`

Widgets receive resolved pronunciation presentation data. Widgets do not
inspect locale maps or perform fallback policy.

---

# Selected Variety

Identifier:

```text
es-general
```

Policy:

- beginner-oriented general Spanish reference;
- broad phonemic IPA where reviewed;
- primary stress marked where pedagogically useful;
- regional distinctions are not presented as universal;
- `c/z`, `ll/y`, `j`, `b/v`, `r/rr` remain explicitly policy-bound.

---

# Reference Slice

Migrated words and phrases:

- `hola`
- `adiós`
- `hasta luego`
- `José`
- `España`
- `autobús`

Migrated sounds/rules:

- silent `h`
- `ñ`
- `j`
- `ll`
- `y`
- `r`
- `rr`
- `b/v`
- `c/z`
- `g` before `e/i`
- stable vowels
- `ue` diphthong
- primary stress

Reuse proven:

- `pronunciation.es.rule.silent_h.v1` is referenced by multiple units.
- `hola` is referenced by vocabulary, dialogues, readings and exercises.
- migrated pronunciation appears through Lesson Player vocabulary rendering.

---

# Russian Recovery

Representative before/after:

| Target | Legacy English hint | Russian hint |
| --- | --- | --- |
| `hola` | `OH-lah` | `о́ла` |
| `adiós` | `ah-DYOHS` | `адьо́с` |
| `hasta luego` | `AHS-tah LWEH-goh` | `а́ста луэ́го` |
| `José` | English-oriented approximation | `хосе́` |
| `España` | English-oriented approximation | `эспа́нья` |

Russian hints are approximate learner aids, not IPA.

---

# Fallback Behavior

Implemented behavior:

```text
requested hint exists
    -> return requested hint

requested non-English hint missing, English hint exists
    -> do not return English hint

IPA exists and requested hint is missing
    -> IPA remains available in presentation

legacy pronunciation exists and support locale is English
    -> legacy hint may be shown

legacy pronunciation exists and support locale is Russian
    -> legacy English hint is hidden
```

Cross-locale learner-hint fallback is prohibited.

---

# Validation and Coverage

Typed issue codes include:

- `pronunciation.missingVariety`
- `pronunciation.missingTargetOrthography`
- `pronunciation.missingRequiredHint`
- `pronunciation.invalidIpa`
- `pronunciation.invalidStressNotation`
- `pronunciation.crossLocaleHintReuse`
- `pronunciation.unexpectedFallback`
- `pronunciation.targetMismatch`
- `pronunciation.duplicateId`
- `pronunciation.unknownReference`
- `pronunciation.unsupportedLocale`
- `pronunciation.legacyEnglishHintInNonEnglishLocale`
- `pronunciation.localizedEntryWithoutBaseUnit`

Reference-slice coverage:

- declared variety: 18/18;
- Russian hints: 18/18;
- IPA: 15/18;
- invalid units: 0;
- unknown references in tests: 0;
- cross-locale fallback during normal reference-slice resolution: 0.

---

# Deferred Migration

Deferred:

- full Spanish A0 pronunciation migration;
- complete IPA review;
- complete Russian pronunciation hints;
- Ukrainian hints;
- Polish hints;
- German hints;
- audio;
- ASR;
- speech scoring;
- pronunciation editor;
- external phonetic APIs;
- persistence changes.

---

End of document.
