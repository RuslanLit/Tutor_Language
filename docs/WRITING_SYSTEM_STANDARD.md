# WRITING_SYSTEM_STANDARD.md

Status: NORMATIVE
Scope: language writing-system model
Authority: primary

Version: 1.1

Related documents:

- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md
- CONTENT_MODEL.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- CURRICULUM_SPEC.md
- EDUCATIONAL_LANGUAGE_STANDARD.md
- WRITING_UNIT_INTRODUCTION_STANDARD.md
- PRONUNCIATION_MODEL.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- READING_RULE_PREREQUISITE_STANDARD.md
- GRAPHEME_PRESENTATION_STANDARD.md
- CONTENT_REVIEW_PROTOCOL.md
- RELEASE_CHECKLIST.md

---

# Purpose

This document defines the universal educational standard for writing systems in
Tutor Language.

The standard exists because writing systems are not merely fonts, characters or
implementation details. For a beginner learner, a written symbol is educational
knowledge. The learner must know how it looks, what it is called or designated,
how that name is pronounced where applicable, how the unit is read in
meaningful language, and how it behaves before being asked to read, type,
recall or apply it.

This standard supports Latin, Cyrillic, Greek, Arabic, Hebrew, Hangul,
Hiragana, Katakana, Hanzi, Kana and future writing systems without requiring
another educational architecture redesign.

Runtime schemas, JSON migrations, editors and validators are deferred unless a
specific implementation phase states otherwise.

---

# Universal Principle

The learner must never encounter an unknown writing unit before it has been
explicitly introduced.

This rule is mandatory for all target languages and support locales.

In practical terms:

```text
WritingUnit Introduction
-> ReadingRule
-> Pronunciation
-> Recognition
-> Vocabulary
-> Phrase
-> Dialogue
```

The forbidden order is:

```text
Unknown symbol
-> Vocabulary
```

The correct order is:

```text
Known symbol
-> Decodable word
-> Meaningful vocabulary
```

---

# WritingUnit

A WritingUnit is a reusable educational knowledge object representing a
written symbol or symbol sequence that the learner may need to recognize,
name, pronounce, type or distinguish visually.

A writing unit is not merely a Unicode character or visible string. It is
reusable educational knowledge whose visual form, designation, conventional
name, name pronunciation, reading, pronunciation, behavior, function and
confusability are distinct authoring concerns.

A WritingUnit may represent:

- single letter;
- digraph;
- trigraph;
- ligature;
- accented letter;
- Hangul jamo;
- Hangul syllable block;
- Kana symbol;
- Chinese character;
- Arabic letter;
- Hebrew letter;
- future writing symbols.

A WritingUnit is target-language educational content. It is not learner state,
not UI text and not a lesson-only note.

---

# Mandatory Fields

A complete conceptual WritingUnit defines:

- id;
- schemaVersion;
- writingSystemId;
- targetLanguage;
- targetVariety;
- unitKind;
- symbol;
- canonicalOrthography;
- graphemeComponents;
- caseForms;
- visualVariants;
- designation;
- conventionalNames;
- namePronunciations;
- readings;
- pronunciationUnitIds;
- readingRuleIds;
- localizedIntroductions;
- localizedNameHints;
- localizedReadingHints;
- localizedExplanations;
- semanticFunctions;
- grammaticalFunctions;
- strokeOrderReference;
- compositionRules;
- confusableWritingUnitIds;
- examples;
- commonMistakes;
- difficulty;
- prerequisites;
- metadata.

These are conceptual fields. They describe the target architecture and
authoring standard. Current runtime JSON support may be partial.

## Unit Kinds

The conceptual `unitKind` scope includes at least:

- letter;
- letter_sequence;
- digraph;
- trigraph;
- ligature;
- diacritic;
- letter_with_diacritic;
- syllabogram;
- mora_symbol;
- jamo;
- syllable_block;
- character;
- logograph;
- radical;
- component;
- abjad_letter;
- abugida_unit;
- vowel_mark;
- tone_mark;
- punctuation;
- combining_mark;
- other.

This list describes semantic scope for future models. It is not a final
runtime API in this documentation-only phase.

