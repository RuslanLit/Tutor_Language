# CONTENT_LOCALIZATION_R2E1_INVENTORY.md

Status: Active

Phase: R2E1 - English Source Normalization and Coverage Inventory

---

# Purpose

This document records the R2E1 educational-content localization inventory for
the Spanish A0 course.

R2E1 does not translate the course into additional support languages.

Its purpose is to prove that every required support-language field has been
identified and has canonical English source text before Russian, Ukrainian,
Polish or German translation begins.

---

# Scope

Inventory source:

- `app/assets/languages/spanish/curriculum/spanish_a0_course.json`
- `app/assets/languages/spanish/vocabulary/`
- `app/assets/languages/spanish/grammar/`
- `app/assets/languages/spanish/dialogues/`
- `app/assets/languages/spanish/readings/`
- `app/assets/languages/spanish/templates/`

Localization overlay:

- `app/assets/languages/spanish/localization/support_localizations.json`

Generation tool:

- `app/tool/generate_content_localization_source.dart`

Validation test:

- `app/test/core/content/content_localization_test.dart`

---

# Field Classification

## TARGET_LANGUAGE

Spanish material being learned:

- vocabulary `spanish`
- vocabulary examples when they are Spanish target-language examples
- dialogue line `spanish`
- reading `text`
- target-language `expected_answer`
- target-language `accepted_answers`
- target-language `accepted_with_feedback_answers.answer`
- target-language `canonical_answer`

These fields must not be translated by support locale.

## SUPPORT_LANGUAGE

Learner-facing educational text:

- course title
- module title
- lesson title
- lesson description
- lesson communicative outcome
- lesson objective description
- lesson section title
- lesson activity title
- lesson summary review prompt
- vocabulary `native_translation`
- vocabulary `notes`
- grammar title
- grammar explanation
- grammar examples when they include support-language explanation or glosses
- dialogue title
- dialogue line `native_translation`
- reading title
- reading `native_translation`
- exercise `prompt_template`
- exercise answer option labels when the visible option is support-language
  text

These fields require canonical English source text in R2E1. Answer option
labels that are Spanish target-language choices remain `TARGET_LANGUAGE` and
must not be translated by support locale.

## LOCALE_INDEPENDENT

Stable educational structure:

- IDs
- asset paths
- references
- ordering
- CEFR values
- lesson version
- prerequisite IDs
- exercise type
- goal type
- object type
- correctness keys
- correct option IDs
- exact-answer policy
- review template IDs
- misconception IDs
- feedback keys
- explanation reference IDs

These fields must remain identical across support locales.

## UI_LOCALIZATION

Generic application chrome and generic feedback labels remain in Flutter ARB.

Examples:

- Back
- Next
- Check answer
- Settings
- generic correct / incorrect labels
- generic route and screen labels

## TECHNICAL_INTERNAL

Implementation details:

- package names
- database names
- route names
- Android identifiers
- file system layout

---

# English Coverage Report

Locale: `en`

| Content area | Total localizable fields | English source fields | Missing fields | Invalid fields | Coverage |
| --- | ---: | ---: | ---: | ---: | ---: |
| course metadata | 1 | 1 | 0 | 0 | 100% |
| module metadata | 9 | 9 | 0 | 0 | 100% |
| lesson metadata | 210 | 210 | 0 | 0 | 100% |
| lesson objectives | 70 | 70 | 0 | 0 | 100% |
| lesson sections | 70 | 70 | 0 | 0 | 100% |
| lesson activities | 311 | 311 | 0 | 0 | 100% |
| lesson summaries | 70 | 70 | 0 | 0 | 100% |
| vocabulary | 515 | 515 | 0 | 0 | 100% |
| grammar | 374 | 374 | 0 | 0 | 100% |
| dialogues | 353 | 353 | 0 | 0 | 100% |
| readings | 152 | 152 | 0 | 0 | 100% |
| exercise prompts | 495 | 495 | 0 | 0 | 100% |
| support-language answer options | 111 | 111 | 0 | 0 | 100% |

Total localizable fields: 2741

Translated fields: 2741 English source fields

Missing fields: 0

Fallback fields: 0 for English

Invalid fields: 0

Coverage percentage: 100%

---

# R2E1 Boundary

R2E1 intentionally does not complete Russian, Ukrainian, Polish or German
localization.

Those locales may still fall back to English until their dedicated phases:

- R2E2 Russian
- R2E3 Ukrainian
- R2E4 Polish
- R2E5 German

Release validation for a translated support locale must require:

- missing required fields = 0
- runtime fallback fields = 0
- invalid fields = 0
- coverage = 100%

---

End of document.
