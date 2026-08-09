# Semantic Localization Unit Standard

Status: DERIVED
Scope: semantic localization unit operations
Canonical owner: EDUCATIONAL_CONTENT_LOCALIZATION.md

Version: 1.0

## Purpose

Semantic Localization Units make learner-facing educational localization typed,
reviewable and safe to render. They exist because raw field-name/string pairs
cannot distinguish meanings, pronunciation hints, target-language examples,
proper nouns, IPA, feedback, remediation or mixed support/target text.

Legacy localization overlays remain loadable during migration, but they are
transitional. Release-ready learner-facing educational localization must be
represented as typed SemanticLocalizationUnit data or explicitly approved by an
equivalent future model.

## Terminology

SemanticLocalizationUnit: one localizable educational unit with semantic type,
ownership, source text, localized values, protected spans, context metadata and
review status.

Protected span: a substring that must not be translated, rewritten or guessed by
a generator. Protected spans are structural data, not accidental Latin text.

Support locale: the learner's explanatory language.

Target language: the language being learned.

## Semantic Types

The initial implemented type set is:

`courseTitle`, `moduleTitle`, `lessonTitle`, `lessonDescription`,
`lessonObjective`, `communicativeOutcome`, `learnerInstruction`,
`exercisePrompt`, `answerOptionLabel`, `feedback`, `remediation`,
`misconceptionExplanation`, `vocabularyMeaning`, `vocabularyUsageNote`,
`exampleTranslation`, `grammarTitle`, `grammarExplanation`, `dialogueTitle`,
`dialogueTranslation`, `readingTitle`, `readingTranslation`,
`readingRuleTitle`, `readingRuleShortExplanation`,
`readingRuleDetailedExplanation`, `articulationHint`,
`commonMistakeExplanation`, `contrastNote`, `pronunciationHint`,
`pronunciationExplanation`, `graphemeDesignation`, `graphemeExplanation`,
`accessibilityDescription`, `metadataLabel`, `properNounMeaning`,
`countryName`, `cityName`, `nationality`, and `grammaticalMetalanguage`.

The model is extensible, but new types require documentation and validator
updates before production use.

## Ownership

Every unit declares one ownership:

| Ownership | Meaning |
| --- | --- |
| `targetLanguageOwned` | Authentic target-language text such as `hola`, `Soy de México.` or a canonical answer. |
| `supportLanguageOwned` | Learner-facing support text such as meanings, explanations, hints and feedback. |
| `localeIndependent` | Stable data such as IPA, IDs, correctness keys and pronunciation variety. |
| `mixedStructured` | Support-language text containing protected target-language spans. |

Mixed text must not be stored as an unstructured sentence when a generator or
validator needs to know which parts are protected.

## Protected Spans

Supported protected span types:

- `targetText`
- `targetExample`
- `targetTerm`
- `ipa`
- `placeholder`
- `properNameTargetForm`
- `codeOrId`

Example:

Source: `Use "Soy de" with a place.`

Protected span: `Soy de` as `targetText`

Ukrainian: `Використайте конструкцію «Soy de» з назвою місця.`

The validator checks that protected spans remain unchanged in mixed structured
or locale-independent units.

## Context

Each unit carries context metadata. Required for all units:

- `courseId`
- `contentObjectId`
- `fieldPath`
- `contentKind`
- `pedagogicalRole`
- `targetLanguage`
- `supportLocale`

Conditional context:

- `moduleId`, `lessonId`, `activityId` when known;
- `grammaticalGender`, `grammaticalNumber`, `grammaticalPerson` for
  morphology-sensitive units;
- `namedEntityType` for proper nouns, countries, cities, languages,
  nationalities, institutions and similar entities;
- `expectedAnswerContext` for prompts and expected-answer alignment;
- `sourceMeaning` for pronunciation/meaning separation checks.

## Named Entities

Named entity types:

- `person`
- `country`
- `city`
- `region`
- `language`
- `nationality`
- `institution`
- `other`

Meaning, target orthography, localized exonym and pronunciation hint are
separate. For example:

| Target form | Entity | Ukrainian meaning | Ukrainian pronunciation hint |
| --- | --- | --- | --- |
| `México` | country | `Мексика` | `ме́хіко` |
| `Ciudad de México` | city | `Мехіко` | separately authored when needed |

## Pronunciation And Meaning

The following invariants are mandatory:

1. `pronunciationHint` is not a translation.
2. Meaning fields are not pronunciation hints.
3. IPA is locale-independent and never localized.
4. Target orthography is never localized.
5. Localized pronunciation hints never replace the target form.
6. Country/city meaning is not inferred from pronunciation hints.

## ReadingRule Applicability

ReadingRule applicability must be grapheme-aware:

- longest match first;
- digraph/trigraph precedence;
- explicit applicability;
- exclusion contexts;
- no substring-only rule application.

For Spanish, `ch`, `ll`, `rr`, `qu` and `gu` are segmented before single
letters. Therefore `Chile` does not receive the silent-`h` rule, while `hola`
does.

## Review States

Review states:

