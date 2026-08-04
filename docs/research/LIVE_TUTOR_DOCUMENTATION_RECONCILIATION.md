# Live Tutor Evidence — Documentation Reconciliation

## 1. Purpose

This report reconciles the observational evidence in
`LIVE_TUTOR_LESSON_CORPUS_ANALYSIS.md` with the current Tutor Language
pedagogical and authoring documentation. It is advisory research. It does not
change the project's source of truth and does not authorize changes to
application code, curriculum data, lesson JSON, tests, or canonical Lessons
1–5.

The central question is not whether the live tutor materials look useful. It is
which observations are portable to a deterministic offline app, which rules
are already present, and which small wording changes would improve future
authoring without overfitting to classroom worksheets.

## 2. Inputs

Primary evidence:

- `docs/research/LIVE_TUTOR_LESSON_CORPUS_ANALYSIS.md`.
- The 30 PDFs in `lesson_exersize/`, as summarized by that report.

Current authoritative documentation reviewed:

- `docs/EDUCATIONAL_PRINCIPLES.md` — foundational design principles.
- `docs/AUTHORING_STYLE_GUIDE.md` — learner-facing style and cognitive-load
  guidance.
- `docs/CONTENT_AUTHORING_GUIDE.md` — reusable content and exercise-authoring
  standard.
- `docs/COURSE_AUTHORING_GUIDE.md` — course, module, lesson, progression and
  review authoring.
- `docs/LEARNING_MODEL.md` — learning-state, session and engine contract.
- `docs/CONTENT_MODEL.md` — content entities and their boundaries.
- `docs/CURRICULUM_SPEC.md` — static curriculum and LessonDefinition contract.
- `docs/CONTENT_REVIEW_PROTOCOL.md` and
  `docs/CONTENT_REVIEW_CHECKLIST.md` — review and release gates.
- `docs/LESSON_AUTHORING_ENTRYPOINT.md` — authoritative reading order and
  authoring workflow.
- `docs/PEDAGOGICAL_SCENARIO_MODEL.md` — scenario construction and assessment
  contract.
- `docs/LEARNING_STATE_MACHINE.md` — learner states, support fading, productive
  repetition and remediation.

Relevant research/audit material was inspected for context, especially
`docs/research/CANONICAL_LESSONS_1_5_PEDAGOGICAL_AUDIT.md`,
`CANONICAL_LESSON_1_DESIGN.md`, and `CANONICAL_LESSON_1_REVIEW.md`. These files
are uncommitted worktree research, not committed normative policy.

## 3. Evidence limitations

The empirical report's verdict is **EMPIRICAL EVIDENCE USEFUL WITH
LIMITATIONS**. It inspected 30/30 PDFs, 130 pages, 28 lesson-bearing packets
and two support-only materials. The corpus is a working-material collection,
not a verified chronological course and not a controlled learning study.

It provides useful evidence about recurring authoring practices: personal
activation, controlled practice, contextual use, support fading, topic chains
and common defects. It does not provide learner outcome data, delayed recall
results, reliable elapsed-time measurements, teacher/learner turn counts, or a
validated communication-time denominator. Repeated topics may represent
sequence, different learners, revision, or unrelated packets.

The portable conclusion is therefore about design opportunities and review
risks, not efficacy. In particular:

- communicative expansion is supported in selected chains but unevenly across
  the corpus;
- retrieval evidence is strongest for immediate and adjacent reuse, not spaced
  retention;
- 70/30 and 80/20 ratios are not empirically validated;
- visible word lists are not evidence that every listed item should become a
  productive A0 target;
- live-teacher success cannot be treated as proof that a worksheet is
  self-sufficient.

## 4. Documentation authority map

