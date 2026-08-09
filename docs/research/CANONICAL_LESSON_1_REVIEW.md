# Canonical Lesson 1 Review

Status: EVIDENCE
Scope: Spanish course/pedagogical review evidence
Normative authority: PEDAGOGICAL_SCENARIO_MODEL.md

Phase: R2E16A

Reviewed document:

`docs/research/CANONICAL_LESSON_1_DESIGN.md`

Evidence base:

`docs/research/PEDAGOGICAL_EVIDENCE.md`

Legend:

- ✓ supported by pedagogical evidence
- △ weakly supported or evidence is mixed
- ✗ contradicted by evidence

---

# Summary Verdict

Overall judgment:

```text
PASS WITH MINOR EVIDENCE RISKS
```

The current Lesson 1 design is broadly supported by the evidence base. It
aligns especially well with Tutor Language documentation, communicative
methodology and the textbook pattern that first-contact/greeting content is a
natural opening for Spanish beginners.

The main weak points are not defects, but adaptations that are smaller and more
mobile-specific than textbook norms:

- only one Spanish expression;
- 20-30 minutes spent on one word;
- no full phonetics opening;
- no live response from a real interlocutor.

These choices are justified for an offline smartphone app, but should be tested
carefully in implementation QA.

---

# Decision Review

## Lesson begins with a human greeting situation before the word

Judgment:

✓ supported

Evidence:

- Communicative textbooks commonly open the first communicative lesson with
  greeting/first-contact situations.
- Tutor Language scenario rules require meaningful context and reject storage
  category sequencing.
- Communicative and task-based methodology support language as meaningful
  action.

Reasoning:

This prevents `Hola.` from becoming an isolated flashcard and creates a reason
for the word to exist.

## Lesson 1 teaches `Hola.` as first-contact communication

Judgment:

✓ supported

Evidence:

- Textbooks B and D introduce greetings at the beginning of Lesson 1.
- Textbook A uses `Hola` in early dialogue work after phonetics.
- CEFR-style communicative framing supports observable communicative activity
  rather than abstract knowledge.

Reasoning:

Greeting is the most consistently supported first communicative domain.

## Only one new Spanish expression is taught

Judgment:

△ weakly supported

Evidence:

- Textbooks usually introduce more than one expression in the first lesson.
- Some traditional sources introduce many dozens of units.
- Tutor Language documentation strongly supports minimal cognitive load,
  single measurable outcomes and state-transition design.

Reasoning:

The choice is not textbook-typical, but it is a defensible mobile adaptation.
It should remain only if the lesson genuinely produces a first successful
communication experience rather than feeling overextended.

## Learner-facing content is Ukrainian-only

Judgment:

✓ supported for current product focus

Evidence:

- The user explicitly requires a Ukrainian canonical lesson first.
- Tutor Language localization standards require support-language clarity and
  natural learner-facing text.

Reasoning:

For the current canonical lesson, Ukrainian learner-facing text avoids
unnecessary English mediation. Future locales should be authored separately,
not translated mechanically from English.

## Pronunciation support appears after meaning, not before the situation

Judgment:

✓ supported

Evidence:

- Textbooks often introduce phonetics early, but communicative lessons connect
  words with meaning and use.
- Tutor Language scenario rules require pronunciation support before reading
  unfamiliar target material, not necessarily before meaning.

Reasoning:

The sequence "situation -> meaning -> pronunciation support" is appropriate:
the learner first knows why the word matters, then how to read it.

## Lesson does not begin with full phonetics

Judgment:

△ weakly supported, with justified disagreement

Evidence:

- Textbooks A, C and D begin with phonetics/alphabet, which argues against this
  choice.
- Textbook B and communicative methodology support first-contact language early.
- Tutor Language documentation rejects unnecessary terminology and supports
  nearest-action explanations.

Reasoning:

The design contradicts a common textbook tradition, but that tradition is
paper/classroom-oriented. For a phone-first Lesson 1, limited just-in-time
pronunciation support is better supported by Tutor Language constraints.

## No alphabet, silent `h`, IPA or writing-system terminology

Judgment:

✓ supported

Evidence:

- Educational language standards require zero linguistic prerequisites for
  beginner-facing explanations.
- Pronunciation should help the next action, not become an encyclopedia entry.

Reasoning:

The lesson only needs the learner to read `Hola.` approximately. Explaining
silent `h` in Lesson 1 would add terminology that does not improve the final
send-message action.

## Recognition precedes recall

Judgment:

✓ supported

Evidence:

- Tutor Language learning model prefers exposure -> recognition -> cued recall
  -> free recall -> application.
- Introductory methodology commonly moves from controlled practice to freer
  production.
- Textbooks use reading, choosing and completion tasks before more productive
  translation/dialogue tasks.

Reasoning:

The scene order is educationally sound.

## Cued recall before independent typing

Judgment:

✓ supported

Evidence:

- Tutor Language state machine distinguishes guided recall from independent
  recall.
- Controlled practice normally precedes freer production.

Reasoning:

The `H__a.` step is justified as a bridge, provided implementation does not
mistake it for mastery evidence.

## Independent typing is included in Lesson 1

Judgment:

✓ supported

Evidence:

- Tutor Language principles prioritize active retrieval and productive
  language.
- Textbook exercises often include translation or production after presentation.

Reasoning:

Typing `Hola.` is appropriate because the target is one short expression. It
would be inappropriate if Lesson 1 contained many new expressions.

## Final action is framed as sending a message

Judgment:

✓ supported

Evidence:

- The app is smartphone-first.
- Communicative and task-based methodology support meaningful action.
- Traditional partner dialogue cannot be copied directly because there is no
  live teacher or partner.

Reasoning:

This is the strongest adaptation in the design: it replaces classroom role-play
with a phone-native first communication act.

## The app shows "conversation started" without introducing a new Spanish reply

Judgment:

✓ supported

Evidence:

- The lesson objective is `Hola.`, not comprehension of a reply.
- Tutor Language documentation warns against adding unsupported new material.

Reasoning:

The response creates a feeling of communication while avoiding overload.

## Scene 11 repeats independent recall after a context change

Judgment:

△ weakly supported

Evidence:

- Retrieval and repetition are supported by Tutor Language principles.
- The design's novelty rule requires adjacent screens to avoid the same mental
  action.

Risk:

Scene 11 may feel too similar to Scene 8 unless the context change is strong in
implementation.

Recommendation:

Keep it only if implementation clearly makes it a second retrieval after a
different action, not a duplicate typing screen.

## Scene 12 checks reading without pronunciation support after typing

Judgment:

✓ supported

Evidence:

- The outcome includes reading and understanding.
- The state machine distinguishes decoding/reading from recall.

Reasoning:

Typing from Ukrainian prompt does not prove reading `Hola.` on screen. This
scene gathers separate evidence.

## Error remediation returns only to the failed transition

Judgment:

✓ supported

Evidence:

- Tutor Language state machine defines remediation paths by failed state.
- Educational principles treat errors as learning information.

Reasoning:

This is better than restarting the lesson or giving generic "try again"
feedback.

## Screen necessity rule

Judgment:

✓ supported

Evidence:

- Tutor Language scenario model requires every step to have a state transition
  and success evidence.
- Mobile constraints and cognitive-load standards reject filler screens.

Reasoning:

This rule should become a general authoring constraint for future lessons.

## Novelty every 1-2 minutes

Judgment:

△ weakly supported

Evidence:

- Interest and variety are required by Tutor Language documentation.
- Short mobile attention and task variation are methodologically plausible.
- The exact 1-2 minute cadence is not directly established by the examined
  textbooks.

Reasoning:

The principle is useful, but the exact timing should be treated as a product
design heuristic rather than a textbook-proven rule.

## Lesson duration of 20-30 minutes

Judgment:

△ weakly supported

Evidence:

- Textbook lessons are much longer, often many pages or hours.
- Smartphone sessions usually benefit from shorter, focused interactions.

Risk:

Twenty to thirty minutes may be long for one expression if implementation is
slow or visually repetitive.

Recommendation:

Treat 20-30 minutes as an upper design envelope including retries. A clean
first pass may reasonably be shorter.

## Avoiding multiple choice as final evidence

Judgment:

✓ supported

Evidence:

- Tutor Language learning model states recognition is weaker than recall.
- Educational principles favor production and independent use.

Reasoning:

Multiple choice is appropriate for early recognition, not final lesson success.

## No dialogue memorization

Judgment:

✓ supported

Evidence:

- Some textbooks use memorized dialogues, but this is weakly suited to an
  offline phone app without a live teacher.
- Tutor Language prioritizes independent use and meaningful retrieval.

Reasoning:

The design correctly avoids memorization as the route to first communication.

---

# Potential Risks

## Risk 1: One-word lesson may feel too thin

Severity:

Medium.

Explanation:

Textbooks usually introduce more material. Tutor Language can justify one word
only if every scene creates a distinct state transition and the final sent
message feels real.

Mitigation:

Implementation must avoid slow pacing, decorative screens and repeated tasks
that feel identical.

## Risk 2: `Hala` / `Ola` distractors may introduce unwanted confusion

Severity:

Low to medium.

Explanation:

The design uses similar forms to check visual recognition. However, beginners
may interpret them as new Spanish words unless clearly framed as choices only.

Mitigation:

Use these only as non-teaching distractors and do not discuss them.

## Risk 3: Final communication is simulated

Severity:

Low.

Explanation:

There is no live interlocutor. The app must create the feeling of a successful
first exchange without pretending to be a real person or introducing new
Spanish.

Mitigation:

Frame the result as "conversation started", not as a fake dialogue partner.

## Risk 4: Exact punctuation requirement may add noise

Severity:

Low.

Explanation:

Requiring the final period may distract from the communicative objective.

Mitigation:

Accept missing period with feedback if the word is correct, as the current
design already specifies.

---

# Required Follow-Up Before Implementation

Before implementing Lesson 1, answer these design-to-runtime questions:

1. Can the final "send message" action be implemented without creating a new
   Flutter interaction pattern?
2. Can remediation branch by meaning, reading and recall failure using existing
   deterministic evaluation?
3. Can Ukrainian pronunciation support `ола` be shown early and hidden during
   independent recall?
4. Can the app avoid showing `Hola.` in prompts where recall is being assessed?
5. Can each scene remain short enough for a 6-7 inch phone without scrolling?

If any answer is no, record an implementation gap. Do not weaken the
pedagogical scenario to fit a convenient storage category.

---

# Final Judgment

The canonical Lesson 1 design is pedagogically defensible and mostly supported
by the evidence base.

Most supported choices:

- first-contact greeting objective;
- Ukrainian learner-facing content;
- situation before word;
- just-in-time pronunciation support;
- support fading;
- independent typed production;
- final phone-native communication action.

Weakest but acceptable adaptations:

- one-expression lesson scope;
- exact 1-2 minute novelty rhythm;
- 20-30 minute design envelope.

No major design decision is directly contradicted by the combined evidence once
Tutor Language's offline smartphone constraints are considered.
