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
| Modules | 9 |
| Live lessons | 70 |
| Reviews | 9 |
| Checkpoints | 7 |
| Vocabulary items across Spanish assets | 388 |
| Grammar topics | 75 |
| Dialogues | 68 |
| Readings | 76 |
| Exercise templates | 495 |
| Referenced multiple-choice steps | 73 |
| Referenced fill-gap steps | 58 |
| Referenced text-entry steps | 199 |
| Referenced matching steps | 2 |

Major findings:

- The 70-lesson course is valid and playable, with Modules 1-9 now implemented as production content.
- Early lessons over-concentrate greetings, names, origin, courtesy and short first-contact phrases.
- Reading foundations have been partially moved earlier, but old reading-basics lesson IDs remain retired rather than repurposed.
- `A0 Checkpoint` at lesson 15 is no longer a true final A0 checkpoint because later lessons add reading, objects, directions, help, family, health and integrated communication.
- Module 9 provides the current final integrated A0 checkpoint; no separate final competency layer is defined in this blueprint.
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
| 14 | es.a0.m05.l028 | m05 | What Is This? | teaching | 6 | 4 | 2 | 1 | 1 | 0 | 2 | 1 | High | Teaches object identification and `¿Qué es esto?`. | Active Module 5 lesson. |
| 15 | es.a0.m05.l029 | m05 | Objects and Availability | teaching | 6 | 4 | 2 | 1 | 1 | 0 | 1 | 1 | High | Teaches polite fixed availability questions. | Active Module 5 lesson. |
| 16 | es.a0.m06.l016 | m06 | Silent h and Stable Vowels | reading foundation | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 2 | High | Arrives too late. | Move earlier near lesson 2. |
| 17 | es.a0.m06.l017 | m06 | ñ, j, and ll | reading foundation | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | High | Arrives too late. | Move earlier near first place/name content. |
| 18 | es.a0.m06.l018 | m06 | qu, gue, gui | reading foundation | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | High | Good content; should be integrated with queso/Miguel. | Move earlier and connect to object/food content. |
| 19 | es.a0.m06.l019 | m06 | Question Accents | reading foundation | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | High | Should appear before repeated qué/cómo/dónde tasks. | Move near first question module. |
| 20 | es.a0.m06.l020 | m06 | Reading Basics Review | review | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 2 | High | Useful review; currently isolated. | Convert to early reading review. |
| 21 | es.a0.m07.l021 | m07 | Numbers 0-10 | teaching | 7 | 4 | 2 | 1 | 1 | 0 | 0 | 0 | High | Retired from the active Module 7 path by C2H. | Reintroduce later only with new active identity. |
| 22 | es.a0.m07.l022 | m07 | Numbers 11-20 | teaching | 7 | 4 | 2 | 1 | 1 | 0 | 0 | 0 | High | Retired from the active Module 7 path by C2H. | Reintroduce later only with new active identity. |
| 23 | es.a0.m07.l023 | m07 | Age with Tener | teaching | 8 | 4 | 2 | 1 | 1 | 0 | 1 | 2 | High | Retired from the active Module 7 path by C2H. | Reintroduce later only with new active identity. |
| 24 | es.a0.m07.l024 | m07 | Simple Numbers in Contact Details | teaching | 7 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | Medium | Retired from the active Module 7 path by C2H. | Reintroduce later only with new active identity. |
| 25 | es.a0.m07.l025 | m07 | Numbers and Age Review | review | 8 | 4 | 2 | 1 | 1 | 0 | 0 | 1 | High | Retired from the active Module 7 path by C2H. | Reintroduce later only with new active identity. |
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

Historical lesson `es.a0.m05.l015` was titled `A0 Checkpoint`, but it appeared before reading foundations, numbers, age, everyday objects, food/drink, family/friends and integrated communication.

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

The learner can handle a short controlled A0 interaction: greet, introduce
themself, ask and answer a name/origin/wellbeing question, ask for
clarification, read common beginner words, ask for basic help, find important
services, request simple urgent help, understand a short profile or dialogue
and close politely.

---

# Target Module Structure

