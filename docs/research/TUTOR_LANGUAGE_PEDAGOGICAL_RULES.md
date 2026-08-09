# Tutor Language Pedagogical Rules

Status: PROPOSAL
Scope: tutor language pedagogical rules
Normative authority: none; requires explicit adoption

This document converts the Spanish textbook research into an original Tutor
Language beginner methodology. It is compatible with the existing lesson
authoring entrypoint, learning state machine, pedagogical scenario model, and
authoring standards.

It does not create lessons, modify curriculum, or define application code.

## Canonical Tutor Language Beginner Methodology

### Lesson Philosophy

A Tutor Language beginner lesson is a guided state transition.

It is not a vocabulary list, reading-rule catalogue, grammar explanation, or
collection of cards. The lesson exists because the learner cannot yet perform
one measurable action. The lesson is complete only when the learner has evidence
of performing that action with the intended level of support.

Required lesson question:

What can the learner do after this lesson that they could not do before it?

### Teacher Replacement Strategy

Traditional Spanish textbooks assume a teacher for pronunciation modeling,
encouragement, exercise selection, pacing, correction, and context creation.
Tutor Language has no live teacher, so the application must provide these
functions through deterministic design.

The app must replace the teacher by providing:

- a clear immediate purpose;
- pronunciation support before unsupported reading;
- examples before abstraction;
- one learner action per step;
- support fading;
- answer checking;
- state-specific feedback;
- remediation for predictable failures;
- visible completion evidence;
- scheduled review.

Any lesson step that needs live teacher judgment must be converted into an
app-checkable action or removed.

### Pronunciation Introduction Strategy

Pronunciation is introduced to make reading and speaking possible, not to teach
phonetics as a subject.

Rules:

- Introduce only the sound or reading fact needed for the next Spanish item.
- Present support-language pronunciation before IPA.
- Use IPA only as secondary metadata.
- Avoid scientific terminology unless the term itself is the lesson objective.
- Provide immediate practice after a new pronunciation fact.
- Fade pronunciation support only after the learner has succeeded with support.

### Reading Strategy

Reading support must appear before the learner is expected to read an unfamiliar
Spanish word or sentence.

Rules:

- No unsupported new Spanish word in A0 learner-facing flow.
- Teach the written symbol or pattern just in time.
- Use real course examples, not random word collections.
- Move from supported decoding to recognition and then recall.
- Do not present a full alphabet or rule table as a beginner lesson unless the
  measurable objective is using that table.
- Introduce stress and intonation only when they support the next learner action.

### Vocabulary Strategy

Vocabulary is taught as usable language.

Rules:

- Each new word needs Spanish form, pronunciation support, natural translation,
  and immediate use.
- The first translation should be the closest natural learner-language
  equivalent, not an explanation.
- New words must be few enough that the learner can use them immediately.
- Examples should reuse known vocabulary whenever possible.
- Avoid topic lists unless the lesson objective is app-checkable use of that
  specific set.

### Grammar Strategy

Grammar serves communication and recall.

Rules:

- Do not introduce a grammar category before the learner needs it.
- Show a usable example before naming a pattern.
- Teach one grammar behavior at a time.
- Practice new grammar with known vocabulary where possible.
- Postpone paradigms, classifications, and exceptions until they directly help a
  measurable learner action.

### Review Strategy

Review exists to prove retention after interference or delay.

Rules:

- Review must change context, support, or response type.
- Repetition without changed learner demand is not review.
- Previously learned words should return inside new actions.
- Failed review should route to the failed learner state, not restart the whole
  lesson automatically.
- Course-level review should appear after several lessons, while micro-review
  can appear inside later lessons.

### Exercise Progression

The default beginner progression is:

1. Purpose: the learner sees why the item matters now.
2. Supported encounter: the learner sees or hears the new item with help.
3. Meaning recognition: the learner identifies what it means.
4. Supported decoding: the learner reads it with pronunciation support.
5. Changed-context recognition: the learner recognizes it outside the first
   display.
