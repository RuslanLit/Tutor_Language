# Spanish A0 Curriculum Blueprint

Status: Draft source of truth for Spanish A0 restructuring

Version: 0.1

Date: 2026-07-12

Related documents:

- PROJECT_VISION.md
- PROJECT_CONTRACT.md
- EDUCATIONAL_PRINCIPLES.md
- LEARNING_MODEL.md
- CONTENT_MODEL.md
- CURRICULUM_SPEC.md
- AUTHORING_STYLE_GUIDE.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- AUTHORING_DECISIONS.md
- CONTENT_REVIEW_CHECKLIST.md
- LANGUAGE_COURSE_BLUEPRINT.md
- V1_IMPLEMENTATION_CONTRACT.md
- V1_TECHNICAL_SPEC.md
- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md

---

# Purpose

This document defines the target Spanish A0 curriculum structure after the C2 content expansion.

It is a curriculum blueprint, not a finished content pack.

It should guide later module-sized content sprints without requiring each sprint to redesign the whole course.

---

# Authority

The source-of-truth order used for this blueprint is:

1. PROJECT_CONTRACT.md and PROJECT_VISION.md for product boundaries.
2. EDUCATIONAL_PRINCIPLES.md and LEARNING_MODEL.md for pedagogy.
3. CONTENT_MODEL.md, CURRICULUM_SPEC.md, ARCHITECTURE.md and ARCHITECTURAL_DECISIONS.md for domain boundaries.
4. CONTENT_AUTHORING_GUIDE.md, COURSE_AUTHORING_GUIDE.md, AUTHORING_STYLE_GUIDE.md, AUTHORING_DECISIONS.md and CONTENT_REVIEW_CHECKLIST.md for authoring practice.
5. Existing Spanish assets for current implementation facts.

No conflict was found that prevents a blueprint. A progress-compatibility risk was found for applying the restructure directly to production.

---

# Current Course Audit Summary

Current production source:

`app/assets/languages/spanish/curriculum/spanish_a0_course.json`

Current metrics:

| Metric | Current value |
|---|---:|
| Modules | 8 |
| Live lessons | 32 |
| Reviews | 5 |
| Checkpoints | 2 |
| Vocabulary items across Spanish assets | 176 |
| Grammar topics | 17 |
| Dialogues | 27 |
| Readings | 28 |
| Exercise templates | 119 |
| Referenced multiple-choice steps | 35 |
| Referenced fill-gap steps | 30 |
| Referenced text-entry steps | 48 |
| Referenced matching steps | 2 |

Major findings:

- The 32-lesson course is valid and playable, but still too compressed for a complete useful A0 foundation.
- Early lessons over-concentrate greetings, names, origin, courtesy and short first-contact phrases.
- Reading foundations are currently lessons 16-20, after many words that need decoding support.
- `A0 Checkpoint` at lesson 15 is no longer a true final A0 checkpoint because lessons 16-32 add reading, numbers, age, objects, food, family and integrated communication.
- The final module combines too many domains: objects, possession, food, family, city, review and final checkpoint.
- First 15 lessons are structurally valid but many lack explicit `communicativeOutcome` values in production JSON.
- Typed recall is now significant, but some early lessons still lean too much on recognition/fill-gap scaffolding.

---

# Current Lesson Audit

Estimated educational value scale:

- High: useful, coherent and should remain in the target path.
- Medium: useful but needs move, rename, split, stronger recall or broader variation.
- Low: too narrow, misplaced or redundant as a standalone lesson.

