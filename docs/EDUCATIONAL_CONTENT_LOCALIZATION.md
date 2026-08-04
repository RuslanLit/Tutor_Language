# EDUCATIONAL_CONTENT_LOCALIZATION.md

Status: Active

Version: 1.1

Related documents:

- PROJECT_VISION.md
- PROJECT_CONTRACT.md
- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md
- CONTENT_MODEL.md
- CURRICULUM_SPEC.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- WRITING_SYSTEM_STANDARD.md
- WRITING_UNIT_INTRODUCTION_STANDARD.md
- PRONUNCIATION_MODEL.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- RELEASE_CHECKLIST.md

---

# Purpose

This document defines how authored educational content is localized in Tutor
Language.

Application interface localization and educational-content localization are
separate systems.

Flutter ARB files localize product UI.

Educational-content localization belongs to the content system.

For migrated production scope, localized educational content must use typed
SemanticLocalizationUnit data as defined in
SEMANTIC_LOCALIZATION_UNIT_STANDARD.md. Legacy locale overlays remain readable
during migration but are transitional.

---

# Terminology

## UI Locale

The language of application chrome:

- buttons;
- navigation;
- settings;
- generic statuses;
- generic accessibility labels.

UI locale is handled by Flutter `AppLocalizations`.

## Support Locale

The learner's explanatory language for authored educational content:

- vocabulary meanings;
- grammar explanations;
- authored task prompts;
- support-language answer options;
- dialogue translations;
- reading translations;
- authored remediation and misconception explanations.

For version 1, support locale follows the resolved UI locale.

Unsupported support locales fall back to English.

Future versions may allow UI locale and support locale to differ.

## Target Language

The language being learned.

For the first release, the target language is Spanish.

Target-language material remains unchanged across support locales.

Examples:

- `hola`
- `adiós`
- `¿Cómo te llamas?`

Writing-system identity is target-language content. WritingUnit stable IDs,
orthography, target language, writing system, official target-language names,
confusable target symbols and target examples are not localized. Learner-facing
display names, symbol explanations, visual-recognition guidance, memory hints
and accessibility descriptions are support-language content. See
WRITING_SYSTEM_STANDARD.md.

When a WritingUnit has a conventional target-language name, the name itself is
not translated across support locales. Localized name pronunciation hints,
designations and learner explanations are support-language content. A
localized learner hint must not replace target-language notation, pinyin, IPA
or other declared canonical reading notation. See
WRITING_UNIT_INTRODUCTION_STANDARD.md.

Pronunciation is a special case. Target orthography, pronunciation variety and
IPA are locale-independent pronunciation data. Learner pronunciation hints and
pronunciation explanations are support-language content. English learner hints
must not fall back into non-English support locales in production.

IPA is the canonical textual pronunciation representation and is not
translated. It remains the same for English, Russian, Ukrainian, Polish,
German and any other support locale.

Localized pronunciation hints are learner support. They may differ by support
language and must follow the pronunciation-hint profile for that support
locale. For multi-syllable words, localized hints must mark stress explicitly.

Localized pronunciation explanations are support-language teaching text. They
explain issues such as silent letters or stress placement, but they do not
replace IPA or pronunciation variety.

Language-specific pronunciation policies remain target-course knowledge. For
Spanish A0, `ll` and consonantal `y` follow
SPANISH_LLY_PRONUNCIATION_POLICY.md. Localized hints must match that policy and
must not introduce a conflicting support-locale approximation.

PronunciationUnit IDs, related vocabulary/grammar references, reading-rule
references, audio reference IDs, difficulty and technical metadata remain
locale-independent. Localized learner hints and localized pronunciation
explanations are localized support content.

ReadingRules are reusable target-language educational knowledge. Their stable
IDs, target language, pronunciation variety, orthographic pattern, phonetic
outcome, IPA representation, examples and related content references are not
localized. ReadingRule learner support is localized separately through titles,
short explanations, detailed explanations, articulation hints, common mistakes
and contrast notes.

Localized grapheme presentations are support-language content. Letter names,
learner-facing contrast explanations and accessibility descriptions must be
authored per support locale. The canonical grapheme and confusable target
forms remain locale-independent ReadingRule data.

Russian, Ukrainian, Polish, German or other support modes must never display an
English ReadingRule title or explanation as a production fallback. If localized
rule support is missing, the renderer should omit the learner-facing text or
surface a development diagnostic rather than showing another locale's
explanation.

