# Beginner Course Blueprint Audit

Status: EVIDENCE
Scope: Spanish course design or implementation evidence
Normative authority: SPANISH_A0_CURRICULUM_BLUEPRINT.md

Scope audited:

- `docs/research/BEGINNER_COURSE_SEQUENCE.md`
- `docs/research/BEGINNER_LESSON_PROGRESSION.md`
- `docs/research/FIRST_15_LESSONS_RATIONALE.md`

Governing sources applied:

- `docs/LEARNING_STATE_MACHINE.md`
- `docs/PEDAGOGICAL_SCENARIO_MODEL.md`
- `docs/LESSON_AUTHORING_ENTRYPOINT.md`
- `docs/LEARNING_MODEL.md`
- `docs/AUTHORING_STYLE_GUIDE.md`
- `docs/CONTENT_AUTHORING_GUIDE.md`
- `docs/COURSE_AUTHORING_GUIDE.md`
- `docs/PRONUNCIATION_AUTHORING_GUIDE.md`
- `docs/WRITING_SYSTEM_STANDARD.md`
- `docs/research/SPANISH_PEDAGOGICAL_FOUNDATION.md`
- `docs/research/SPANISH_TEACHING_PRINCIPLES.md`
- `docs/research/TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md`

This audit does not rewrite the blueprint and does not define implementation
content.

## Executive Verdict

PASS WITH REQUIRED REVISIONS

The blueprint is directionally coherent and much stronger than a
content-category or textbook-table opening. It starts with communication, keeps
grammar implicit, uses just-in-time pronunciation, and distributes integration
checkpoints across the first 15 lessons.

It is not ready for lesson implementation as written. The largest blockers are
prerequisite gaps and hidden load: `por favor` is reused without a clear
introduction, the stated ability to ask someone's name is not actually reached,
and several lessons ask learners to read or type forms whose writing or reading
units are not explicitly accounted for.

Findings:

- Critical: 2
- Major: 7
- Minor: 6
- Observations: 4

## Critical Findings

### C1. `por favor` Is Required Before It Is Introduced

Severity:
Critical.

Affected documents:

- `BEGINNER_COURSE_SEQUENCE.md`, Canonical Lesson Order, Lessons 10 and 12.
- `BEGINNER_LESSON_PROGRESSION.md`, Lessons 10 and 12.

Affected lessons:
Lessons 10 and 12.

Relevant governing documents:

- `LEARNING_STATE_MACHINE.md`: Not introduced material cannot be assumed.
- `PEDAGOGICAL_SCENARIO_MODEL.md`: every lesson must define genuinely new
  units required for the outcome.
- `TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md`: examples use known or immediately
  introduced language.

Evidence type:
Direct evidence.

Finding:
Lesson 10 is described in the sequence as "Use `Por favor` in a short request
frame", but the detailed Lesson 10 plan lists no new vocabulary and does not
introduce `Por favor`. Lesson 12 then says it "reuses `por favor`" and that
only `Repite` is new. No earlier lesson introduces `por favor`.

Why this blocks implementation:
An implementation would either ask the learner to use unknown language or
silently add an unstated lesson objective. Both violate explicit introduction
before required use.

Required revision:
Introduce `por favor` explicitly before Lesson 12, or change Lesson 12 so it
does not require it. Lesson 10 may become the explicit `por favor` lesson, but
then its cognitive load and progression must say so.

### C2. The Blueprint Claims Name-Question Ability That It Does Not Teach

Severity:
Critical.

Affected documents:

- `BEGINNER_COURSE_SEQUENCE.md`, Beginning Scope and Lesson 14.
- `BEGINNER_LESSON_PROGRESSION.md`, Lessons 14 and 15.

Affected lessons:
Lessons 14 and 15.

Relevant governing documents:

- `PEDAGOGICAL_SCENARIO_MODEL.md`: outcomes must be measurable learner
  capabilities.
- `LEARNING_MODEL.md`: recognition and independent production are different
  evidence.
- `TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md`: recognition precedes recall, but does
  not replace recall when production is claimed.

