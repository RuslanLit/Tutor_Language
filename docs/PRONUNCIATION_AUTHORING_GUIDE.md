# PRONUNCIATION_AUTHORING_GUIDE.md

Status: Active

Version: 1.0

Related documents:

- PROJECT_VISION.md
- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md
- CONTENT_MODEL.md
- CONTENT_AUTHORING_GUIDE.md
- PRONUNCIATION_MODEL.md
- COURSE_AUTHORING_GUIDE.md
- EDUCATIONAL_CONTENT_LOCALIZATION.md
- AUTHORING_STYLE_GUIDE.md
- RELEASE_CHECKLIST.md

---

# Purpose

This document defines how Tutor Language represents, authors, localizes,
validates and renders pronunciation guidance.

Pronunciation requires its own authoring model because pronunciation guidance
is not ordinary translation. A learner-facing pronunciation aid may depend on:

- the target language;
- the selected target-language pronunciation variety;
- the learner's support language;
- the learner's writing-system expectations;
- the learner's level;
- whether the representation is IPA, audio or an approximate hint.

English-style respelling such as `OH-lah`, `ah-DYOHS` or `AHS-tah LWEH-goh`
must not be reused for Russian, Ukrainian, Polish, German or any other support
locale. It is an English-oriented learner hint, not a universal pronunciation
representation.

Pronunciation guidance must never assume that all learners interpret Latin
letters according to English spelling conventions.

Pronunciation is reusable educational knowledge. It should be represented as a
PronunciationUnit and referenced by vocabulary, lessons and exercises instead
of being copied into each asset. The conceptual domain model is defined in
PRONUNCIATION_MODEL.md.

This standard supports Spanish and future target-language courses such as
German, Polish, Ukrainian, English, French and Italian by separating authentic
target spelling, language-neutral pronunciation data, support-locale-specific
learner hints, localized explanations, reading rules, audio references and
pronunciation variety.

Educational-content localization is defined in
EDUCATIONAL_CONTENT_LOCALIZATION.md. This guide extends that model for
pronunciation-specific fields.

---

# Terminology

## Target Orthography

The authentic written form in the language being learned.

Examples:

- `hola`
- `adiós`
- `hasta luego`
- `José`
- `España`

When the authentic spelling uses accents or special characters, the authored
content must preserve them.

## IPA Transcription

A language-neutral phonetic or phonemic representation using the International
Phonetic Alphabet.

IPA examples in this document are illustrative. They must be reviewed against
the declared pronunciation variety before use in production content.

IPA is not English dictionary respelling.

IPA is the canonical textual pronunciation representation.

IPA is locale-independent and never changes between support languages.

## Learner Pronunciation Hint

An approximate localized reading aid written for speakers of one support
language.

Illustrative examples for Spanish `hola`:

- `en`: `OH-lah`
- `ru`: `о́ла`
- `uk`: `о́ла`
- `pl`: `óla`
- `de`: `óla`

A learner hint is an approximation. It does not replace the target spelling,
IPA or audio.

Localized learner hints are learner support, not canonical pronunciation.

For multi-syllable words, learner hints must mark stress explicitly according
to the support-locale profile.

## Pronunciation Explanation

A localized pedagogical explanation of a sound, spelling pattern or reading
rule.

Example concept:

```text
The Spanish h is silent.
```

The explanation must be localized by support locale.

Pronunciation explanations belong to localized learner support. They are not
locale-independent pronunciation metadata.

## Reading Rule

A reusable rule describing how a letter or letter combination is pronounced or
read in the target language.

Examples:

- Spanish `h` is usually silent.
- Spanish `qu` before `e` or `i` represents a hard `k` sound.

## Pronunciation Variety

The dialect, accent or pronunciation norm used by the course.

Examples:

- Peninsular Spanish;
- Latin American Spanish;
- General American English;
- Received Pronunciation;
- Standard German.

Where several target-language variants exist, the course must state the chosen
norm and avoid presenting it as universal.