R2E2C prohibits cross-locale learner-hint fallback in the pronunciation
runtime reference implementation. English pronunciation hints must not be shown as a
fallback in Russian mode.

## Locale-Independent Data

The following must not vary by support locale:

- stable IDs;
- content type;
- target-language forms;
- CEFR level;
- references;
- ordering;
- exercise type;
- answer correctness policy;
- target-language canonical answers;
- mastery rules;
- learner progress identifiers.

---

# Storage Strategy

Tutor Language uses locale overlays for educational-content localization.

Base content stores stable educational identity, target-language material,
locale-independent metadata and English support text during the migration
period.

Localization overlays store support-language fields keyed by stable content ID.

Changing a support translation must not rewrite Spanish target-language data.

Current production overlay:

```text
app/assets/languages/spanish/localization/support_localizations.json
```

---

# Runtime Resolution

The runtime flow is:

```text
resolved UI locale
        |
        v
SupportLocaleResolver
        |
        v
EducationalContentLocalizationResolver
        |
        v
localized educational view models
        |
        v
rendering widgets
```

Widgets must not manually inspect locale codes or select localized fields.

Pure content-domain code receives a `SupportLocale` value and does not depend
on `BuildContext`.

For version 1:

```text
en -> en
uk -> uk
ru -> ru
pl -> pl
de -> de
other -> en
```

---

# Fallback Policy

Runtime fallback:

```text
requested locale field exists
    -> requested locale text

requested locale field missing
    -> English source support text

unsupported locale
    -> English source support text
```

Authoring validation is stricter than runtime fallback.

Missing English source support text is a validation error.

Fallback keeps the application usable, but it must not make incomplete
translation packages appear release-complete.

---

# Release Status

R2E1 established the canonical English source inventory for Spanish A0:

- total localizable source fields: 2742;
- missing English source fields: 0;
- invalid fields: 0;
- English coverage: 100%.

R2E2 completed Russian support localization for the same inventory:

- Russian localized fields: 2742;
- Russian fallback fields: 0;
- invalid fields: 0;
- Russian coverage: 100%.

R2E2A added the Russian quality gate:

- forbidden English instructional fragments in Russian support text: 0;
- generator suspicious identical fields: 0;
- mixed-language validation findings: 0.

Structural coverage alone is not sufficient for release-complete support
localization. A support locale must also pass the quality gate for untranslated
or mixed-language learner-facing text.

R2E4B adds a stricter semantic gate for migrated reference slices: learner-facing
semantic units must be approved, protected target spans must be preserved, named
entities must be typed and pronunciation hints must remain separate from
meanings.

Historical Spanish A0 semantic pilot bundles were removed during the course
reset. Future semantic pilots must declare their lesson scope from the new
course content and remain validated by:

```text
app/tool/validate_semantic_lesson.dart
```

The pilot gate requires 100% expected learner-visible field coverage and zero
legacy fallback for the declared lessons. It is not a coverage expansion for an
unmigrated full course.

R2E5R supersedes the Ukrainian and Russian legacy educational localization
state. Ukrainian and Russian UI localization remains available, but educational
content for `uk` and `ru` is explicitly `rebuilding` and temporarily uses
English source fallback only. No Ukrainian or Russian legacy educational value,
pronunciation hint or semantic production unit may be treated as release-ready.

The readiness source of truth is:

```text
app/assets/languages/spanish/localization/semantic/manifests/educational_locales.json
```

New localized educational content must be authored as draft/generated semantic
scaffolds, then reviewed before any `approved` status is set:

```text
dart run tool/create_semantic_localization_scaffold.dart
```

R2E5 adds a full-course Ukrainian semantic migration audit:

```text
app/tool/audit_semantic_ukrainian_migration.dart
```

This audit compares approved Ukrainian semantic units with the legacy
educational localization inventory. It is a production gate for Ukrainian:
release-ready Ukrainian educational content requires zero remaining legacy
resolutions, zero source fallback, zero missing fields, zero generated units
and zero unapproved semantic units. As of the R2E5 audit, Ukrainian remains
incomplete because 2574 legacy Ukrainian fields still resolve outside the
semantic source of truth.

Ukrainian, Polish and German educational-content translations remain separate
future phases. Until those phases complete, they may fall back to English at
runtime and must not be treated as release-complete educational-content
locales.

---

# Field Ownership

Every authored field must be classified.

## TARGET_LANGUAGE

Spanish forms and sentences being learned:

- vocabulary `spanish`;
- dialogue line `spanish`;
- reading `text`;
- target-language expected answers.