Evidence type:
Direct evidence plus auditor inference.

Finding:
The beginning scope says the learner should be able to "ask someone else's
name." The sequence table says Lesson 14 lets the learner "Ask `¿Cómo te
llamas?` and recognize it as a name question." The detailed Lesson 14 objective
is only "understands and recognizes `¿Cómo te llamas?`", and writing is "none
required." Lesson 15 integrates a first-contact exchange but does not explicitly
teach or assess production of `¿Cómo te llamas?`.

Why this blocks implementation:
The blueprint promises a productive communicative ability but supplies only
recognition evidence. Implementing from this blueprint would leave authors to
invent a missing production step.

Required revision:
Either reduce the scope to recognition of the name question or add a separate
lesson that moves `¿Cómo te llamas?` through guided and independent production.

## Major Findings

### M1. Writing-System Prerequisites Are Underspecified While Alphabet Is Postponed

Severity:
Major.

Affected documents:

- `BEGINNER_COURSE_SEQUENCE.md`, Global Sequencing Rules and Early Reading Rule
  Order.
- `BEGINNER_LESSON_PROGRESSION.md`, all lessons with typed Spanish production.

Affected lessons:
Lessons 1, 2, 4, 6, 8, 9, 12, 13, and 15.

Relevant governing documents:

- `WRITING_SYSTEM_STANDARD.md`: a learner must never encounter an unknown
  writing unit before it has been explicitly introduced.
- `CONTENT_AUTHORING_GUIDE.md`: do not ask the learner to read, type,
  recognize, recall, or apply a new written symbol before introduction.

Evidence type:
Auditor inference from direct blueprint omissions.

Finding:
The blueprint correctly postpones full alphabet instruction, but it does not
state how individual letters, punctuation, accents, or digraphs are introduced
before typed recall. For example, Lesson 1 requires typing `Hola`, Lesson 2
requires typing `Hola, Ana`, and Lesson 6 requires typing `Adiós`.

Why this matters:
Postponing the full alphabet is supported. Omitting just-in-time WritingUnit
introduction is not. The blueprint needs a general rule that each new written
unit required for reading or typing is introduced locally without turning the
lesson into an alphabet lesson.

Required revision:
Add a writing-unit policy for the first 15 lessons: every new typed form must
declare which letters, accents, punctuation, or digraphs are taught as local
writing support.

### M2. Lesson 3 Understates Reading Load In `¿Qué tal?`

Severity:
Major.

Affected documents:

- `BEGINNER_LESSON_PROGRESSION.md`, Lesson 3.
- `BEGINNER_COURSE_SEQUENCE.md`, Early Reading Rule Order.

Affected lesson:
Lesson 3.

Relevant governing documents:

- `PRONUNCIATION_AUTHORING_GUIDE.md`: ReadingRule cards answer how to read the
  next course word.
- `WRITING_SYSTEM_STANDARD.md`: new writing units must be introduced before
  active reading.
- `SPANISH_TEACHING_PRINCIPLES.md`: `qu` and stress/intonation should be
  introduced only when needed, but must be introduced when needed.

Evidence type:
Direct evidence.

Finding:
Lesson 3 lists only Spanish question marks as a reading rule, while `¿Qué tal?`
also contains `qu` and accented `é`. The cognitive load notes "punctuation and
accent appear", but the new knowledge section does not account for how the
learner reads `Qué`.

Why this matters:
The lesson may remain comprehension-only, but it still asks the learner to
encounter and read a new Spanish phrase. Whole-phrase pronunciation support may
be enough, but the blueprint must say that explicitly or introduce the local
reading facts.

Required revision:
Clarify whether Lesson 3 teaches `¿Qué tal?` as an unanalyzed whole phrase with
pronunciation support, or whether it introduces local `qu` and accent support.

### M3. Lesson 2 Jumps From Recognition To Independent Production

Severity:
Major.

Affected document:
`BEGINNER_LESSON_PROGRESSION.md`, Lesson 2.

Affected lesson:
Lesson 2.

Relevant governing documents:

- `LEARNING_STATE_MACHINE.md`: recognition, supported recall, and independent
  recall are distinct learner states.