| Module | Title | Lessons | New vocabulary target | Main role |
|---|---|---:|---:|---|
| M01 | First Words and Reading | 1-6 | 22-28 | greetings, courtesy, silent h, stable vowels, early clarification |
| M02 | Names and Introductions | 7-12 | 18-24 | name patterns, varied names, ñ/j/ll with names and Spain |
| M03 | Origin, Languages and Personal Identity | 13-19 | 22-28 | origin, residence, languages, controlled personal profile |
| M04 | People and Everyday Conversation | 20-27 | 24-32 | identify and describe people, third-person facts, short everyday exchange |
| M05 | Shopping and Everyday Objects | 28-35 | 30-38 | objects, availability, prices, cheap/expensive, purchase request |
| M06 | Transport and Directions | 36-43 | 28-34 | transport, location questions, simple directions, near/far, route exchange |
| M07 | Asking for Help | 44-51 | 18-24 | attention words, help requests, communication repair, services, urgent help |
| M08 | Home and Family | 52-60 | 24-30 | family, rooms, household objects, `hay` versus `está`, integrated home profile |
| M09 | Health and Integrated Communication | 61-70 | 20-26 | basic wellbeing, symptoms, service requests, controlled integrated A0 communication |

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

## M04 — People and Everyday Conversation

### Communicative Goal

The learner can identify another person, state a basic role or relationship,
describe the person simply, ask and answer basic questions about the person and
sustain a short predictable everyday exchange.

### Real-Life Scenarios

- identifying a friend, teacher, student or classmate;
- saying another person's name with `se llama`;
- asking `¿Quién es?` and `¿Cómo es?`;
- describing a person with a controlled adjective;
- giving origin, residence and language facts about another person;
- answering yes/no questions about another person;
- completing a short conversation about a familiar person.

## M05 — Shopping and Everyday Objects

### Communicative Goal

The learner can identify common everyday objects, ask whether an item is
available, ask and understand a simple price, express a basic purchase
intention and complete a short predictable shopping exchange.

### Real-Life Scenarios

- asking `¿Qué es esto?` and naming a familiar object;
- asking the seller `¿Tiene...?` in a fixed polite shopping pattern;
- asking `¿Cuánto cuesta?` and understanding one controlled price;
- saying whether a practiced item is cheap or expensive;
- requesting one familiar item with `quiero` or `este/esta, por favor`;
- responding to `¿Algo más?` with a polite closing.

## M06 — Transport and Directions

### Communicative Goal

The learner can name basic transport, ask where a place is, ask how to get somewhere, understand short route instructions and complete a controlled directions exchange.

### Real-Life Scenarios

- saying `Voy en metro` or `Voy a pie`;
- asking `¿Dónde está la estación?`;
- asking `¿Cómo llego al hotel?`;
- understanding `sigue recto`, `gira a la izquierda` and `gira a la derecha`;
- distinguishing `cerca` and `lejos`;
- completing a short route and transport exchange.

## M07 — Asking for Help

### Communicative Goal

The learner can get polite attention, ask for help, repair communication, ask
where an important service is and request simple urgent help in a controlled
A0 situation.

### Real-Life Scenarios

- getting attention with `disculpe` or `oiga`;
- asking `¿Puede ayudarme?`;
- saying `No entiendo`, `Repita, por favor` or `Hable más despacio`;
- asking where the bathroom, pharmacy, hospital or police are;
- saying `Necesito un médico`, `Necesito la policía` or `Es una emergencia`;
- completing a short help exchange without describing complex problems.

## M08 — People, Home and Simple Surroundings

### Communicative Goal

The learner can give and understand tiny facts about people, home, city and simple surroundings.

### Real-Life Scenarios

- saying a simple fact about a friend or family member;
- saying where someone lives or is from in a minimal profile;
- reading a tiny profile using known structures;
- recognizing third-person facts with `es` and `tiene`;
- combining people, places and familiar objects.

## M09 — Health and Integrated Communication

### Communicative Goal

The learner can state basic wellbeing, ask for simple help, and combine the A0 foundation in controlled conversations and checkpoints without relying on a single memorized script.

### Real-Life Scenarios

- saying whether they are well or not well;
- naming a small set of basic symptoms without diagnosis or treatment;
- asking for a doctor, pharmacy or hospital in a bounded help scenario;
- understanding a short profile or dialogue with known patterns;
- completing a mixed first-contact interaction;
- handling tightly controlled shopping, transport-help or health-need prompts only when they use already introduced language.