## Audio Reference

A future optional stable reference to an audio asset.

Audio does not exist as a required Version 1 feature. The model must still
allow future recorded audio, multiple speakers and regional variants.

---

# Data Ownership Classes

Pronunciation fields must be classified before authoring or localization.

## TARGET_ORTHOGRAPHY

Authentic written target-language form.

- target-language-specific;
- not localized by support locale;
- required for vocabulary and target-language examples.

## IPA_PRONUNCIATION

IPA transcription for a declared pronunciation variety.

- target-language-specific;
- locale-independent;
- not localized by support locale;
- required where production pronunciation guidance is released.

## SUPPORT_LOCALE_PRONUNCIATION_HINT

Approximate learner hint for one support locale.

- support-language-localized;
- required for release vocabulary in each released support locale when
  pronunciation guidance is applicable;
- must not be reused across unrelated support locales.

## SUPPORT_LOCALE_PRONUNCIATION_EXPLANATION

Localized explanation of a sound, rule or pronunciation difficulty.

- support-language-localized;
- optional and pedagogical;
- authored when the learner benefits from an explanation.

## READING_RULE

Reusable target-language reading rule.

- target-language-specific;
- may have localized explanations;
- referenced by lessons, exercises or remediation.

## PRONUNCIATION_VARIETY

Course-level or content-level pronunciation norm.

- locale-independent;
- target-language-specific;
- required before IPA is treated as authoritative.

## AUDIO_REFERENCE

Stable ID for future audio.

- technical identity;
- not localized by support locale;
- may point to target-language audio or localized explanatory narration.

## TECHNICAL_METADATA

Stable IDs, version fields, source references and validation metadata.

- locale-independent;
- not learner-facing.

---

# Canonical Pronunciation Model

PRONUNCIATION_MODEL.md defines the long-term PronunciationUnit object and field
responsibilities.

The preferred conceptual model is:

```json
{
  "target": {
    "text": "hola",
    "language": "es"
  },
  "pronunciation": {
    "pronunciationUnitId": "pronunciation.es.hola.general.v1",
    "variety": "es-general",
    "ipa": "/ˈola/",
    "learnerHints": {
      "en": "OH-lah",
      "ru": "Russian-locale approximation",
      "uk": "Ukrainian-locale approximation",
      "pl": "Polish-locale approximation",
      "de": "German-locale approximation"
    },
    "explanations": {
      "en": "The h is silent.",
      "ru": "Russian explanation of silent h.",
      "uk": "Ukrainian explanation of silent h."
    }
  }
}
```

This is a conceptual model, not a required JSON schema.

A production PronunciationUnit may contain:

- `id`;
- target orthography;
- IPA;
- pronunciation variety;
- localized pronunciation hints;
- localized pronunciation explanations;
- reading rule references;
- audio reference IDs;
- metadata.

Current implementation:

- vocabulary assets contain a single optional `pronunciation` string;
- that string is currently rendered as plain learner-facing text;
- the existing Spanish A0 values are English-oriented learner hints;
- the field is not IPA;
- the field is not localized by support locale;
- audio is not implemented.

Target architecture:

- target orthography remains in target-language fields;
- reusable PronunciationUnit objects own pronunciation knowledge;
- vocabulary, grammar, readings, dialogues, lessons and exercises reference
  PronunciationUnit IDs instead of duplicating pronunciation data;
- IPA and pronunciation variety become locale-independent pronunciation data;
- learner hints and explanations become support-locale-specific educational
  localization data;
- runtime rendering must select only pronunciation data appropriate to the
  learner's support locale or safe locale-independent data.

Deferred implementation:

- full migration of current `pronunciation` strings;
- IPA authoring and review;
- support-locale learner-hint authoring;
- audio references and playback.

R2E2B implemented the first runtime foundation and a Spanish A0 reference
slice. Treat it as partial implementation, not full-course migration.

---

# Source-of-Truth Hierarchy