- `LEARNING_MODEL.md`: cued recall and free recall are different evidence.

Evidence type:
Direct evidence.

Finding:
Lesson 2 progression goes from changed addressee context directly to
independent production. It lacks an explicit guided recall stage for `Hola,
Ana.` even though the learner is now producing a two-part utterance with a name
and punctuation.

Why this matters:
The difficulty increase is controlled in concept, but the progression skips a
state that the governing model normally expects before independent production.

Required revision:
Add a non-leaking guided recall step or reduce the final outcome to recognition
until production evidence is built.

### M4. Lesson 7 Has An Ambiguous Productive Demand

Severity:
Major.

Affected document:
`BEGINNER_LESSON_PROGRESSION.md`, Lesson 7.

Affected lesson:
Lesson 7.

Relevant governing documents:

- `PEDAGOGICAL_SCENARIO_MODEL.md`: every lesson must define completion
  evidence.
- `LEARNING_MODEL.md`: recognition and production are different evidence.

Evidence type:
Direct evidence.

Finding:
Lesson 7 objective is contextual choice between `Hola` and `Adiós`, but the
new-knowledge section says writing is "optional recall of known word depending
scenario evidence." The exercise progression includes guided recall and
independent contextual choice.

Why this matters:
Optional productive work makes the lesson objective and assessment ambiguous.
The lesson should either be a recognition/discrimination lesson or a recall
lesson with explicit evidence.

Required revision:
Define whether Lesson 7 proves contextual recognition or contextual recall.

### M5. Lesson 10 Is Too Broad If It Also Introduces `Por favor`

Severity:
Major.

Affected documents:

- `BEGINNER_COURSE_SEQUENCE.md`, Lesson 10.
- `BEGINNER_LESSON_PROGRESSION.md`, Lesson 10.

Affected lesson:
Lesson 10.

Relevant governing documents:

- `PEDAGOGICAL_SCENARIO_MODEL.md`: one lesson teaches one measurable outcome and
  uses the strictest beginner-scale budget.
- `TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md`: review lessons introduce no new target
  language.

Evidence type:
Auditor inference from C1.

Finding:
Lesson 10 is named as a checkpoint with no new vocabulary in the detailed plan,
but the sequence says it uses `Por favor` in a short request frame. If Lesson
10 introduces `Por favor`, it stops being a pure checkpoint and may combine
review, new courtesy vocabulary, and request framing.

Why this matters:
The lesson cannot simultaneously be a zero-new-language integration checkpoint
and the first introduction of a new courtesy phrase.

Required revision:
Split `Por favor` into its own lesson, or redefine Lesson 10 as the explicit
`Por favor` lesson and move the checkpoint later.

### M6. Review Strategy Is Often Directional Rather Than State-Specific

Severity:
Major.

Affected documents:

- `BEGINNER_LESSON_PROGRESSION.md`, Lessons 6-15.
- `FIRST_15_LESSONS_RATIONALE.md`, Review Architecture.

Affected lessons:
Lessons 6-15, especially 10 and 15.

Relevant governing documents:

- `LEARNING_STATE_MACHINE.md`: remediation paths depend on failed state.
- `TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md`: review must change context, support, or
  response type; failed review routes to the failed learner state.

Evidence type:
Auditor inference.

Finding:
The blueprint repeatedly says review changes context or response type, but many
lesson plans do not specify which previous units are reviewed at which evidence
level. Lesson 15 says it reviews Lessons 1-14, which is likely too broad unless
implementation narrows the retrieval targets.

Why this matters:
Implementation authors still need to decide which state each review checks.
That leaves room for mechanical mixed practice rather than deterministic review.

Required revision:
For each checkpoint, list the exact reviewed capabilities and target learner
states.

### M7. Lesson 15 May Overreach By Combining Name, Courtesy, And Repair

Severity:
Major.

Affected document:
`BEGINNER_LESSON_PROGRESSION.md`, Lesson 15.

Affected lesson:
Lesson 15.

Relevant governing documents:

- `AUTHORING_STYLE_GUIDE.md`: increase difficulty one dimension at a time.
- `PEDAGOGICAL_SCENARIO_MODEL.md`: every step must justify state transition and
  evidence.

Evidence type:
Auditor inference.

Finding:
Lesson 15 integrates greeting, name exchange, courtesy, and "repair phrase if
needed." If this includes `No entiendo` and `Repite, por favor`, it combines
several communicative domains in one checkpoint.

Why this matters:
The lesson introduces no new forms, which helps, but the communicative decision
space may still be too large for a first integrated mobile checkpoint.

Required revision:
Define a narrower Lesson 15 success path and move repair phrase review to a
separate classroom-survival checkpoint if needed.

## Minor Findings

### m1. Lesson 3, 11, And 14 Communicative Outcomes Are Recognition-Only

Severity:
Minor.

Affected document:
`BEGINNER_LESSON_PROGRESSION.md`, Lessons 3, 11, and 14.

Relevant governing documents:

- `LEARNING_MODEL.md`: recognition is weaker than recall.
- `PEDAGOGICAL_SCENARIO_MODEL.md`: outcome must match evidence.

Evidence type:
Direct evidence.

Finding:
Recognition-only lessons can be valid when they prepare later production, but
their communicative outcomes should not be phrased as if the learner can use
the expression independently.

Required revision:
Label these as comprehension/preparation lessons and ensure the next lesson
builds production.

### m2. Multiword Phrases Are Counted As One Word

Severity:
Minor.

Affected document:
`BEGINNER_LESSON_PROGRESSION.md`, Lessons 9, 11, 12, 13, and 14.

Relevant governing document:
`PEDAGOGICAL_SCENARIO_MODEL.md`, New material budget.

Evidence type:
Direct evidence.

Finding:
Several lessons count a fixed phrase as "1 word" or "1 fixed phrase." This is
acceptable if the phrase is taught as a chunk, but the blueprint should state
that the count is phrase-chunk load, not literal word count.

### m3. "Stable Vowels" Are Listed Globally But Not Placed Clearly

Severity:
Minor.

Affected document:
`BEGINNER_COURSE_SEQUENCE.md`, Early Reading Rule Order.

Relevant governing documents:
`SPANISH_TEACHING_PRINCIPLES.md`; `PRONUNCIATION_AUTHORING_GUIDE.md`.

Evidence type:
Direct evidence.

Finding:
Stable vowel reading is listed as the second early reading fact, but no lesson
explicitly owns this as a local teaching point. Lesson 2 mentions "simple vowel
continuity" in `Ana`, but says no broad vowel lesson.

Required revision:
Either attach stable-vowel support to a specific lesson or state that it is
distributed as word-level pronunciation support until later formalization.

### m4. Lesson 6 Accent Production Policy Is Deferred To Implementation

Severity:
Minor.

Affected document:
`BEGINNER_LESSON_PROGRESSION.md`, Lesson 6.

Relevant governing document:
`LEARNING_MODEL.md`, accepted-with-feedback distinction.

Evidence type:
Direct evidence.

Finding:
Lesson 6 says missing accent handling "may" be accepted-with-feedback in
implementation. The blueprint should decide the pedagogical expectation:
whether exact accent production is required, accepted with feedback, or delayed.

### m5. "First Review Checkpoint" Is Inconsistent

Severity:
Minor.

Affected document:
`BEGINNER_COURSE_SEQUENCE.md`, Lesson 15.

Relevant governing document:
`COURSE_AUTHORING_GUIDE.md`, coherent course roadmap.

Evidence type:
Direct evidence.

Finding:
Lesson 15 is described as establishing "the first review checkpoint", but
Lessons 5 and 10 are already integration checkpoints.

### m6. Lesson 13 Personal Name Slot Needs Boundary Conditions

Severity:
Minor.

Affected document:
`BEGINNER_LESSON_PROGRESSION.md`, Lesson 13.

Relevant governing documents:
`PEDAGOGICAL_SCENARIO_MODEL.md`; `WRITING_SYSTEM_STANDARD.md`.

Evidence type:
Auditor inference.

