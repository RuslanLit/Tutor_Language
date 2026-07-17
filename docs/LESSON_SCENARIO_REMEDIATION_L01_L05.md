# LESSON_SCENARIO_REMEDIATION_L01_L05.md

Phase: R2E9C Scenario Remediation and Determinism Hardening

Status: Remediation report for `LESSON_SCENARIO_REVIEW_L01_L05.md`.

Files changed in this phase:

- Modified: `docs/LESSON_SCENARIO_REVIEW_L01_L05.md`
- Created: `docs/LESSON_SCENARIO_REMEDIATION_L01_L05.md`

No lesson JSON, educational content assets, localization assets, runtime code, schemas,
validators, or tests were modified.

---

# Remediation Register

| ID | Lesson | Finding | Severity | Root cause | Required correction | Corrected in section |
|---|---|---|---|---|---|---|
| B01 | 2 | Uses meaningful context without explicit independent evidence for `Hola, Ana.` | Blocking | Final production was under-specified | Define exact hidden information and final no-support production | Lesson 2 Step 6; Lesson 2 Assessment |
| B02 | 3 | `Bien.` skipped required states | Blocking | Two new chunks were introduced in one lesson | Defer `Bien.` to Lesson 4 | Lesson 3 New Knowledge Budget; Lesson 4 full scenario |
| B03 | 3 | Understanding `¿Qué tal?` and producing `Bien.` were conflated | Blocking | Question comprehension and answer production were treated as one skill | Lesson 3 teaches only question comprehension; Lesson 4 teaches answer | Lessons 3-4 |
| B04 | 4 | Immediate contrast was called retention | Blocking | Retention term used without delay | Remove long-term retention claim; use contextual use/brief interference only | Overall Goal; Lesson 4; Cross-Lesson Dependency Table |
| B05 | 5 | Integrated task claimed retention without delayed evidence | Blocking | Same-lesson ordering overclaimed retention | Rename ending state to meaningful use after brief interference | Lesson 5 Ending State; Lesson 5 Assessment |
| B06 | 5 | Separate use -> retention skipped integration evidence | Blocking | Integration path was too compressed | Add situation interpretation, role matching, reconstruction, then production | Lesson 5 Steps 1-4 |
| B07 | All | Assessment could prove short-term memory rather than capability | Blocking | Assessments lacked alternative-explanation controls | Add assessment validity fields for every lesson | Assessment sections, Lessons 1-5 |
| B08 | All | Support levels were vague and could leak answers | Blocking | "Partial support" and "minimal hint" were undefined | Replace with exact visible/hidden information per step | All lesson steps; Operational Support Definitions |
| B09 | All | Implementation not deterministic enough | Blocking | Distractors, cues, and changed contexts were underspecified | Define operational support, distractors, changed context, visible/hidden info | Operational Support Definitions; all steps |
| M01 | 1 | Attention evidence weak | Major | Step only said learner notices target | Add observable identification of focus | Lesson 1 Step 1 |
| M02 | 1 | Meaning recognition depends on unspecified distractors | Major | Distractors not defined | Define plausible greeting-domain distractors | Lesson 1 Step 2 |
| M03 | 1 | Supported decoding could be visual matching | Major | Reading contrast not operational | Add reading options `ола`, `хола`, `гола` | Lesson 1 Step 3 |
| M04 | 1 | Changed context could be cosmetic | Major | Context not exact | Define arrival/leaving contrast and hide pronunciation | Lesson 1 Step 4 |
| M05 | 1 | First-letter cue could leak answer | Major | Cue vague | Remove first-letter cue; use non-leaking situation cue | Lesson 1 Step 5 |
| M06 | 2 | `Ana` reading evidence weak | Major | Name could be label recognition | Add attended-name and decoding steps | Lesson 2 Steps 2 and 4 |
| M07 | 2 | "Someone else not focus" vague | Major | Changed context not operational | Define Situation A/B role contrast | Lesson 2 Step 5 |
| M08 | 2 | Guided recall could be trivial | Major | Support cue too strong | Remove guided recall step; require final situation-only production | Lesson 2 Step 6 |
| M09 | 3 | Distractors unspecified | Major | Recognition evidence weak | Define greeting-domain distractors | Lesson 3 Step 2 |
| M10 | 3 | Final review step had no state movement | Major | Closure repeated content | Remove review-reading step | Lesson 3 scenario |
| M11 | 4 | `Adios` partial support could leak spelling | Major | Farewell scenario removed | Defer goodbye expression outside Lessons 1-5 | State Paths; Cross-Lesson Dependency Table |
| M12 | 5 | Same-state transitions without progress | Major | Ordering/confirmation repeated states | Replace with sequence: interpret -> match roles -> reconstruct -> produce | Lesson 5 Steps 1-4 |
| M13 | All | Failure recovery omitted confidence and specific spelling cases | Major | Remediation paths generic | Add failure-state remediation for required cases in each lesson | Remediation sections, Lessons 1-5 |
| M14 | All | Lessons 1-4 shared same skeleton | Major | Direct presentation dominated | Start Lessons 2-5 with retrieval, incomplete interaction, question retrieval, and situation interpretation | Cognitive-Operation Comparison |
| M15 | All | Dictionary/phrasebook risk remained | Major | New units could still appear as cards | Bind each unit to a communicative state transition and exact hidden support | Revised scenarios and Dictionary Test |

