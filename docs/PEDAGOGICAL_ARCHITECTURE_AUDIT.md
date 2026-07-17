# Pedagogical Architecture Audit

Phase: R2E8 Documentation Pedagogical Audit

Status: Documentation audit only.

This audit reviews the educational documentation as an instructional designer, not as
an implementer. It assumes that current lesson quality is unacceptable and asks why the
documentation allowed formally valid but repetitive, dictionary-like beginner lessons.

No lesson content, application code, schemas, validators, or curriculum sequencing were
modified for this audit.

## Executive Verdict

The main problem is not that the repository has no pedagogical standards. It has many
strong standards. The problem is that those standards are fragmented and mostly operate
at the level of assets, fields, validators, content objects, and individual cards.

The documentation is strong at answering:

- What content objects exist?
- What fields must they contain?
- What must not leak to the learner?
- How should beginner-facing text be phrased?
- How should writing-system and pronunciation units avoid invalid representations?

The documentation is weaker at answering:

- Why does this lesson exist as a learner experience?
- What can the learner not do before this lesson?
- What exact action can the learner perform after it?
- Why does this activity appear now?
- How does the lesson create attention, curiosity, micro-success, variation, and recall?
- How should a teacher pace the lesson minute by minute?

As a result, an author or AI can create lessons that satisfy many local rules while still
feeling like a sequence of dictionary entries followed by generic practice.

The current documentation can produce correct cards. It does not yet reliably produce
good lessons.

## Documentation Reviewed

The audit reviewed the required documentation set and closely related educational
documents, including:

- `ARCHITECTURE.md`
- `ARCHITECTURAL_DECISIONS.md`
- `AUTHORING_STYLE_GUIDE.md`
- `COMMUNICATIVE_COMPETENCY_MAP.md`
- `CONTENT_AUTHORING_GUIDE.md`
- `CONTENT_MODEL.md`
- `CONTENT_REVIEW_PROTOCOL.md`
- `COURSE_AUTHORING_GUIDE.md`
- `CURRICULUM_SPEC.md`
- `EDUCATIONAL_LANGUAGE_STANDARD.md`
- `LEARNING_MODEL.md`
- `WRITING_SYSTEM_STANDARD.md`
- `PRONUNCIATION_AUTHORING_GUIDE.md`
- `EDUCATIONAL_PRINCIPLES.md`
- `READING_RULE_PREREQUISITE_STANDARD.md`
- `WRITING_UNIT_INTRODUCTION_STANDARD.md`
- `GRAPHEME_PRESENTATION_STANDARD.md`
- `CONTENT_REVIEW_CHECKLIST.md`
- `LANGUAGE_COURSE_BLUEPRINT.md`
- `SPANISH_A0_CURRICULUM_BLUEPRINT.md`
- `SPANISH_A0_FOUNDATIONAL_READING_SEQUENCE.md`

## Documentation Strengths

### Strong separation of educational data and runtime behavior

The architecture and content model clearly separate content definitions, curriculum
structure, learner state, deterministic runtime behavior, and validation. This is a
major strength. It makes content review possible and prevents hidden runtime pedagogy
from being invented inside UI code.

### Strong validation culture

The documentation repeatedly emphasizes production approval, deterministic behavior,
content gates, answer leakage prevention, explicit review states, and executable
contracts. This makes it harder for invalid content to silently enter production.

### Strong learner-facing language standards

`AUTHORING_STYLE_GUIDE.md` and `EDUCATIONAL_LANGUAGE_STANDARD.md` contain valuable
requirements for beginner clarity, cognitive load, concrete examples, useful vocabulary,
short explanations, and one concept per learner-facing unit.

### Strong pronunciation and writing-system standards

`PRONUNCIATION_AUTHORING_GUIDE.md`, `WRITING_SYSTEM_STANDARD.md`,
`READING_RULE_PREREQUISITE_STANDARD.md`, and related documents contain important rules
for pronunciation support, IPA placement, writing-unit prerequisites, and avoiding
script confusion.

These standards are especially good at preventing invalid or confusing representations.

### Retrieval progression exists