Finding:
The supported name slot is useful, but implementation needs to know whether the
name is selected from known names, typed freely, or represented as a placeholder.
Free typing personal names would introduce uncontrolled spelling and
localization issues.

## Global Progression Assessment

The global progression is mostly coherent:

- The course starts with an appropriate learner task: `Hola` as immediate
  communication.
- Communication starts early enough.
- Pronunciation begins at the correct point, before unsupported reading.
- Reading is gradual in intent, but specific reading-unit ownership is
  underdefined for `¿Qué tal?`, accents, and multiword phrases.
- Alphabet instruction is appropriately postponed, but just-in-time WritingUnit
  introduction must be specified.
- Writing begins early but with short forms; this is supported if writing units
  are locally introduced.
- Grammar is appropriately delayed and communicative.
- Vocabulary growth is mostly controlled, except for hidden multiword and
  `por favor` load.
- Independent recall appears gradually in many lessons, but Lessons 2 and 7
  need cleaner state transitions.
- Review is distributed, but checkpoint review needs state-specific targets.
- By Lesson 15 the learner reaches a meaningful first-contact outcome only if
  the name-question and `por favor` gaps are resolved.

Overall:
The sequence is not arbitrary and is not textbook-like in the bad sense. Its
main weakness is that it sometimes treats phrase-level familiarity as if all
reading, writing, and prerequisite knowledge were already covered.

## Per-Lesson Assessment

| Lesson | Primary objective | Load | Prerequisites | Outcome | Placement | Verdict |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Read, understand, type `Hola.` | Low but needs local writing-unit support. | None. | Real first greeting. | Strong opening. | Supported with minor prerequisite clarification. |
| 2 | Produce `Hola, Ana.` | Moderate hidden punctuation/name load. | `Hola` recall. | Real named greeting. | Good after Lesson 1. | Needs guided recall and writing-unit clarification. |
| 3 | Recognize `¿Qué tal?` | Understated due to `qu`, accent, question marks. | Greeting context. | Comprehension only. | Good before answer lesson. | Needs reading-load revision. |
| 4 | Answer with `Bien.` | Low-moderate. | Recognize `¿Qué tal?`. | Real answer. | Correct after Lesson 3. | Supported. |
| 5 | Complete mini exchange. | Controlled integration. | Lessons 1-4. | Real tiny exchange. | Good checkpoint. | Supported if no new language appears. |
| 6 | Type `Adiós.` | Moderate due to accent. | Greeting/farewell contrast not required. | Real farewell. | Good after greeting exchange. | Needs accent policy. |
| 7 | Choose greeting/farewell. | Low. | `Hola`, `Adiós`. | Contextual discrimination. | Good after Lesson 6. | Objective/recall evidence ambiguous. |
| 8 | Type `Gracias.` | Moderate; longer word and local `c`. | Social context. | Real thanks. | Good after greeting/farewell. | Supported with local reading support. |
| 9 | Produce `De nada.` | Moderate phrase chunk. | `Gracias`. | Real response to thanks. | Good after Lesson 8. | Supported, clarify phrase load. |
| 10 | Courtesy checkpoint / `Por favor` use. | Contradictory. | Lessons 1-9 plus unintroduced `por favor`. | Potentially useful. | Weak as written. | Critical revision required. |
| 11 | Recognize `No entiendo.` | Moderate phrase chunk. | Known social phrases. | Comprehension only. | Reasonable after basic social set. | Supported if followed by production. |
| 12 | Produce `Repite, por favor.` | High if `por favor` unknown. | `No entiendo`, `por favor`. | Useful repair request. | Good concept, bad prerequisite. | Blocked by C1. |
| 13 | Produce `Me llamo ...`. | Moderate; `ll` and name slot. | Greeting confidence. | Real self-introduction. | Good after survival basics. | Supported with name-slot constraints. |
| 14 | Recognize `¿Cómo te llamas?` | Moderate-high; accent, question, `ll`. | `Me llamo`. | Comprehension only. | Good before production. | Scope contradiction unless production follows. |
| 15 | Complete first-contact exchange. | Potentially high integration. | Lessons 1-14. | Meaningful if narrowed. | Good checkpoint position. | Needs scope and review narrowing. |