| Responsibility | Authoritative owner | Role and boundary |
|---|---|---|
| Educational objective and learner independence | `EDUCATIONAL_PRINCIPLES.md` | Foundational principles; does not define JSON fields or a fixed lesson template. |
| Learner-facing clarity, tone and cognitive load in prose | `AUTHORING_STYLE_GUIDE.md` | Authoring standard for language and examples. |
| Reusable vocabulary, grammar, dialogue, reading and exercise rules | `CONTENT_AUTHORING_GUIDE.md` | Content-authoring owner, including current beginner vocabulary recommendation and recognition-to-retrieval guidance. |
| Course/module/lesson progression and review lessons | `COURSE_AUTHORING_GUIDE.md` | Curriculum authoring procedure; it does not assign learner-specific mastery or scheduling. |
| Static LessonDefinition shape and objective/prerequisite metadata | `CURRICULUM_SPEC.md` | Structural curriculum contract; it does not perform evaluation or learner progress. |
| Content entity boundaries and references | `CONTENT_MODEL.md` | Data model; it must not absorb learner state or adaptive policy. |
| Learner states, support fading and remediation paths | `LEARNING_STATE_MACHINE.md` | State-machine contract; strongest owner for recognition, recall, application and retention distinctions. |
| Scenario-first lesson construction | `PEDAGOGICAL_SCENARIO_MODEL.md` | Lesson-authoring procedure; requires starting state, one measurable outcome, support plan and evidence. |
| Authoring entry point and document precedence | `LESSON_AUTHORING_ENTRYPOINT.md` | Workflow router, not a competing pedagogical standard. |
| Review gates and deterministic answerability | `CONTENT_REVIEW_PROTOCOL.md`, `CONTENT_REVIEW_CHECKLIST.md` | QA/release standard; rules here should be checkable. |
| Learner-specific retry, eligibility and future review scheduling | `LEARNING_MODEL.md` and runtime architecture | Learning-engine responsibility; curriculum provides authored opportunities and references. |
| Corpus observations and proposals | `docs/research/` | Research only; never canonical until deliberately adopted into an authoritative owner. |

The most important ownership rule is the curriculum/engine boundary: authors
define capability, prerequisites, content references, activity purpose and
available review opportunities; the engine interprets learner state, retry,
eligibility, remediation selection and any future learner-specific review
priority.

## 5. HEAD vs worktree policy differences

The repository was already substantially dirty before this task. The comparison
was made without restoring or modifying any existing file.

### Committed HEAD

In `HEAD`:

- `EDUCATIONAL_PRINCIPLES.md` contains learner independence, active retrieval,
  productive language, feedback and error principles, but no named
  “communicative expansion” principle.
- No normative `70/30`, `80/20`, `20/80`, or equivalent percentage rule was
  found in the reviewed committed documentation.
- `CONTENT_AUTHORING_GUIDE.md` recommends 5–10 new words per beginner lesson,
  preferably 6–8 for A0, and says review vocabulary does not count.
- `COURSE_AUTHORING_GUIDE.md` recommends review lessons every 4–6 lessons,
  while `LEARNING_MODEL.md` and architecture documentation keep advanced
  spaced-repetition scheduling future/engine work.
- The scenario and state documents already require a measurable outcome,
  necessary learner-state transitions, support fading, meaningful use,
  deterministic evidence and remediation.

### Current worktree

The current worktree adds an uncommitted section to
`docs/EDUCATIONAL_PRINCIPLES.md` titled “Principle 2a — Communicative
Expansion.” It says that old language should gain new communicative functions
and asks each later lesson to identify an earlier capability that is actively
retrieved and used for new work. This is a plausible candidate amendment, but
it is not a long-established committed rule and is not treated as one here.

The worktree also contains uncommitted canonical Lessons 1–5, audits, research
reports and many content/application changes. Those materials are useful
context, but they do not override `HEAD` or the active normative documents.
Several older research and pedagogical files are deleted in the worktree; their
former wording is historical evidence, not current authority. The new corpus
analysis is itself uncommitted research.

No reviewed committed document contains the numeric ratios. The only current
worktree occurrences are in the empirical report's analysis of those ratios.

## 6. Empirical findings vs current rules