6. Guided recall: the learner recalls with partial support that does not reveal
   the answer.
7. Independent recall: the learner produces the item without answer leakage.
8. Controlled use: the learner uses it in a small meaningful context.
9. Closure: the learner sees what they can now do.
10. Delayed review: the item returns after interference or time.

This progression may be shortened only when the learner state evidence already
exists.

### Explanation Strategy

The first explanation must help the learner perform the next action.

Rules:

- Use familiar learner-language words.
- Keep explanations short.
- Prefer direct translations and examples over descriptions.
- Explain one idea per screen.
- Remove any sentence that does not help the next learner action.
- Avoid author instructions, validator language, implementation language, and
  linguistic encyclopedia content.

### Motivation Strategy

Motivation should be practical and immediate.

Rules:

- Start from a real action the learner can complete soon.
- Use micro-success instead of long promises.
- Make progress visible through what the learner can now read, understand, type,
  or choose.
- Use context, variety, and changed actions instead of decorative explanation.

### Remediation Strategy

Remediation must match the failed learner state.

Examples:

- Meaning failure: return to translation or context recognition.
- Reading failure: return to pronunciation support and decoding.
- Spelling failure: show form-focused feedback without leaking future recall.
- Recall failure: restore partial support and then fade it again.
- Context failure: return to a simpler known context before transfer.

Generic failure messages are insufficient for A0. The learner should know what
to try differently next.

## Mandatory Beginner Rules

- One lesson teaches one measurable skill.
- One screen introduces one new idea.
- Every new Spanish word has pronunciation support before active use.
- Every new Spanish sentence has pronunciation support before active use.
- Recognition precedes recall unless prior evidence proves the learner is ready.
- Recall tasks must not display the answer.
- Examples use known or immediately introduced language.
- Reading rules are pronunciation aids, not reference articles.
- Grammar is introduced only when needed for the current learner action.
- Review changes retrieval demand.
- Feedback identifies the failed learner state.

## Forbidden Beginner Patterns

- Starting from JSON, asset IDs, or content categories.
- Building a lesson as `vocabulary -> reading -> practice` without a learner
  state scenario.
- Full alphabet tables as the first learner experience.
- Dictionary-like vocabulary lists.
- Many unrelated first-lesson goals.
- Linguistic terminology as the primary explanation.
- IPA without an understandable learner explanation.
- Teacher-only open tasks that the app cannot evaluate.
- Copying textbook dialogues, exercises, or wording.
- Repeating the same word or sentence merely to fill space.

## Textbook Principle Adaptation

| Textbook principle | Tutor Language adaptation |
| --- | --- |
| Phonetics before unsupported reading | Keep as just-in-time pronunciation support. |
| Alphabet and rule tables | Adapt into micro-rules tied to immediate course words. |
| Teacher-led repetition | Adapt into deterministic support fading and state-specific review. |
| Long communicative chapters | Split into one-skill mobile lessons. |
| Grammar explanation before exercises | Adapt to example-first and action-first grammar support. |
| Translation and retelling | Use only when response can be checked or safely scaffolded. |
| Large vocabulary topics | Replace with small usable sets and later review. |

## Authoring Checklist

Before lesson content is created, answer:

- What exact learner state is missing?
- What single measurable action proves progress?
- What pronunciation support is required before the first Spanish item?
- What meaning support is required?
- What is the first recognition task?
- What is the first recall task?
- Where does support fade?
- What failure states are possible?
- What deterministic remediation handles each failure?
- What delayed review evidence will be needed later?

## Final Self-Review Questions

For every beginner lesson scenario:

- Did the design extract principles instead of copying textbook material?
- Can every major rule be traced to the project documentation or to one or more
  analyzed textbooks?
- Would another educator looking at the same sources likely identify the same
  broad principles?
- Is the resulting lesson methodology independent enough to create original
  Tutor Language content without returning to textbook wording?
- Does every step replace a real teacher function or perform an app-specific
  learning-state function?