| Pos | Current ID | Module | Title | Type | Runtime steps | Checkable | Text entry | MC | Fill | Match | Misconceptions | Review refs | Value | Problems | Disposition |
|---:|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---|---|
| 1 | es.a0.m01.l001 | m01 | Hello and Goodbye | teaching | 6 | 3 | 0 | 1 | 1 | 1 | 0 | 0 | Medium | No typed recall; greetings precede reading support. | Keep with minor revision; add early reading cue and one typed greeting. |
| 2 | es.a0.m01.l002 | m01 | Please, Thank You, Sorry | teaching | 5 | 2 | 0 | 1 | 1 | 0 | 0 | 0 | Medium | Useful but too early if all courtesy remains clustered. | Keep; move some courtesy reuse later. |
| 3 | es.a0.m01.l003 | m01 | Yes, No, I Do Not Understand | teaching | 5 | 2 | 0 | 1 | 1 | 0 | 0 | 0 | High | Clarification is important early; needs typed recall. | Keep with minor revision. |
| 4 | es.a0.m02.l004 | m02 | My Name Is | teaching | 7 | 3 | 1 | 1 | 1 | 0 | 1 | 1 | High | Overuses Ana in existing examples. | Keep; broaden variation. |
| 5 | es.a0.m02.l005 | m02 | I Am From | teaching | 7 | 3 | 1 | 1 | 1 | 0 | 1 | 1 | High | Madrid dominates and countries/cities need spacing. | Keep; broaden place pool. |
| 6 | es.a0.m02.l006 | m02 | How Are You? | teaching | 4 | 2 | 0 | 1 | 1 | 0 | 0 | 0 | Medium | Too small; should precede response lesson directly. | Keep with minor revision. |
| 7 | es.a0.m03.l007 | m03 | Answering How Are You | teaching | 5 | 2 | 0 | 1 | 0 | 1 | 0 | 0 | Medium | Needs typed short responses and delayed review. | Keep with minor revision. |
| 8 | es.a0.m03.l008 | m03 | More Courtesy | teaching | 5 | 2 | 0 | 1 | 1 | 0 | 0 | 0 | Medium | Courtesy cluster is dense. | Move some practice into later need/request module. |
| 9 | es.a0.m03.l009 | m03 | Do You Speak Spanish? | teaching | 5 | 2 | 0 | 2 | 0 | 0 | 0 | 0 | Medium | Mostly recognition; useful classroom phrase. | Move to classroom survival module and add typed recall. |
| 10 | es.a0.m04.l010 | m04 | Unit 1 Review | review | 6 | 3 | 1 | 1 | 1 | 0 | 0 | 0 | High | Scope is first-contact only. | Rename target role to First Contact Review. |
| 11 | es.a0.m04.l011 | m04 | Tener: I Have | teaching | 8 | 4 | 1 | 2 | 1 | 0 | 0 | 1 | Medium | Appears before enough objects, numbers and states. | Move later to possession module; split age/state uses. |
| 12 | es.a0.m04.l012 | m04 | Basic Word Order | teaching | 5 | 3 | 2 | 0 | 1 | 0 | 0 | 0 | Medium | Abstract unless tied to varied known patterns. | Move after name/origin/tener foundations. |
| 13 | es.a0.m05.l013 | m05 | Review 1 | review | 6 | 4 | 2 | 1 | 1 | 0 | 0 | 0 | Medium | Name/origin examples still narrow. | Keep as early cumulative review; broaden examples. |
| 14 | es.a0.m05.l014 | m05 | Review 2 | review | 6 | 4 | 2 | 2 | 0 | 0 | 0 | 0 | Medium | Reviews material from modules that should be rebalanced. | Keep with revised scope after modules 4-5. |
| 15 | es.a0.m05.l015 | m05 | A0 Checkpoint | checkpoint | 8 | 6 | 2 | 2 | 2 | 0 | 0 | 0 | Medium | Premature final label. | Rename/reassign as Foundations Checkpoint. |
| 16 | es.a0.m06.l016 | m06 | Silent h and Stable Vowels | reading foundation | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 2 | High | Arrives too late. | Move earlier near lesson 2. |
| 17 | es.a0.m06.l017 | m06 | ñ, j, and ll | reading foundation | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | High | Arrives too late. | Move earlier near first place/name content. |
| 18 | es.a0.m06.l018 | m06 | qu, gue, gui | reading foundation | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | High | Good content; should be integrated with queso/Miguel. | Move earlier and connect to object/food content. |
| 19 | es.a0.m06.l019 | m06 | Question Accents | reading foundation | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | High | Should appear before repeated qué/cómo/dónde tasks. | Move near first question module. |
| 20 | es.a0.m06.l020 | m06 | Reading Basics Review | review | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 2 | High | Useful review; currently isolated. | Convert to early reading review. |
| 21 | es.a0.m07.l021 | m07 | Numbers 0-10 | teaching | 7 | 4 | 2 | 1 | 1 | 0 | 0 | 0 | High | Good but needs earlier small quantity use. | Keep; minor revision. |
| 22 | es.a0.m07.l022 | m07 | Numbers 11-20 | teaching | 7 | 4 | 2 | 1 | 1 | 0 | 0 | 0 | High | Good progression. | Keep. |
| 23 | es.a0.m07.l023 | m07 | Age with Tener | teaching | 8 | 4 | 2 | 1 | 1 | 0 | 1 | 2 | High | Depends on tener and numbers. | Keep after numbers and tener intro. |
| 24 | es.a0.m07.l024 | m07 | Simple Numbers in Contact Details | teaching | 7 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | Medium | Good practical context but narrow. | Keep; add varied contact facts. |
| 25 | es.a0.m07.l025 | m07 | Numbers and Age Review | review | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | High | Good cumulative function. | Keep. |
| 26 | es.a0.m08.l026 | m08 | Everyday Objects | teaching | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 0 | High | Belongs before tener possession. | Move before possession. |
| 27 | es.a0.m08.l027 | m08 | Possession with Objects | teaching | 8 | 4 | 2 | 1 | 1 | 0 | 1 | 2 | High | Good once objects are established. | Keep after object lesson. |
| 28 | es.a0.m08.l028 | m08 | Food, Drink, and Polite Requests | teaching | 8 | 4 | 2 | 1 | 1 | 0 | 1 | 0 | High | Misclassified by title audit as reading; content is requests. | Split food/drink from need states if expanded. |
| 29 | es.a0.m08.l029 | m08 | Family, Friend, and City | teaching | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 0 | Medium | Combines people, family, place in one lesson. | Split into family/friend and city/profile lessons. |
| 30 | es.a0.m08.l030 | m08 | Mixed First Conversation | integrated practice | 8 | 4 | 2 | 1 | 1 | 0 | 2 | 0 | High | Good integration but too early for final integration. | Keep as module integration. |
| 31 | es.a0.m08.l031 | m08 | Integrated A0 Review | review | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 0 | High | Useful but should not be only late review. | Keep as late cumulative review. |
| 32 | es.a0.m08.l032 | m08 | Final A0 Checkpoint | checkpoint | 10 | 6 | 4 | 1 | 1 | 0 | 0 | 0 | High | Good final checkpoint seed but not enough full-course breadth yet. | Keep as true final checkpoint after expansion. |

---

# Structural Problems

## Premature Checkpoint

`es.a0.m05.l015` is titled `A0 Checkpoint`, but it appears before reading foundations, numbers, age, everyday objects, food/drink, family/friends and integrated communication.

Target role:

- Rename conceptually to `Foundations Checkpoint`.
- Keep the lesson ID if possible to preserve progress.
- Do not treat it as the final A0 checkpoint.

## Reading Foundations Too Late

Reading support currently begins at lesson 16. Learners meet `hola`, `adiós`, `qué`, `cómo`, `España`, `años`, `queso` and `Miguel` before enough reading guidance.

Target change:

- Move silent `h` and stable vowels into Module 1.
- Introduce `ñ` near Spain/age content.
- Introduce question accents before extended question practice.
- Keep `qu`, `gue`, `gui`, `j`, `ll`, `r/rr` as compact micro-lessons connected to real vocabulary.

## First Contact Overload

Lessons 1-15 spend heavily on greetings, name, origin, courtesy, clarification and review before opening other domains.

Target change:

- Keep essential first-contact early.
- Spiral courtesy and clarification into classroom, café and integrated modules.
- Avoid several adjacent lessons that only vary one first-contact phrase.

## Tener Placement

`Tener: I Have` currently appears before a sufficiently broad object, number, age and state pool.

Target sequence:

1. Objects: `libro`, `teléfono`, `llave`, `bolsa`, `agua`.
2. `tengo` for possession.
3. `tienes` and `tiene` for short exchanges.
4. Numbers and quantities.
5. Age with `tener`.
6. Fixed states: `tengo hambre`, `tengo sed`.

## Final Module Overload

Current Module 8 combines objects, possession, food/drink, requests, family, friend, city, integration, review and final checkpoint.

Target change:

- Split into coherent modules for objects/possession, food/needs, people/places and integrated communication.

---

# Target Course Design

Target metrics:

| Metric | Target |
|---|---:|
| Lessons | 52 |
| Modules | 9 |
| Teaching / guided practice lessons | 38 |
| Reading foundation lessons | 5 |
| Integrated practice lessons | 3 |
| Review lessons | 7 |
| Checkpoints | 4 |
| Expected first-pass learner activity | 6-10 hours |
| Vocabulary target | 180-220 useful lexical units and fixed expressions |

Target learner outcome:

The learner can handle a short controlled A0 interaction: greet, introduce themself, ask and answer a name/origin/wellbeing question, ask for clarification, read common beginner words, use numbers 0-20, state age or a simple possession/need, understand a short profile or dialogue and close politely.

---

# Target Module Structure