| Finding | Classification | Reconciliation |
|---|---|---|
| Family → Home/Family → Room/Prepositions → Demonstratives → Talents is the strongest supported chain | RESEARCH-ONLY OBSERVATION | Useful as evidence of one topical chain; not a language-independent curriculum order and not enough to determine Lessons 6–10. |
| Personal activation followed by supported production and meaningful use recurs | CONFIRMS — NO DOC CHANGE NEEDED | Scenario-first authoring, meaningful context, support plans and evidence already express the portable part. |
| Communicative expansion occurs in some chains but not all packets | EXTENDS EXISTING RULE | Reuse and meaningful application exist already; a concise explicit criterion would make the distinction from repetition reviewable. See A1. |
| Corpus retrieval is mostly adjacent, recognition or cued recall | CONFIRMS — WORDING COULD BE STRENGTHENED | Existing active-retrieval and state-machine rules fit; evidence supports avoiding claims of spaced retention. No new schedule is justified. |
| Visible lists often contain 8–15 words plus bonus/incidental material | REVEALS AMBIGUITY | The 5–10 rule does not say clearly enough whether it governs productive targets or all displayed lexicon. See A3. |
| Teacher translation, reformulation, omission and reordering repair worksheets | REVEALS MISSING RULE | Deterministic lessons need authored support and answerability; existing documents imply this but a review check can make it explicit. See A2. |
| Activity changes commonly occur every 5–15 minutes | USEFUL AUTHORING HEURISTIC ONLY | Existing variation guidance is sufficient; timing would overfit classroom pacing and encourage superficial switching. |
| Personal questions are common | CONFIRMS — NO DOC CHANGE NEEDED | Controlled, bounded tasks are already supported by deterministic evaluation and scenario contracts. Open conversation is not portable as a default. |
| Full packets are often 55–70 minutes | NOT PORTABLE TO TUTOR LANGUAGE | `CURRICULUM_SPEC.md` already recommends 10–20-minute LessonDefinitions; the app boundary is explicit. |
| Topic labels recur across packets | CONFIRMS — NO DOC CHANGE NEEDED | Curriculum docs distinguish module/theme grouping from lesson objectives, and scenario docs reject topic labels as outcomes. |
| Support generally reduces toward production but inconsistently | CONFIRMS — WORDING COULD BE STRENGTHENED | The state machine already mandates state transitions and reduced support where assessed. No fixed choreography should be added. |
| One grammar focus is common | CONFIRMS — NO DOC CHANGE NEEDED | Current one-concept-at-a-time and single-objective guidance is stricter and safer. |

## 7. Communicative expansion

Communicative expansion is meaningfully distinct from repetition and retrieval:

- repetition repeats a form or task;
- retrieval recalls previously learned language;
- communicative expansion reuses prior language to perform an additional
  communicative function, combination, role, context or interaction.

The corpus provides moderate-to-strong support in selected room,
city, food and hotel chains, but the same corpus also contains packets that stop
at matching, gap-fill or scripted repetition. Therefore the evidence supports
the design principle as a quality criterion, not a claim that every tutor lesson
achieved it or that it improves retention by itself.

The concept is absent from committed `EDUCATIONAL_PRINCIPLES.md` and present
only in the dirty worktree addition and research files. It belongs primarily in
the foundational principles as a short authoring consequence, with review
operationalization in the scenario/review process if needed. It should not get
its own standard document, and it should not require an artificial connection
between every pair of lessons. Recommended decision: **ADOPT as a targeted
normative clarification, subject to controlled review and later application**.

## 8. Cumulative reuse vs learner-specific spaced review

Lesson-level cumulative reuse is authored curriculum behavior. It includes old
language reappearing, supporting a new task, being recombined in a dialogue, or
being used with reduced support. It can be represented deterministically in a
LessonDefinition and reviewed against a lesson objective.

Learner-specific spaced retrieval is an engine behavior. It includes which weak
competency returns, when it returns, the spacing interval, mastery/decay
interpretation and adaptive prioritization. The current architecture explicitly
keeps advanced spaced repetition and adaptive scheduling out of static lesson
content.

The corpus supports the first responsibility and does not establish the second.
The `COURSE_AUTHORING_GUIDE.md` recommendation of a review lesson every 4–6
lessons is a curriculum-level review cadence, not proof that the engine provides
individualized spaced repetition. This is not a contradiction once the two
meanings are named. The current documentation is **already sufficient**; no
amendment should hard-code a schedule into LessonDefinitions.

## 9. 70/30 and 80/20 reconciliation

No reviewed committed normative document contains 70/30 or 80/20. The ratios
occur in the empirical report only, where they are correctly classified as
unvalidated heuristics because the PDFs do not provide a defensible denominator
for minutes, turns or communicative work.

