# PEDAGOGICAL_COMPLIANCE_EXAMINATION.md

Phase: R2E9B Independent Pedagogical Compliance Examination

Status: EVIDENCE
Scope: Spanish course/pedagogical review evidence
Normative authority: PEDAGOGICAL_SCENARIO_MODEL.md

Scope examined:

- `PEDAGOGICAL_ARCHITECTURE_AUDIT.md`
- `LEARNING_STATE_MACHINE.md`
- `PEDAGOGICAL_SCENARIO_MODEL.md`
- `LESSON_AUTHORING_ENTRYPOINT.md`
- `LESSON_SCENARIO_REVIEW_L01_L05.md`

This examination treats the R2E9/R2E9A documents as work produced by another team. It
does not defend the scenarios. Its purpose is to find pedagogical defects before any
implementation begins.

No code, JSON, lesson assets, localization, runtime files, schemas, validators, or
tests were modified for this examination.

---

# Executive Verdict

Implementation of Lessons 1-5 is prohibited until blocking issues are remediated.

The new state-machine and scenario architecture is directionally stronger than the
previous content-category approach, but the first five design scenarios still contain
state skips, underspecified evidence, assessment validity gaps, support-leakage risks,
and insufficient determinism for independent implementation.

The most serious findings:

- Lesson 3 introduces two new conversational chunks but does not run both through the
  full learner-state path.
- Lesson 5 claims retention/integration, but the evidence may prove short-term ordering
  and repetition rather than durable retention after real delay.
- Several "changed context" steps are too weakly changed and may be identical exposure
  in disguise.
- Several assessments can prove short-term memory or visual matching rather than the
  stated capability.
- The scenarios still leave too much author interpretation in names, exact prompts,
  distractors, partial cues, timing, and what counts as sufficient evidence.

---

# Examination 1: Learning State Machine Compliance

## Lesson 1

| Transition | Evidence that transition happens | Evidence it is only assumed | Finding |
|---|---|---|---|
| Not introduced -> Attends | Learner notices `Hola.` with pronunciation and meaning. | "Can identify lesson is about one greeting word" is not a strong observable learner action. | Minor defect: attention evidence is weak but recoverable. |
| Attends -> Understands meaning | Learner chooses `привіт`. | Distractor quality is unspecified; weak distractors could make this guessing. | Major defect: evidence depends on unspecified distractors. |
| Understands -> Can read with support | Learner matches `Hola.` to `ола`. | Matching may be visual association, not reading. | Major defect: supported decoding evidence is underspecified. |
| Can read with support -> Recognizes changed context | Learner selects `Hola.` for arrival. | "A person arrives" may not be meaningfully different from first encounter. | Major defect: changed context may be cosmetic. |
| Recognizes -> Recalls with support | Learner completes or types `Hola.` with light support. | "Possibly first-letter cue" is too vague and may leak the answer. | Major defect: support level not deterministic. |
| Recalls with support -> Recalls independently | Learner types `Hola.` from `привіт`. | This may prove short-term memory after repeated exposure, not durable independent recall. | Major defect: valid as immediate recall, not retention. |

## Lesson 2

| Transition | Evidence that transition happens | Evidence it is only assumed | Finding |
|---|---|---|---|
| Independent `Hola.` -> Attends to `Ana` | Learner identifies Ana as person being greeted. | No clear evidence learner reads `Ana` rather than recognizes a displayed label. | Major defect. |
| Attends -> Understands greeting sentence | Learner chooses "Привіт, Ано." | Ukrainian vocative `Ано` adds support-language morphology that may distract A0 learners. | Minor defect: support wording risk. |
| Understands -> Can read with support | Learner matches `Hola, Ana.` to supported reading. | Matching full sentence to pronunciation may be visual matching. | Major defect. |
| Can read -> Recognizes changed context | Learner chooses greeting addressed to Ana. | "Someone else is not the focus" is underspecified; authors may create very different contexts. | Major defect: low determinism. |
| Recognizes -> Recalls with support | Learner completes Spanish greeting from "Привіт, Ано." | The support-language cue may fully specify the answer if only one name exists. | Major defect: guided recall may be trivial. |
| Recalls with support -> Uses meaningful context | Learner types `Hola, Ana.` from situation. | State machine skips explicit "recalls independently" label for the full sentence. | Blocking defect: claimed independent writing needs independent recall evidence before contextual-use claim. |