## Adjacent-Lesson Transition Assessment

| Transition | Prior knowledge reused | New demand added | Assessment |
| --- | --- | --- | --- |
| 1 -> 2 | `Hola` meaning, reading, recall. | Add name/address context. | Good, but production jump needs guided recall. |
| 2 -> 3 | Greeting context. | Understand a greeting question. | Good; controlled if `¿Qué tal?` reading load is handled. |
| 3 -> 4 | Recognized question. | Produce answer. | Strong state progression. |
| 4 -> 5 | Greeting, question, answer. | Order and controlled exchange. | Strong integration checkpoint. |
| 5 -> 6 | Social exchange confidence. | Farewell and accent. | Good; accent policy needed. |
| 6 -> 7 | Greeting and farewell forms. | Contextual discrimination. | Good, but recall requirement ambiguous. |
| 7 -> 8 | Social-function contrast. | Thanking. | Good expansion. |
| 8 -> 9 | `Gracias`. | Paired response. | Strong dependency logic. |
| 9 -> 10 | Courtesy pair plus greeting/farewell. | Checkpoint or `por favor`. | Not controlled as written; `por favor` gap. |
| 10 -> 11 | Social phrases. | Survival phrase recognition. | Reasonable if Lesson 10 is fixed. |
| 11 -> 12 | Recognize misunderstanding phrase. | Ask for repetition. | Good logic, blocked by `por favor` prerequisite. |
| 12 -> 13 | Survival confidence. | Self-introduction with `ll`. | Reasonable, but this is a domain shift; review should be small. |
| 13 -> 14 | `Me llamo` answer frame. | Recognize name question. | Good comprehension-before-production logic. |
| 14 -> 15 | Name question recognition and known phrases. | Integrated first-contact exchange. | Potentially too broad; does not prove asking-name production. |

## Methodology Compliance Matrix

| Decision | Source rule | Compliance status | Evidence | Comment |
| --- | --- | --- | --- | --- |
| Start with `Hola` instead of alphabet. | `SPANISH_TEACHING_PRINCIPLES.md`: communication motivates technical work; full alphabet table adapted. | SUPPORTED | Direct evidence from R2E12 rationale and research docs. | Strong opening. |
| Introduce pronunciation immediately. | `TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md`: pronunciation before unsupported reading. | SUPPORTED | Lesson 1 pronunciation support. | Correct. |
| Postpone full alphabet. | `SPANISH_TEACHING_PRINCIPLES.md`: alphabet tables adapted into micro-rules. | SUPPORTED | Global sequencing rules. | Needs just-in-time WritingUnit policy. |
| Require typing from Lesson 1. | `LEARNING_MODEL.md`: recall stronger than recognition. | PARTIALLY SUPPORTED | Lesson 1 has guided and independent recall. | Supported only if writing units are locally introduced. |
| Teach `¿Qué tal?` as recognition before answer. | `LEARNING_STATE_MACHINE.md`: recognition before recall. | SUPPORTED | Lessons 3-4 split question and answer. | Reading load must be explicit. |
| Use `por favor` in Lesson 10/12. | `LEARNING_STATE_MACHINE.md`: Not introduced cannot be assumed. | CONTRADICTED | No lesson introduces `por favor`. | Critical prerequisite gap. |
| Delay grammar terminology. | `AUTHORING_STYLE_GUIDE.md`: grammar supports communication; examples before theory. | SUPPORTED | Early grammar order. | Strong. |
| Integration checkpoints at 5, 10, 15. | `TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md`: review changes context/support/response type. | PARTIALLY SUPPORTED | Checkpoints named, but review targets vague. | Needs state-specific review definitions. |
| Recognition-only lessons for long phrases. | `LEARNING_MODEL.md`: recognition is weaker but valid stage. | PARTIALLY SUPPORTED | Lessons 3, 11, 14. | Valid only if production later appears when claimed. |
| Name-question scope. | `PEDAGOGICAL_SCENARIO_MODEL.md`: outcome must be measurable. | CONTRADICTED | Scope says ask name; lesson only recognizes. | Critical. |
| Phrase chunks counted as one unit. | Scenario new material budget. | PARTIALLY SUPPORTED | Lessons 9, 11-14. | Acceptable if explicitly defined as chunk load. |
| Avoid textbook-sized lessons. | `SPANISH_TEACHING_PRINCIPLES.md`: large textbook lessons are not mobile lessons. | SUPPORTED | One expression or checkpoint per lesson. | Strong except Lesson 15 breadth. |