Recommendation: **do not adopt them as invariants, pass/fail quotas or ordinary
LessonDefinition fields**. They may remain informal research heuristics in
research notes, but no amendment is needed. The qualitative rule already in
the project is stronger and portable: one primary objective, controlled new
load, substantial reuse where useful, learner retrieval and meaningful use,
with bounded explanation and support.

## 10. Productive vs receptive lexical load

The corpus visibly lists more lexical material than a strict A0 app lesson can
make productive. Some items are target words, while others are translations,
examples, reading vocabulary, bonus words, idioms, role vocabulary or incidental
input. A visible occurrence is not evidence that the learner should retrieve,
type or be assessed on it.

`CONTENT_AUTHORING_GUIDE.md` already limits beginner new vocabulary to 5–10,
preferably 6–8 for A0, and separately says reading should primarily use known
vocabulary with limited unknown material. It does not clearly name the
distinction between productive target lexicon, recognition lexicon and
incidental input. This is a genuine authoring ambiguity, not evidence that the
limit should be relaxed.

Recommendation: retain the existing productive-load limit and clarify the
categories in the content-authoring owner. Do not add a schema field or require
every incidental item to be catalogued as productive. Proposed A3 would state
that the numeric beginner limit applies to new productive targets; contextual
items must be intentional, limited, supported and not assessed as productive
unless promoted explicitly.

## 11. Scaffolding and teacher-independent lesson completeness

The empirical gradient is portable in principle:

```text
meaning/context → recognition → controlled use → guided production →
independent production
```

It is not a mandatory screen sequence. `PEDAGOGICAL_SCENARIO_MODEL.md` already
requires a support plan, observable evidence, and progression through necessary
states; `LEARNING_STATE_MACHINE.md` defines support fading and remediation; the
review checklist checks that material is taught before use and that retrieval is
fair.

The missing emphasis is operational: a live worksheet may depend on a teacher
to translate, rephrase, omit, correct or reorder. An offline lesson must encode
the support, context, accepted answer, feedback and remediation needed for its
claimed outcome, or explicitly mark an open response as diagnostic rather than
mastery evidence. This is best added as a review criterion, not as a new named
standard or a fixed template. Proposed A2 addresses this gap.

## 12. Activity rhythm

Frequent changes are observed, but their pedagogical value comes from changing
the mental operation, context, retrieval demand or support level—not from
changing UI components for novelty. `PEDAGOGICAL_SCENARIO_MODEL.md` already
requires variation in task type, context and retrieval demand and rejects
redundant screens. The corpus confirms that guidance and does not warrant a
timer or a minimum number of activity modes. **Current documentation is already
sufficient.**

## 13. Personalization

Personal warm-ups and prompts are portable only when the response mode is
bounded: a choice, short authored response, controlled role, or deterministic
competency task. Free answers that require a teacher to interpret meaning,
correct language or keep the conversation moving are not equivalent to
controlled personalization.

The scenario model's meaningful-context requirements, the exercise answerability
rules and the engine's deterministic boundary already support this distinction.
The corpus does not justify adding arbitrary learner-profile questions or
semantic evaluation. **Current documentation is sufficient**, although future
authoring reviews should continue to record whether personalization is assessed,
diagnostic, or merely motivational.

## 14. Classroom lesson vs app lesson

The 55–70-minute corpus packets combine plan, worksheet, teacher talk, pair work,
homework and often a quiz. They are not one-to-one templates for an app lesson.
`CURRICULUM_SPEC.md` recommends a 10–20-minute LessonDefinition and
`CONTENT_REVIEW_CHECKLIST.md` requires workload to fit expected duration.
`COURSE_AUTHORING_GUIDE.md` separates static LessonDefinitions from runtime
session behavior. **No change is needed.** Future authors should preserve
objective and state progression while splitting longer source arcs into
resumable app-sized units where appropriate.

## 15. Topic context vs communicative objective