## Lesson 3

| Transition | Evidence that transition happens | Evidence it is only assumed | Finding |
|---|---|---|---|
| Uses greeting -> Attends to `Que tal?` | Learner notices a new question after greeting. | No issue if the focus is constrained. | Acceptable. |
| Attends -> Understands `Que tal?` | Learner selects `як справи?`. | Distractors are unspecified. | Major defect. |
| Understands `Que tal?` -> Recognizes `Bien.` | Teacher gives `Bien.` means `добре`; learner selects it as answer. | `Bien.` does not receive its own explicit Attends -> Understands -> Can read path. | Blocking defect: second new unit skips required states. |
| Recognizes answer relation -> Recalls `Bien.` with support | Learner completes `Bien.` | The scenario does not specify whether support reveals spelling. | Major defect. |
| Recalls with support -> Uses context | Learner types `Bien.` after `Que tal?` | This may prove memorized response to one prompt, not meaningful response ability. | Blocking defect: assessment too narrow for stated contextual use. |
| Uses context -> Uses context | Learner reads full exchange and points to answer. | No new state movement. | Major defect: likely removable or boredom risk. |

## Lesson 4

| Transition | Evidence that transition happens | Evidence it is only assumed | Finding |
|---|---|---|---|
| Known greeting context -> Attends to `Adios.` | Learner notices leaving needs different phrase. | Acceptable if arrival/leaving contrast is clear. | Acceptable with specification. |
| Attends -> Understands meaning | Learner chooses `до побачення`. | Distractors unspecified. | Major defect. |
| Understands -> Recognizes changed context | Learner chooses between `Hola` and `Adios.` | This is meaningful contrast if situations are clear. | Acceptable. |
| Recognizes -> Recalls with support | Learner completes `Adios.` | Partial support not specified; could leak spelling. | Major defect. |
| Recalls with support -> Uses context | Learner types `Adios.` from leaving situation. | No explicit independent recall state before meaningful use. | Major defect. |
| Uses context -> Retains after interference/delay | Learner mixes arrival/leaving moments immediately. | Immediate contrast is interference, not delay. Retention claim is too strong. | Blocking defect if lesson claims retention. |

## Lesson 5

| Transition | Evidence that transition happens | Evidence it is only assumed | Finding |
|---|---|---|---|
| Uses expressions separately -> Recognizes integrated interaction | Learner identifies greet/answer/leave moments. | This may be meta-recognition of structure, not language recognition. | Major defect. |
| Recognizes separately -> Recognizes sequence | Learner orders three moves. | Same state to same state; no clear state progress. | Major defect. |
| Recognizes sequence -> Recalls with support | Learner fills missing moves. | "One known expression at a time" may be cloze repetition. | Major defect. |
| Recalls with support -> Uses full interaction | Learner writes three responses from situation. | May assess memory of previous sequence, not flexible communication. | Major defect. |
| Uses full interaction -> Retains after interference/delay | Timing changes immediately. | Immediate reordering is interference but not delay; no retention evidence. | Blocking defect. |
| Retains -> Retains | Learner returns to original meeting. | Circular confirmation, no new state. | Major defect: likely removable. |

---

# Examination 2: Hidden State Skips

