# Pedagogical Evidence For Canonical Lesson 1

Status: EVIDENCE
Scope: Spanish course/pedagogical review evidence
Normative authority: PEDAGOGICAL_SCENARIO_MODEL.md

Phase: R2E16A

Scope: Spanish A0 Lesson 1 for Ukrainian learner-facing content

---

# Purpose

This document summarizes the evidence that should govern the canonical first
Tutor Language lesson.

It is a research document only. It does not implement lessons, JSON, Flutter,
assets, validators or curriculum.

---

# Method And Limitations

Sources used:

- local beginner Spanish textbooks under `Books/`;
- introductory language-learning methodology references;
- existing Tutor Language pedagogical documentation.

The analysis extracts pedagogical principles. It does not copy textbook
dialogues, exercises or lesson wording.

Local source limitation:

- `Books/Испанский для начинающих (2).pdf` produced no extractable text with
  `pdftotext`.
- `Books/Самоучитель испанского.djvu` could not be text-extracted in the current
  environment because `djvutxt` was unavailable.

These two files were not used as evidence for conclusions. They should be
revisited if OCR or DJVU text extraction becomes available.

---

# Source Log

## Textbook A

Source:

`Books/Испанский для начинающих.pdf`

Bibliographic identity:

И. А. Дышлевая, `Курс испанского языка для начинающих`, 2nd ed., Перспектива,
2017.

Relevant sections:

- Preface, extracted near the beginning of the PDF.
- Introductory phonetic section, printed pages around 9-14.
- First dialogue/exercise cluster, printed pages around 30-36.

Observed pedagogy:

- The course begins with an introductory phonetic section before communicative
  Lesson 1 content.
- The phonetic section presents the alphabet, sounds, reading rules and many
  sound-focused reading exercises.
- `Hola` appears later inside multi-line greeting and introduction dialogues,
  not as a single-word lesson.
- Lesson exercises include reading dialogues, lexical commentary, completing
  tables, composing dialogues and translation.

Conclusion:

This source supports the importance of pronunciation support before independent
reading, but it reflects a classroom/book model with heavy front-loaded
phonetics and too much first-lesson material for a smartphone A0 first lesson.

## Textbook B

Source:

`Books/Испанский.pdf`

Bibliographic identity:

М. М. Раевская, А. И. Ковригина, `Испанский язык: новый самоучитель`, АСТ,
2017.

Relevant sections:

- Preface and structure, printed pages around 5-10.
- Lesson 1, printed pages around 39-59.

Observed pedagogy:

- The book frames its first stage as A1 phonetic course plus Lessons 1-5.
- Lesson 1 begins with greeting and introduction formulas. `Hola` is introduced
  as a broad greeting before names, politeness, personal pronouns, `ser`,
  `estar`, `ir`, countries, professions and goodbye formulas.
- The first lesson is communicative in topic but very dense in vocabulary and
  grammar.
- The book expects long self-study or classroom time, not short mobile
  interactions.

Conclusion:

This source strongly supports beginning with greeting/contact, but contradicts
the idea that a smartphone Lesson 1 should inherit textbook-scale density.

## Textbook C

Source:

`Books/Учебник испанского для начинающих.pdf`

Bibliographic identity:

Е. И. Родригес-Данилевская, А. И. Патрушев, И. Л. Степунина,
`Учебник испанского языка. Практический курс для начинающих`, ЧеРо, 2007.

Relevant sections:

- Preface, printed pages around 3-5.
- Lesson 1 phonetics, extracted around the printed Lesson 1 opening.
- Later Lesson 1 dialogue/exercise sections.

Observed pedagogy:

- The textbook states a practical goal: speaking and listening are central.
- It explicitly describes phonetics, grammar, vocabulary, texts and exercises as
  core lesson components.
- It reports average text vocabulary around 80-90 new words in a lesson.
- Method guidance assumes a teacher and audio recordings; exercises include
  listening/repeating, teacher questions, retelling and dialogue construction.
- Lesson 1 begins with phonetics and articulatory descriptions before later
  dialogue work.