Health is limited to basic communication and service requests. It does not teach diagnosis, medication, treatment, dosage, medical advice or emergency-procedure content.

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
| 20 | es.a0.m04.l020 | M04 | Who Is This Person? | teaching | Ask who a person is and say the person's name. | 19 | quién es, es, se llama, él, ella | names | question punctuation | 3 typed recall, third-person name misconception | C2E |
| 21 | es.a0.m04.l021 | M04 | People and Roles | teaching | Identify a person's basic relationship or role. | 20 | amigo/amiga, profesor/profesora, estudiante, compañero/compañera, mi, tu | names | ñ in compañera | 3 typed recall, gender role misconception | C2E |
| 22 | es.a0.m04.l022 | M04 | Basic Description | teaching | Describe a person with one controlled adjective. | 21 | cómo es, simpático/simpática, alto/alta, joven, serio/seria | roles | accent in cómo | 3 typed recall, adjective agreement misconception | C2E |
| 23 | es.a0.m04.l023 | M04 | Information About Another Person | teaching | Use es, vive and habla for another person. | 22 | vive, habla, también, pero | M03 origin/residence/languages | accents in country names | 3 typed recall, person-form misconception | C2E |
| 24 | es.a0.m04.l024 | M04 | Everyday Questions and Answers | teaching | Ask and answer yes/no questions about another person. | 23 | no es, ¿Es tu amigo?, ¿Habla español? | M01-M03 | question punctuation | 3 typed recall | C2E |
| 25 | es.a0.m04.l025 | M04 | Short Everyday Conversation | dialogue/application | Sustain a short predictable conversation about another person. | 20-24 | none | M01-M04 | question punctuation | 3 typed recall | C2E |
| 26 | es.a0.m04.l026 | M04 | People and Conversation Review | review | Recombine people, roles, descriptions and third-person facts. | 20-25 | none | M01-M04 | accent review | 3 typed recall | C2E |
| 27 | es.a0.m04.l027 | M04 | Module 4 People Checkpoint | checkpoint | Assess people, descriptions, third-person facts and short questions. | 20-26 | none | M01-M04 | sampled punctuation | 4 typed recall | C2E |
| 28 | es.a0.m05.l028 | M05 | What Is This? | teaching | Ask what an object is and identify it. | 27 | esto, libro, cuaderno, botella, bolsa | M01-M04 | question punctuation | 3 typed recall | C2F |
| 29 | es.a0.m05.l029 | M05 | Objects and Availability | teaching | Ask and answer whether a shop has an item. | 28 | tiene, tenemos, agua, bolígrafo, llave | objects | none | 3 typed recall | C2F |
| 30 | es.a0.m05.l030 | M05 | Asking the Price | teaching | Ask and understand a simple price. | 29 | cuánto cuesta, cuesta, euro/euros, one/two/five/ten | availability | accent in cuánto | 3 typed recall | C2F |
| 31 | es.a0.m05.l031 | M05 | Cheap or Expensive | teaching | Describe a familiar item as cheap or expensive. | 30 | caro/cara, barato/barata | object gender | none | 2 typed recall | C2F |
| 32 | es.a0.m05.l032 | M05 | Asking for an Item | teaching | Request one familiar item and close politely. | 31 | quiero, necesito, comprar, este/esta, nada más | price/courtesy | none | 3 typed recall | C2F |
| 33 | es.a0.m05.l033 | M05 | Basic Shopping Exchange | dialogue/application | Combine greeting, item request, price question and closing. | 28-32 | none | M01-M05 | question punctuation | 3 typed recall | C2F |
| 34 | es.a0.m05.l034 | M05 | Shopping Review | review | Recombine objects, availability, prices and requests. | 28-33 | none | M01-M05 | price/list reading | 3 typed recall | C2F |
| 35 | es.a0.m05.l035 | M05 | Shopping Checkpoint | checkpoint | Assess Module 5 shopping skills without new teaching. | 28-34 | none | M01-M05 | sampled punctuation | 5 typed recall | C2F |
| 32 | es.a0.m08.l026 | M06 | Everyday Objects | teaching | Name common objects. | 31 | libro, teléfono, llave, bolsa, mesa, silla | numbers | ll in llave | 2 typed recall | C2G |
| 33 | new: es.a0.m06.l033 | M06 | Un and Una | teaching | Use un/una with familiar objects. | 32 | un, una | objects | none | 2 typed recall | C2G |
| 34 | new: es.a0.m06.l034 | M06 | Tener: I Have | teaching | Use `tengo` with objects and states. | 32-33 | tengo | objects | none | 2 typed recall | C2G |
| 35 | es.a0.m08.l027 | M06 | Tienes and Tiene | teaching | Ask and state possession with you/he/she. | 34 | tienes, tiene | objects | none | 2 typed recall, form-confusion misconception | C2G |
| 36 | new: es.a0.m06.l036 | M06 | Basic Word Order | guided practice | Keep short subject-verb-complement order. | 34-35 | word order | M01-M06 | none | 3 typed recall | C2G |
| 37 | new: es.a0.m06.l037 | M06 | Where Is the Object? | teaching | Ask and answer where a known object is. | 32,16 | está, aquí, allí | objects | dónde accent | 2 typed recall | C2G |
| 38 | new: es.a0.m06.l038 | M06 | Objects and Tener Review | review | Recall objects, articles and tener. | 32-37 | none | M06 | ll/qu review | 3 typed recall | C2G |
| 39 | es.a0.m08.l028 | M07 | Food, Drink and Polite Requests | teaching | Request water, coffee, bread or cheese politely. | 38 | agua, café, pan, queso, quiero | por favor, tener | café accent | 2 typed recall, `porfavor` misconception | C2H |
| 40 | new: es.a0.m07.l040 | M07 | I Am Hungry or Thirsty | teaching | Use fixed tener expressions for hunger/thirst. | 34,39 | hambre, sed | tengo | silent h in hambre | 2 typed recall | C2H |
| 41 | new: es.a0.m07.l041 | M07 | I Need Help | teaching | Say `necesito ayuda` in a simple context. | 22 | necesito ayuda | clarification | none | 2 typed recall | C2H |
| 42 | new: es.a0.m07.l042 | M07 | Café Exchange | dialogue/application | Handle a tiny polite request exchange. | 39-41 | none | M01-M07 | accents in café | 2 typed recall | C2H |
| 43 | new: es.a0.m07.l043 | M07 | Needs and Requests Review | review | Recall food, drink, needs and courtesy. | 39-42 | none | M07 | h/café review | 3 typed recall | C2H |
| 44 | new: es.a0.m07.l044 | M07 | Needs Checkpoint | checkpoint | Assess polite request and need patterns. | 39-43 | none | M01-M07 | none | 4 typed recall | C2H |
| 45 | es.a0.m08.l052 | M08 | My Family | teaching | Identify close family members with `este/esta` and `mi`. | 44 | madre, padre, hermano, hermana, hijo, hija, mi | people and names | none | 2 typed recall | C2I |
| 46 | es.a0.m08.l053 | M08 | Names and Family Information | teaching | State a family member's name and ask who she is. | 45 | `se llama` family pattern, `quién` review | M04 names | question punctuation | 2 typed recall | C2I |
| 47 | es.a0.m08.l054 | M08 | Brothers, Sisters and Simple Questions | teaching | Ask and answer whether someone has siblings. | 45-46 | hermanos, `tengo`, `tienes`, `tiene` in family facts | M06 tener | none | 3 typed recall | C2I |
| 48 | es.a0.m08.l055 | M08 | Rooms in the Home | teaching | Identify rooms and ask where a room is. | 47 | casa, piso, habitación, dormitorio, cocina, baño, salón | M06 location | question punctuation | 2 typed recall | C2I |
| 49 | es.a0.m08.l056 | M08 | Objects and Location | teaching | Locate simple household objects with `está` and `hay`. | 48 | puerta, mesa, silla, cama, ventana, `hay`, `al lado de` | M06 objects/location | accent in `está` | 3 typed recall | C2I |
| 50 | es.a0.m08.l057 | M08 | Describing a Home and Family | application | Produce a bounded family-and-home profile. | 45-49 | combined family/home facts | M01-M08 | none | 2 typed recall | C2I |
| 51 | es.a0.m08.l058 | M08 | Integrated Family and Home Conversation | dialogue/application | Exchange short family and home information. | 45-50 | integrated question-answer flow | M01-M08 | question punctuation | 2 typed recall | C2I |
| 52 | es.a0.m08.l059 | M08 | Home and Family Review | review | Recombine family, rooms, objects and simple location. | 45-51 | none | M08 | reading review | 4 typed recall | C2I |
| 53 | es.a0.m08.l060 | M08 | Home and Family Checkpoint | checkpoint | Assess family and home communication without new teaching. | 45-52 | none | M01-M08 | sampled punctuation | 5 typed recall | C2I |
| 61 | es.a0.m09.l061 | M09 | How Do You Feel? | teaching | Say whether you are well or not well. | 60 | `estoy bien`, `no estoy bien`, `¿estás bien?` | M01-M08 | accents in `estás` | 2 typed recall, `soy`/`estoy` misconception | C2J |
| 62 | es.a0.m09.l062 | M09 | Basic Symptoms | teaching | State a fever or simple pain location. | 61 | `tengo fiebre`, `me duele la cabeza`, `me duele el estómago` | tener, body words | accents in `estómago` | 2 typed recall, symptom contrast | C2J |
| 63 | es.a0.m09.l063 | M09 | Basic Health Questions | teaching | Ask and answer basic health questions. | 61-62 | `¿Qué te pasa?`, `¿Tienes fiebre?` | question/answer distinction | `qué`, `sí` | 2 typed recall, response-type misconception | C2J |
| 64 | es.a0.m09.l064 | M09 | Doctor and Pharmacy Requests | teaching | Request a doctor, pharmacy or hospital in a bounded context. | 62-63 | `médico`, `médica`, `farmacia`, `hospital` | need/request patterns | accents in `médico` | 2 typed recall, service contrast | C2J |
| 65 | es.a0.m09.l065 | M09 | Understanding Simple Help | teaching | Ask for repetition or slower speech in a health-help exchange. | 64 | `repita`, `más despacio`, health yes/no answers | M07 repair phrases | none | 2 typed recall | C2J |
| 66 | es.a0.m09.l066 | M09 | Basic Health Exchange | dialogue/application | Complete a short bounded health-help exchange. | 61-65 | no major new vocabulary | M01-M09 | none | 2 typed recall, sequence misconception | C2J |
| 67 | es.a0.m09.l067 | M09 | Integrated Everyday Help | application | Combine help, health state and location question. | 66 | none | M06-M09 | question punctuation | 2 typed recall | C2J |
| 68 | es.a0.m09.l068 | M09 | Integrated A0 Communication | integrated practice | Combine identity, origin, transport repair and health help. | 67 | none | M01-M09 | punctuation and accents | 2 typed recall, preferred-order feedback | C2J |
| 69 | es.a0.m09.l069 | M09 | Health and Integrated Communication Review | review | Recombine health, help, origin, directions and family/home material. | 61-68 | none | M01-M09 | mixed review | 3 typed recall | C2J |
| 70 | es.a0.m09.l070 | M09 | Health and Integrated Communication Checkpoint | checkpoint | Assess bounded health and integrated A0 communication without new teaching. | 69 | none | M01-M09 | sampled reading rules | 4 typed recall | C2J |

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
| M04 | 20-27 | 96-128 | people and everyday conversation |
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
- Pronunciation notes should follow PRONUNCIATION_AUTHORING_GUIDE.md:
  target orthography, pronunciation variety, IPA and localized learner hints
  are separate; current practical text guides remain legacy until migrated.