## SUPPORT_LANGUAGE

Learner-facing explanatory content:

- `native_translation`;
- grammar `title`;
- grammar `explanation`;
- support-language examples;
- course/module/lesson titles;
- lesson descriptions;
- section and activity titles;
- exercise `prompt_template` when it gives learner instructions;
- answer option labels only when the visible option is support-language text;
- authored remediation and misconception explanation text.
- localized learner pronunciation hints;
- localized pronunciation explanations.

IPA transcription and pronunciation variety are not support-language
translations. They remain locale-independent pronunciation data.

## LOCALE_INDEPENDENT

Stable educational structure:

- IDs;
- references;
- ordering;
- CEFR;
- exercise type;
- correctness rules;
- mastery rules.

## UI_LOCALIZATION

Application chrome in ARB files:

- Back;
- Next;
- Check;
- Settings;
- generic feedback labels.

## TECHNICAL_INTERNAL

Implementation details:

- asset paths;
- route names;
- database names;
- package names.

---

# Answer Evaluation Boundary

Educational-content localization must not change deterministic correctness.

Target-language answers remain evaluated as target-language answers.

Support-language answer options should use stable option IDs where practical.

Changing a visible translation must not change which answer is correct.

Generic answer feedback remains in ARB.

Authored pedagogical feedback belongs to educational content when it explains a
specific misconception, remediation or knowledge distinction.

---

# Persistence Boundary

Learner progress must persist stable IDs and typed outcomes, not translated
display strings.

Changing a translation must not invalidate:

- lesson attempts;
- step results;
- mastery evidence;
- competency gaps;
- remediation history;
- lesson completion.

No database schema change is required for educational-content localization.

---

# Validation

Validation must detect:

- unknown localized IDs;
- unknown localized fields;
- duplicate localization entries;
- unsupported locale codes;
- missing English source support text;
- missing required English source fields;
- malformed locale maps.

Runtime fallback and release validation are separate.

Release validation for a completed support-language package may require full
coverage for that locale.

The complete R2E1 English source inventory is recorded in:

```text
docs/CONTENT_LOCALIZATION_R2E1_INVENTORY.md
```

The inventory generation tool is:

```text
app/tool/generate_content_localization_source.dart
```

Before translating any non-English support locale, English source coverage must
have:

- missing required fields = 0;
- invalid fields = 0;
- coverage = 100%.

---

# Coverage Reporting

The localization coverage report measures, by support locale:

- total localizable fields;
- translated fields;
- missing fields;
- fallback fields;
- coverage ratio.

R2D validates only a minimal production reference slice.

R2E1 validates full-course English source coverage before the translated
support locales are completed in later R2E stages.

---

# Migration Path

Current English support fields remain readable as canonical English source
content during migration.

The long-term direction is:

1. keep stable IDs and Spanish target-language content in base assets;
2. normalize English support fields into overlay coverage;
3. migrate complete lesson slices into reviewed SemanticLocalizationUnit
   bundles before broad support-locale expansion;
4. translate complete support overlays for Ukrainian, Russian, Polish and
   German;
5. keep runtime fallback for safety;
6. use validation to prevent incomplete release packages.

Legacy English-only support fields should not become a permanent second
localization system.

For Ukrainian, the semantic migration direction is now stricter:

1. do not mark generated or legacy-derived text as `approved` without
   review evidence;
2. migrate the remaining legacy Ukrainian fields into typed semantic units;
3. preserve protected target-language spans, IPA, entity distinctions and
   pronunciation-role separation;
4. pass `dart run tool/audit_semantic_ukrainian_migration.dart`;
5. complete representative device QA only after the semantic audit reports
   zero legacy fallback.

---

# R2D Reference Slice

R2D implements a minimal production reference slice for:

- Spanish A0 course title;
- Module 1 title;
- Lesson 1 title and description;
- selected Lesson 1 activity metadata;
- selected vocabulary;
- selected grammar;
- selected dialogue translations;
- selected reading translation;
- selected exercise prompt and answer option labels.

The slice includes English and Russian support text.

Ukrainian, Polish and German full-course translations are deferred.

---

End of document.

---

# R2E5N0A Semantic Scope Inventory

R2E5N0A reconciles Module 1 inventory only. The final scaffold/audit scope for
canonical Module 1 contains 263 support-localized required identities, with
missing, extra, duplicate and unresolved counts at zero. No Ukrainian text is
authored in this phase and runtime fallback/readiness policy remains unchanged.