Conclusion:

This source is valuable evidence for teacher-mediated classroom practice, but
its volume, metalanguage and teacher/audio assumptions should not be copied into
the first offline smartphone lesson.

## Textbook D

Source:

`Books/самоучитель испанского.pdf`

Bibliographic identity:

М. В. Малинская, `Экспресс-самоучитель испанского языка`, АСТ, 2016.

Relevant sections:

- Author introduction, printed pages around 3-4.
- Introductory phonetic lesson, beginning near the PDF opening.
- Lesson 1, printed pages around 13-18 and later Lesson 1 exercise pages.

Observed pedagogy:

- The book is designed for independent learners.
- It begins with an introductory phonetic lesson and alphabet.
- Lesson 1 is titled around greetings and introduces many greeting, question,
  answer, introduction, origin/residence and goodbye expressions.
- Exercises include gap filling, choosing reactions, translating dialogues and
  memorizing dialogues.
- Later Lesson 1 content expands into grammar and additional dialogue
  translation.

Conclusion:

This source supports independent learning, greeting as a first communicative
domain and immediate exercises after presentation. It also shows the common
paper-self-study tendency to overload the first lesson and rely on memorization
and translation.

## Tutor Language Documentation

Sources:

- `docs/LESSON_AUTHORING_ENTRYPOINT.md`
- `docs/LEARNING_STATE_MACHINE.md`
- `docs/PEDAGOGICAL_SCENARIO_MODEL.md`
- `docs/LEARNING_MODEL.md`
- `docs/EDUCATIONAL_PRINCIPLES.md`
- `docs/AUTHORING_STYLE_GUIDE.md`
- `docs/EDUCATIONAL_LANGUAGE_STANDARD.md`

Relevant principles:

- A lesson is learner-state movement, not a sequence of storage categories.
- Required workflow: learner state -> scenario -> learner action -> support
  plan -> assessment plan -> later content mapping.
- Preferred progression: exposure, recognition, cued recall, free recall,
  controlled application, independent application.
- Support should fade.
- Recognition alone is weaker evidence than recall and production.
- Learner-facing text must be simple, natural, useful and free of unnecessary
  terminology.
- Beginner pronunciation support must use learner-understandable explanation
  before optional technical notation.

Conclusion:

Tutor Language documentation supports a small measurable Lesson 1 outcome,
state transitions, support fading, active recall and meaningful use.

## External Methodology References

Sources consulted:

- Council of Europe, CEFR Companion Volume page, 2024 edition information.
  The CEFR describes language ability in terms of communicative activities and
  includes Pre-A1/A1 descriptors, online interaction and phonological
  competence.
- British Council TeachingEnglish, "Free practice". It contrasts controlled
  practice with freer production and situates free practice in production stages.
- Cambridge University Press, Dörnyei chapter summary on principled
  communicative language teaching. It frames CLT around usable communicative
  competence.
- Cambridge University Press, Jackson `Task-Based Language Teaching` summary.
  It identifies task design, preparation, interaction and repetition as
  relevant to second-language outcomes.

Conclusion:

Introductory methodology supports communication as the goal, controlled
practice before freer use, task meaningfulness and attention to learner ability.
It does not support making Lesson 1 a pure grammar, alphabet or dictionary
entry.

---

# Required Questions

## 1. What communicative objective is most commonly used for Lesson 1?

Most accessible beginner Spanish textbooks examined begin the first
communicative lesson around greeting, first contact and introduction.

Evidence:

- Textbook B introduces first expressions around greeting, presentation and
  goodbye.
- Textbook D titles Lesson 1 around greetings and begins with `Hola`.
- Textbook A introduces `Hola` in greeting/introduction dialogues after a
  phonetic introduction.
- Textbook C is less minimal and begins with phonetics, but later first-lesson
  dialogue work includes greetings and classroom/social contact.

Recommendation:

Tutor Language Lesson 1 should use a first-contact greeting objective. The
recommended measurable objective is not "learn greetings" but:

```text
The learner can start a first Spanish exchange by sending Hola.
```

