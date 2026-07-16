# Educational Localization Reset Inventory

Phase: R2E5R

Starting HEAD: `4898f408075bc30f4b466b45be1c901d11ff3b75`

This inventory was created before destructive reset edits. It classifies the
current Ukrainian and Russian educational-localization sources and records the
reset decision for each file or file family.

## Summary

| Category | Active items before reset | Reset decision |
| --- | ---: | --- |
| Ukrainian legacy educational fields | 2742 | Clear from production legacy overlay |
| Russian legacy educational fields | 2742 | Clear from production legacy overlay |
| Ukrainian semantic units | 589 approved values | Deactivate from production bundles |
| Russian semantic units | 0 found | Keep empty clean structure |
| Ukrainian pronunciation unit hints | 751 unit hints, 749 localization hints | Clear |
| Russian pronunciation unit hints | 751 unit hints, 746 localization hints | Clear |
| Ukrainian pronunciation explanations/rule text | 490 localized fields | Clear |
| Russian pronunciation explanations/rule text | 487 localized fields | Clear |
| Ukrainian/Russian UI localization | Flutter ARB/UI layer | Preserve |
| Polish localization | Not started | Remain blocked |

## File Classification

| Path | Category | Ownership | Locale | Canonical | Generated | Runtime-loaded | Production-used | Preserve | Clear | Retire | Rationale |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `app/assets/languages/spanish/curriculum/course.json` | A/C | Course/module order and Spanish target course metadata | es/en source model | yes | no | yes | yes | yes | no | no | Defines canonical course identity, modules and ordering. |
| `app/assets/languages/spanish/curriculum/lessons/*.json` | A/B/C | Canonical lesson metadata, learner flow and English source fields | es/en | yes | no | yes | yes | yes | no | no | Must not change lesson IDs, module IDs, course order or English source. |
| `app/assets/languages/spanish/vocabulary/*.json` | B/C | Spanish vocabulary, English meanings, accepted content references | es/en | yes | no | yes | yes | yes | no | no | Canonical Spanish vocabulary and English source inventory. |
| `app/assets/languages/spanish/grammar/*.json` | B/C | Spanish grammar content and English educational source | es/en | yes | no | yes | yes | yes | no | no | Canonical target/source content. |
| `app/assets/languages/spanish/dialogues/*.json` | B/C | Spanish dialogue lines and English source translations | es/en | yes | no | yes | yes | yes | no | no | Canonical Spanish dialogue content. |
| `app/assets/languages/spanish/readings/*.json` | B/C | Spanish readings and English source translations | es/en | yes | no | yes | yes | yes | no | no | Canonical Spanish reading content. |
| `app/assets/languages/spanish/templates/*.json` | A/B/C | Exercise prompts, canonical answers and accepted answers | es/en | yes | no | yes | yes | yes | no | no | Correctness data and accepted answers must remain unchanged. |
| `app/assets/languages/spanish/localization/support_localizations.json` | B/D/E | Legacy educational support overlay | en/uk/ru | mixed | generated/edited | yes | yes | yes | uk/ru only | no | Preserve English source and identities; clear unreliable Ukrainian and Russian values. |
| `app/assets/languages/spanish/localization/semantic_reference_slice.json` | H | Old Ukrainian semantic reference slice | uk/en | no | mixed | yes before reset | yes before reset | structure only | uk production values | no | Approved flags predate the reset standard; must not be production-loaded as Ukrainian content. |
| `app/assets/languages/spanish/localization/semantic_pilot_lessons.json` | H | Old Ukrainian pilot semantic bundle | uk/en | no | generated/edited | yes before reset | yes before reset | structure only | uk production values | no | Pilot data remains recoverable through Git; production runtime should not treat it as completed localization. |
| `app/assets/languages/spanish/localization/semantic/module_1.uk.json` | H | R2E5A Ukrainian Module 1 bundle | uk/en | no | generated/edited | yes before reset | yes before reset | structure only | uk production values and completed scope | no | R2E5R supersedes R2E5A completion; Module 1 production completion must be cleared. |
| `app/assets/languages/spanish/localization/semantic/manifests/educational_locales.json` | A | Reset readiness manifest | en/uk/ru | policy source | no | yes after reset | yes | yes | no | no | Single source of truth for educational locale readiness. |
| `app/assets/languages/spanish/localization/semantic/uk/shared.json` | H | Clean future Ukrainian semantic scaffold bundle | uk | no | scaffold | yes after reset | no production units | yes | no | no | Empty or draft-only semantic-only rebuild target. |
| `app/assets/languages/spanish/localization/semantic/ru/shared.json` | I | Clean future Russian semantic scaffold bundle | ru | no | scaffold | yes after reset | no production units | yes | no | no | Empty placeholder; Russian follows Ukrainian. |
| `app/assets/languages/spanish/pronunciation/reference_slice.json` | A/F/G | Pronunciation units, IPA, rules and localized learner hints | es/en/uk/ru | mixed | generated/edited | yes | yes | canonical fields | uk/ru hints and explanations | no | Preserve unit IDs, IPA and rules; clear unreviewed Ukrainian/Russian learner hints and rule prose. |
| `app/lib/core/content/semantic_localization.dart` | K | Semantic model, review state, resolver and validators | all | architecture | no | yes | yes | yes | no | no | Infrastructure is preserved; reset validation may be tightened. |
| `app/lib/core/content/content_localization.dart` | K | Legacy and semantic educational localization runtime | all | architecture | no | yes | yes | yes | no | no | Preserve resolver; ensure reset manifest and clean semantic bundles are used. |
| `app/lib/core/content/content_localization_providers.dart` | K | Runtime providers | all | architecture | no | yes | yes | yes | no | no | Preserve and expose readiness manifest. |
| `app/lib/core/content/semantic_pilot_scope.dart` | K | Debug semantic QA scope | uk debug | no | no | debug | no production | yes | no | no | Keep as QA-only historical pilot support. |
| `app/lib/core/content/pronunciation_catalog.dart` | K | Pronunciation runtime resolver | all | architecture | no | yes | yes | yes | no | no | Preserve; it must not cross-fallback between Ukrainian and Russian. |
| `app/lib/core/content/pronunciation_models.dart` | K | Pronunciation schema/model | all | architecture | no | yes | yes | yes | no | no | Preserve IDs, IPA and schema behavior. |
| `app/tool/translate_content_localization_uk.dart` | J | Legacy Ukrainian prose generator | uk | no | yes | no | dangerous if run | no production use | no | yes | Generated from Russian/replacement tables; add hard archive guard. |
| `app/tool/translate_content_localization_ru.dart` | J | Legacy Russian prose generator | ru | no | yes | no | dangerous if run | no production use | no | yes | Old prose generator must not author production localization. |
| `app/tool/generate_semantic_module_1_bundle.dart` | J | R2E5A Ukrainian semantic migration generator | uk | no | yes | no | dangerous after reset | no production use | no | yes | Module 1 production migration is superseded by reset. |
| `app/tool/generate_semantic_pilot_bundle.dart` | J/K | Historical pilot generator | uk | no | yes | no | QA archaeology only | yes as archived tool | no | yes for production | Must not be recommended for production localization. |
| `app/tool/audit_ukrainian_content_localization.dart` | K | Legacy Ukrainian quality audit | uk | no | no | no | diagnostic | yes | no | no | Keep as historical/diagnostic, not as production proof. |
| `app/tool/audit_foundational_russian_presentation.dart` | K | Russian presentation audit | ru | no | no | no | diagnostic | yes | no | no | Keep diagnostic audit; does not generate content. |
| `app/tool/audit_localization_architecture.dart` | K | Architecture audit | all | no | no | no | validation | yes | no | no | Preserve validation. |
| `app/tool/audit_semantic_ukrainian_migration.dart` | K | Ukrainian semantic migration gate | uk | no | no | no | validation | yes | no | no | Update so reset reports not-ready without false PASS. |
| `app/tool/report_semantic_localization_coverage.dart` | K | Coverage reporter | all | no | no | no | validation | yes | no | no | Update to reset-aware zero-production semantics. |
| `app/tool/validate_semantic_localization_units.dart` | K | Semantic unit validator | all | no | no | no | validation | yes | no | no | Update away from required Ukrainian reference slice. |
| `app/tool/validate_semantic_lesson.dart` | K | Historical pilot validator | uk debug | no | no | no | validation | yes | no | no | Keep QA-only; production reset must not depend on it. |
| `app/tool/generate_content_localization_source.dart` | K | English source inventory generator | en | yes | no | no | authoring support | yes | no | no | Preserves canonical source workflow. |
| `app/tool/create_semantic_localization_scaffold.dart` | K | New semantic-only scaffold workflow | future locales | no | deterministic scaffold | no | authoring support | yes | no | no | Creates draft scaffolds, never approved prose. |
| `app/tool/audit_educational_localization_reset.dart` | K | Reset audit | en/uk/ru | no | no | no | validation | yes | no | no | Enforces fail-closed reset state and integrity counts. |
| `app/lib/l10n/*.arb` | M | Flutter UI localization | UI locales | yes for UI | no | yes | yes | yes | no | no | Ukrainian and Russian UI must remain available. |
| `docs/UKRAINIAN_TRANSLATION_MEMORY.md` | L | Historical Ukrainian translation memory | uk | no | mixed | no | docs | archive | no | yes | Not automatically trustworthy; archive as legacy. |
| `docs/UKRAINIAN_SEMANTIC_AUTHORING_LEXICON.md` | L | Clean Ukrainian semantic lexicon | uk | no | no | no | authoring docs | yes | no | no | Minimal reviewed terminology only. |
| `docs/RUSSIAN_SEMANTIC_AUTHORING_LEXICON.md` | L | Clean Russian semantic lexicon placeholder | ru | no | no | no | authoring docs | yes | no | no | Placeholder only; no generated translations. |
| `docs/R2E5*_REPORT.md` and earlier localization reports | L | Historical phase reports | uk/ru | no | no | no | docs | yes | no | no | Keep honest history; mark superseded by R2E5R where appropriate. |

## Reset Policy Chosen

Temporary runtime behavior: Option A, English educational fallback.

- Ukrainian and Russian Flutter UI localization remains available.
- Ukrainian and Russian educational localization state is `rebuilding`.
- English source educational content remains available.
- Ukrainian never falls back to Russian.
- Russian never falls back to Ukrainian.
- Completed semantic modules for Ukrainian and Russian are empty.
- Production semantic readiness for Ukrainian and Russian is false.