| Lesson | Hidden skip | Severity | Explanation |
|---|---|---|---|
| 2 | Recalls with support -> Uses meaningful context without explicit independent recall for `Hola, Ana.` | Blocking | The lesson goal says independently writes a greeting. The state path should prove independent recall before contextual use. |
| 3 | `Bien.` introduced -> suitable answer recognition without explicit Attends/Understands/Supported reading path | Blocking | The lesson introduces a second new unit but treats it as dependent on the question. |
| 3 | Meaning recognition of `Que tal?` -> contextual use through typing `Bien.` | Blocking | Understanding the question and producing the answer are separate capabilities. |
| 4 | Supported recall -> meaningful use for `Adios.` | Major | Independent recall is implied by final typing but not named in the transition chain. |
| 4 | Immediate mixed contrast -> retention | Blocking | Retention after delay/interference is overclaimed. |
| 5 | Separate contextual use -> integrated retention | Blocking | Integration and retention need stronger intermediate evidence. |
| 5 | Recognition sequence -> same recognition state | Major | State label repeats without clear progress. |

---

# Examination 3: Assessment Validity

| Lesson | Assessment | What it claims to prove | What it may actually prove | Validity |
|---|---|---|---|---|
| 1 | Type `Hola.` from `привіт` | Independent read/understand/type | Immediate memory of one recently repeated form | Partially valid; does not independently prove reading. |
| 2 | Write `Hola, Ana.` for greeting Ana | Contextual use of addressed greeting | Copyable short-term memory of exact modeled sentence | Weak unless prompts/delay vary. |
| 3 | Type `Bien.` after `Que tal?` | Contextual response to a question | Memorized answer to a single fixed prompt | Invalid for broader contextual-use claim. |
| 4 | Type `Adios.` for leaving | Appropriate farewell use | Recall of one phrase from a binary contrast | Partially valid; needs varied leaving contexts. |
| 5 | Complete tiny interaction | Integration and retention | Sequencing recently practiced lines | Invalid for retention unless delay/interference is stronger. |

Blocking assessment issues:

- Lesson 3 assessment is too narrow.
- Lesson 5 assessment overclaims retention.
- Lesson 1 does not separately assess independent reading after pronunciation is removed.

---

# Examination 4: Support Leakage

| Step | Support | Leak? | Severity | Correction |
|---|---|---|---|---|
| L1 2:50-3:40 | Support-language meaning plus possible first-letter cue | Possible | Major | Specify exact cue. For `Hola`, first-letter cue may reveal too much after repeated exposure. |
| L1 3:40-4:40 | Prompt `привіт` only | No direct leak | Minor | Add a separate independent reading check before typing if goal includes reading. |
| L2 3:00-3:50 | "Привіт, Ано" plus possible known `Hola` reminder | Possible | Major | If the only name is Ana, cue may reveal the whole sentence. Define non-leaking partial support. |
| L2 3:50-4:50 | Situation "greet Ana" | Low | Minor | Valid only if prior model is no longer visible. |
| L3 2:20-3:10 | Question context and support-language meaning; partial answer possible | Possible | Major | Define exact partial support and ensure `Bien` spelling is not leaked. |
| L3 3:10-4:10 | Spanish question remains | No spelling leak for `Bien` | Minor | Could be one-to-one memorized answer; add changed question context or delayed recall. |
| L4 2:10-3:00 | Support-language cue plus partial support | Possible | Major | Define whether partial support is initial letter, syllable, or blank. Avoid spelling leak. |
| L4 3:00-4:00 | Leaving situation only | Low | Minor | Need multiple leaving situations to avoid cue-to-answer shortcut. |
| L5 0:00-0:40 | Known Spanish expressions briefly visible as memory refresh | Possible | Major | If expressions are visible immediately before ordering/filling, later recall may be short-term copying. |
| L5 1:30-2:30 | Surrounding known lines | Possible | Major | Surrounding lines may make missing line obvious by sequence, not recall. |
| L5 2:30-3:40 | Whole situation only | Low direct leak | Minor | Valid only if no line-by-line translation remains. |

---

# Examination 5: Cognitive Load