| Module | Title | Lessons | New vocabulary target | Main role |
|---|---|---:|---:|---|
| M01 | First Words and Reading | 1-6 | 22-28 | greetings, courtesy, silent h, stable vowels, early clarification |
| M02 | Names and Introductions | 7-12 | 18-24 | name patterns, varied names, ñ/j/ll with names and Spain |
| M03 | Origin, Languages and Personal Identity | 13-19 | 22-28 | origin, residence, languages, controlled personal profile |
| M04 | How People Are and Classroom Survival | 19-24 | 18-24 | wellbeing, clarification, `hablas español`, classroom exchanges |
| M05 | Numbers and Personal Facts | 25-31 | 24-30 | 0-20, phone-style numbers, age with `tener` |
| M06 | Everyday Objects and Tener | 32-38 | 22-28 | objects, `un/una`, possession, `tengo/tienes/tiene` |
| M07 | Food, Drink and Needs | 39-44 | 18-24 | water/coffee/food, polite requests, `hambre`, `sed`, simple needs |
| M08 | People, Home and Simple Surroundings | 45-49 | 16-22 | family, friend, house, city, third-person mini-profiles |
| M09 | Integrated A0 Communication | 50-52 | 0-8 | cumulative integration, final review, final checkpoint |

---

# Communicative Module Progression

The Spanish A0 course should read as a growing set of usable situations, not as a sequence of grammar demonstrations.

Grammar, vocabulary, reading rules and exercise templates are included because they help the learner do something concrete in Spanish.

Each module should culminate in an authored communicative competency check when the needed diagnostic tasks exist.

Later modules may recover earlier prerequisites through authored recovery references.

Cross-module recovery must not reorder the target course or mutate prior module content.

## M01 — First Words and Reading

### Communicative Goal

The learner can greet, say goodbye, use basic courtesy words and ask for very simple repair when communication breaks down.

### Real-Life Scenarios

- entering or leaving a classroom;
- greeting a new person politely;
- thanking someone for help;
- saying that speech is not understood;
- asking someone to repeat or speak more slowly.

## M02 — Names and Introductions

### Communicative Goal

The learner can introduce themself, ask another person's name and complete a short first-meeting exchange.

### Real-Life Scenarios

- meeting a classmate;
- introducing oneself to a teacher or helper;
- asking a new person's name;
- responding to `mucho gusto`;
- recognizing names that include early Spanish reading challenges.

## M03 — Origin, Languages and Personal Identity

### Communicative Goal

The learner can say where they are from, say where they live, say which
languages they speak, ask basic identity questions and understand a tiny
personal profile.

### Real-Life Scenarios

- giving origin during a first conversation;
- asking a new person where they are from;
- saying where they live now;
- asking which languages another person speaks;
- reading a short profile with name, origin, residence and languages;
- recognizing common city, country and language names;
- answering early personal-information questions without overexplaining.

## M04 — How People Are and Classroom Survival

### Communicative Goal

The learner can ask how someone is, give a short wellbeing answer and use simple classroom-survival phrases.

### Real-Life Scenarios

- starting a small conversation after greeting;
- answering `¿Qué tal?` or `¿Cómo estás?`;
- saying that only a little Spanish is available;
- asking what a word means;
- repairing a classroom or tutoring exchange.

## M05 — Numbers and Personal Facts

### Communicative Goal

The learner can recognize and produce numbers 0-20 and use them in tightly controlled personal facts.

### Real-Life Scenarios

- understanding a short number sequence;
- giving a simple age statement;
- recognizing a phone-style number sequence;
- using one or two familiar quantities;
- answering basic personal-information prompts.

## M06 — Everyday Objects and Tener

### Communicative Goal

The learner can name common objects, use `un/una` with them and make simple possession statements with `tener`.

### Real-Life Scenarios

- saying that one has a book, phone, key or bag;
- asking whether another person has a familiar object;
- understanding a short object-location exchange;
- distinguishing `tengo`, `tienes` and `tiene` in simple contexts;
- repairing basic word order in short sentences.

## M07 — Food, Drink and Needs

### Communicative Goal

The learner can make a tiny polite request for food or drink and express basic needs such as hunger, thirst or help.

### Real-Life Scenarios

- asking for water, coffee, bread or cheese;
- saying `por favor` and `gracias` in a request exchange;
- saying `tengo hambre` or `tengo sed`;
- asking for help in a controlled public situation;
- handling a very short cafe-style exchange.

## M08 — People, Home and Simple Surroundings

### Communicative Goal

The learner can give and understand tiny facts about people, home, city and simple surroundings.

### Real-Life Scenarios

- saying a simple fact about a friend or family member;
- saying where someone lives or is from in a minimal profile;
- reading a tiny profile using known structures;
- recognizing third-person facts with `es` and `tiene`;
- combining people, places and familiar objects.

## M09 — Integrated A0 Communication

### Communicative Goal

The learner can combine the A0 foundation in controlled conversations and checkpoints without relying on a single memorized script.

### Real-Life Scenarios

- meeting someone and exchanging name, origin and wellbeing;
- requesting a basic item or help politely;
- understanding a short profile or dialogue with known patterns;
- completing a mixed first-contact interaction;
- handling tightly controlled shopping, transport-help or health-need prompts only when they use already introduced language.

Transport and health remain limited A0 scenarios in this blueprint. They should not become full topic modules until the course intentionally introduces the needed vocabulary and patterns.

---

# Complete Target Lesson Blueprint

ID policy:

- Existing lesson IDs remain attached to their current educational identity wherever practical.
- Existing lessons may move modules conceptually without immediately changing IDs.
- New inserted lessons use new IDs in the later implementation phase.
- Do not reuse retired IDs for different outcomes.
- Before production reordering, add curriculum-version/progress reconciliation or an approved equivalent policy.