---

# Field Ownership

Locale-independent target-language fields:

- stableId;
- writingSystemId;
- targetLanguage;
- targetVariety;
- unitKind;
- symbol;
- canonicalOrthography;
- conventionalNames when the writing tradition defines target-language names;
- namePronunciations;
- readings;
- pronunciationUnitIds;
- readingRuleIds;
- confusableWritingUnitIds;
- target-language examples;
- semantic or grammatical functions when they are target-language facts;
- difficulty;
- technical metadata.

Support-locale-localized fields:

- localized designation when it is learner-facing support text;
- localized introductions;
- localized name hints;
- localized reading hints;
- localized explanations;
- localized learner pronunciation hints;
- localized pronunciation explanations;
- localized visual-recognition explanations;
- localized common-mistake explanations;
- localized memory hints.

Reusable related knowledge:

- pronunciation belongs to PronunciationUnit;
- spelling-to-sound behavior belongs to ReadingRule;
- symbol identity and visual recognition belong to WritingUnit.

No support-language text belongs in locale-independent fields.

---

# Mandatory Educational Rule

Every WritingUnit introduction must explicitly teach:

- how the symbol is written;
- what the unit is;
- what the unit is conventionally called, when applicable;
- how that conventional name is pronounced, when taught;
- how the unit is read or pronounced in meaningful language;
- how the reading may change by context;
- what function or meaning it performs, when relevant;
- how the symbol behaves inside words;
- typical beginner mistakes;
- how to recognize it visually;
- how not to confuse it with similar symbols.

Examples:

| Target language | WritingUnit | Called |
| --- | --- | --- |
| Spanish | `h` | `hache` |
| Chinese | `人` | designation such as "character 人"; Mandarin reading with tone marking according to course policy |
| Korean | `ㄱ` | `기역` |
| Japanese | `あ` | hiragana `a` |
| Arabic | `ب` | `ba` / `ba'` according to course transliteration policy |

The learner-facing support explanation is localized. The stable educational
identity remains target-language content.

Do not conflate the conventional name with the reading inside words.

For ReadingRule cards, do not turn writing-system safety into learner-facing
prose unless the lesson explicitly teaches that writing-system contrast.
Ordinary pronunciation cards must follow the Learner Presentation Standard in
PRONUNCIATION_AUTHORING_GUIDE.md and answer how to read the next course word,
not how validators distinguish scripts.

Incorrect:

```text
h is pronounced hache
```

Correct concept:

```text
The letter is written h.
Its Spanish name is hache.
The name hache is pronounced /ˈatʃe/.
In most modern Spanish words, h itself is silent.
```

The detailed first-introduction standard is
WRITING_UNIT_INTRODUCTION_STANDARD.md.

---

# Grapheme Presentation

Every new WritingUnit must have an introductory presentation before active
use.

The presentation must include:

- visual symbol;
- localized designation;
- conventional target-language name, where applicable;
- pronunciation of the conventional name, where applicable;
- reading or readings;
- pronunciation of the taught reading;
- IPA or approved locale-independent phonetic representation where applicable;
- localized learner pronunciation hint;
- function or meaning, where applicable;
- visual decomposition or composition, where applicable;
- one isolated example;
- one word example;
- common confusion;
- memory hint.

Do not display absent or irrelevant sections.

Do not turn the card into a dense technical specification.

For visually confusable symbols, use GRAPHEME_PRESENTATION_STANDARD.md for
decomposition, localized names, contrast display and accessibility guidance.

---

# Universal Reading Progression

The mandatory progression for alphabetic and similar systems is:

```text
WritingUnit
-> ReadingRule
-> PronunciationUnit
-> VocabularyItem
-> Phrase
-> Sentence
-> Dialogue
-> Reading
-> Writing
-> Communication
```

For compositional systems such as Hangul:

```text
component WritingUnits
-> composition rule
-> syllable block
-> pronunciation
-> recognition
-> vocabulary
```

For morphosyllabic systems:

```text
character or components
-> reading
-> tone or pronunciation
-> meaning
-> compound behavior
-> vocabulary and sentence use
```

