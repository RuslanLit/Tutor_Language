# WRITING_UNIT_INTRODUCTION_STANDARD.md

Status: Active

Version: 1.0

Related documents:

- WRITING_SYSTEM_STANDARD.md
- ARCHITECTURAL_DECISIONS.md
- CONTENT_MODEL.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- CURRICULUM_SPEC.md
- EDUCATIONAL_LANGUAGE_STANDARD.md
- EDUCATIONAL_CONTENT_LOCALIZATION.md
- PRONUNCIATION_MODEL.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- READING_RULE_PREREQUISITE_STANDARD.md
- GRAPHEME_PRESENTATION_STANDARD.md
- CONTENT_REVIEW_PROTOCOL.md
- CONTENT_REVIEW_CHECKLIST.md
- RELEASE_CHECKLIST.md

---

# Purpose

This document defines how a WritingUnit is introduced to an absolute beginner.

It is a focused authoring and presentation specification under
WRITING_SYSTEM_STANDARD.md. It does not define a runtime schema, JSON format,
validator implementation or UI component.

The core rule is simple:

A learner must never be expected to know how a symbol is named, read,
pronounced, typed, combined or distinguished merely because it is visible on
screen.

---

# Core Distinctions

The following concepts must remain separate.

## Symbol

The visible written form.

Examples:

- `h`
- `ll`
- `ñ`
- `ㄱ`
- `가`
- `あ`
- `ア`
- `人`
- `ب`

The symbol is not automatically the name, reading, pronunciation or meaning.

## Designation

A stable human-readable way to identify the unit in teaching or documentation.

Examples:

- the letter `h`;
- the letter combination `ll`;
- the Hangul consonant `ㄱ`;
- the character `人`;
- the Arabic letter `ب`.

Designation is not necessarily the writing tradition's conventional name.

Designation may be localized when it is learner-facing support text.

## Conventional Name

The established target-language name of a letter or writing unit, when such a
name exists and is pedagogically relevant.

Examples:

- Spanish `h` -> `hache`;
- Spanish `j` -> `jota`;
- Spanish `ñ` -> `eñe`;
- Korean `ㄱ` -> `기역`;
- Arabic `ب` -> `باء`.

Do not require a conventional name where the writing tradition does not define
one in the same sense. Use a clear pedagogical designation instead.

## Name Pronunciation

The pronunciation of the conventional name itself.

Example:

```text
symbol: h
conventional name: hache
name IPA: /ˈatʃe/
uk learner hint: а́че
```

Name pronunciation is distinct from the sound or reading represented by the
symbol inside words.

## Reading

The value or values used when the unit appears in meaningful written language.

Examples:

- Spanish `h` usually has no pronounced segment in modern words;
- Spanish `j` commonly corresponds to /x/ under the selected course profile;
- Japanese kanji may have multiple readings;
- Chinese characters have language- and context-dependent readings;
- Arabic letters may have context-dependent shapes and vowel behavior;
- Hangul jamo combine into syllable blocks.

A WritingUnit may have multiple readings.

## Pronunciation

The spoken realization of a reading in a declared target-language variety or
context.

Pronunciation belongs to PronunciationUnit data. A symbol's conventional name
and its sound in words must never be conflated.

## Meaning Or Function

Some WritingUnits carry lexical, grammatical, semantic or structural
information.

This is especially important for:

- Han characters;
- punctuation;
- diacritics;
- determinatives;
- grammatical markers;
- syllable blocks;
- combining signs.

Meaning and function are separate from pronunciation.

---

# Anti-Confusion Rule

Explanations must not merge symbol, name, reading, pronunciation or meaning.

Incorrect:

```text
h is pronounced hache
```

This confuses the letter name with its behavior inside words.

Correct conceptual explanation:

```text
The letter is written h.
Its Spanish name is hache.
The name hache is pronounced /ˈatʃe/.
In most modern Spanish words, the letter h itself is silent.
```

For A0 Ukrainian support, an acceptable concept may be:

```text
Німа літера h — «аче»

Написання:
h

Назва іспанською:
hache

Як вимовляється назва:
а́че

У словах:
сама літера h зазвичай не вимовляється.

Приклад:
hola
/ˈola/
о́ла
```

Do not mandate exact learner-facing wording without editorial review.

A compact lesson title may use a pattern such as:

```text
Німа h («аче») і сталі голосні
```

only when the surrounding lesson immediately explains that `аче` is the
Spanish name of the letter, not its sound inside a word.

---

# First-Introduction Invariant