- Future Spanish A0 pronunciation content should reference reusable
  PronunciationUnit objects as defined in PRONUNCIATION_MODEL.md.

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
| C2E | Module 4 | 20-27 | People, roles, basic descriptions, third-person facts and short everyday conversation. | dialogue comprehension, recall coverage, review and checkpoint preserve module ownership |
| C2F | Module 5 | 25-31 | Numbers, quantities, age, personal facts checkpoint. | number/age references, answer constraints, delayed reuse |
| C2G | Module 6 | 32-38 | Objects, articles, tener possession, word order. | tener misconceptions, review references, object diversity |
| C2H | Module 7 | 39-44 | Food, drink, hunger/thirst, needs checkpoint. | request prompts, no unsupported grammar, application tasks |
| C2I | Module 8 | 52-60 | Home and family: close family members, family names, siblings, rooms, household objects, `hay` versus `está`, integrated review and checkpoint. | family/home prompt constraints, `hay`/`está` misconceptions, Module 8 competency recovery |
| C2J | Module 9 | 61-70 | Health and integrated communication: bounded wellbeing, symptoms, service requests, integrated review and checkpoint. | health-scope audit, final coverage matrix, no answer leakage, course quality targets |
| C2K | Production reorder | all | Apply approved curriculum order after progress policy. | planner/progress compatibility |

---

# Pedagogical Quality Targets

These targets are binding for the final Spanish A0 course.

They are not all immediate pass/fail gates for the current 70-lesson production course. During C2B-C2J, each completed module should move the implemented curriculum toward these targets and add tests for the rules that are enforceable for the completed slice.

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