| Seq | Proposed ID | Module | Title | Type | Outcome | Prerequisites | New scope | Reused scope | Reading focus | Required practice | Sprint |
|---:|---|---|---|---|---|---|---|---|---|---|---|
| 1 | es.a0.m01.l001 | M01 | Hello and Goodbye | teaching | Greet and say goodbye. | none | hola, adiós, hasta luego | none | stable vowels, silent h note | 1 typed recall | C2B |
| 2 | es.a0.m06.l016 | M01 | Silent h and Stable Vowels | reading foundation | Read `hola` and `hambre` without pronouncing h. | 1 | h, vowels, hambre | hola | h, vowels | 2 typed recall | C2B |
| 3 | es.a0.m01.l002 | M01 | Please, Thank You, Sorry | teaching | Use basic courtesy words. | 1 | gracias, por favor, perdón, de nada | hola | accent in perdón as recognition | 1 typed recall | C2B |
| 4 | es.a0.m01.l003 | M01 | I Do Not Understand | teaching | Ask for repetition or slower speech. | 1-3 | no entiendo, repite, más despacio | por favor | none | 1 typed recall | C2B |
| 5 | new: es.a0.m01.l006 | M01 | Morning and Evening Greetings | guided practice | Choose an appropriate greeting by context. | 1 | buenos días, buenas tardes, buenas noches | hola | vowels in días/noches | 2 typed recall | C2B |
| 6 | es.a0.m04.l010 | M01 | First Words Review | review | Recall greetings, courtesy and clarification. | 1-5 | none | M01 | h/vowel review | 3 typed recall | C2B |
| 7 | es.a0.m02.l004 | M02 | My Name Is | teaching | Say a name with `me llamo`. | 6 | me llamo, name pool | greetings | ll in llamo | 2 typed recall, misconception `soy Name` | C2C |
| 8 | new: es.a0.m02.l007 | M02 | What Is Your Name? | teaching | Ask and answer a name question. | 7 | cómo te llamas | me llamo | question punctuation | 2 typed recall | C2C |
| 9 | es.a0.m06.l017 | M02 | ñ, j and ll in Names | reading foundation | Recognize ñ, j and ll in familiar names/words. | 7 | España, José, llave | name pool | ñ, j, ll | 2 typed recall | C2C |
| 10 | new: es.a0.m02.l008 | M02 | Nice to Meet You | teaching | Complete a short introduction exchange. | 7-9 | mucho gusto, igualmente | names, greetings | none | 2 typed recall | C2C |
| 11 | new: es.a0.m02.l009 | M02 | Introduction Dialogue Practice | dialogue/application | Choose and produce replies in a first meeting. | 7-10 | none | M01-M02 | question punctuation | 2 typed recall | C2C |
| 12 | es.a0.m05.l013 | M02 | Names and Introductions Review | review | Recall varied introductions without relying on Ana. | 7-11 | none | M01-M02 | ll/ñ review | 3 typed recall | C2C |
| 13 | es.a0.m03.l013 | M03 | I Am From | teaching | Say origin with `soy de`. | 12 | soy de, varied places | names | de in pattern | 2 typed recall, missing `de` misconception | C2D |
| 14 | es.a0.m03.l014 | M03 | Where Are You From? | teaching | Ask and answer origin. | 13 | de dónde eres | soy de | dónde accent | 2 typed recall | C2D |
| 15 | es.a0.m03.l015 | M03 | Where Do You Live? | teaching | Say and ask residence. | 13-14 | vivo en, dónde vives, Kyiv, Lima, Bogotá, Valencia | origin contrast | dónde accent | 2 typed recall, origin/residence misconception | C2D |
| 16 | es.a0.m03.l016 | M03 | Languages I Speak | teaching | Say and ask which languages someone speaks. | 15 | hablo, hablas, idiomas, español, inglés, ucraniano, ruso, un poco de | identity questions | qué accent | 3 typed recall | C2D |
| 17 | es.a0.m03.l017 | M03 | Identity Questions and Answers | dialogue/application | Exchange origin, residence and language information. | 13-16 | none | M01-M03 | question punctuation | 2 typed recall | C2D |
| 18 | es.a0.m03.l018 | M03 | Personal Identity Review | review | Recombine names, origin, residence and languages. | 13-17 | none | M01-M03 | accents and question marks | 3 typed recall | C2D |
| 19 | es.a0.m03.l019 | M03 | Module 3 Foundations Checkpoint | checkpoint | Assess greetings, names, origin, residence, languages and early questions. | 1-18 | none | M01-M03 | h, ñ, accents, question marks | 4 typed recall | C2D |
| 19 | es.a0.m02.l006 | M04 | How Are You? | teaching | Ask how someone is. | 18 | cómo estás, qué tal | greetings | cómo accent | 2 typed recall | C2E |
| 20 | es.a0.m03.l007 | M04 | Short Wellbeing Answers | teaching | Answer with bien, mal, más o menos. | 19 | bien, muy bien, mal, más o menos | courtesy | none | 2 typed recall | C2E |
| 21 | es.a0.m03.l009 | M04 | Do You Speak Spanish? | teaching | Ask and answer `¿Hablas español?` | 19 | hablas español, un poco | sí/no | question marks | 2 typed recall | C2E |
| 22 | new: es.a0.m04.l021 | M04 | Classroom Repair | guided practice | Ask what a word means or ask for repetition. | 4,16 | qué significa | clarification | qué accent | 2 typed recall | C2E |
| 23 | new: es.a0.m04.l022 | M04 | Short Classroom Dialogue | dialogue/application | Combine greeting, wellbeing and clarification. | 19-22 | none | M01-M04 | question punctuation | 2 typed recall | C2E |
| 24 | es.a0.m05.l014 | M04 | Interaction Review | review | Recall wellbeing, Spanish question and clarification phrases. | 19-23 | none | M01-M04 | accent review | 3 typed recall | C2E |
| 25 | es.a0.m07.l021 | M05 | Numbers 0-10 | teaching | Recognize and recall 0-10. | 24 | 0-10 | none | regular vowels | 2 typed recall | C2F |
| 26 | es.a0.m07.l022 | M05 | Numbers 11-20 | teaching | Recognize and recall 11-20. | 25 | 11-20 | 0-10 | accent in dieciséis | 2 typed recall | C2F |
| 27 | new: es.a0.m05.l027 | M05 | Simple Quantities | teaching | Say one or two familiar items. | 25 | simple quantities | greetings, early nouns | none | 2 typed recall | C2F |
| 28 | es.a0.m07.l024 | M05 | Contact Number Practice | guided practice | Understand a short number sequence. | 25-26 | número | 0-20 | none | 2 typed recall | C2F |
| 29 | es.a0.m07.l023 | M05 | Age with Tener | teaching | Say a controlled age with `tengo ... años`. | 26 | años, age pattern | tener seed | ñ in años | 2 typed recall, `soy age` misconception | C2F |
| 30 | es.a0.m07.l025 | M05 | Numbers and Age Review | review | Recall numbers, age and short facts. | 25-29 | none | M05 | dieciséis/años | 3 typed recall | C2F |
| 31 | new: es.a0.m05.l031 | M05 | Personal Facts Checkpoint | checkpoint | Assess numbers, age and short personal facts. | 25-30 | none | M01-M05 | number spelling | 4 typed recall | C2F |
| 32 | es.a0.m08.l026 | M06 | Everyday Objects | teaching | Name common objects. | 31 | libro, teléfono, llave, bolsa, mesa, silla | numbers | ll in llave | 2 typed recall | C2G |
| 33 | new: es.a0.m06.l033 | M06 | Un and Una | teaching | Use un/una with familiar objects. | 32 | un, una | objects | none | 2 typed recall | C2G |
| 34 | es.a0.m04.l011 | M06 | Tener: I Have | teaching | Use `tengo` with objects and states. | 32-33 | tengo | objects | none | 2 typed recall | C2G |
| 35 | es.a0.m08.l027 | M06 | Tienes and Tiene | teaching | Ask and state possession with you/he/she. | 34 | tienes, tiene | objects | none | 2 typed recall, form-confusion misconception | C2G |
| 36 | es.a0.m04.l012 | M06 | Basic Word Order | guided practice | Keep short subject-verb-complement order. | 34-35 | word order | M01-M06 | none | 3 typed recall | C2G |
| 37 | new: es.a0.m06.l037 | M06 | Where Is the Object? | teaching | Ask and answer where a known object is. | 32,16 | está, aquí, allí | objects | dónde accent | 2 typed recall | C2G |
| 38 | new: es.a0.m06.l038 | M06 | Objects and Tener Review | review | Recall objects, articles and tener. | 32-37 | none | M06 | ll/qu review | 3 typed recall | C2G |
| 39 | es.a0.m08.l028 | M07 | Food, Drink and Polite Requests | teaching | Request water, coffee, bread or cheese politely. | 38 | agua, café, pan, queso, quiero | por favor, tener | café accent | 2 typed recall, `porfavor` misconception | C2H |
| 40 | new: es.a0.m07.l040 | M07 | I Am Hungry or Thirsty | teaching | Use fixed tener expressions for hunger/thirst. | 34,39 | hambre, sed | tengo | silent h in hambre | 2 typed recall | C2H |
| 41 | new: es.a0.m07.l041 | M07 | I Need Help | teaching | Say `necesito ayuda` in a simple context. | 22 | necesito ayuda | clarification | none | 2 typed recall | C2H |
| 42 | new: es.a0.m07.l042 | M07 | Café Exchange | dialogue/application | Handle a tiny polite request exchange. | 39-41 | none | M01-M07 | accents in café | 2 typed recall | C2H |
| 43 | new: es.a0.m07.l043 | M07 | Needs and Requests Review | review | Recall food, drink, needs and courtesy. | 39-42 | none | M07 | h/café review | 3 typed recall | C2H |
| 44 | new: es.a0.m07.l044 | M07 | Needs Checkpoint | checkpoint | Assess polite request and need patterns. | 39-43 | none | M01-M07 | none | 4 typed recall | C2H |
| 45 | es.a0.m08.l029 | M08 | Family and Friend | teaching | Say a tiny fact about family or a friend. | 44 | familia, amigo/amiga, mi | names | none | 2 typed recall | C2I |
| 46 | new: es.a0.m08.l046 | M08 | Home and City | teaching | Say a simple home/city fact. | 45 | casa, ciudad, en | places | none | 2 typed recall | C2I |
| 47 | new: es.a0.m08.l047 | M08 | Third-Person Mini Profile | teaching | Understand and produce `es`, `tiene`, `es de`. | 45-46 | él/ella review | tener, origin | none | 2 typed recall | C2I |
| 48 | new: es.a0.m08.l048 | M08 | Short Profile Reading | reading/application | Read a tiny profile using known structures. | 45-47 | none | M01-M08 | accents and punctuation | 2 typed recall | C2I |
| 49 | new: es.a0.m08.l049 | M08 | People and Places Review | review | Recall people, family, home, city and profile facts. | 45-48 | none | M08 | reading review | 3 typed recall | C2I |
| 50 | es.a0.m08.l030 | M09 | Mixed First Conversation | integrated practice | Combine first-contact, origin, need and object language. | 49 | none | all prior | question punctuation | 3 typed recall | C2J |
| 51 | es.a0.m08.l031 | M09 | Integrated A0 Review | review | Recall all major A0 patterns in varied contexts. | 50 | none | all prior | all reading basics | 4 typed recall | C2J |
| 52 | es.a0.m08.l032 | M09 | Final A0 Checkpoint | final checkpoint | Assess the complete Spanish A0 foundation. | 51 | none | all prior | sampled reading rules | 5 typed recall | C2J |