This objective is strongly supported by textbook patterns and Tutor Language's
communication-first learning model.

## 2. How many new language units are normally introduced?

Observed range in sources:

- Minimum: one expression can be justified for a smartphone micro-lesson, but
  this is a Tutor Language adaptation rather than the textbook norm.
- Typical textbook first communicative lesson: roughly 10-30 visible phrases or
  lexical units, often including greetings, "how are you", names, origin and
  goodbye formulas.
- Maximum in the examined sources: 80-90 new words in a traditional university
  textbook text, plus grammar and phonetics.

Why the range is wide:

- Paper and classroom textbooks treat one lesson as several hours of study.
- University textbooks assume a teacher, audio support, classroom correction and
  homework.
- Self-study books compress many survival phrases into one chapter because page
  count and chapter structure matter more than phone-session cognitive load.
- Tutor Language's first phone lesson is a smaller session and must create
  independent action without a teacher.

Recommendation:

For Tutor Language Lesson 1, use one target Spanish expression only:

```text
Hola.
```

This is below the textbook norm, but evidence supports it as an adaptation to
offline mobile learning and the documented Tutor Language requirement to avoid
overload.

## 3. How is pronunciation introduced?

Observed approaches:

- Before vocabulary: Textbooks A, C and D include an introductory phonetic or
  alphabet section before or at the start of communicative content.
- Together with vocabulary: Textbook B introduces `Hola` with explanation and
  pronunciation/usage commentary inside the first communicative lesson.
- After vocabulary: None of the accessible sources clearly delay all
  pronunciation support until after first use; reading support appears early.

How much pronunciation is introduced:

- Traditional textbooks introduce a large system: alphabet, vowels, consonants,
  reading rules, stress and many examples.
- Communicative self-study sources introduce less at the exact point of the word
  or phrase, but still often include more phonetics than a first mobile screen
  should carry.

Recommendation:

Tutor Language Lesson 1 should introduce pronunciation together with the target
word, after meaning is established:

```text
Hola. -> привіт -> Читай приблизно: ола
```

Do not introduce the whole alphabet, silent `h`, IPA or articulatory terms in
Lesson 1.

## 4. Should the first lesson begin with phonetics?

Evidence for yes:

- Textbooks A, C and D begin with phonetic/alphabet sections.
- For Spanish, early reading support is important because letters such as `h`,
  `j`, `ll`, `ñ`, `c`, `g`, `qu` differ from learner expectations.

Evidence for no:

- Communicative first lessons commonly begin with greetings and first contact.
- Tutor Language documentation requires every step to serve the nearest learner
  action and rejects unnecessary terminology.
- A phone learner with no teacher may experience a full phonetic introduction as
  abstract, heavy and disconnected from communication.

Recommendation:

Do not begin Lesson 1 with phonetics as a system.

Begin with a communicative need, then provide only the pronunciation support
needed to read `Hola.`. Systematic phonetics should be distributed across later
lessons when each rule helps the next word.

Judgment:

Evidence is mixed in textbooks, but Tutor Language constraints make the
communication-first approach better for the first smartphone lesson.

## 5. When does independent reading normally begin?

Textbooks:

- In phonetic-course textbooks, independent reading begins after alphabet and
  sound drills.
- In communicative lessons, learners read dialogues early, but this assumes the
  surrounding book/audio/teacher support can carry the load.

Tutor Language:

- The state machine says supported decoding must precede independent reading.
- The scenario model says localized pronunciation support should appear before
  asking the learner to read unfamiliar target material.

Recommendation:

Independent reading should begin only after:

1. the learner has seen the word and meaning;
2. the learner has received simple Ukrainian pronunciation support;
3. the learner has recognized the word in a changed context.

For Lesson 1, independent reading evidence should be limited to recognizing
`Hola.` without visible `ола`.

## 6. When is the learner expected to type or produce language independently?

Textbooks:

- Traditional books often ask learners to translate or compose after a large
  presentation block.
- Dialogue memorization and teacher-led oral production are common, but they
  depend on classroom or paper conditions.