Pronunciation authority follows this order:

1. PronunciationUnit stable ID.
2. Target-language orthography.
3. Pronunciation variety.
4. IPA transcription.
5. Audio reference, when available.
6. Localized learner hint.
7. Localized explanatory note.

IPA is the language-neutral textual source of truth.

Audio may later become the practical pronunciation reference.

Learner hints are secondary approximations. They must never override IPA or
the target-language spelling.

Support-language learner hints must be authored or reviewed directly for that
support locale. They must not be mechanically derived at runtime from another
support locale.

---

# Support-Language Localization Rules

Each support locale may require its own pronunciation approximation.

Policy:

- English support uses English-oriented respelling when useful.
- Russian support uses Russian-locale conventions.
- Ukrainian support uses Ukrainian-locale conventions.
- Polish support uses Polish-locale conventions.
- German support uses German-locale conventions.

One learner hint must not be reused across unrelated support languages.

English respelling must not appear in Russian or Ukrainian mode.

Russian and Ukrainian hints may look similar, but they remain independently
authored and reviewed.

Hints should follow the reading expectations of the support language.

Do not transliterate blindly.

Do not use another support locale as an intermediate source.

---

# IPA Authoring Rules

IPA must be authored or reviewed against a declared pronunciation variety.

Authoring requirements:

- choose phonemic or phonetic transcription and use it consistently;
- use slash `/.../` for phonemic transcription and brackets `[...]` for
  phonetic transcription only when the distinction is intentional;
- mark stress consistently;
- define how optional sounds and regional variants are represented;
- do not invent IPA from spelling without verification;
- do not use English dictionary notation as IPA.

Every course blueprint that includes pronunciation should declare:

```text
pronunciationVariety:
ipaGranularity:
stressNotationPolicy:
regionalVariantPolicy:
```

Example:

```text
pronunciationVariety: es-general
ipaGranularity: broad-phonemic
stressNotationPolicy: primary-stress-marked
regionalVariantPolicy: neutral-general-form
```

---

# Learner-Hint Authoring Rules

A learner hint must:

- be understandable to speakers of its support language;
- mark stress consistently;
- avoid suggesting sounds that do not exist in the target form;
- avoid overprecision;
- remain concise;
- preserve syllable boundaries where pedagogically useful;
- avoid Latin letters interpreted by English rules in non-English locales;
- state only an approximation;
- never replace authentic target spelling.

Prohibited for Russian locale:

```text
OH-lah
ah-DYOHS
AHS-tah LWEH-goh
```

Illustrative Russian-locale forms for Spanish might be:

```text
о́ла
адьо́с
а́ста луэ́го
```

Production forms must use the chosen Russian pronunciation-hint profile and
must be reviewed against the selected Spanish pronunciation variety. The
illustrations above are not release-ready linguistic authority.

Stress marking is mandatory for multi-syllable words.

Examples:

```text
hola        [о́ла]
José        [хосе́]
España      [эспа́нья]
igualmente  [игуальме́нте]
```

Stress omission is not acceptable for multi-syllable words because A0 learners
cannot reliably infer stress.

Stress marking is optional for single-syllable words:

```text
de  [дэ]
es  [эс]
mi  [ми]
```

Use brackets for learner-facing approximate hints when the support-locale
profile requires that visual distinction.

---

# Language-Specific Authoring Profiles

Each support language should define a pronunciation-hint profile.

Template:

```text
Support locale:
Script:
Stress notation:
Syllable separator:
Approximation conventions:
Known limitations:
Prohibited conventions:
Examples:
Reviewer notes:
```

## English Support Profile Outline

Support locale: `en`

Script: Latin.

Stress notation: capitalization or another explicitly selected convention.

Syllable separator: hyphen where useful.

Approximation conventions: may use English-oriented respelling.

Known limitations: English vowel spelling is inconsistent and may mislead.

Prohibited conventions: presenting English respelling as IPA.

Examples: `OH-lah` may be acceptable only as an English learner hint.