---

# Current-to-Target Reassignment Map

| Current lesson | Current role | Target role | Action |
|---|---|---|---|
| Hello and Goodbye | Teaching | Module 1 teaching | Keep with minor revision. |
| Please, Thank You, Sorry | Teaching | Module 1 teaching and later review | Keep; reuse courtesy later. |
| Yes, No, I Do Not Understand | Teaching | Module 1 teaching | Keep with stronger recall. |
| My Name Is | Teaching | Module 2 teaching | Keep; broaden names. |
| I Am From | Teaching | Module 3 teaching | Keep; broaden place pool. |
| How Are You? | Teaching | Module 4 teaching | Move later after name/origin foundations. |
| Answering How Are You | Teaching | Module 4 teaching | Keep with typed recall. |
| More Courtesy | Teaching | Module 1 and Module 7 reuse | Keep as reusable content, reduce standalone emphasis. |
| Do You Speak Spanish? | Teaching | Module 4 classroom survival | Move and add recall. |
| Unit 1 Review | Review | Module 1 review | Rename conceptually to First Words Review. |
| Tener: I Have | Teaching | Module 6 possession foundation | Move after objects. |
| Basic Word Order | Teaching | Module 6 guided practice | Move after enough patterns exist. |
| Review 1 | Review | Module 2 review | Keep with variation. |
| Review 2 | Review | Module 4 review | Keep with revised scope. |
| A0 Checkpoint | Checkpoint | Module 3 Foundations Checkpoint | Rename/reassign; not final A0. |
| Silent h and Stable Vowels | Reading | Module 1 reading foundation | Move earlier. |
| ñ, j, and ll | Reading | Module 2 reading foundation | Move earlier near names/Spain. |
| qu, gue, gui | Reading | Module 6/7 reading support | Move near queso/Miguel and food/object use. |
| Question Accents | Reading | Module 3 reading foundation | Move before extended question practice. |
| Reading Basics Review | Review | Module 3 or 4 reading review | Move earlier. |
| Numbers 0-10 | Teaching | Module 5 teaching | Keep. |
| Numbers 11-20 | Teaching | Module 5 teaching | Keep. |
| Age with Tener | Teaching | Module 5 teaching after numbers | Keep after tener seed and numbers. |
| Simple Numbers in Contact Details | Teaching | Module 5 guided practice | Keep. |
| Numbers and Age Review | Review | Module 5 review | Keep. |
| Everyday Objects | Teaching | Module 6 teaching | Move before tener. |
| Possession with Objects | Teaching | Module 6 teaching | Keep after objects and articles. |
| Food, Drink, and Polite Requests | Teaching | Module 7 teaching | Split into food/drink and needs if needed. |
| Family, Friend, and City | Teaching | Module 8 teaching | Split into family/friend and home/city. |
| Mixed First Conversation | Integrated | Module 9 integrated practice | Keep as integration. |
| Integrated A0 Review | Review | Module 9 review | Keep. |
| Final A0 Checkpoint | Checkpoint | Module 9 final checkpoint | Keep, expand coverage after new modules. |

Asset reassignment:

- `unit_1_first_contact.*`: remain valid, but examples tied to Ana/Madrid need broadening in later sprints.
- `a0_c2_core.*`: remain valid as expansion seed; some content should be redistributed across new modules.
- `a0_foundations_review.*`: useful review seed, but narrow examples should be revised.
- `hello_goodbye.*`, `greetings.*`, `basic_greeting.json`: retain as legacy/simple assets unless duplicated by richer content; avoid newly referencing them when richer stable Unit 1 assets exist.

---

# Gap Analysis