No severity was downgraded to obtain a pass. Some findings were resolved by removing or
deferring material, not by preserving the previous scenario.

---

# Revised State Paths

| Unit | Revised path |
|---|---|
| `Hola.` | Lesson 1: Not introduced -> Attends -> Understands meaning -> Decodes with support -> Recognizes changed context -> Recalls with support -> Recalls independently. Lesson 2 uses it in addressed context. |
| `Ana` | Lesson 2: Not introduced -> Attends -> Understands role -> Decodes with support -> Recognizes in addressed context -> Used in `Hola, Ana.` |
| `Hola, Ana.` | Lesson 2: Combination introduced -> meaning -> supported reading -> changed-context recognition -> independent contextual production. Lesson 5 integrates it. |
| `¿Qué tal?` | Lesson 3: Not introduced -> Attends -> Understands meaning -> Decodes with support -> Recognizes changed context -> Recognizes after brief interference. |
| `Bien.` | Lesson 4: Not introduced -> Attends -> Understands meaning -> Decodes with support -> Recognizes answer function -> Recalls with support -> Uses in meaningful context. |
| Goodbye expression | Deferred. No goodbye expression is introduced or assessed in Lessons 1-5. |
| Polite expression | Deferred. No polite expression is introduced or assessed in Lessons 1-5. |
| Reading/spelling rules | Only local reading supports are taught. Broad punctuation, accent, and spelling rules are deferred or treated through accepted-feedback policy during implementation. |

---

# Corrected Assessment Evidence

| Lesson | Claimed capability | Task | Evidence produced | Alternative explanation controlled |
|---|---|---|---|---|
| 1 | Independently read, understand, and type `Hola.` | Type `Hola.` after one meaning-only interference decision | Correct typed form with target/pronunciation hidden | Controls immediate copying through support removal and brief interference |
| 2 | Independently write `Hola, Ana.` to greet Ana | Type greeting from situation only | Correct addressed greeting with no Spanish support | Controls model copying through role discrimination and hidden target forms |
| 3 | Read/understand `¿Qué tal?` | Identify question meaning after brief known-material interference | Correct discrimination from `Hola, Ana.` without pronunciation/translation | Controls immediate recognition and weak distractors |
| 4 | Answer `¿Qué tal?` with `Bien.` | Type `Bien.` when only the known question is visible | Correct answer with no answer support | Controls answer leakage by hiding translation, pronunciation, first letter, and options |
| 5 | Complete tiny exchange | Type known lines from support-language situation after discrimination task | Correct ordered exchange with all Spanish lines hidden | Controls line-bank copying by removing bank before production |

Open assessment policy needed before implementation:

- Exact accepted-with-feedback treatment for punctuation, capitalization, and Spanish
  question marks/accents.

This is not a scenario blocker for Lesson 1, but it is a production-authoring policy
dependency for later lessons.