Reviewer notes: verify that the hint does not suggest an English sound absent
from the target form.

## Russian Support Profile Outline

Support locale: `ru`

Script: normally Cyrillic, unless a project style decision chooses a limited
Latin convention for a specific task.

Stress notation: explicit and consistent.

Syllable separator: optional; use only when it helps.

Approximation conventions: should follow Russian reading expectations.

Known limitations: Russian lacks some target-language contrasts and may imply
palatalization or vowel reduction if not handled carefully.

Prohibited conventions: English respelling such as `OH-lah`, `DYOHS`,
`LWEH-goh`.

Examples: independently author Russian hints from IPA/audio, not from English.

Reviewer notes: review stress, vowel quality and consonant softness.

## Ukrainian Support Profile Outline

Support locale: `uk`

Script: normally Cyrillic.

Stress notation: explicit and consistent.

Syllable separator: optional.

Approximation conventions: should follow Ukrainian reading expectations.

Known limitations: do not assume Russian and Ukrainian hints are identical.

Prohibited conventions: English respelling and Russian-only conventions.

Examples: independently author Ukrainian hints from IPA/audio.

Reviewer notes: review against Ukrainian orthographic expectations.

## Polish Support Profile Outline

Support locale: `pl`

Script: Latin with Polish reading expectations.

Stress notation: explicit when target stress is pedagogically important.

Syllable separator: optional.

Approximation conventions: may use Polish spelling-like approximations.

Known limitations: Polish spelling conventions differ from English and from
Spanish.

Prohibited conventions: English respelling and unmarked ambiguous Latin hints.

Examples: independently author Polish hints from IPA/audio.

Reviewer notes: avoid suggesting Polish-specific sounds that are not intended.

## German Support Profile Outline

Support locale: `de`

Script: Latin with German reading expectations.

Stress notation: explicit when useful.

Syllable separator: optional.

Approximation conventions: may use German spelling-like approximations.

Known limitations: vowel length and final devoicing expectations may mislead.

Prohibited conventions: English respelling.

Examples: independently author German hints from IPA/audio.

Reviewer notes: review vowel length and consonant quality.

---

# Target-Language Pronunciation Profiles

Each target-language course must declare a pronunciation profile.

Template:

```text
Target language:
Course pronunciation variety:
Phonemic inventory assumptions:
Regional choices:
Letter-to-sound rules:
Stress rules:
Major learner difficulties:
IPA policy:
Audio policy:
Support-hint policy:
```

## Spanish A0 Example Profile

Target language: Spanish.

Course pronunciation variety: general beginner Spanish, with regional choices
declared before production IPA is authored.

Phonemic inventory assumptions: keep beginner explanations practical; avoid
claiming one regional realization is universal.

Regional choices:

- choose whether `c/z` follows a seseo norm or a distinction norm;
- choose how `ll` and `y` are represented;
- avoid overclaiming b/v, j, r and rr realizations across regions.

Letter-to-sound rules:

- `h` is usually silent;
- `ñ` is a separate Spanish letter;
- `j` differs from English `h` and varies by region;
- `ll` and `y` vary by region;
- `r` and `rr` require separate teaching;
- `b` and `v` are not pronounced like English `b` versus `v` in most Spanish;
- `c/z` depends on following vowel and regional norm;
- `g` changes before `e` or `i`, while `gue/gui` keep a hard sound;
- Spanish vowels are relatively stable compared with English;
- written accents can mark stress or meaning.

Stress rules: declare how primary stress is marked in IPA and learner hints.

Major learner difficulties: silent `h`, `ñ`, `j`, `ll/y`, `r/rr`, `b/v`,
`c/z`, `g`, stable vowels and written accents.

IPA policy: broad phonemic transcription is preferred for beginner content
unless a specific lesson requires finer detail.

Audio policy: future recorded audio should declare speaker variety and speed.

Support-hint policy: hints are support-locale-specific approximations.