| Gap | Why required | Current coverage | Target coverage | Lessons needed | New content needed | Module | Priority |
|---|---|---|---|---:|---|---|---|
| Early reading support | Learners see Spanish spelling from lesson 1. | Lessons 16-20. | Lessons 2, 9, 16, 18, 20. | 5 | short readings and typed decoding tasks | M01-M03 | High |
| Varied introductions | Avoid memorizing Ana only. | Some variation, still Ana-heavy. | name pool across M02/M09. | 3-4 | dialogues with varied names | M02 | High |
| Origin/place variation | Avoid Madrid-only pattern. | Place pool exists but late. | cities/countries in M03 plus later profiles. | 4-5 | profiles, readings, templates | M03/M08 | High |
| Wellbeing transfer | Need practical responses. | Two small lessons. | full M04 sequence. | 3 | dialogues, typed short answers | M04 | Medium |
| Numbers and quantities | A0 practical facts. | Lessons 21-25. | M05 plus object quantities. | 5-6 | quantity readings/templates | M05/M06 | High |
| Tener sequencing | Needs objects before possession and numbers before age. | Tener appears early. | possession in M06, age in M05, needs in M07. | 5-6 | split grammar and templates | M05-M07 | High |
| Food/drink/needs | Practical requests. | One compressed lesson. | M07 sequence. | 4-5 | dialogue, readings, request templates | M07 | High |
| Family/friend/home | Practical people/place facts. | One compressed lesson. | M08 sequence. | 4-5 | profile readings, third-person templates | M08 | Medium |
| Cumulative review | Durable recall requires delay. | Reviews exist but uneven. | review every 4-6 lessons. | 7 | mixed review templates | all | High |
| Final assessment | Must assess complete A0 scope. | Lesson 32 is seed only. | true final checkpoint after M09. | 1 | broader checkpoint templates | M09 | High |

---

# Redundancy and Overuse Audit

Measured occurrences in current Spanish JSON assets:

| Pattern | Count | Interpretation | Recommendation |
|---|---:|---|---|
| Ana | 162 | Excessive as a dominant person/context. | Reduce frequency; keep as one name in a pool. |
| Luis | 94 | Frequent but less problematic than Ana. | Keep frequency with more balanced names. |
| Madrid | 49 | Still too dominant for origin practice. | Replace contexts with Valencia, Lima, Bogotá, Kyiv, Sevilla, México. |
| Me llamo Ana | 27 | Exact sentence overused. | Replace many with Elena, Carlos, Lucía, Miguel, Marta. |
| Soy de Madrid | 20 | Exact sentence overused. | Replace many with varied origin statements. |
| Tengo un libro | 23 | Useful but overused as the default object sentence. | Replace contexts with teléfono, llave, bolsa, agua, pan, queso. |
| Hola | 52 | Legitimate high-frequency repetition. | Keep, but vary surrounding context. |
| Gracias | 16 | Legitimate, not excessive. | Keep and reuse in polite exchanges. |
| Por favor | 6 | Underused for requests. | Increase in Module 7. |

---

# Variation Policy

People:

- Use Ana, Luis, Sofía, Carlos, Elena, Pedro, Lucía, Miguel, Marta and Diego.
- No single name should dominate a module unless the lesson explicitly follows a single dialogue.

Places:

- Use Madrid, Barcelona, Valencia, México, Lima, Bogotá, Buenos Aires, Santiago, Sevilla and Kyiv.
- Introduce countries/cities gradually. Do not turn A0 into geography memorization.

Objects:

- Rotate libro, teléfono, agua, café, casa, familia, amigo/amiga, mesa, silla, bolsa, llave, comida, pan and queso.
- Do not let `libro` carry every possession lesson.

States and needs:

- Use bien, muy bien, mal, más o menos, hambre and sed in controlled contexts.

Subjects:

- Use yo, tú, él, ella, named people and omitted subject only after the pattern has been introduced.

Settings:

- Meeting someone, classroom, café, street/help request, message/profile, home and contact exchange.

Determinism:

- Every text-entry/fill-gap prompt must specify the required language, word/phrase/sentence scope and semantic target.
- Variation must not create multiple valid answers unless all are authored intentionally.

---

# Vocabulary Budget

| Module | New units | Cumulative target | Notes |
|---|---:|---:|---|
| M01 | 22-28 | 22-28 | greetings, courtesy, clarification, reading symbols |
| M02 | 18-24 | 40-52 | names, intro phrases, ñ/j/ll words |
| M03 | 22-28 | 62-80 | origin, places, question words |
| M04 | 18-24 | 80-104 | wellbeing and classroom survival |
| M05 | 24-30 | 104-134 | numbers, age, quantities |
| M06 | 22-28 | 126-162 | objects, articles, possession |
| M07 | 18-24 | 144-186 | food, drink, needs |
| M08 | 16-22 | 160-208 | family, friend, home, profile facts |
| M09 | 0-8 | 180-220 | mostly review and integration |

Outside current A0 scope:

- broad travel, shopping, hotel/restaurant menus, full conjugation tables, broad gender rules, broad plural morphology, complex adjective agreement and tense contrast.

---

# Grammar and Pattern Map

| Pattern | First explicit lesson | Practice | Review | Assessment |
|---|---|---|---|---|
| `me llamo` | 7 | 8, 10, 11 | 12, 50, 51 | 18, 52 |
| `¿Cómo te llamas?` | 8 | 10, 11 | 12 | 18 |
| `soy`, `eres`, `es` | 7, 13, 17 | 13-18, 47 | 24, 49, 51 | 18, 52 |
| `soy de`, `es de` | 13, 17 | 14-18 | 24, 49, 51 | 18, 52 |
| `qué`, `cómo`, `dónde` | 16, 19, 22 | 19-24, 37 | 24, 51 | 18, 52 |
| `tengo`, `tienes`, `tiene` | 29, 34, 35 | 35-38 | 38, 51 | 44, 52 |
| `un`, `una` | 33 | 34-38 | 38 | 52 |
| simple plural recognition | 27 | 30, 31 | 38 | 52 |
| subject-verb-complement | 36 | 37, 47, 50 | 51 | 52 |
| subject omission | 34 | 36, 50 | 51 | 52 |
| question punctuation | 8, 16 | 16, 19, 22, 37 | 24, 51 | 52 |
| written accents | 16 | 19, 20, 23, 39 | 24, 51 | 52 |
| fixed tener expressions | 29, 40 | 40-44 | 43, 51 | 44, 52 |

---

# Reading and Pronunciation Integration Plan

Course baseline:

- Use a neutral classroom pronunciation baseline.
- Do not claim one regional pronunciation is universal.
- Pronunciation notes should be practical text guides, not IPA, unless a later documentation decision changes that.