This progression does not require every lesson to contain every stage. It means
that active use of a later stage must not depend on an unknown earlier-stage
unit.

Review may revisit any stage, but review never counts as first introduction.

---

# Relationship With ReadingRule

A ReadingRule describes reusable behavior of one or more WritingUnits.

Examples:

- Spanish `h` is silent;
- Spanish `ll` before a vowel follows the course's selected `ll/y` policy;
- German `sch` represents a single pronunciation pattern;
- Polish `sz` represents a single pronunciation pattern;
- Japanese kana have stable syllabic readings;
- Arabic letters change shape depending on position.

ReadingRule prerequisites remain governed by
READING_RULE_PREREQUISITE_STANDARD.md.

A learner must not actively use a ReadingRule before the WritingUnits required
by that rule have been introduced, unless the same activity is the explicit
introductory presentation.

---

# Relationship With PronunciationUnit

PronunciationUnit owns reusable pronunciation knowledge.

WritingUnit owns symbol identity and visual recognition.

ReadingRule owns reusable spelling-to-sound behavior.

These objects reference each other by stable IDs. They must not duplicate each
other's full data.

Every WritingUnit reading that the learner is expected to recognize or produce
must have a complete pronunciation representation appropriate to the course
level. Where applicable, this includes declared target-language variety,
canonical IPA or another explicitly approved locale-independent phonetic
representation, target-script reading notation, support-locale learner hint,
stress, tone, length or other contrastive suprasegmental information, and
context notes where pronunciation changes.

Do not reduce all pronunciation systems to stress. The model must support
lexical stress, tone, vowel length, pitch accent, gemination, consonant
strength, phonation and other contrastive features.

Example:

```text
VocabularyItem
        |
        v
WritingUnit
        |
        v
PronunciationUnit
        |
   +----+----------+
   |               |
  IPA        ReadingRule
   |
Localized learner hints
        |
      Lesson
        |
     Exercise
```

---

# Reuse

One WritingUnit may be reused by:

- Vocabulary;
- Grammar;
- Reading;
- Dialogue;
- Listening;
- Speaking;
- Typing;
- Review;
- Competency checks;
- future AI-assisted tutoring.

Lessons must reference WritingUnits and related ReadingRules or
PronunciationUnits rather than storing copied writing-system explanations.

---

# Support Languages

WritingUnit presentation is localized for the learner's support language.

IPA is universal and locale-independent.

ReadingRule is reusable and target-language specific.

PronunciationUnit is reusable and target-language specific.

Only learner-facing explanations, hints, memory aids and accessibility text
change by support locale.

English explanations or English-oriented respelling must not be used as a
production fallback for Russian, Ukrainian, Polish, German or any other
unrelated support locale.

---

# Chinese Support

Chinese characters are WritingUnits.

Do not state that every Chinese character has a conventional "name" identical
to its reading.

Stroke order belongs to WritingUnit because it describes how the symbol is
written.

Mandarin pinyin is a standardized reading notation, not a localized
pronunciation hint. Tone is part of the reading and must not be omitted where
the reading is taught.

IPA remains the canonical pronunciation representation.

A Han character may have one or more readings in a particular language and
variety, one or more meanings, components or radicals that may themselves be
taught as WritingUnits, and stroke order separate from pronunciation.

Localized learner hints are support-locale aids and must not replace pinyin.

---

# Korean Support

Hangul jamo are WritingUnits.

Hangul syllable blocks may also be WritingUnits when the course teaches block
recognition or assembly.

Assembly explanation is localized learner support.

Jamo have conventional Korean names. Jamo also have sound values that may
differ by syllable position. Name pronunciation and sound value are distinct.
Batchim behavior belongs to context-sensitive ReadingRules.

IPA remains the canonical pronunciation representation.

---

# Japanese Support

Hiragana, Katakana and Kanji are WritingUnits.

Reading variants belong to PronunciationUnit and ReadingRule data. Learner
support may explain which reading is used in the current word or context.