Current documentation is clear enough. `CURRICULUM_SPEC.md` uses modules to
group lessons around themes, while LessonDefinitions carry objectives;
`PEDAGOGICAL_SCENARIO_MODEL.md` requires one measurable outcome and explicitly
rejects “Greetings topic” or “Module 1 content” as an outcome. The correct model
is already present: topic/context supplies a meaningful situation; the
communicative objective states what the learner can do; vocabulary and grammar
support that capability. **No change is needed.**

## 16. Existing documentation contradictions

These are existing tensions, not changes made by this task.

| Rank | Tension | Assessment |
|---|---|---|
| MAJOR | `CONTENT_AUTHORING_GUIDE.md` gives a numeric 5–10 beginner vocabulary recommendation, while other active documents use qualitative “small,” “limited,” or “strictest beginner-scale budget” language. | Not logically contradictory, but the denominator/productive-vs-contextual scope is ambiguous. Address via A3. |
| MAJOR | `COURSE_AUTHORING_GUIDE.md` recommends review lessons every 4–6 lessons, while the learning model says advanced spaced repetition/adaptive scheduling is future work. | Different levels of responsibility, but easy to misread as an engine spacing guarantee. Clarify during a later controlled documentation pass if needed; do not change architecture here. |
| MINOR | The worktree's new “Principle 2a” is normative-sounding but uncommitted, while current committed principles do not name communicative expansion. | State mismatch, not an internal HEAD contradiction. A1 is the controlled adoption proposal. |
| MINOR | Current scenario documents describe a progression and examples that can look like a template when read beside flexible course guidance. | The scenario document explicitly says the progression is not a mandatory UI template. Wording is adequate. |
| WORDING ONLY | `CURRICULUM_SPEC.md` permits multiple objectives but says one should be primary; scenario documentation requires a single measurable outcome. | Compatible prioritization, not a conflict. Future review can align terminology if desired. |

No evidence was found of a committed ratio rule, a curriculum-owned
learner-specific spaced schedule, or a contradiction between topic grouping and
communicative outcomes.

## 17. Amendment decision matrix

| Candidate | Empirical support | Already covered? | Conflict? | Normative value | Decision | Confidence |
|---|---|---|---|---|---|---|
| Communicative expansion | Moderate/strong in selected chains; uneven overall | Partly: reuse, meaningful context and application | Worktree-only wording is not HEAD | High if phrased as a criterion, not quota | CHANGE REQUIRED — propose A1 | High |
| Lesson-level cumulative reuse | Strong local evidence | Yes, through reuse, prerequisites, scenarios and review activities | None material | Medium; existing rules already operational | CURRENT DOCUMENTATION ALREADY SUFFICIENT | High |
| Learner-specific spaced retrieval | No delayed learner data | Yes, engine boundary and future-work notes | Review cadence can be misread | High architectural importance, no new rule needed | CURRENT DOCUMENTATION ALREADY SUFFICIENT | High |
| 70/30 | Not measurable from corpus | No normative rule exists | None | Low; false precision risk | RESEARCH-ONLY HEURISTIC; do not adopt | High |
| 80/20 | Not measurable from corpus | No normative rule exists | None | Low; false precision risk | RESEARCH-ONLY HEURISTIC; do not adopt | High |
| Productive vocabulary limits | Corpus lists are larger; no learning outcome evidence | Limit exists, category distinction does not | Scope/denominator ambiguity | High for A0 authoring and review | CHANGE REQUIRED — propose A3 | Medium |
| Teacher-independent scaffolding | Strong evidence of teacher compensation and source defects | Mostly covered, but not as a direct release check | Live-classroom assumptions can leak into app content | High | CHANGE REQUIRED — propose A2 | High |
| Activity rhythm | Recurrent mode changes, no efficacy evidence | Yes: meaningful variation and anti-redundancy | None | Low/medium; timer would overconstrain | CURRENT DOCUMENTATION ALREADY SUFFICIENT | High |
| Controlled personalization | Common bounded prompts; open discussion is teacher-mediated | Sufficiently covered by context, deterministic evaluation and role constraints | Open-ended conversation is not portable | Medium | CURRENT DOCUMENTATION ALREADY SUFFICIENT | Medium |
| Classroom/app lesson density | 55–70-minute packets observed | Yes: 10–20-minute LessonDefinition and workload review | Importing packet density would conflict | High boundary value, no amendment needed | CURRENT DOCUMENTATION ALREADY SUFFICIENT | High |