Question and exclamation punctuation are orthography, not pronunciation.

---

# Field Requirements by Content Type

## Vocabulary

Vocabulary may include:

- target form;
- PronunciationUnit reference;
- example;
- pronunciation note.

Current Version 1 assets use `pronunciation` as a legacy learner hint. Future
assets should not add more universal pronunciation hints.

New pronunciation-capable vocabulary items containing two or more syllables
must not be published without:

- target-language orthography;
- IPA;
- pronunciation variety;
- localized pronunciation hint for every released support locale;
- explicit stress marking in each localized hint;
- localized pronunciation explanation when required;
- example sentence.

One-syllable words may omit stress marking in the localized hint when stress is
pedagogically obvious.

Example:

```text
hambre
/ˈambɾe/
[а́мбре]
голод
Tengo hambre.
```

## Grammar

Pronunciation should appear only when relevant to the grammar or reading point.

Examples:

- silent `h`;
- `qu` before `e/i`;
- stress-marking accents.

## Reading

Readings may include:

- passage-level audio reference;
- difficult-word pronunciation annotations;
- reading-rule references.

Do not annotate every known word unless pronunciation is the learning
objective.

## Dialogue

Dialogues may include:

- line-level audio reference;
- pronunciation focus;
- speaker variety metadata.

Do not place support-language respelling inside authentic Spanish dialogue
lines.

## Exercise

Pronunciation exercises may use:

- target sound ID;
- stable option IDs;
- IPA;
- localized instruction;
- future audio reference.

Exercise prompts remain support-language text and are localized through the
educational-content localization system.

## Lesson Metadata

A lesson title normally does not need pronunciation unless it contains target
language being taught.

---

# Rendering Rules

Preferred presentation order:

1. target orthography;
2. support-language meaning;
3. localized learner hint, if available;
4. IPA, optionally depending on learner level or settings;
5. example sentence;
6. localized note.

Rules:

- do not show English learner hints in non-English support locales;
- if a localized hint is missing, prefer hiding the hint or showing IPA rather
  than showing the wrong support-language hint;
- runtime fallback from a missing Russian hint to an English hint is prohibited
  in production unless explicitly marked as a development-only diagnostic;
- release validation must treat missing required learner hints as incomplete;
- target text and learner hint must be visually distinguishable;
- screen readers should use the target-language locale for target words when
  practical.

Current implementation limitation:

- the existing runtime may render the legacy `pronunciation` field directly;
- this is not compliant for non-English support-locale release QA and must be
  migrated before pronunciation hints are treated as production-ready.

---

# Fallback Policy

## Runtime Production Policy

```text
requested learner hint available
    -> show requested hint

requested learner hint missing, IPA available
    -> show IPA or omit hint according to renderer policy

requested learner hint missing, only another locale hint available
    -> do not show another locale hint

IPA missing
    -> omit pronunciation representation and report content defect
```

Do not use English learner respelling as a universal fallback.

## Authoring Validation Policy

Missing required pronunciation data must be reported.

Release validation is stricter than runtime resilience.

## Development Diagnostics

Development builds may show a diagnostic marker for missing pronunciation
data. Production learner-facing screens must not show raw keys or another
support locale's hint.

---

# Validation Rules

Validators should emit deterministic issue codes.

Required issue categories:

- `pronunciation.missingIpa`
- `pronunciation.missingVariety`
- `pronunciation.missingLearnerHint`
- `pronunciation.crossLocaleHintReuse`
- `pronunciation.invalidIpa`
- `pronunciation.invalidStressNotation`
- `pronunciation.targetMismatch`
- `pronunciation.unsupportedLocale`
- `pronunciation.unexpectedFallback`
- `pronunciation.emptyHint`
- `pronunciation.hintWithoutLocale`
- `pronunciation.ipaLooksLikeRespelling`
- `pronunciation.explanationWrongLocale`
- `pronunciation.duplicateMetadata`
- `pronunciation.missingTargetReference`