`LEARNING_MODEL.md` and `CONTENT_AUTHORING_GUIDE.md` name a useful progression:

- Exposure
- Recognition
- Cued recall
- Free recall
- Controlled application
- Independent application

This is a sound pedagogical basis.

### Course-level communicative intent exists

`COURSE_AUTHORING_GUIDE.md` and `COMMUNICATIVE_COMPETENCY_MAP.md` correctly state that
lessons should be organized around communicative capability, not grammar for its own
sake.

### The Spanish A0 blueprint contains many needed quality targets

`SPANISH_A0_CURRICULUM_BLUEPRINT.md` includes stronger guidance on lesson quality,
knowledge density, pattern transfer, dialogue quality, review quality, and retrieval
distribution. Much of the missing instructional design model already exists there in
partial form.

## Documentation Weaknesses

### No mandatory lesson-scenario artifact

There is no required document, schema, or review step that forces the author to design
the lesson as a learning scenario before creating cards or JSON.

The current docs allow this workflow:

1. Choose a vocabulary set.
2. Add a reading or dialogue.
3. Add practice.
4. Validate fields.

They do not require this workflow:

1. Define what the learner cannot do before the lesson.
2. Define the measurable action the learner can do after the lesson.
3. Design the minimum learning path.
4. Decide why each activity is necessary.
5. Convert that path into content objects.

This is the single highest-priority gap.

### Lesson objectives can still be too broad

Some documentation encourages one objective per lesson, but examples such as
"introduce vocabulary" or "reinforce grammar" remain too broad. They describe teaching
activity, not learner capability.

A measurable A0 objective should look like:

- The learner can read, understand, and type "Hola."
- The learner can choose between "hola" and "adios" in a simple exchange.
- The learner can type a short answer to "Como te llamas?"

It should not be:

- Learn greetings.
- Introduce vocabulary.
- Practice pronunciation.

### Cognitive progression is named but not operationalized

The retrieval stages are present, but they are not consistently bound to lesson design.
One document says the stages are not mandatory sections in every lesson. That is
reasonable architecturally, but it creates ambiguity for authors.

The missing rule is:

The stages do not have to be visible section names, but the learner's path through a new
skill must still move from supported comprehension toward recall or use.

Without this clarification, lessons can include recognition and practice in arbitrary
order without a real learning arc.

### Activity design explains storage better than educational necessity

The docs explain content types, exercise types, validation rules, IDs, fields, and
contracts. They do not define a strict purpose model for each activity type.

For each activity type, authors need explicit answers to:

- Why does this activity exist?
- What learner state must exist before it?
- What learner action must happen inside it?
- What next activity does it prepare?
- When is this activity forbidden?

Without this, a "Reading" activity can become a list of phrases, and a "Practice"
activity can become generic checking rather than a necessary learning step.

### Motivation and curiosity are under-specified

Some docs mention confidence, usefulness, communication, and success. However, there is
no mandatory rule requiring:

- curiosity,
- micro-success,
- surprise,
- emotional progression,
- meaningful context,
- variation,
- a reason to continue.

`LEARNING_MODEL.md` indicates that an advanced motivation model is postponed. That may
be technically true, but it can be misread as motivation being optional for current
content.

For beginner lessons, motivation is not an advanced feature. It is part of the basic
learning experience.

### Content variety is not protected

The documentation does not prevent repeated lesson shapes such as:

Vocabulary -> Dialogue -> Reading -> Practice

or:

Reading rule -> Vocabulary -> Reading -> Practice

The docs say examples should be natural and lessons coherent, but they do not reject
consecutive lessons with identical rhythm, identical activity pattern, and identical
learner action.

This makes boring repetition formally valid.

### The strongest lesson-quality guidance is not clearly authoritative everywhere

`SPANISH_A0_CURRICULUM_BLUEPRINT.md` contains important quality requirements, but it
also distinguishes target/final-course quality from immediate pass/fail gates. That
creates authority ambiguity.

An author can treat strong blueprint guidance as aspirational while treating validators
and field-level standards as binding.

### Implementation language competes with pedagogy