## Cross-Document Contradictions

1. `BEGINNER_COURSE_SEQUENCE.md` says Lesson 10 uses `Por favor`; detailed
   Lesson 10 says no new vocabulary.

2. `BEGINNER_LESSON_PROGRESSION.md` Lesson 12 says `por favor` is reused, but
   no previous lesson introduces it.

3. `BEGINNER_COURSE_SEQUENCE.md` Beginning Scope includes "ask someone else's
   name"; detailed Lesson 14 teaches only recognition of `¿Cómo te llamas?`.

4. `BEGINNER_COURSE_SEQUENCE.md` says Lesson 15 establishes the first review
   checkpoint, but the same document defines Lessons 5, 10, and 15 as
   integration checkpoints.

5. `FIRST_15_LESSONS_RATIONALE.md` says every lesson ends with a measurable
   communicative gain, but Lessons 3, 11, and 14 are recognition-only
   preparation lessons. This is acceptable only if the wording is narrowed.

## Unsupported Design Assumptions

1. The blueprint assumes the learner can type Latin-letter words while the
   alphabet is postponed, without defining local WritingUnit introduction.

2. The blueprint assumes whole-phrase pronunciation support can cover hidden
   reading facts in `¿Qué tal?`, `No entiendo`, and `¿Cómo te llamas?`, but it
   does not state when whole-phrase support is sufficient versus when a
   ReadingRule is required.

3. The blueprint assumes integration checkpoints can review many prior lessons
   without overload. This is plausible but needs exact reviewed state targets.

4. The blueprint assumes `accepted-with-feedback` handling for `Adiós` accent
   without defining the pedagogical production expectation.

5. The blueprint assumes a supported personal name slot can be implemented
   deterministically without specifying whether the learner selects from known
   names or enters arbitrary text.

## Required Revisions Before Implementation

1. Resolve the `por favor` prerequisite gap.
   Either introduce it explicitly before Lesson 12 or remove it from Lesson 12.

2. Resolve the name-question production mismatch.
   Either remove "ask someone else's name" from the first-15 scope or add a
   production lesson for `¿Cómo te llamas?`.

3. Add a just-in-time WritingUnit policy for Lessons 1-15.
   This must reconcile postponed alphabet instruction with active typing.

4. Clarify reading support for `¿Qué tal?`.
   State whether Lesson 3 teaches whole-phrase reading only or introduces local
   `qu`, accent, and question-mark support.

5. Add guided recall to Lesson 2 or reduce the final outcome.

6. Decide whether Lesson 7 assesses recognition or recall.

7. Narrow Lesson 15 to a specific first-contact success path and exact reviewed
   states.

8. Define checkpoint review targets for Lessons 5, 10, and 15.

9. Clarify phrase-chunk counting and accent production policy.

10. Constrain the Lesson 13 name slot to deterministic learner-safe behavior.

## Final Recommendation

Approve after targeted revisions.

The blueprint should not be returned to full redesign. Its core architecture is
sound: communication first, pronunciation just in time, grammar delayed,
recognition before recall, and integration checkpoints. The required work is
targeted: fix prerequisite gaps, make hidden reading/writing load explicit, and
tighten checkpoint review evidence before implementation begins.

## Audit Self-Check

- The audited blueprint documents were not rewritten.
- No replacement lesson content was produced.
- No JSON, code, tests, validators, runtime, curriculum, or localization files
  were modified by this audit.
- Findings distinguish direct evidence from auditor inference.
- Every substantive finding cites affected documents and governing rules.
