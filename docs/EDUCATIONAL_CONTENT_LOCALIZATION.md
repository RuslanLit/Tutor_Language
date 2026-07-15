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
- RELEASE_CHECKLIST.md

---

# Purpose

This document defines how authored educational content is localized in Tutor
Language.

Application interface localization and educational-content localization are
separate systems.

Flutter ARB files localize product UI.

Educational-content localization belongs to the content system.

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

- total localizable source fields: 2741;
- missing English source fields: 0;
- invalid fields: 0;
- English coverage: 100%.

R2E2 completed Russian support localization for the same inventory:

- Russian localized fields: 2741;
- Russian fallback fields: 0;
- invalid fields: 0;
- Russian coverage: 100%.

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
3. translate complete support overlays for Ukrainian, Russian, Polish and
   German;
4. keep runtime fallback for safety;
5. use validation to prevent incomplete release packages.

Legacy English-only support fields should not become a permanent second
localization system.

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
