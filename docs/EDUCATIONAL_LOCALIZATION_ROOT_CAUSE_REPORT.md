# Educational Localization Root-Cause Report

Phase: R2E4A diagnostic audit

Status: EVIDENCE
Scope: educational content localization phase evidence
Normative authority: EDUCATIONAL_CONTENT_LOCALIZATION.md

This report is intentionally diagnostic. It does not regenerate Ukrainian
localization, does not start Polish localization, and does not declare the
current Ukrainian bundle production-ready.

## Executive Verdict

The Ukrainian localization failures are not isolated bad strings. They are a
systemic result of a generator, data model and validation stack that treats many
educational strings as untyped text while the project documentation requires
field-specific educational semantics, target-language invariants, support-locale
review and pronunciation-specific modeling.

The current automated PASS labels from R2E3/R2E4 were false release signals:
they showed that deterministic blocker checks and runtime smoke paths passed,
not that Ukrainian learner-facing content passed editorial, linguistic,
pronunciation or localization review.

Polish localization must not begin from the current Ukrainian generator pattern.
The next phase must fix the localization architecture and review gates first.

## Evidence Summary

The diagnostic tool added in this phase is
`app/tool/audit_localization_architecture.dart`.

Observed output from `dart run app/tool/audit_localization_architecture.dart`:

| Severity | Count |
| --- | ---: |
| error | 11 |
| warning | 3637 |
| info | 1 |
| total | 3649 |

Representative finding classes:

| Finding code | Count | Meaning |
| --- | ---: | --- |
| `localization.entryUntypedUnreviewed` | 1704 | Localized entries lack per-field semantic typing and review metadata. |
| `uk.unclassifiedLatinSpan` | 1544 | Latin spans are present without explicit target/support segmentation. |
| `uk.mixedScriptNeedsSpanClassification` | 238 | Mixed Cyrillic/Latin strings need intentional pedagogical span metadata. |
| `localization.sameSourceDifferentContexts` | 79 | Same source string appears in different inferred semantic contexts. |
| `localization.sameSourceMultipleTargets` | 58 | Same source string has multiple Ukrainian outputs. |
| `pronunciation.hintEqualsMeaning` | 4 | Pronunciation hint and meaning are conflated. |
| `entity.surfaceWithoutEntityType` | 10 | Proper noun/toponym surfaces lack entity-type disambiguation. |
| `generator.*` | 5 | Ukrainian generator uses Russian conversion, exact overrides, embedded replacements and template morphology. |
| `audit.*` | 3 | Existing Ukrainian audit uses token/blocklist checks and skips important semantic review. |
| `runtime.sourceLocaleFallback` | 1 | Runtime can still load through source-locale fallback. |

The tool is diagnostic-only and exits 0 by design. Non-zero findings are the
result, not a tool failure.

## Root Causes