The architecture documentation is necessary for engineers, but too much implementation
detail is adjacent to authoring standards. This can train AI authors to optimize for
schema compliance instead of learner experience.

The documentation needs a clearer separation between:

- Author-facing instructional design rules.
- Reviewer-facing quality gates.
- Validator-facing structural constraints.
- Engineer-facing runtime architecture.

## Missing Pedagogical Rules

### P0: Lesson scenario before content objects

Every lesson must begin from a scenario design, not from JSON fields or asset lists.

Required authoring order:

1. Learner cannot yet perform X.
2. After the lesson, learner can perform Y.
3. The shortest educational path from X to Y is Z.
4. Each screen exists because the previous screen made it necessary.
5. Only then are content objects authored.

### P0: One lesson equals one measurable learner action

Every lesson must teach exactly one measurable action. A lesson objective must be
testable by observing learner behavior.

Rejected objectives:

- Learn greetings.
- Practice pronunciation.
- Introduce vocabulary.
- Understand basic phrases.

Accepted objectives:

- The learner can read and type "Hola."
- The learner can choose the correct goodbye in a two-line exchange.
- The learner can answer "Como te llamas?" with "Me llamo Ana."

### P0: No dictionary lessons

A lesson must not be organized as a vocabulary inventory plus examples plus quiz.

Vocabulary is allowed only when it is needed for the lesson's single learner action.
Every new word must be used inside a meaningful learner decision shortly after
introduction.

### P0: Every activity must have a local reason

Each activity must answer:

- Why now?
- What learner action happens here?
- What earlier screen prepared this?
- What later screen depends on this?

If an activity can be removed without breaking the learning path, it should not exist.

### P0: Required learning arc

Every lesson should include a learning arc, even if the exact activity types vary:

1. Motivation or communicative need.
2. One new item or pattern.
3. Immediate supported comprehension.
4. Recognition.
5. Guided recall.
6. Independent recall or controlled use.
7. Tiny summary of what the learner can now do.

This should be a pedagogical sequence, not a required list of section names.

### P0: Boring-lesson rejection criterion

Reviewers should reject a lesson if it is formally correct but experientially flat.

A lesson is experientially flat when:

- the learner only reads entries and answers checks,
- there is no communicative reason for the content,
- several activities repeat the same action,
- examples do not create a situation,
- the same activity pattern repeats across adjacent lessons,
- nothing changes emotionally from start to finish.

### P1: Activity purpose matrix

Each activity type needs a normative purpose matrix:

- Educational purpose.
- Allowed learner state before it.
- Required learner action.
- Required support level.
- Common misuse.
- Forbidden use.
- Expected next step.

Example:

Recognition is allowed when the learner has just met a new item and needs low-risk
orientation. Recognition is not enough as the final evidence of mastery when the lesson
objective requires recall or production.

### P1: Variation budget

The docs should define variation expectations across adjacent lessons:

- No more than two adjacent lessons may use the same activity rhythm without an explicit
  pedagogical reason.
- Repetition must change the learner action, context, or support level.
- Review should feel like reuse in a new situation, not a replay of the same card.

### P1: Delayed recall policy

The docs mention review and future reuse, but they need a concrete delayed-recall
policy:

- newly learned items should reappear after a delay,
- review should reduce support,
- review should appear in a slightly changed context,
- review should sometimes require production, not only recognition.

### P1: Motivation and micro-success standard

Every A0 lesson should include:

- a simple reason the learner wants this phrase now,
- an early success within the first screens,
- a visible improvement by the end,
- a human-feeling example or exchange.

### P2: Example ecology

Examples should be planned as an ecology, not selected one by one.

The docs should specify:

- examples must reuse known material in varied combinations,
- examples must prepare the next exercise,
- examples should avoid random names or phrases unless they create a real mini-context,
- examples should not exist merely to display a word.

## Conflicting Or Ambiguous Rules

### Retrieval stages are named but weakened

`LEARNING_MODEL.md` defines a strong progression, then says these stages are not
mandatory sections in every lesson. This is ambiguous.

Recommended clarification:

The labels are not mandatory section names, but the progression from support to recall
must be visible in the learning path whenever a lesson teaches a new usable skill.

Priority: P0.

### Typical lesson composition can become a template trap

`CONTENT_AUTHORING_GUIDE.md` describes a typical beginner lesson as introduction, new
vocabulary, grammar, guided examples, dialogue/reading, exercises, and summary.

This can be helpful as a checklist, but it also encourages mechanical assembly.

Recommended change:

Reframe this as a set of optional resources selected by the lesson scenario, not as a
default lesson structure.

Priority: P0.

### Broad lesson goals conflict with measurable capabilities

Some docs allow lesson goals framed as introducing or reinforcing content. Other docs
require communicative capability.

Recommended change:

Only learner-observable outcomes may be primary lesson objectives. Content categories
may be metadata, not goals.

Priority: P0.

### Pronunciation precision can conflict with learner simplicity

Writing-system and pronunciation documents correctly protect script and pronunciation
integrity. However, if authors over-apply those standards to learner cards, the result
can become author-facing or validator-facing text.

R2E6B/R2E6C solve this for reading rules, but the docs should explicitly separate:

- what validators must know,
- what authors must preserve,
- what A0 learners should see.

Priority: P1.

### Spanish A0 blueprint authority is unclear

The Spanish A0 blueprint contains the strongest full-lesson guidance, but it is not
always presented as an immediate mandatory standard for production lessons.

Recommended change:

Promote its transferable lesson-quality rules into global authoring standards, then
state which language-specific details remain Spanish-only.

Priority: P1.

### Motivation cannot be postponed for beginner lessons

If motivation is described as part of a future advanced model, authors may ignore it.

Recommended change:

Separate advanced personalization from basic motivation. Basic curiosity, context,
micro-success, and emotional progression are mandatory even in Gen 1.

Priority: P1.

## Rules That Encourage Poor Lessons

### Static lesson composition lists

Any list that says a beginner lesson typically contains vocabulary, grammar, examples,
dialogue, reading, exercises, and summary can unintentionally produce a repetitive
factory pattern.

This documentation permits:

Vocabulary -> Dialogue -> Reading -> Practice

with no scenario, no tension, no learner problem, and no reason for the order.

Priority: P0.

### Asset-first content modeling

The content model is necessary, but it can encourage authors to think in isolated
objects:

- vocabulary item,
- phrase,
- reading,
- exercise,
- review.

Without a scenario-first standard, authors can assemble valid objects into weak
lessons.

Priority: P0.

### Field-level validation can substitute for pedagogical validation

A lesson can pass checks for:

- required IDs,
- allowed answer sets,
- approved localization,
- no leakage,
- valid reading-rule prerequisites,
- valid review state,

while still being dull and educationally thin.

Priority: P0.

### "Introduce vocabulary" language

When documentation uses "introduce vocabulary" as a lesson purpose, it implicitly
permits dictionary-style lessons.

Priority: P0.

### Reading as content category instead of communicative act

Docs warn against vocabulary dumps, but do not strictly require every reading to be a
miniature communicative event. This permits reading sections that are merely phrase
lists.

Priority: P1.

## Recommended Removals

### P0: Remove broad objectives as acceptable primary goals

Remove or demote examples such as:

- introduce vocabulary,
- reinforce grammar,
- practice pronunciation.

They may remain as internal instructional functions, but not as primary lesson
objectives.

### P0: Remove default activity-stack framing

Do not present vocabulary, grammar, examples, dialogue, reading, exercises, and summary
as a default beginner lesson recipe.

Replace it with:

The lesson scenario determines which resources are needed.

### P0: Remove ambiguity around retrieval progression

Remove wording that allows authors to ignore support-to-recall progression. Keep the
flexibility that labels are not required, but make the learner progression mandatory.

### P1: Move implementation-heavy material away from author-facing guidance

Author-facing docs should not require an instructional designer to parse runtime
architecture before understanding how to make a good lesson.

### P1: Remove aspirational status from core lesson-quality rules

Rules about one objective, variation, recall, and communicative context should not be
aspirational for production A0 content.