| Lesson | New vocabulary | New reading rules | New grammar | New communicative functions | New concepts | Load verdict |
|---|---:|---:|---:|---:|---:|---|
| 1 | 1 word | 1 reading fact | 0 | greeting | first Spanish word; silent `h` in this word | Acceptable but fragile: reading plus typing in first lesson needs careful pacing. |
| 2 | 1 name | 0 | 0 explicit | address a person | name as addressee; comma pattern implicitly | Acceptable if punctuation/name use is not assessed harshly. |
| 3 | 2 chunks | 0 explicit | 0 explicit | ask/answer wellbeing | question-answer adjacency pair | High for A0 because two chunks are introduced and one is assessed productively. |
| 4 | 1 phrase | 0 explicit | 0 | farewell vs greeting | situational contrast arrival/leaving | Acceptable. |
| 5 | 0 words | 0 | 0 | complete mini-interaction | sequencing; integration; interference | Acceptable only if not requiring too much typing at once. |

Blocking cognitive-load concern:

Lesson 3 may exceed the strict beginner-scale budget because it teaches a question and
an answer together but only gives one of them full state treatment. It should either
reduce productive demand or split the skill.

---

# Examination 6: Variety Audit

## Mental Operation Classification

| Lesson | Step sequence by mental operation |
|---|---|
| 1 | Attention -> meaning recognition -> reading/matching -> context recognition -> guided recall -> typed recall |
| 2 | Attention -> meaning recognition -> reading/matching -> context recognition -> guided recall -> typed generation |
| 3 | Attention -> meaning recognition -> answer matching -> guided recall -> typed response -> review reading |
| 4 | Attention -> meaning recognition -> contextual discrimination -> guided recall -> typed generation -> mixed discrimination |
| 5 | Situation recognition -> ordering -> cloze recall -> multi-line generation -> contextual discrimination -> confirmation |

Findings:

- Lessons 1 and 2 are nearly identical in mental operation through the first five
  steps. The difference is communicative target, not mental work.
- Lessons 2 and 4 both become "new phrase/name -> recognize context -> guided recall
  -> type phrase."
- Lesson 5 is more varied, but its ordering and fill-missing-line steps can still feel
  like structured practice rather than communication.

Severity:
Major. Variety is improved from a content stack, but the first four lessons still share
the same instructional skeleton.

---

# Examination 7: Lesson Identity

| Lesson | Why it exists | Primary learner experience | What makes it memorable | What would be lost if removed |
|---|---|---|---|---|
| 1 | First complete Spanish word success | Decode and type first word | First independent `Hola` | Foundation for any later greeting |
| 2 | Turn `Hola` toward a person | Addressee-specific greeting | Greeting Ana | Specific-person greeting practice |
| 3 | Respond after greeting | Answer a friendly question | First response to another speaker | Ability to respond, not just initiate |
| 4 | End an encounter | Arrival/leaving contrast | Choosing goodbye at the right moment | Closing an interaction |
| 5 | Integrate pieces | Complete tiny meeting | Whole encounter | Transfer across known expressions |

Identity finding:

Lessons 1, 3, 4, and 5 have clear identities. Lesson 2 is pedagogically plausible but
the weakest identity: it may be perceived as "Lesson 1 plus a name" unless the scenario
strongly dramatizes addressing a person.

---

# Examination 8: Teacher Review

Teacher A, traditional classroom teacher:

- Would likely ask for clearer board sequence and exact teacher prompts.
- Would object that Lesson 3 introduces a question and answer too quickly.
- Would want explicit check that learners can read each new form before typing.

Teacher B, communicative language teaching specialist:

- Would criticize Lessons 1 and 2 for being too form-controlled and not interactive
  enough.
- Would like Lesson 5 but argue that "write three responses" is still not actual
  communication unless there is a simulated partner.
- Would request more meaningful choice earlier.

Teacher C, cognitive psychology specialist:

- Would object that immediate typed recall is overinterpreted as stable learning.
- Would say retention claims require delay or interference that is stronger than a
  same-lesson reordering task.
- Would flag high cue-dependency and short-term memory contamination.

Teacher D, primary-school literacy teacher:

- Would worry that punctuation, capitalization, `Que tal?`, and name reading are
  under-scaffolded.
- Would ask for separate visual discrimination of Spanish forms before production.
- Would object to vague "partial support" because it can accidentally become copying.

Teacher E, adult language instructor:

- Would appreciate the practical sequence but may find Lessons 1-2 slow.
- Would ask for adult-relevant context and agency.
- Would criticize the lack of choice in Lesson 3: only one answer, `Bien.`, may feel
  artificial.

---

# Examination 9: Learner Review

Predicted learner responses:

- Most liked lesson: Lesson 5, because separate pieces become a complete interaction.
- Slowest lesson: Lesson 2, because it may feel like repeating `Hola` with a name.
- Most repetitive exercise: guided recall steps in Lessons 1, 2, and 4 if implemented
  as fill/complete after recognition.
- Strongest success moment: Lesson 1 independent typing of `Hola.` or Lesson 5 complete
  mini-interaction.
- Most confusing moment: Lesson 3, because the learner meets both `Que tal?` and
  `Bien.` and must understand which one is question and which one is answer.

---

# Examination 10: Dictionary Test

| Lesson | Dictionary/phrasebook/reference risk | Explanation |
|---|---|---|
| 1 | Low-medium | One word is taught, but the scenario gives it a use. Risk remains if implemented as form/pronunciation/translation card followed by checks. |
| 2 | Medium | Could become a phrasebook pattern: `Hola, Ana.` = "Hello, Ana." Needs stronger person-addressing situation. |
| 3 | Medium-high | `Que tal?` and `Bien.` can become a phrasebook pair if the exchange is not dramatized. |
| 4 | Medium | Binary phrase contrast is communicative, but can become flashcard-like if arrival/leaving contexts are too thin. |
| 5 | Low | Integration reduces dictionary risk, but cloze sequencing can become workbook-like. |

Dictionary-test verdict:
The scenarios reduce dictionary structure but do not eliminate phrasebook risk,
especially in Lessons 2 and 3.

---

# Examination 11: Implementation Independence

Could two independent authors implement recognizably similar lessons?

Partially, but not safely enough for production.

Ambiguities that would produce divergent implementations:

- Exact distractors for all recognition tasks.
- What counts as "changed context."
- Whether first-letter cues are allowed for short words.
- How much of the previous example remains visible before recall.
- Whether punctuation and capitalization are assessed strictly.
- Whether `Que tal?` must include Spanish opening punctuation and accent.
- Whether Lesson 5 expects typed full lines, selected lines, or ordered responses.
- What makes a "person arrives/leaves" situation sufficiently clear without UI details.
- How remediation is displayed and how many retries occur.

Implementation readiness is blocked until these are specified.

---

# Examination 12: Determinism

Places where creative freedom could materially change lessons:

- Lesson 1: "someone appears" could be a picture, text scenario, or sentence; evidence
  differs.
- Lesson 1: "possibly first-letter cue" changes recall difficulty substantially.
- Lesson 2: "someone else is not the focus" is too vague.
- Lesson 2: "greet Ana" may or may not require comma/punctuation.
- Lesson 3: "miniature exchange" could include unknown speaker labels or extra text.
- Lesson 3: "partial answer support" is unconstrained.
- Lesson 4: "arrival/leaving moments" may be obvious or ambiguous.
- Lesson 5: "known expressions briefly visible as a memory refresh" may destroy
  assessment validity if too close to recall.
- Lesson 5: "complete interaction" may mean typing three lines, choosing from options,
  or filling blanks.

Determinism verdict:
Blocking. The scenario model works, but the five scenarios do not yet constrain
implementation enough.

---

# Examination 13: State Machine Integrity

## Graph

```text
L1:
Not introduced
-> Attends
-> Understands meaning
-> Supported reading
-> Changed-context recognition
-> Supported recall
-> Independent recall

L2:
Independent recall of Hola
-> Attends to Ana/pattern
-> Understands sentence
-> Supported reading
-> Changed-context recognition
-> Supported recall
-> Meaningful use

L3:
Meaningful use of addressed greeting
-> Attends to Que tal
-> Understands Que tal
-> Recognizes Bien as answer
-> Supported recall of Bien
-> Meaningful use
-> Meaningful use

L4:
Known greeting context
-> Attends to Adios
-> Understands Adios
-> Changed-context recognition
-> Supported recall
-> Meaningful use
-> Retention after interference

L5:
Separate meaningful use
-> Changed-context recognition
-> Changed-context recognition
-> Supported recall
-> Meaningful use
-> Retention after interference
-> Retention after interference
```