Before the first active use of a WritingUnit, the learner must receive enough
information to:

- recognize it;
- name or designate it where appropriate;
- read it;
- pronounce its taught reading;
- distinguish it from likely confusables.

The minimum introduction depends on the writing system, but it must never
consist of the symbol alone.

A unit is actively used when the learner must:

- recognize it as meaningful;
- distinguish it from another unit;
- read it;
- choose its pronunciation;
- type it;
- handwrite it;
- combine it;
- recall a word containing it;
- interpret a word through it.

---

# Introduction Card

A first-introduction card should be composable. It must show only the fields
that are relevant to the WritingUnit and learner stage.

Recommended order:

1. Visible unit.
2. Localized designation.
3. Conventional target-language name, where applicable.
4. Pronunciation of the name, where applicable.
5. Reading or readings.
6. Pronunciation of the taught reading.
7. Localized learner hint.
8. Function or meaning.
9. Visual decomposition or composition.
10. Confusable units.
11. One minimal example.
12. One meaningful word or context example.

Do not turn the card into a dense technical specification.

Do not display absent or irrelevant sections.

---

# First-Use Naming Policy

The conventional name or designation is required at first introduction when it
is applicable.

After successful introduction, the symbol may be used alone where the context
is clear.

Do not clutter every vocabulary card with repeated naming such as:

```text
h (hache)
```

The full name returns when:

- the rule is reviewed;
- the learner confuses symbols;
- remediation is triggered;
- a metalinguistic task asks about the symbol itself.

---

# Localized Name Pronunciation

The conventional name belongs to the target-language writing system.

The localized pronunciation hint for that name belongs to the support locale.

Example:

```text
symbol: h
target-language conventional name: hache
name IPA: /ˈatʃe/
uk hint: а́че
ru hint: а́че
pl hint: independently authored Polish-oriented approximation
```

Do not derive one support locale's hint from another support locale's hint.

Do not treat English respelling as universal.

Do not change the target-language conventional name across support locales.

---

# Multiple Names

Some WritingUnits have historical, regional, formal, colloquial or alternative
names.

The conceptual model must support name roles such as:

- preferred;
- alternative;
- regional;
- historical;
- formal;
- deprecated.

The course profile must select one preferred beginner name.

Do not expose multiple alternatives to A0 learners unless pedagogically
necessary.

---

# Multiple Readings

Some WritingUnits have multiple readings.

Examples include:

- Japanese kanji;
- Chinese characters across compounds or varieties;
- Arabic letters affected by surrounding marks;
- English graphemes;
- context-dependent letter sequences.

A reading must be representable conceptually with:

- readingId;
- language;
- variety;
- context;
- writtenForm;
- pronunciationUnitId;
- meaningOrFunction;
- priority;
- difficulty;
- examples.

Do not model multiple readings as one comma-separated text string.

---

# Conditional Requiredness

Do not require every field for every writing system.

Use deterministic applicability rules.

Conventional name:

- required when the writing tradition defines a teachable conventional name;
- may be absent or replaced by a pedagogical designation when no single
  conventional name exists.

Name IPA:

- required when a conventional spoken name is taught;
- not required merely to satisfy schema completeness where no conventional
  name is used pedagogically.

Reading:

- required whenever the WritingUnit contributes to reading;
- may contain multiple context-dependent readings.

Pronunciation:

- required for every reading taught as production or recognition knowledge.

Meaning:

- required for meaning-bearing units when meaning is part of the learning
  objective.

Stroke order:

- required only when handwriting or character construction is in scope.

Confusables:

- required when a beginner can realistically mistake the unit for another
  symbol.

Composition:

- required for systems where components combine structurally, including
  Hangul, combining diacritics and many character-based systems.

---

# Script-Specific Considerations

## Chinese

Han characters are WritingUnits.

Do not state that every Chinese character has a conventional "name" identical
to its reading.

A Han character may have:

- one or more readings in a particular language and variety;
- one or more meanings;
- components or radicals that may themselves be taught as WritingUnits;
- stroke order separate from pronunciation.

Mandarin pinyin is a standardized reading notation, not a localized
pronunciation hint. Tone is part of the reading and must not be omitted where
the reading is taught.

IPA remains locale-independent pronunciation data when authored.

Localized learner hints are support-locale aids and must not replace pinyin.

Conceptual example:

```text
symbol: 人
designation: character 人
Mandarin reading: ren with second tone
meaning: person
IPA: reviewed locale-independent transcription
localized explanation: support-language-specific
```