Validators should detect:

- learner hint stored without support locale;
- English-style respelling reused across all locales;
- missing IPA where required;
- missing declared pronunciation variety;
- unsupported locale code;
- empty hint;
- target orthography accidentally changed in localization;
- learner hint equal to support meaning;
- IPA containing invalid plain-English respelling;
- localized explanation containing another support language unexpectedly;
- English hint shown for Russian or Ukrainian content;
- duplicate pronunciation metadata;
- inconsistent stress notation;
- missing target word reference;
- mismatch between pronunciation item and stable content ID.

A pronunciation asset is release-complete only if:

- IPA exists;
- stress is correct;
- every required localized learner hint exists;
- each hint passes support-locale QA;
- pronunciation explanation exists where required;
- the vocabulary example sentence exists.

Release validation must treat a vocabulary card as incomplete if it lacks any
mandatory pronunciation element required by this guide.

---

# Coverage Reporting

Pronunciation coverage must be reported by target language and support locale.

Report separately:

- target forms requiring pronunciation;
- IPA present;
- audio references present;
- learner hints present;
- localized explanations present;
- missing required fields;
- fallback uses;
- invalid entries;
- coverage percentage.

Do not collapse IPA coverage, learner-hint coverage, audio coverage and
explanation coverage into one misleading percentage.

---

# Authoring Workflow

Suggested workflow:

1. Define target-language pronunciation profile.
2. Choose course pronunciation variety.
3. Author target orthography.
4. Author or verify IPA.
5. Add audio reference when available.
6. Create support-language learner hints.
7. Add localized explanations only where pedagogically needed.
8. Run validation.
9. Review representative content on device.
10. Record coverage.

Do not derive Russian, Ukrainian, Polish or German hints from English hints.

Use IPA and the target audio or pronunciation norm as the reference.

---

# Review Checklist

Before approving pronunciation data:

```text
[ ] target spelling is authentic
[ ] pronunciation variety is declared
[ ] IPA matches the selected variety
[ ] stress is marked consistently
[ ] learner hint is authored for the correct support locale
[ ] no foreign support-language convention leaked into the hint
[ ] learner hint is clearly approximate
[ ] target form was not replaced
[ ] example is correct
[ ] renderer fallback is safe
[ ] accessibility behavior is defined
[ ] device QA completed
```

---

# Future Audio Integration

The pronunciation architecture must support future:

- recorded native audio;
- multiple speakers;
- male and female voices where pedagogically useful;
- regional variants;
- slow and normal speed;
- offline bundled assets;
- content-addressed audio IDs;
- optional TTS only if a future architecture permits it.

Audio references must use stable IDs and remain independent of support locale
unless the audio itself is localized explanatory narration.

Do not implement audio merely to satisfy pronunciation authoring.

---

# Multi-Course Extensibility

This standard applies to future target-language courses including German,
English, Polish, Ukrainian, French, Italian and later non-Latin writing
systems.

The architecture must support:

- `targetLanguage`;
- `pronunciationVariety`;
- `ipa`;
- `supportLocaleLearnerHint`;
- `supportLocaleExplanation`;
- `audioReference`.

It must not assume:

- Latin alphabet;
- Spanish phonology;
- English support language;
- Cyrillic support language.

---

# Migration Guidance

Current English-oriented pronunciation strings should be classified before
migration.

Possible classes:

- legacy English learner hint;
- candidate IPA;
- support-language explanation;
- target orthography;
- unknown or requires review.

Migration rules:

- do not treat legacy respelling as IPA;
- retain legacy respelling only as an English learner hint if valid;
- create real IPA separately;
- author Russian, Ukrainian, Polish and German learner hints independently;
- do not copy English hints into other locales;
- mark uncertain entries for manual review;
- preserve stable content IDs.

For Spanish A0, existing `pronunciation` values such as `OH-lah` and
`ah-DYOHS` should be treated as legacy English learner hints until migrated.

---

End of document.