Integrity findings:

- No direct Not introduced -> Independent recall transition appears.
- Lesson 3 has a missing state path for `Bien.`
- Lesson 5 has repeated same-state transitions without clear progress.
- Lesson 4 and Lesson 5 overclaim retention.
- Lesson 3 and Lesson 5 include teaching/review after claimed meaningful use without
  clearly marking it as intentional review.

Blocking integrity issues:
Lesson 3 missing state path; Lesson 5 retention claim; repeated same-state transitions
without evidence.

---

# Examination 14: Failure Recovery

## Lesson 1

Wrong meaning selected:
Returns to form-meaning pairing. Correct.

Reading rule misunderstood:
Restores `ола`. Correct.

Typing mistake:
Spelling feedback and retry. Correct if feedback is authored.

Correct sound but incorrect spelling:
Handled explicitly. Correct.

Loss of confidence:
Not specified. Defect: affective remediation is missing.

## Lesson 2

Wrong meaning selected:
Not explicitly separated from address-pattern failure. Defect.

Reading misunderstood:
Restores name pronunciation. Partially correct; full sentence reading may need support.

Typing mistake:
Focused feedback and retry. Correct if authored.

Correct sound but incorrect spelling:
Not fully specified for `Hola, Ana.` punctuation/name casing. Defect.

Loss of confidence:
Not specified.

## Lesson 3

Wrong meaning selected:
Returns to `Que tal?` or `Bien.` pairing. Correct in principle.

Reading misunderstood:
Not explicitly specified. Defect.

Typing mistake:
Not separated from answer-choice failure. Defect.

Correct sound but incorrect spelling:
Not specified for `Bien.` Defect.

Loss of confidence:
Not specified.

## Lesson 4

Wrong meaning selected:
Returns to `Adios.` -> meaning. Correct.

Reading misunderstood:
Not explicit; pronunciation restoration implied but not stated in remediation. Defect.

Typing mistake:
Focused feedback and retry. Correct.

Correct sound but incorrect spelling:
Handled in broad terms. Acceptable.

Loss of confidence:
Not specified.

## Lesson 5

Wrong meaning selected:
Not clearly applicable because no new words, but wrong function choice returns to
communicative moments. Acceptable.

Reading misunderstood:
Restores pronunciation for the expression only. Correct.

Typing mistake:
Not specified. Defect.

Correct sound but incorrect spelling:
Not specified. Defect.

Loss of confidence:
Not specified.

Failure-recovery verdict:
Major defects. Remediation targets failed states better than prior designs, but
spelling, punctuation, reading failures for multi-word items, and confidence recovery
are insufficiently specified.

---

# Examination 15: Boredom Risk Analysis

High-risk boredom points:

- L1 0:30-2:00: form/meaning/pronunciation/matching can feel like a flashcard if the
  "first encounter" situation is not vivid.
- L1 2:50-3:40: supported recall after recognition may repeat the same mental action if
  the cue is too strong.
- L2 0:40-2:10: repeats Lesson 1's form/meaning/reading path with a longer string.
- L2 3:00-3:50: completing the same exact greeting may not change context enough.
- L3 4:10-4:50: returning to the full exchange and pointing to the answer changes no
  learner state.
- L4 2:10-3:00: completing `Adios.` after binary recognition may feel mechanical.
- L5 0:40-1:30: ordering known moves could be too easy if all expressions are visible.
- L5 4:40-5:10: final confirmation repeats the prior interaction without a new demand.

---

# Examination 16: Minimal Lesson Test

Potentially removable or reducible steps:

- L1 2:00-2:50: can be merged with meaning recognition unless the changed context is
  made genuinely different.
- L2 1:30-2:10: full-sentence supported reading may be redundant if `Ana` reading is
  already supported and `Hola` is mastered.