---

# Exact Support Definitions Applied

The revised scenario removes vague support language.

Replacements:

- "Partial support" -> exact visible/hidden information per step.
- "Changed context" -> different speaker role, addressee, or communicative moment.
- "Plausible distractor" -> previously taught or greeting-domain expression that is
  semantically wrong in the current situation.
- "Short delay" -> brief interference: one intervening known-material task.
- "Simple prompt" -> exact support-language situation or meaning prompt.
- "Minimal hint" -> non-leaking cue that does not show target letters, pronunciation, or
  model answer.

---

# Cognitive-Operation Sequence

| Lesson | Cognitive operation sequence |
|---|---|
| 1 | observe new form -> choose meaning -> decode with support -> recognize function -> retrieve form -> retrieve after brief interference |
| 2 | retrieve prior word -> identify addressee -> understand addressed action -> decode new name -> discriminate isolated/addressed greeting -> construct addressed greeting |
| 3 | predict next conversational move -> choose question meaning -> decode question -> discriminate question from greeting -> recognize after brief interference |
| 4 | retrieve known question meaning -> attend to answer -> choose answer meaning -> decode answer -> link answer to question -> produce answer -> answer in context |
| 5 | interpret whole situation -> match known lines to roles -> reconstruct sequence from shuffled known lines -> produce full exchange after brief interference |

Template break:

- Lessons 2, 3, 4, and 5 do not begin with direct presentation of a new target form.
- No two lessons share the same full cognitive-operation sequence.
- Lesson 5 adds no new words and therefore cannot be a vocabulary-introduction lesson.

---

# Cross-Lesson Dependency Table

| Lesson | Assumes from earlier lessons | Establishes for later lessons | Deferred capability |
|---|---|---|---|
| 1 | None | Independent recall of `Hola.` | Long-term retention |
| 2 | Independent recall of `Hola.` | Contextual use of `Hola, Ana.` | Greeting other names; strict punctuation |
| 3 | Contextual use of `Hola, Ana.` | Independent recognition/comprehension of `¿Qué tal?` | Producing the question; answering |
| 4 | Recognition/comprehension of `¿Qué tal?` | Independent answer `Bien.` | Alternate answers; asking back |
| 5 | Separate use/recognition of `Hola, Ana.`, `¿Qué tal?`, `Bien.` | Integrated use after brief interference | Long-term retention; farewell; open conversation |

Continuity result:

- No forward reference remains.
- No secondary chunk is silently treated as known.
- No contextual-only punctuation or spelling rule is assessed as a primary outcome.
- No false long-term retention claim remains.

---

# Repeated Adversarial Examination

## Learner-State Compliance

PASS for design layer.

Evidence:
Every scenario step now names current state, target state, visible/hidden information,
evidence, failure interpretation, and remediation. `Bien.` has its own Lesson 4 state
path. `¿Qué tal?` is no longer expected to be answered in the same lesson where it is
introduced.

Residual risk:
Implementation must preserve the exact hidden-information conditions.

## Hidden State Skips

PASS for revised scenarios.

Evidence:
No new unit moves from Not introduced to independent recall. Lesson 3 no longer skips
`Bien.`. Lesson 5 does not introduce new language.

Residual risk:
Punctuation/accent handling must not become an unintroduced assessed skill.

## Assessment Validity

PASS WITH IMPLEMENTATION POLICY DEPENDENCY.

Evidence:
Each assessment now states claimed capability, task, evidence, alternative explanation,
control, and minimum passing evidence.

Dependency:
Accepted-with-feedback policy for punctuation, capitalization, Spanish question marks,
and accents must be defined before production implementation of Lessons 2-5.

## Support Leakage

PASS for design layer.

Evidence:
Every step states exact visible and hidden information. First-letter cues were removed.
Pronunciation support is hidden during independent recall. Line banks are removed before
Lesson 5 production.

Residual risk:
Screens must not display prior model answers adjacent to recall prompts.

## Cognitive Load

PASS.

Evidence:
Lesson 3 now teaches only `¿Qué tal?`. Lesson 4 teaches only `Bien.`. Lesson 5 adds no
new Spanish words. Goodbye and polite expressions are deferred.