## Korean

Individual jamo are WritingUnits.

Jamo have conventional Korean names.

Jamo have sound values that may differ by syllable position.

A Hangul syllable block may also be a compound WritingUnit.

The block's visual composition must be taught.

Name pronunciation and sound value are distinct.

Batchim behavior belongs to context-sensitive ReadingRules.

Localized hints must not replace Hangul structure or IPA.

Conceptual example:

```text
symbol: ㄱ
conventional name: 기역
name pronunciation: separate PronunciationUnit
reading values: context-dependent
composition examples: 가, 각
```

## Japanese

Hiragana and Katakana symbols are WritingUnits.

Kana generally have conventional designations or readings that often coincide,
but the model must not assume name and reading are universally identical.

Kanji may have multiple readings.

On-reading and kun-reading are structured reading categories.

Okurigana and compounds affect reading.

Pitch accent, where taught, belongs to pronunciation data rather than symbol
naming.

Romanization is support notation, not canonical pronunciation.

## Arabic And Hebrew

Base letters may have positional forms.

Short vowels may be absent or represented by marks.

Letter names and sound values are separate.

Combining marks may be WritingUnits.

Directionality is part of presentation metadata.

Joining behavior belongs to writing or composition rules.

Presentation must not reorder bidirectional text incorrectly.

Isolated, initial, medial and final forms may require visual introduction.

---

# Confusable-Symbol Standard

A WritingUnit introduction must identify likely confusions based on:

- visual similarity;
- case;
- script;
- direction;
- component order;
- rotation or reflection;
- font rendering;
- Unicode lookalikes.

Examples:

- lowercase `l` versus uppercase `I`;
- Latin `a` versus Cyrillic `а`;
- Latin `B` versus Cyrillic `В`;
- `O` versus `0`;
- `rn` versus `m`;
- `ll` versus `II`;
- Hangul component confusions;
- similar kana;
- similar Han characters;
- Arabic positional forms.

Do not present all possible confusables. Select those relevant to the current
learner level.

The distinction must not depend on color alone.

Accessibility wording must name each symbol unambiguously.

---

# Pronunciation Completeness

Every WritingUnit reading that the learner is expected to recognize or produce
must have a complete pronunciation representation appropriate to the course
level.

Where applicable, this consists of:

- declared target-language variety;
- canonical IPA or another explicitly approved locale-independent phonetic
  representation;
- target-script reading notation where the language uses one;
- support-locale learner hint;
- stress, tone, length or other contrastive suprasegmental information;
- context notes where pronunciation changes.

Do not reduce all pronunciation systems to stress.

The model must support:

- lexical stress;
- tone;
- vowel length;
- pitch accent;
- gemination;
- consonant strength;
- phonation;
- other contrastive features.

A localized learner hint is incomplete if it omits a contrastive pronunciation
property necessary to distinguish the taught form.

Do not require advanced phonetic detail at A0 unless it changes recognition or
meaning.

---

# Accessibility

Every WritingUnit presentation must have semantics capable of conveying:

- script;
- symbol;
- case, where relevant;
- component sequence;
- conventional name;
- reading;
- confusable comparison.

For example, a screen reader must not announce `ll` and `II` without
explaining which are lowercase Latin `l` and which are uppercase Latin `I`.

Accessibility must account for:

- bidirectional scripts;
- combining characters;
- characters that screen readers pronounce inconsistently;
- invisible or spacing marks;
- multi-code-point graphemes.

---

# Unicode And Grapheme Clusters

A WritingUnit is not necessarily one Unicode code point.

One visible grapheme may contain multiple code points.

One code point may have multiple visual forms.

Normalization must not destroy educational distinctions.

IDs must not be based solely on raw visible text.

Canonical orthography and code-point representation must be documented.

Combining marks must be preserved.

Variation selectors may matter.

Locale-dependent case conversion must not define educational identity.

This section is a technical authoring rule, not a runtime implementation.

---

# Authoring Workflow

Recommended future workflow:

```text
identify writing system
-> classify WritingUnit kind
-> assign stable ID
-> author symbol and canonical representation
-> author designation
-> author conventional name where applicable
-> author name pronunciation where taught
-> author reading or readings
-> connect PronunciationUnits
-> connect ReadingRules
-> author localized learner support
-> author confusables
-> author examples
-> assign prerequisites
-> language review
-> pronunciation review
-> beginner review
-> release validation
```

A WritingUnit must not be published merely because its symbol field is filled.

---

End of document.