| ID | Root cause | Evidence | Consequence |
| --- | --- | --- | --- |
| RC1 | Localized assets are untyped string maps. | `LocalizedEducationalEntry` stores `Map<String, Map<String, String>>` in `app/lib/core/content/content_localization.dart:106-152`; the role enum at lines 10-16 is not carried by JSON entries. | The system cannot distinguish meaning, prompt, explanation, target phrase, name, country, pronunciation hint or review note when generating or validating localized text. |
| RC2 | The Ukrainian generator is deterministic string conversion, not educational localization. | `translate_content_localization_uk.dart:192-215` selects by `type`, `id`, `fieldName`, exact tables and broad strategies; `:447-470` converts Russian by phrase/word replacement plus Cyrillic substitution; `:473-490` does embedded dictionary replacement. | Russian artifacts, English fragments, unnatural syntax and semantic mistakes are expected outcomes. |
| RC3 | Template morphology is encoded as slash alternatives instead of grammatical generation. | `translate_content_localization_uk.dart:542-544`, `:615-620`, `:652-654` output forms such as `потрібен/потрібна`, `дорогий/дорога`, `Мій/моя`. | Ukrainian agreement, case and naturalness cannot be guaranteed. |
| RC4 | Pronunciation hints are derived mechanically from Russian hints. | `translate_content_localization_uk.dart:691-713` builds Ukrainian pronunciation support by substituting Russian hint text. | Support-locale pronunciation hints are not independently authored or reviewed, despite docs requiring locale-specific hints. |
| RC5 | Validation checks known leaks, not semantic correctness. | `audit_ukrainian_content_localization.dart:219-283` checks identical English/Russian, Russian-only letters, known forbidden words and known English words; `:294-319` allows broad Latin/Spanish-looking invariants; `:79-80` skips grammar examples. | Bad strings can pass if they are novel, Ukrainian-looking, Spanish-looking, or semantically wrong but token-clean. |
| RC6 | Runtime accepts whichever localized string exists. | `_field` returns `values[locale.code] ?? values[bundle.sourceSupportLocale]` in `content_localization.dart:431-445`; resolvers insert fields directly in `:316-429`. | A UI smoke test proves only that screens render, not that localized content is correct. |
| RC7 | Pronunciation rule applicability is not context-validated. | `silent_h` has pattern `h` in `reference_slice.json:15-25`; `Chile` references `silent_h` in `:17121-17135`; localized support explains silent `h` for `Chile` in `:28084-28092`. | The model allows the single-letter `h` rule to attach inside the Spanish `ch` digraph. |
| RC8 | Proper nouns/toponyms lack entity semantics. | `México` is a pronunciation unit with hint `ме́ксико` in `reference_slice.json:19831-19845`; vocabulary also uses country meanings in multiple files, but pronunciation units do not encode entity type, exonym, country/city/name distinction or support-locale form. | Meaning, spelling, exonym and pronunciation collide. This explains the México/Mexico class of failure. |
| RC9 | Review protocol exists but is not enforced by release gates. | `CONTENT_REVIEW_PROTOCOL.md:36-40` says review is mandatory and tests are insufficient; `:235-265` rejects literal/machine/unnatural/mixed text and applies this to vocabulary, prompts, pronunciation and ReadingRule support. | PASS reports based on automation contradict the required release process. |

## Required Field Classification

The docs already define the conceptual ownership, but the bundle does not encode
it per field. These classes must be explicit before production localization:

| Class | Examples | Source authority | Target-locale behavior | Permitted inclusions |
| --- | --- | --- | --- | --- |
| Target-language content | Spanish words, phrases, examples, accepted answers, ReadingRule IDs, orthographic patterns | Spanish course authoring | Never translated as support text | Spanish orthography, punctuation, target examples |
| Support-language meaning | `native_translation`, dialogue/reading translations, answer labels when they express meaning | Support-locale editor | Must be natural Ukrainian/Polish/etc. | Target-language spans only when intentionally quoted |
| Support-language instructional prose | prompts, explanations, notes, remediation, hints | Support-locale editor | Must be independently localized and reviewed | Spanish examples with explicit span metadata |
| Pronunciation hint | localized learner approximation with stress | Pronunciation reviewer and support-locale reviewer | Must match target IPA/policy and support-locale hint profile | Stress marks, approved support-locale phonetic spelling |
| Pronunciation invariant | target orthography, IPA, variety, ReadingRule IDs | Pronunciation model | Never localized | IPA, stable IDs, rule references |
| Writing-system invariant | WritingUnit symbol, symbol kind, visual identity, reading behavior | Writing-system model | Never inferred from localized prose | Target symbols, canonical names/readings |
| Proper noun/toponym | personal names, cities, countries, exonyms | entity model plus support-locale editor | Meaning and pronunciation must be separate | Entity type, surface form, support-locale exonym |
| UI/technical metadata | IDs, schema, route labels, difficulty, release flags | app/model | Not learner prose unless explicitly mapped | Stable identifiers only |

## Case Traces

### México