## Cognitive-Operation Variety

PASS.

Evidence:
The revised cognitive-operation table shows different openings and primary operations.
Four lessons begin without direct presentation.

## Lesson Identity

PASS.

Evidence:
Each lesson includes a unique identity sentence:

- first independent word recall;
- transforming a known greeting toward a person;
- understanding a new question without answering it;
- turning a known question into an answer;
- coordinating known expressions into one exchange.

## Determinism

PASS WITH NARROW IMPLEMENTATION CAUTION.

Evidence:
Visible and hidden information are specified at every step. Distractor types and changed
context are operationally defined.

Caution:
Exact accepted-answer policy remains outside the scenario layer.

## Failure Recovery

PASS.

Evidence:
Each lesson now defines remediation for wrong meaning, reading failure, spelling issue,
copying instead of recall, expression confusion, and contextually inappropriate answer
where applicable. Remediation targets the failed state and does not restart the whole
lesson.

## Boredom Risk

PASS WITH WATCH ITEMS.

Evidence:
Non-essential review steps were removed. Lesson 3 and Lesson 5 no longer contain
same-state closure assessments. Lessons differ in opening and cognitive operation.

Watch items:
Lesson 1 remains necessarily simple and can feel card-like if the first encounter is
implemented flatly. Lesson 4 can feel narrow if `Bien.` is not framed as a response to
Ana.

## Minimal Lesson Test

PASS.

Evidence:
Each remaining step is necessary for a state transition:

- attention;
- meaning;
- supported decoding;
- changed-context recognition;
- supported recall when required;
- independent recall/use when required.

Removed/replaced:

- Lesson 3 final repeated exchange step;
- Lesson 4 false retention step;
- Lesson 5 circular confirmation step;
- vague guided recall steps with leaking partial support.

## Dictionary Test

PASS WITH LOW RISK FOR LESSON 1.

Evidence:
No lesson starts from a vocabulary list. Lesson 3 is comprehension-only. Lesson 5 has no
new words and is integration-only.

Residual risk:
Lesson 1 necessarily teaches a single word and must preserve the encounter framing.

---

# Findings Remediated

Remediated blockers:

- `Bien.` state skip.
- Lesson 3 overloading.
- False retention claims.
- Vague support and leakage.
- Weak assessment evidence.
- Hidden repeated template.
- Under-specified remediation.
- Implementation determinism gaps at scenario level.

Remediated major issues:

- Weak distractors.
- Cosmetic changed context.
- Reading evidence via simple visual matching.
- Same-state repeated closure.
- Dictionary/phrasebook risk in Lessons 2-5.

---

# Findings Still Open

Open non-scenario dependencies:

1. Accepted-with-feedback policy for punctuation, capitalization, Spanish opening
   question mark, and accent in `¿Qué tal?`.

2. Device/runtime presentation must ensure hidden information is actually hidden near
   recall prompts.

3. Long-term retention remains deferred to a later review lesson/session and is not
   claimed by Lessons 1-5.

4. Farewell and polite expressions are intentionally deferred and must not be assumed
   known after Lesson 5.

---

# Final Verdict

READY FOR LESSON 1 IMPLEMENTATION ONLY

Reason:
The revised five-lesson scenario layer is substantially stronger and state-complete, but
the narrowest defensible production move is to implement Lesson 1 first and validate the
state-machine behavior, support hiding, and typed recall experience on the real runtime
before implementing Lessons 2-5. Later lessons depend on presentation details for
multi-expression prompts, punctuation policy, and integrated exchange production.

Implementation of Lessons 2-5 should wait until Lesson 1 proves that the new scenario
format can be faithfully represented without support leakage or UI-induced copying.

Do not begin implementation from this report without human approval.

---

# Validation Plan

Required validation after this report:

- `git diff --check`
- `git status --short`
- verify this phase changed only:
  - `docs/LESSON_SCENARIO_REVIEW_L01_L05.md`
  - `docs/LESSON_SCENARIO_REMEDIATION_L01_L05.md`
- do not run Flutter tests because no code or assets changed;
- create no commit.