Methodology:

- Controlled practice normally precedes freer production.
- Task-based and communicative approaches support meaningful use after enough
  preparation.

Tutor Language:

- Recognition is not sufficient evidence.
- Cued recall should precede free recall.
- Independent assessment must avoid answer leakage.

Recommendation:

Independent typing should happen only after:

```text
meaning encounter
-> pronunciation support
-> changed-context recognition
-> visible construction
-> partial cue recall
```

Lesson 1 should include independent typing because the final outcome is a first
sent message, but the prompt must not show `Hola.`, `ола` or partial spelling.

## 7. Which exercise types are most common?

Ranked from the examined sources:

1. Reading aloud / listen-repeat / pronunciation drills.
   Used because Spanish textbooks often start with sound-symbol mapping.

2. Read and translate dialogues.
   Used because textbooks model communication through written dialogues.

3. Gap filling and completion.
   Used to control form practice after presentation.

4. Multiple choice / choose the right reaction.
   Used for early recognition and comprehension checks.

5. Translation from support language into Spanish.
   Used as production evidence in paper self-study contexts.

6. Compose or perform dialogues.
   Used for communicative transfer, usually with a teacher or partner.

7. Memorize dialogues.
   Used in some self-study books as a substitute for live interaction.

Tutor Language adaptation:

For a first phone lesson, use:

1. observation of a communication situation;
2. supported presentation;
3. recognition with plausible contrast;
4. guided construction/completion;
5. independent typed recall;
6. final send-message action.

## 8. Which exercise types appear to produce little educational value?

Low-value for Tutor Language Lesson 1:

- Memorizing whole dialogues.
  It may create surface fluency, but for an offline app it risks recitation
  without understanding or adaptive correction.

- Large alphabet or sound drills before need.
  Useful in a textbook, but poor as a first phone experience because it delays
  communication and increases cognitive load.

- Long word lists.
  They create dictionary-like lessons and weak immediate use.

- Translation of overloaded dialogues.
  Good for advanced classroom practice, but too heavy for first-contact A0.

- Multiple choice as final evidence.
  Useful for recognition, but insufficient for independent communication.

- Copy-the-answer tasks.
  They do not prove recall.

## 9. Which traditional textbook parts should probably not be copied into a smartphone application?

Do not copy directly:

- full opening alphabet tables;
- long articulatory descriptions;
- long grammar explanations before use;
- word lists grouped by topic but not needed immediately;
- long printed dialogues with many unknown words;
- teacher-led prompts such as "answer the teacher's questions";
- memorize-and-recite dialogue instructions;
- large translation blocks;
- cultural notes before the learner has a communicative anchor;
- exercises designed for partner/classroom role-play without adaptation.

Why:

These components assume paper space, a teacher, audio recordings, classroom
time, homework and partner correction. A smartphone app must replace those
teacher functions through smaller screens, visible state transitions,
deterministic feedback and tight support fading.

## 10. Which pedagogical principles are consistent across most modern beginner courses?

Strong candidates for Tutor Language:

- Begin with useful communication, often greeting or first contact.
- Provide pronunciation/reading support before expecting reading.
- Use examples before abstract theory where possible.
- Move from controlled support to more independent production.
- Practice should follow presentation soon, not many pages later.
- Reuse earlier material in later contexts.
- Use dialogues or situations to make language feel social.
- Give feedback or correction after learner output.
- Keep learner output constrained at the beginning.

Tutor Language-specific adaptation:

- Convert teacher-led correction into deterministic app feedback.
- Replace long textbook lessons with phone-sized scenes.
- Replace partner dialogue with simulated first-message communication when no
  live partner is available.
- Use active recall as stronger evidence than recognition.
- Avoid adding new terms unless they help the next learner action.

---

# Recommendation For Canonical Lesson 1

Recommended Lesson 1 principle:

```text
The first lesson should give the learner a first successful act of Spanish
communication, not a first inventory of Spanish.
```

Recommended target:

```text
Hola.
```

Recommended support path:

```text
human situation
-> target word + Ukrainian meaning
-> Ukrainian pronunciation support
-> recognition in changed context
-> guided construction
-> cued recall
-> independent typing
-> sent-message communication
```

Recommended exclusion:

Do not teach the Spanish alphabet, silent `h`, greeting systems, names,
goodbye, grammar, IPA or cultural commentary in Lesson 1 unless the lesson
objective changes.

---

# Disagreements And Resolution

## Phonetics first vs communication first

Alternative A:
Start with phonetics and alphabet.

Evidence:
Several textbooks do this, especially classroom or systematic self-study
books.

Risk for Tutor Language:
It delays communication and may overload a mobile learner.

Alternative B:
Start with communication and introduce only needed pronunciation.

Evidence:
Greeting-first lessons and communicative methodology support this.

Recommendation:
Use Alternative B for Lesson 1. Preserve systematic phonetics for later
reading-rule moments.

## Many useful phrases vs one expression

Alternative A:
Teach greetings, how-are-you questions, names, origin and goodbye in the first
lesson.

Evidence:
Textbooks B and D do this.

Risk for Tutor Language:
Too many units make phone scenes repetitive, dictionary-like or dependent on
memorization.

Alternative B:
Teach one expression and make it usable.

Evidence:
Tutor Language learning-state documentation and mobile constraints support
small measurable outcomes.

Recommendation:
Use Alternative B for canonical Lesson 1.

## Dialogue memorization vs first-message communication

Alternative A:
Memorize short dialogues.

Evidence:
Some self-study books instruct learners to memorize dialogues.

Risk for Tutor Language:
Without a teacher, memorization can become surface recall with weak meaning.

Alternative B:
Use one realistic phone action: send the first greeting.

Evidence:
Task-based and communicative methodology prioritize meaningful use; Tutor
Language is a smartphone app.

Recommendation:
Use Alternative B.

---

# Evidence Status

Supported with converging evidence:

- greeting/first contact as Lesson 1 domain;
- pronunciation support before independent reading;
- controlled practice before independent production;
- active recall as stronger evidence than recognition;
- avoiding large first-lesson overload in a phone app.

Weak or mixed evidence:

- exactly one target expression. This is strongly supported by Tutor Language
  constraints but is smaller than the examined textbook norm.
- 20-30 minute lesson length. Textbooks use much longer lesson units; the
  duration is a product/mobile adaptation.

Contradicted by textbook tradition but justified by Tutor Language:

- not beginning with full phonetics;
- not introducing multiple greeting formulas in Lesson 1;
- not using dialogue memorization.

---

# References

Local:

- `Books/Испанский для начинающих.pdf`
- `Books/Испанский.pdf`
- `Books/Учебник испанского для начинающих.pdf`
- `Books/самоучитель испанского.pdf`
- `docs/LESSON_AUTHORING_ENTRYPOINT.md`
- `docs/LEARNING_STATE_MACHINE.md`
- `docs/PEDAGOGICAL_SCENARIO_MODEL.md`
- `docs/LEARNING_MODEL.md`
- `docs/EDUCATIONAL_PRINCIPLES.md`
- `docs/AUTHORING_STYLE_GUIDE.md`
- `docs/EDUCATIONAL_LANGUAGE_STANDARD.md`

External methodology:

- Council of Europe CEFR Companion Volume:
  https://www.coe.int/en/web/education/-/common-european-framework-of-reference-for-languages-learning-teaching-assessment-14
- British Council TeachingEnglish, "Free practice":
  https://www.teachingenglish.org.uk/en/article/free-practice
- Cambridge University Press, Dörnyei, "Communicative Language Teaching in the
  twenty-first century":
  https://www.cambridge.org/core/books/abs/meaningful-action/communicative-language-teaching-in-the-twentyfirst-century-the-principled-communicative-approach/9ADDC53C49360197E4B24763E553790C
- Cambridge University Press, Jackson, `Task-Based Language Teaching`:
  https://www.cambridge.org/core/elements/taskbased-language-teaching/395B3D3B0F7078DF325579CC8314E38B