## 18. Exact proposed amendments

These are proposals only. They were not applied.

### Amendment A1 — Name communicative expansion as an authoring criterion

**Target document:** `docs/EDUCATIONAL_PRINCIPLES.md`
**Target section:** After “Principle 2 — Active Retrieval,” before “Principle 3
— Productive Language.”

**Current text/rule:** `HEAD` defines active retrieval and says recognition
should normally be followed by stronger retrieval. It does not distinguish
retrieval from using prior language for a new communicative function. The
worktree currently contains an uncommitted “Principle 2a” candidate.

**Problem:** Authors can satisfy “review” by repeating a phrase or showing it
again, without stating what the learner can newly accomplish with it. The live
corpus supports the distinction unevenly, so a rigid per-lesson quota would be
too strong.

**Empirical evidence:** The report identifies communicative expansion in room,
city, food and hotel chains, but also finds packets limited to matching,
gap-fill or scripted repetition.

**Architectural/pedagogical rationale:** The principle is language-independent,
compatible with deterministic content, and reviewable at scenario level. It
supports active retrieval without pretending to implement spaced repetition or
requiring artificial links in every lesson.

**Proposed replacement/insertion:**

```text
# Principle 2a — Communicative Expansion

When previously learned language is reused, authors should prefer opportunities
for it to perform an additional communicative function, appear in a new context
or combination, or support a new role or interaction. This is communicative
expansion; it is more than displaying or repeating the same phrase.

Each later lesson should identify a meaningful reuse opportunity when the
objective permits it. The opportunity may be retrieval, recombination,
transfer, reduced support, or controlled application. Do not force an artificial
link when it would overload the lesson or distract from its primary objective.
```

**Impact:** Makes a useful distinction explicit and gives reviewers a question
they can inspect in the scenario.
**Risk:** Authors may invent weak “new functions” merely to satisfy the wording.
**Confidence:** HIGH.

### Amendment A2 — Add a teacher-independent completeness review gate

**Target document:** `docs/CONTENT_REVIEW_CHECKLIST.md`
**Target section:** “Scope” or “Pedagogical Sequence,” alongside the existing
checks for prerequisites, workload, teaching before testing and deterministic
retrieval.

**Current text/rule:** The checklist verifies objective, duration, level,
teaching before testing, introduction before use, support of the objective and
deterministic validation, but does not directly ask whether a teacher would
have to repair a missing prerequisite or interpret an open response for the
lesson to succeed.

**Problem:** Live worksheets often rely on teacher translation, reformulation,
selective omission, correction or reordering. An app lesson can appear complete
on paper while remaining unanswerable without invisible intervention.

**Empirical evidence:** The corpus report explicitly records teacher compensation,
hidden burden, ambiguous prompts, answer leakage and source errors.

**Architectural/pedagogical rationale:** An offline deterministic lesson must
encode its learner-facing context, supports, answer mode, accepted variants,
feedback and remediation, or clearly mark an open response as diagnostic. This
belongs in QA, not as a new content type or a mandatory choreography.

**Proposed insertion:**

```text
- [ ] The lesson is teacher-independent for its claimed outcome: no step relies
      on an unstated teacher translation, reformulation, prerequisite repair,
      answer interpretation or activity reordering.
- [ ] Any open-ended response that cannot be evaluated deterministically is
      explicitly marked diagnostic or motivational and is not the sole evidence
      of mastery.
- [ ] Required context, support, accepted answers, feedback and remediation are
      authored wherever the learner needs them to complete the intended path.
```

**Impact:** Converts a strong architecture boundary into a practical release
check and protects future lessons from importing classroom assumptions.
**Risk:** “Teacher-independent” could be interpreted as banning optional
  teacher use; the text limits the requirement to the lesson's claimed outcome.
**Confidence:** HIGH.

### Amendment A3 — Distinguish productive targets from contextual lexicon

**Target document:** `docs/CONTENT_AUTHORING_GUIDE.md`
**Target section:** “Vocabulary Limits,” immediately after the current 5–10
new-word recommendation.