Kana generally have conventional designations or readings that often coincide,
but the model must not assume name and reading are universally identical.
Kanji may have multiple readings. On-reading and kun-reading are structured
reading categories. Okurigana and compounds affect reading. Pitch accent,
where taught, belongs to pronunciation data rather than symbol naming.
Romanization is support notation, not canonical pronunciation.

Kanji stroke order and visual recognition belong to WritingUnit.

---

# Arabic And Hebrew Support

Base letters may have positional forms.

Short vowels may be absent or represented by marks.

Letter names and sound values are separate.

Combining marks may be WritingUnits.

Directionality is part of presentation metadata.

Joining behavior belongs to writing or composition rules.

Presentation must not reorder bidirectional text incorrectly.

Isolated, initial, medial and final forms may require visual introduction.

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

---

# Authoring Workflow

Recommended authoring sequence:

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

Authoring checklist:

1. Identify every new written symbol or symbol sequence.
2. Reuse existing WritingUnits where possible.
3. Create missing WritingUnits before vocabulary uses them.
4. Author designation and conventional name where applicable.
5. Author name pronunciation separately from reading pronunciation where
   applicable.
6. Author all taught readings as structured data, not comma-separated prose.
7. Link WritingUnits to ReadingRules and PronunciationUnits.
8. Author localized learner explanations and hints.
9. Author confusables, composition rules and examples.
10. Place the WritingUnit introduction before active vocabulary, phrase,
   dialogue, reading or typing use.
11. Validate course order.
12. Review on device with the intended support locale.

A WritingUnit must not be published merely because its symbol field is filled.

---

# Validation Rules

Future validators should report deterministic issues such as:

- `writingUnit.unknownReference`
- `writingUnit.missingIntroduction`
- `writingUnit.usedBeforeIntroduction`
- `writingUnit.missingDesignation`
- `writingUnit.missingConventionalName`
- `writingUnit.conflatesNameAndReading`
- `writingUnit.missingNamePronunciation`
- `writingUnit.missingReading`
- `writingUnit.missingReadingPronunciation`
- `writingUnit.missingContrastiveFeature`
- `writingUnit.missingPronunciation`
- `writingUnit.missingIpa`
- `writingUnit.missingLocalizedLearnerHint`
- `writingUnit.missingLocalizedExplanation`
- `writingUnit.missingVisualPresentation`
- `writingUnit.missingConfusableSymbolGuidance`
- `writingUnit.unknownReadingRule`
- `writingUnit.unknownPronunciationUnit`
- `writingUnit.vocabularyIntroducesUnseenSymbol`
- `writingUnit.phraseIntroducesUnseenSymbol`
- `writingUnit.dialogueIntroducesUnseenSymbol`
- `writingUnit.lessonOrderViolation`
- `writingUnit.invalidGraphemeCluster`
- `writingUnit.unstableTextBasedId`

Validators must not infer identity from localized prose. They may audit visible
target text to find likely missing WritingUnit references, but authored stable
IDs remain the source of truth.

---

# Review Protocol

Reviewers must check that:

- every new symbol is introduced;
- every symbol is named;
- every symbol is pronounced;
- symbol name and symbol reading are distinct;
- pronunciation of the name is available where taught;
- all taught readings are represented;
- meaning or function is separated from pronunciation;
- every symbol is explained;
- every symbol is visually distinguishable;
- stress, tone, length or other contrastive features are preserved where
  required;
- every symbol has beginner guidance;
- every active use follows introduction;
- every localized explanation is natural in the support language;
- accessibility text does not rely on ambiguous glyphs alone.

---

# Future Applicability

This standard applies to:

- Spanish;
- English;
- German;
- French;
- Italian;
- Polish;
- Ukrainian;
- Portuguese;
- Chinese;
- Japanese;
- Korean;
- Arabic;
- Hebrew;
- future languages.

It assumes no specific alphabet, script direction, phonology or support
language.

---

# Current Implementation Status

This phase is documentation only.

Existing runtime support covers PronunciationUnit, ReadingRule and selected
grapheme presentation behavior for the migrated Spanish A0 scope. It does not
yet implement a standalone runtime WritingUnit schema, JSON migration, editor,
full validators or writing-system database.

Those implementation tasks are deferred to future phases.

---

End of document.