## Recommended Additions

### P0: Add `LESSON_SCENARIO_STANDARD.md`

Purpose:

Define the mandatory scenario-first design process for every lesson.

Required sections:

- Before state: what the learner cannot yet do.
- After state: measurable learner action.
- Lesson reason: why this lesson exists now.
- Minimum path: the fewest steps needed.
- Activity chain: why each step follows the previous one.
- Evidence of mastery: what proves the learner can now perform the action.

### P0: Add scenario review to `CONTENT_REVIEW_PROTOCOL.md`

Mandatory reviewer questions:

- Is the lesson objective learner-observable?
- Can the learner perform the objective by the end?
- Does every activity directly support that objective?
- Does the lesson move from support toward recall or use?
- Would removing any activity damage the learning path?
- Does the lesson avoid dictionary-entry behavior?

Any "No" should reject production approval.

### P0: Add a No Dictionary Lessons rule

Normative wording:

A beginner lesson must not be structured as a list of vocabulary entries followed by
generic examples and checks. New words are introduced only as needed for the lesson's
single learner action and must be used in a meaningful decision or recall task shortly
after introduction.

### P0: Add measurable objective requirements

A lesson objective must include:

- learner action,
- target language material,
- expected support level,
- observable evidence.

Example:

The learner can type "Hola." after seeing a Ukrainian prompt and no visible Spanish
answer.

### P1: Add `ACTIVITY_PURPOSE_STANDARD.md`

Purpose:

Define allowed and forbidden uses for each activity type.

For each activity:

- Why it exists.
- What it cannot do.
- What learner state it requires.
- What support level is allowed.
- What should normally follow.
- What misuse looks like.

### P1: Add `LEARNING_EXPERIENCE_DESIGN_STANDARD.md`

Purpose:

Define pacing, engagement, curiosity, micro-success, emotional progression, variation,
and delayed recall as mandatory parts of A0 lesson design.

### P1: Add anti-repetition rules

Examples:

- Adjacent lessons should not use the same visible activity rhythm unless required by a
  documented pedagogical reason.
- Repetition must change context, support level, or learner action.
- Practice must not merely repeat the presentation.

### P1: Add delayed recall schedule guidance

Define how new material should reappear later:

- same lesson: supported recognition and recall,
- next lesson: reduced support,
- later lesson: changed context,
- checkpoint: independent use.

### P2: Add full lesson exemplars

The docs need complete examples, not only card-level examples.

Include:

- one excellent A0 lesson,
- one rejected dictionary-like lesson,
- one rejected over-explained lesson,
- one rejected repetitive lesson,
- reviewer notes explaining the decision.

### P2: Add an authoring worksheet

A short worksheet should be required before JSON authoring:

- What is the learner trying to do?
- What blocks the learner now?
- What is the first tiny success?
- What must be recognized before it can be recalled?
- Where does recall happen?
- Where does transfer happen?
- What can be deleted?

## New Documents Required

### P0: `LESSON_SCENARIO_STANDARD.md`

Defines scenario-first lesson design and measurable before/after learner capability.

### P1: `ACTIVITY_PURPOSE_STANDARD.md`

Defines the educational purpose, allowed use, and misuse patterns for every activity
type.

### P1: `LEARNING_EXPERIENCE_DESIGN_STANDARD.md`

Defines pacing, curiosity, motivation, emotional progression, micro-success, and
variation.

### P1: `LESSON_REVIEW_RUBRIC.md`

Turns instructional design quality into production review gates.

### P2: `A0_EXAMPLE_LIBRARY_STANDARD.md`

Defines how examples should be selected, sequenced, reused, varied, and rejected.

## Concrete Examples Of How Current Documentation Permits Boring Lessons

### Example 1: Vocabulary -> Dialogue -> Reading -> Practice

The current documents allow a lesson to contain:

1. Several vocabulary entries.
2. A short dialogue using those entries.
3. A reading section using those entries.
4. Practice checks.

This can be formally valid because it uses approved content types, follows a typical
lesson composition, and gives practice after presentation.