- L3 4:10-4:50: likely removable; it repeats the full exchange after the assessment.
- L4 4:00-4:50: should not be called retention; could remain as interference practice
  if renamed and strengthened.
- L5 0:40-1:30: ordering step may be removable if the final task already includes
  sequencing, unless it is made a genuine comprehension bridge.
- L5 4:40-5:10: likely closure/confirmation, not assessment; remove or reduce to one
  closure sentence.

---

# Examination 17: Red Team Review

Can the scenarios still be proved to be:

```text
Vocabulary -> Reading -> Practice
```

in disguise?

Partially, yes.

Evidence:

- Lessons 1, 2, and 4 still follow a repeated mental skeleton: introduce form and
  meaning, read with support, recognize context, produce with support, type.
- The documents avoid the words "Vocabulary", "Reading", and "Practice", but several
  steps can map directly onto those functions unless implementation constraints force
  stronger state transitions.
- Lesson 3 resembles a phrasebook pair: question -> answer -> type answer.
- Lesson 5 is less dictionary-like, but can become a workbook sequence: order lines,
  fill missing line, type lines.

Why they genuinely differ in part:

- Each lesson has a communicative purpose.
- Lesson 4 requires situational discrimination.
- Lesson 5 integrates known material and introduces interference.
- New material budgets are narrow.

Red-team verdict:
The scenarios are not pure content catalogs, but Lessons 1-4 remain vulnerable to
becoming content-category lessons during implementation.

---

# Final Verdict

| Category | Grade | Blocking? |
|---|---|---|
| Learning State Machine | C | Yes |
| Scenario Model | B- | No |
| Cognitive Load | C+ | Yes |
| Variety | C | Yes |
| Assessment | C- | Yes |
| Remediation | C | Yes |
| Motivation | B- | No |
| Determinism | D+ | Yes |
| Beginner Suitability | C+ | Yes |
| Implementation Readiness | D | Yes |

Overall verdict:
FAIL FOR IMPLEMENTATION READINESS.

Implementation of Lessons 1-5 is prohibited until blocking issues are remediated.

---

# Prioritized Remediation List

## P0: Blocking before implementation

1. Split or redesign Lesson 3 so `Que tal?` and `Bien.` each receive adequate state
   treatment, or narrow the lesson outcome to recognition of the question only.

2. Remove retention claims from Lesson 4 and Lesson 5 unless there is real delay or
   stronger interference evidence.

3. Define exact assessment evidence for every lesson, including what proves reading,
   meaning, independent recall, contextual use, and retention.

4. Specify exact support levels for every guided recall step. Remove vague phrases like
   "possibly first-letter cue" and "partial support" unless the exact support is named.

5. Strengthen "changed context" requirements so they are not cosmetic.

6. Define exact distractor standards for recognition tasks.

7. Clarify Spanish orthography expectations for `Que tal?`, punctuation, capitalization,
   and accepted-with-feedback behavior before scenario implementation.

8. Add explicit independent recall states before claiming meaningful contextual use
   where the learner must write the target form.

## P1: Required before content authoring at scale

1. Add affective remediation for loss of confidence.

2. Make Lesson 2 more distinct from Lesson 1 or combine it with a stronger addressing
   task.

3. Reduce Lesson 5's final confirmation to closure unless it adds new evidence.

4. Add implementation-independent prompt constraints: what is visible, what is hidden,
   what is assessed, and what counts as success.

5. Define whether multi-line typed production is appropriate for A0 Lesson 5 or whether
   controlled contextual choice should precede it.

## P2: Quality improvements

1. Add teacher-facing examples of strong and weak changed contexts.

2. Add examples of non-leaking support for very short words.

3. Add a pacing note for adult learners so Lessons 1-2 do not feel slow.

4. Add a variety check that compares mental operations, not lesson titles.

---

# Validation

Required validation after writing this report:

- `git diff --check`
- verify no code modified in this phase;
- verify no JSON modified in this phase;
- verify no assets modified in this phase;
- verify no runtime modified in this phase;
- verify no tests modified in this phase;
- verify only one new report was created for this phase;
- create no commit.