**Current text/rule:** Generation 1 recommends 5–10 new words per beginner
lesson, preferably 6–8 for A0, and says review vocabulary does not count. The
document separately permits limited unknown vocabulary in readings but does not
define the denominator across presentation, recognition and production.

**Problem:** A visible tutor word list can contain productive targets,
recognition-only material, incidental reading input and bonus vocabulary. If all
visible items count equally, authors may either overload the productive target
or incorrectly treat normal contextual input as a taught target.

**Empirical evidence:** Corpus packets commonly list roughly 8–15 target words
plus bonus words, translations, pronunciation spellings, adjectives, idioms and
scenario vocabulary. The report recommends stricter active vocabulary for an
A0 app, but does not validate a larger load.

**Architectural/pedagogical rationale:** Preserves the existing low-load rule,
matches the content model's distinction between authored knowledge and lesson
references, and remains reviewable without requiring a new schema field.

**Proposed insertion:**

```text
The beginner vocabulary limit applies to new productive target items: forms the
lesson expects the learner to retrieve, type, say, construct or use as evidence
of the primary outcome. Distinguish these from recognition items and incidental
contextual input used to understand a dialogue or reading.

Contextual items do not automatically become productive targets, but they must be
intentional, limited, level-appropriate and supported by context or translation.
Do not assess a contextual item as productive unless it has been explicitly
promoted, taught and included in the lesson's target scope. A large visible list
does not justify increasing the productive beginner budget.
```

**Impact:** Makes the existing 5–10 rule usable in review and prevents corpus
word-list density from being imported into A0 authoring.
**Risk:** Authors may use “incidental” to hide excessive unexplained burden;
the existing limited-unknown and review checks must continue to apply.
**Confidence:** MEDIUM.

## 19. Rules explicitly NOT recommended

The following attractive corpus patterns should not become Tutor Language rules:

- every lesson begins with five warm-up questions;
- every lesson contains a vocabulary list or exactly one grammar block;
- every lesson lasts 55–70 minutes or exactly 60 minutes;
- every lesson must use a fixed sequence of vocabulary → grammar → reading →
  speaking;
- every lesson must review only the immediately previous lesson;
- a repeated topic proves chronological sequence or spaced retention;
- every visible vocabulary item becomes productive;
- English tutor-material order determines Spanish curriculum order;
- every lesson must contain open discussion, pair work, role-play or homework;
- 70/30 or 80/20 is a pass/fail composition quota;
- the engine should generate, interpret or repair unrestricted conversation;
- a human teacher's live translation, correction or emotional support may remain
  implicit in an app lesson;
- repeated screens count as communicative expansion merely because they contain
  an old phrase.

These are rejected because they are classroom-specific, insufficiently measured,
not deterministic, or already contradicted by the scenario-first architecture.

## 20. Implications for Lessons 6–10

No Lessons 6–10 were designed here. No vocabulary, grammar, sequence or JSON is
proposed.

Currently authoritative principles for a future authoring task are:

- one primary, measurable communicative objective;
- explicit starting capability and prerequisites;
- small, controlled beginner load and gradual difficulty;
- recognition → guided recall → independent recall/application when required;
- support fading and state-specific remediation;
- meaningful context and deterministic evidence;
- teacher-independent answerability for the claimed outcome;
- curriculum-authored opportunities for reuse, with learner-specific review
  decisions left to the engine;
- app-sized LessonDefinitions rather than classroom packet duration.

Proposed but not yet adopted principles are A1's explicit communicative-
expansion criterion, A2's checklist gate and A3's productive/contextual lexical
distinction. Future tasks must not treat these proposal texts as canonical until
they are separately approved and applied.

## 21. Recommended next documentation phase

Conduct a controlled documentation pass limited to the three proposed owners:

1. decide whether to adopt A1 in `EDUCATIONAL_PRINCIPLES.md`;
2. decide whether to add A2 to the review checklist;
3. decide whether A3 is sufficiently clear without schema changes;
4. if adopted, update the corresponding cross-references and review examples;
5. separately clarify the wording around curriculum review cadence versus
   learner-specific engine scheduling only if maintainers observe continued
   misreading.

Do not create separate standards for communicative expansion, retrieval or live
teacher compensation. Do not apply proposals in the same task as this report.