| Rule | First exposure | Explicit lesson | Practice | Review | Checkpoint |
|---|---|---|---|---|---|
| stable vowels | 1 | 2 | 3, 5 | 6 | 18 |
| silent h | 1 | 2 | 4, 40 | 6, 43 | 18, 52 |
| ñ | 9 | 9 | 15, 29 | 20, 30 | 31, 52 |
| j | 9 | 9 | names/reading tasks | 20 | 52 |
| ll | 7 | 9 | `llamo`, `llave` | 20, 38 | 52 |
| r/rr recognition | new M06 reading note | new object/reading lesson | later readings | 51 | 52 |
| qu | 18 or 39 | 18 | queso, qué | 20, 43 | 52 |
| gue/gui | 18 | 18 | Miguel, guided reading | 20 | 52 |
| g before e/i | new compact note | M06/M07 | reading examples | 51 | 52 |
| accents as stress/meaning | 3, 16 | 16 | 19, 23, 39 | 24, 51 | 52 |
| question punctuation | 8 | 16 | 19, 22, 37 | 24, 51 | 52 |

---

# Review and Checkpoint Architecture

Review lessons:

- Lesson 6: First Words Review.
- Lesson 12: Names and Introductions Review.
- Lesson 24: Interaction Review.
- Lesson 30: Numbers and Age Review.
- Lesson 38: Objects and Tener Review.
- Lesson 43: Needs and Requests Review.
- Lesson 49: People and Places Review.
- Lesson 51: Integrated A0 Review.

Checkpoints:

- Lesson 18: Foundations Checkpoint. Scope: greetings, names, origin, early questions, early reading.
- Lesson 31: Personal Facts Checkpoint. Scope: numbers, age, simple personal facts.
- Lesson 44: Needs Checkpoint. Scope: food, drink, needs, polite requests.
- Lesson 52: Final A0 Checkpoint. Scope: whole A0 foundation.

Checkpoint rules:

- Do not introduce major new content.
- Do not show the answer in the same activity where it is assessed.
- Include typed recall and transfer prompts.
- Include reading/dialogue comprehension without bilingual answer leakage.

---

# Progress Compatibility Analysis

Durable completion history now exists for lesson IDs and lesson attempts.

Restructuring risk:

- Moving an existing lesson while retaining its ID preserves completion for that lesson.
- Inserting new prerequisites before a completed old lesson can leave a learner with later lessons completed while new earlier lessons are incomplete.
- Current planner rules select incomplete/current/next lessons based on durable history and course order, but there is no explicit curriculum-version reconciliation layer.
- Renaming a lesson without changing ID is safe for persistence but may be confusing if the old title implied a final checkpoint.
- Reusing an existing ID for a different educational outcome is not safe.

Recommended policy:

- Existing completed lesson IDs remain completed.
- Moved lessons retain completion when their educational identity is substantially the same.
- New inserted lessons are not fabricated as completed.
- Do not reuse retired IDs for different outcomes.
- Before applying major production reordering, implement or approve a `Curriculum Versioning and Progress Reconciliation` phase.
- Planner must not skip newly inserted prerequisite lessons solely because a later old lesson is complete.

Verdict:

The target restructure should not be applied wholesale to production until progress reconciliation is designed. The blueprint itself is safe.

---

# Content Sprint Plan

| Sprint | Scope | Lessons | Main work | Tests |
|---|---|---|---|---|
| C2B | Module 1 | 1-6 | Move reading support early; revise first words and clarification. | curriculum order, content references, prompt constraints, typed recall |
| C2C | Module 2 | 7-12 | Names, introductions, ñ/j/ll, name variation. | misconception, variation, typed recall, pattern transfer |
| C2D | Module 3 | 13-19 | Origin, residence, languages, identity profile, foundations checkpoint and module competency. | checkpoint integrity, place/language variation, no answer leakage, competency recovery |
| C2E | Module 4 | 19-24 | Wellbeing, classroom survival, interaction review. | dialogue comprehension, recall coverage, review mixes three prior lessons |
| C2F | Module 5 | 25-31 | Numbers, quantities, age, personal facts checkpoint. | number/age references, answer constraints, delayed reuse |
| C2G | Module 6 | 32-38 | Objects, articles, tener possession, word order. | tener misconceptions, review references, object diversity |
| C2H | Module 7 | 39-44 | Food, drink, hunger/thirst, needs checkpoint. | request prompts, no unsupported grammar, application tasks |
| C2I | Module 8 | 45-49 | Family, friends, home, city, profiles. | profile reading integrity, third-person transfer |
| C2J | Module 9 | 50-52 | Integrated review and final checkpoint. | final coverage matrix, no answer leakage, course quality targets |
| C2K | Production reorder | all | Apply approved curriculum order after progress policy. | planner/progress compatibility |

---

# Pedagogical Quality Targets

These targets are binding for the final Spanish A0 course.

They are not all immediate pass/fail gates for the current 32-lesson production course. During C2B-C2J, each completed module should move the implemented curriculum toward these targets and add tests for the rules that are enforceable for the completed slice.

## Lesson Quality

Each teaching lesson must have one clear educational objective.

A single lesson must not teach multiple independent concepts at the same time.

Every teaching lesson should contain:

- new knowledge;
- at least one understanding check;
- at least one recall exercise;
- at least one application exercise;
- a connection to previously learned material.

## Knowledge Density

Each lesson should introduce a limited amount of new information:

- 4-8 new vocabulary items or fixed expressions;
- no more than one new grammar or communication pattern;
- one new communicative skill;
- no more than one new reading rule, when the lesson includes reading instruction.

Review vocabulary does not count as new vocabulary.

## Pattern Transfer

The course must teach control of reusable patterns, not memorization of one example.

Important patterns must appear with varied:

- names;
- cities;
- countries;
- objects;
- situations;
- speakers.

Exact full-sentence repetition should be limited outside review and checkpoint contexts.

## Example Diversity

Targets:

- no single name should exceed 15% of person-name examples;
- no single city should exceed 15% of city/place examples;
- no single object should exceed 15% of object examples;
- no full sentence should appear more than twice outside review lessons unless the repetition is explicitly justified.

These percentages should be tested against authored examples and referenced exercise prompts after each module is implemented.

## Dialogue Quality

Every dialogue must have a natural communicative purpose.

Dialogues must not differ only by replacing a name.

Across the course, dialogues should cover distinct situations such as:

- meeting someone;
- greeting by time of day;
- saying goodbye;
- requesting help;
- asking for clarification;
- café or drink request;
- home or object context;
- short profile exchange;
- integrated first conversation.

## Review Quality

Every review should combine material from at least three previous lessons.

A review must not repeat a teaching lesson wholesale.

Reviews should primarily use:

- recall;
- mixed tasks;
- new combinations of already known elements;
- delayed reuse of fragile patterns.

## Checkpoint Quality

A checkpoint must assess, not teach.

Every checkpoint should include:

- reading;
- comprehension;
- typed recall;
- application;
- integration of several previously learned topics.

Checkpoint prompts must avoid answer leakage from immediately visible bilingual source text.

## Retrieval Practice

Active memory should remain the main assessment mode in every module.

Target distribution for checkable exercises:

- 40-50% typed recall / text entry;
- 20-30% fill gap;
- 20-30% recognition;
- remaining share for matching or mixed contextual tasks.

Multiple choice remains useful for exposure and recognition, but it must not become the main proof of learning.

## Context Variation

Each important construction should progress through varied contexts.

Example path:

```text
Me llamo Luis.
Me llamo Elena.
¿Cómo te llamas?
Ella se llama Marta.
Mucho gusto, me llamo Carlos.
```

The exact path may change, but the principle is required: later exercises should test transfer, not one memorized sentence.

## Reading Integration

Reading rules should appear immediately before broad use of words that depend on them.

Reading instruction should accompany the whole course gradually rather than remain a late isolated block.

## Cumulative Learning

Every important pattern should pass through this cycle:

```text
Presentation
→ Recognition
→ Guided Recall
→ Free Recall
→ Dialogue
→ Review
→ Checkpoint
```

The cycle can span multiple lessons and modules.

## Misconception Coverage

High-frequency predictable errors should have:

- a deterministic authored explanation;
- remediation content;
- a review reference when supported by the current model.

Unknown or unsupported errors must remain neutral rather than receiving invented explanations.

## Lesson Completion Criteria

A lesson is pedagogically complete when:

- it introduces or intentionally reviews knowledge;
- it checks understanding;
- it checks recall;
- it checks application;
- the material appears again later.

## Module Completion Criteria

Each target module should contain:

- 4-6 teaching lessons;
- at least one review;
- one checkpoint or clearly justified integration boundary;
- at least one integrated dialogue;
- at least one short reading;
- gradual reuse of material from previous modules.

## Course Quality Targets

By the end of Spanish A0, the learner should be able to do these without visible answer choices:

- introduce themself;
- ask another person's name;
- state origin;
- maintain a short controlled conversation;
- use basic polite expressions;
- understand simple texts;
- read unfamiliar simple words using taught reading rules;
- use basic patterns in a new controlled context.

---

# Content Regression Rules

These rules turn pedagogical quality into repeatable checks after each content sprint.

They should be implemented incrementally as tests. A rule should become mandatory when the relevant module or architecture support exists.

## Immediate Regression Rules

These can be enforced during C2B and later:

- no lesson referenced by production curriculum is empty;
- every referenced content asset resolves;
- every checkable runtime step is checkable by the current engine;
- every fill-gap and text-entry prompt is explicit and semantically constrained;
- no checkpoint typed prompt exposes its canonical answer in the prompt;
- every review/checkpoint includes at least one typed recall task;
- no placeholder activity titles or placeholder text are visible;
- no duplicate stable Educational Content IDs exist;
- every authored misconception references valid explanation content where provided;
- every authored review reference resolves.

## Module-Level Regression Rules

These should become mandatory as each target module is completed:

- each teaching lesson has at least one typed recall exercise;
- each teaching lesson has at least one application or contextual transfer task;
- each module has at least one review;
- each module has a checkpoint or approved integration boundary;
- each module has at least one dialogue and one reading;
- each module includes delayed reuse of at least two earlier patterns;
- each review combines material from at least three earlier lessons;
- each module keeps the target retrieval distribution near 40-50% typed recall, 20-30% fill gap and 20-30% recognition.

## Course-Level Regression Rules

These should become mandatory when the 48-55 lesson target course is implemented:

- each major pattern appears after introduction in at least two later lessons;
- each major pattern appears in a review and checkpoint;
- no single name/city/object exceeds the 15% example-share target;
- no full sentence appears more than twice outside review lessons unless allowlisted with a reason;
- each key topic has at least one dialogue and one reading;
- no newly introduced vocabulary item remains unused in later lessons;
- every high-frequency misconception listed in this blueprint has authored feedback, remediation and review support where the current model supports it.

## Test Design Notes

Tests should be threshold-based and semantic where possible.

Avoid brittle tests that fail because one sentence was improved without changing the educational structure.

Good tests:

- count exercise modes across referenced templates;
- verify every lesson has typed recall after its module is implemented;
- verify review lessons reference material from at least three earlier lessons;
- check exact repeated full sentences against a small allowlist;
- verify each new vocabulary ID is referenced by at least one later dialogue, reading or template.

Bad tests:

- require an exact prompt string forever;
- count raw text occurrences without distinguishing examples, translations, reviews and checkpoints;
- force every lesson into the same activity order.

---

# Acceptance Criteria for Final Spanish A0

- 48-55 meaningful lessons.
- 180-220 useful lexical units or fixed expressions.
- Reading foundations appear near first use.
- Reviews appear after roughly every 3-5 teaching lessons.
- Typed recall remains a major activity type.
- Multiple choice is scaffold, not final proof of knowledge.
- Checkpoints assess rather than reteach.
- Examples use varied people, places, objects and settings.
- No name, city or object dominates examples beyond the target diversity threshold.
- Major patterns complete the presentation-to-checkpoint cycle.
- High-frequency misconceptions have deterministic authored feedback and remediation.
- Content regression rules are implemented for completed modules.
- Stable IDs are preserved where educational identity is preserved.
- Durable learner history remains safe after production restructuring.

---

# Documentation Compliance Review

| Document | Result | Notes |
|---|---|---|
| EDUCATIONAL_PRINCIPLES.md | PASS | Blueprint centers recall, production, feedback and meaningful effort. |
| LEARNING_MODEL.md | PASS | Uses recognition to recall to application progression. |
| CONTENT_MODEL.md | PASS | Keeps Educational Content separate from LessonDefinitions and learner state. |
| CURRICULUM_SPEC.md | PASS WITH NOTED LIMITATION | Stable IDs and hierarchy are respected; production reordering needs progress/version handling. |
| AUTHORING_STYLE_GUIDE.md | PASS | Requires short A0 examples and controlled cognitive load. |
| CONTENT_AUTHORING_GUIDE.md | PASS | Uses existing five content types and existing template fields. |
| COURSE_AUTHORING_GUIDE.md | PASS | Reviews, modules and vocabulary pacing follow guide. |
| CONTENT_REVIEW_CHECKLIST.md | PASS | Adds explicit checks for recall, leakage, variation and references. |

---

# Unresolved Decisions

1. Whether to introduce an explicit curriculum version/reconciliation artifact before applying the 52-lesson order.
2. Whether moved lessons should keep old module IDs forever or receive new IDs with a migration map.
3. Exact pronunciation baseline wording for regional variation.
4. Whether `A0 Checkpoint` should be renamed in production immediately or only in the future reordering sprint.
5. Whether current standalone `curriculum/lessons/*.json` files should be regenerated to match the future blueprint or retired as draft artifacts.

---

# Recommended Next Phase

C2B should implement Module 1 only:

- Revise lessons 1-6 according to this blueprint.
- Move silent h/stable vowel support near the start.
- Keep production course coherent and valid.
- Do not introduce the full 52-lesson order until progress compatibility is approved.

---

End of document.
