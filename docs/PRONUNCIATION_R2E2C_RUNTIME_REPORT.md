# Pronunciation R2E2C Runtime Report

Status: Complete with deferred full-course migration

Date: 2026-07-15

---

# Scope

R2E2C integrates the PronunciationUnit runtime foundation into the Spanish A0
content pipeline.

Implemented:

- typed PronunciationUnit schema version support;
- optional vocabulary-level `pronunciationUnitId`;
- runtime resolution by direct PronunciationUnit reference;
- safe fallback for migrated and legacy pronunciation data;
- support-locale-safe rendering in Lesson Player vocabulary cards;
- deterministic pronunciation validation tool;
- deterministic pronunciation coverage report tool;
- expanded Spanish A0 migrated pronunciation reference slice.

Not implemented:

- full Spanish A0 pronunciation migration;
- professional IPA review for every vocabulary item;
- audio;
- pronunciation editor;
- database changes;
- answer-evaluation changes;
- generated pronunciation data.

---

# Runtime Ownership

Vocabulary assets may reference a PronunciationUnit by stable ID.

PronunciationUnit owns:

- target orthography;
- target language;
- pronunciation variety;
- IPA;
- reading-rule references;
- localized learner hints;
- localized explanations;
- related vocabulary/content references;
- technical metadata.

The pronunciation catalog resolves the correct support-locale presentation.

Lesson Player renders the resolved presentation only. It does not implement
pronunciation fallback policy.

---

# Migrated Reference Slice

The migrated Spanish A0 slice includes:

- `hola`;
- `adiós`;
- `hasta luego`;
- `José`;
- `España`;
- `hambre`;
- `me llamo`;
- `mucho gusto`;
- `igualmente`;
- `amigo`;
- `amiga`;
- `profesor`;
- `profesora`;
- `compañero`;
- `compañera`;
- `joven`;
- `simpático`;
- `simpática`;
- `autobús`;
- Spanish reading-rule and sound units for silent `h`, `ñ`, `j`, `ll/y`,
  single `r`, `rr`, `b/v`, `c/z`, `g` before `e/i`, stable vowels, `ue`, and
  primary stress.

The course does not currently contain a standalone vocabulary item for
`llamo`; the migrated production item is the authored phrase `me llamo`.

---

# Validation Tools

Added:

- `app/tool/validate_pronunciation_content.dart`;
- `app/tool/report_pronunciation_coverage.dart`.

Existing inventory tool remains:

- `app/tool/inventory_pronunciation_content.dart`.

Validation issue categories implemented include:

- `pronunciation.duplicateUnitId`;
- `pronunciation.duplicateRuleId`;
- `pronunciation.missingTargetOrthography`;
- `pronunciation.missingVariety`;
- `pronunciation.missingIpa`;
- `pronunciation.missingLocalizedHint`;
- `pronunciation.missingStressMark`;
- `pronunciation.crossLocaleHintReuse`;
- `pronunciation.unknownUnitReference`;
- `pronunciation.unknownRuleReference`;
- `pronunciation.targetOrthographyMismatch`;
- `pronunciation.targetLanguageMismatch`;
- `pronunciation.localizedEntryWithoutUnit`;
- `pronunciation.legacyHintInNonEnglishLocale`;
- `pronunciation.missingExample`;
- `pronunciation.explanationRequired`.

---

# Coverage Snapshot

Latest deterministic coverage output:

```text
legacyPronunciationFields=166
uniqueTargetForms=154
pronunciationCapableVocabularyEntries=181
pronunciationUnits=31
unitsWithDeclaredVariety=31
unitsWithIpa=28
unitsWithEnglishLearnerHint=31
unitsWithRussianLearnerHint=31
multisyllabicRussianHintsWithStress=21
unitsWithRussianExplanation=24
unitsWithExample=19
unitsRequiringExplanation=5
unitsWithRequiredExplanation=5
readingRules=12
unitsReferencingRules=31
unmigratedLegacyEntries=135
crossLocaleFallbackAttempts=0
invalidUnits=0
unknownReferences=0
```

The migrated slice validates cleanly. Full Spanish A0 pronunciation migration
remains incomplete.

---

# Deferred Work

Deferred deliberately:

- migrate every legacy vocabulary `pronunciation` field to PronunciationUnit;
- validate complete IPA coverage for all release vocabulary;
- complete Russian pronunciation hints for all release vocabulary;
- add Ukrainian, Polish and German pronunciation hints;
- add audio references and playback;
- add pronunciation package/version migration tooling;
- add professional pronunciation review workflow.

---

End of document.