- `generated`
- `structurallyValidated`
- `semanticallyValidated`
- `editoriallyReviewed`
- `pedagogicallyVerified`
- `productionApproved`
- `approved`

Rules:

- `generated` is not release-ready.
- `structurallyValidated` is not editor-approved.
- `semanticallyValidated` does not prove natural-language quality.
- `editoriallyReviewed` does not prove the lesson hides and reveals knowledge
  correctly.
- `pedagogicallyVerified` records that the semantic text has passed educational
  review, but it is still not a production gate by itself.
- Production learner-facing educational text requires `productionApproved`.
- Legacy `approved` is historical compatibility only and must not release new
  learner-facing semantic units.
- Generators must not set `editoriallyReviewed`, `pedagogicallyVerified`,
  `productionApproved` or legacy `approved`.

## Fallback

Semantic units override legacy fields only when a `productionApproved` value
exists for the requested support locale. If no semantic unit exists, the legacy
localization bundle remains the transitional fallback path.

Fallback keeps the app usable. It must not be counted as completed production
localization.

## Validation

Independent validators must not use generator translation tables, replacement
maps or allowlists. They check architecture invariants:

- semantic type present;
- ownership present;
- required context present;
- protected spans preserved;
- target text and IPA unchanged;
- pronunciation hint separated from meaning;
- named entity type present where required;
- country/city distinction;
- review status acceptable;
- ReadingRule applicability;
- duplicate identity conflicts.

## Migration Strategy

Migrate small production reference slices first. Do not scale to full Ukrainian,
Polish, German or future locales until:

1. semantic unit validation passes;
2. review-state gates are enforced;
3. mixed target/support spans are structural;
4. pronunciation/meaning separation is represented;
5. named entities are explicit.

After the reference slice, migrate complete production lessons as pilots before
full-course migration. A complete-lesson pilot must declare its lesson IDs,
collect every expected learner-visible field deterministically from production
content assets, require `productionApproved` semantic units for all collected
fields and report zero legacy fallback inside the declared pilot scope. Pilot
success is scoped. It proves the semantic architecture on the declared lessons
and must not be reported as complete semantic localization for an unmigrated
course.

Full Ukrainian migration is gated by:

```text
app/tool/audit_semantic_ukrainian_migration.dart
```

The audit is intentionally stricter than the general coverage reporter. It
fails until `productionApproved` Ukrainian semantic units cover every legacy Ukrainian
educational field and runtime would no longer need legacy or source fallback
for Ukrainian educational content. A mechanically converted legacy string does
not become a `productionApproved` semantic unit merely because it validates
structurally.

R2E5R reset Ukrainian and Russian educational localization. After the reset,
production semantic bundles for `uk` and `ru` must start empty or draft-only;
old R2E4/R2E5 approval statuses are historical and do not confer production
approval. New `uk` and `ru` content must be scaffolded with generated review
status and empty localized values until independently authored and reviewed.

R2E5P adds an executable pedagogical contract for production lesson assembly.
Each learner-facing lesson step must declare or derive educational intent,
presented/hidden knowledge, expected recall, assessment target, allowed visible
information and success criteria. ReadingRule and PronunciationUnit support is
production-complete only when localized learner explanation, localized
pronunciation hint, IPA, Spanish orthography, examples and misconception
guidance are present. Independent recall steps must not reveal the target
response in prompts or answer options.

## Authoring Examples

Good mixed instruction:

```json
{
  "semanticType": "learnerInstruction",
  "ownership": "mixedStructured",
  "sourceText": "Use \"Soy de\" with a place.",
  "protectedSpans": [
    {"type": "targetText", "text": "Soy de"}
  ],
  "values": {
    "uk": "Використайте конструкцію «Soy de» з назвою місця."
  }
}
```

Good pronunciation split:

```text
targetOrthography: México
meaning.uk: Мексика
pronunciationHint.uk: ме́хіко
ipa: /ˈmexiko/
```

## Anti-Examples

Do not:

- generate Ukrainian through Russian word replacement;
- assemble support-language sentences word by word;
- store `Soy de` as an accidental Latin substring;
- mark generated text as `productionApproved`;
- use pronunciation hints as meanings;
- apply `silent_h` to the `h` inside `ch`.

## Release Gates

Production PASS requires:

- `productionApproved` learner-facing semantic units for migrated release scope;
- zero semantic validator issues;
- no protected-span mutation;
- no generated release-ready units;
- no unsupported fallback counted as complete localization;
- zero legacy Ukrainian educational resolutions for a completed Ukrainian
  migration phase;
- ReadingRule applicability checks passing for migrated scope.

## R2E5N0A Scope Extraction

Before authoring a locale, Module 1 scope is extracted from the canonical
course graph: `Course.modules[0]` -> lesson IDs -> lesson activity references
-> reusable content objects -> pronunciation and ReadingRule dependencies.
The scaffold inventory includes only support-language-localized required
identities. Spanish target text, IPA, canonical answers, accepted answers,
stable IDs and Flutter UI strings are excluded as localized values and may
appear only as protected spans or context.