However, it can still be boring because the docs do not require:

- a learner problem,
- a reason the dialogue matters,
- a change in learner action,
- curiosity,
- micro-success,
- independent transfer,
- variation from adjacent lessons.

### Example 2: "Gracias and Please" as a vocabulary cluster

A lesson about "gracias" and "por favor" can become:

1. Show both words.
2. Translate both words.
3. Read examples.
4. Ask recognition questions.
5. Ask typing questions.

The lesson may pass vocabulary and exercise checks, but it may not teach the social
action: making a polite request and responding to thanks.

The missing documentation rule is:

The lesson objective must be the communicative action, not the word set.

### Example 3: Reading rule compliance without a reason to read

A lesson can correctly introduce a reading rule, provide pronunciation support, and
avoid script confusion, yet still feel like reference material if the learner has no
immediate word or message they want to read.

The missing documentation rule is:

A reading rule appears only when it immediately unlocks the next meaningful word,
phrase, or learner action.

### Example 4: Valid examples that do not form a scene

The docs require examples to be natural and level-appropriate. That is good, but not
enough.

An author can write:

- Hola.
- Hola, Ana.
- Adios.
- Gracias.

Each example is valid. Together they may still feel like a list.

The missing documentation rule is:

Examples in one lesson should form a small communicative situation whenever possible.

### Example 5: Same rhythm across adjacent lessons

If several lessons use the same rhythm:

Vocabulary -> Dialogue -> Reading -> Practice

each individual lesson may pass review. The sequence as a learner experience becomes
predictable and flat.

The missing documentation rule is:

Review must evaluate adjacent lessons for rhythm, variation, and cumulative learner
experience.

### Example 6: Recognition and recall without progression

A lesson can include one recognition exercise and one typing exercise and appear to
cover progression. But if the typing exercise simply asks for the same item shown
moments earlier, the learner may be copying memory traces rather than recalling in a
meaningful context.

The missing documentation rule is:

Recall must reduce support and change the learner task enough to demonstrate learning.

## Failure Analysis Of Lessons 1-5 As Evidence

The current early-lesson pattern shows how the documentation failure manifests:

- Lessons can be organized around vocabulary clusters rather than learner actions.
- Reading and dialogue can become containers for already listed phrases.
- Practice can verify recognition or short recall without creating a meaningful need.
- Adjacent lessons can repeat the same structure.
- Pronunciation and writing correctness can be validated while the lesson remains flat.
- The learner may complete screens without feeling a communicative progression.

This should not be blamed first on implementation. The implementation is largely doing
what the documentation permits: storing valid content objects, enforcing validators, and
presenting approved activities.

The missing layer is lesson-level instructional design.

## Priority Summary

### P0: Must fix before more lesson authoring

- Add `LESSON_SCENARIO_STANDARD.md`.
- Require measurable before/after learner capability.
- Add No Dictionary Lessons rule.
- Make support-to-recall progression mandatory at lesson-path level.
- Replace default activity-stack guidance with scenario-first guidance.
- Add scenario review gates to `CONTENT_REVIEW_PROTOCOL.md`.

### P1: Should fix before broad curriculum expansion

- Add `ACTIVITY_PURPOSE_STANDARD.md`.
- Add `LEARNING_EXPERIENCE_DESIGN_STANDARD.md`.
- Add anti-repetition and variation rules.
- Add delayed recall policy.
- Clarify authority of Spanish A0 blueprint rules.
- Separate author-facing pedagogy from implementation architecture.

### P2: Should fix to improve consistency and reviewer calibration

- Add full compliant and rejected lesson exemplars.
- Add authoring worksheet.
- Add example ecology guidance.
- Add adjacent-lesson review rubric.

## Recommended Next Step

Do not continue rewriting Lessons 1-5 until the documentation has a mandatory
scenario-first lesson design standard.

The project already has strong content validation. The missing standard is not another
field-level validator. The missing standard is a pedagogical architecture for lessons:

Learning objective -> educational scenario -> learner actions -> activity chain ->
content objects -> JSON.

Only after that standard exists should lesson authoring resume.