`pronunciation.es.word.mexico.v1` has `targetOrthography: "México"`, IPA
`/mˈeksiko/`, and Ukrainian hint `ме́ксико`
(`reference_slice.json:19831-19845`). The failure is architectural even when a
specific spelling can be patched: the unit does not encode whether the surface is
a country, city, target word, Ukrainian exonym, or pronunciation hint. The
generator also has no entity model, so it cannot know when `Mexico` means
`Мексика`, when `México` should remain Spanish, and when the learner needs a
sound hint.

### Chile

`silent_h` is modeled as pattern `h` (`reference_slice.json:15-25`). The `Chile`
unit references `silent_h` (`:17121-17135`) and the localized explanation says
the `h` is silent (`:28084-28092`). This is wrong because `ch` is a Spanish
digraph. The root cause is not Ukrainian text; it is a rule-applicability model
that matches a single letter inside a larger writing unit.

### `se llama`, `ll`, and `¿Cómo es?`

The docs say Spanish `ll`/consonantal `y` follow the Spanish course policy and
localized hints must not conflict with that policy
(`EDUCATIONAL_CONTENT_LOCALIZATION.md:116-119`). The current data model can
store `readingRuleIds`, but validation does not prove that rule references are
contextually applicable to the target orthography. Question prompts such as
`¿Cómo es?` can also mix target text and support-language instruction, but the
bundle has no explicit spans separating Spanish target text from support prose.

### `simpático / simpática`

The generator can map English templates to slash morphology and dictionary
fragments. It does not model gender, agreement, case or whether the localized
string is a meaning, phrase prompt, grammar explanation or target-language
example. The resulting text may be token-clean while still failing as a Ukrainian
teacher-facing explanation.

### Proper nouns, countries and cities

Names and places appear as vocabulary meanings, target-language words, dialogue
participants and pronunciation targets. Without `entityType` or equivalent
metadata, the generator cannot distinguish personal name, city, country,
support-locale exonym and Spanish pronunciation form.

## Why Previous PASS Was False

The existing Ukrainian audit can find missing strings, identical English/Russian
fallback, Russian-only letters and known forbidden words. It cannot prove:

- Ukrainian grammar, case, agreement or naturalness;
- semantic equivalence;
- whether a Spanish span is intentional or leaked;
- whether a pronunciation hint matches IPA and course policy;
- whether a ReadingRule applies in context;
- whether a proper noun is a name, country, city or exonym;
- whether a localized string has been reviewed.

The runtime can render content after lookup and fallback. That is useful
engineering safety, but it is explicitly not release validation. The review
protocol says content must not be released merely because it loads, validates
structurally or passes automated tests.

## Bad or Insufficient Documentation/Process Areas

The core standards are mostly correct, but they are not operationalized:

| Area | Problem |
| --- | --- |
| Localization docs | Field ownership is described, but no required per-field schema is enforced in assets. |
| Pronunciation docs | Pronunciation and ReadingRule separation is documented, but applicability checks such as digraph precedence are not required by current validators. |
| Writing-system docs | WritingUnit separation is documented as future/partial runtime work; localization can still infer too much from prose. |
| Review protocol | Mandatory review exists on paper but prior PASS reports used automated checks as if they were release readiness. |
| Release reports | PASS is overloaded. It should distinguish structural pass, automated audit pass, editorial pass and production pass. |

## Required Next Phase

1. Add semantic field metadata to localization inventory and bundle output.
2. Split target-language spans from support-language prose in prompt and exercise
   templates.
3. Add entity metadata for names, countries, cities and exonyms.
4. Replace Ukrainian string conversion with authored/reviewed localization
   workflows or a generator that consumes typed semantic units and produces
   review-required drafts.
5. Add pronunciation applicability validation, including digraph precedence and
   rule-pattern matching by WritingUnit/ReadingRule, not raw substring.
6. Make review state a release gate: generated/unreviewed localized fields must
   block production status.
7. Rename automated PASS labels to structural/audit PASS unless human-style
   editorial review is complete.

## Polish Decision

Do not start Polish localization yet.

Starting Polish now would copy the same architecture defects into another
support locale. Polish can begin only after the semantic localization schema,
diagnostic gates and review workflow are in place.
