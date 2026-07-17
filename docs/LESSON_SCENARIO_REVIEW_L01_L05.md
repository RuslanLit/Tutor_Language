# LESSON_SCENARIO_REVIEW_L01_L05.md

Phase: R2E9C Revised Design-Only Scenarios for Lessons 1-5

Status: Design review only. Do not implement from this file without human approval.

This document defines instructional scenarios only. It does not modify lesson JSON,
educational content assets, localization, runtime code, schemas, validators, or tests.

Authoritative context:

- `LESSON_AUTHORING_ENTRYPOINT.md`
- `LEARNING_STATE_MACHINE.md`
- `PEDAGOGICAL_SCENARIO_MODEL.md`
- curriculum documents
- content authoring documents
- pronunciation and localization standards

Architecture, schemas, runtime, and validators remain reference material only.

---

# Operational Support Definitions

Translation:
The nearest natural support-language meaning of the target expression.

Pronunciation support:
Support-language reading aid for an unfamiliar Spanish form. It is visible before first
decoding and hidden during independent recall of the same form.

Exact changed context:
The target is used with a different speaker role, addressee, or communicative moment
than the teaching example. Merely repeating the same line with the same situation is not
a changed context.

Plausible distractor:
A previously taught expression from the same communicative domain that is semantically
wrong in the current situation. Random unrelated words are not valid distractors.

Non-leaking cue:
A cue that names the communicative intention or situation without showing target
letters, target pronunciation, or a model answer.

Brief interference:
One intervening task using already taught material before the assessed target returns.
This is not long-term retention.

---

# Overall Five-Lesson Goal

By the end of Lesson 5, the learner can greet a named person, understand the greeting
question `¿Qué tal?`, answer it with `Bien.`, read the taught expressions, and produce
the tiny exchange independently.

No lesson claims long-term retention. Lessons 1-5 establish immediate recall,
contextual use, and recall after brief interference. Cross-lesson retention must be
checked in a later review lesson or later session.

---

# Lesson 1

## Lesson Title

Your First Spanish Hello

## Lesson Goal

The learner independently reads, understands, and types `Hola.`

## Starting Learner State

Not introduced.

## Ending Learner State

Recalls it independently.

## New Knowledge Budget

| Category | New units |
|---|---|
| Target-language forms | `Hola.` - genuinely new |
| Meanings | `привіт` - genuinely new |
| Reading rules | In `Hola`, written `h` is not pronounced - genuinely new |
| Spelling rules | Capital `H` at sentence start; final period accepted as sentence punctuation - genuinely new but not separately assessed |
| Grammar | None |
| Communicative functions | Greeting someone - genuinely new |
| Interaction conventions | A greeting can open an encounter - genuinely new |

This is acceptable for A0 because it teaches one word, one meaning, one necessary
reading fact, and one immediate communicative function.

## Why This Lesson Exists

The learner needs one complete first success: seeing a Spanish word, knowing what it
means, reading it safely, and producing it without visible answer support.

## Lesson Scenario

### Step 1: First Encounter

Current learner state:
Not introduced.

Target learner state:
Attends to the new unit.

Exact visible information:
`Hola.`; `ола`; `привіт`; one-sentence situation in the support language: "Someone is
meeting you."

Exact hidden information:
No other Spanish words; no distractors; no spelling task.

Teacher/system action:
Present `Hola.` as the only Spanish word in the encounter.

Learner action:
Notice the word and continue.

Evidence:
The learner identifies `Hola.` as the focus by selecting the only shown Spanish word
when asked what word is being learned.

Failure interpretation:
The learner has not attended to the target unit.

Remediation:
Show only `Hola.` with `ола` and `привіт` again.

Reason this step is necessary:
The learner cannot recognize, read, or recall a unit that has not been explicitly
introduced.

### Step 2: Meaning Recognition

Current learner state:
Attends to the new unit.

Target learner state:
Understands its meaning.

Exact visible information:
`Hola.`; `ола`; answer options: `привіт`, `дякую`, `до побачення`.

Exact hidden information:
No model sentence; no typed answer field; no extra examples.

Teacher/system action:
Ask what `Hola.` means.

Learner action:
Choose `привіт`.

Evidence:
Correct selection against two plausible greeting-domain distractors.

Failure interpretation:
Meaning is not established.

Remediation:
Return to direct pairing `Hola.` -> `привіт`, then retry with the same distractors in a
different order.

Reason this step is necessary:
The learner must connect form to meaning before recall can be meaningful.

### Step 3: Supported Decoding

Current learner state:
Understands its meaning.

Target learner state:
Can read or decode it with support.

Exact visible information:
`Hola.`; `ола`; short support-language reading note: "Read this word as `ола`."

Exact hidden information:
No translation choices; no typing task.

Teacher/system action:
Direct attention to the reading of the word.

Learner action:
Match `Hola.` to `ола`.

Evidence:
The learner chooses `ола` over `хола` and `гола`.

Failure interpretation:
The learner has not connected the written form to the supported reading.

Remediation:
Restore `Hola.` -> `ола` and repeat the contrast with the same options in a different
order.

Reason this step is necessary:
Independent typing later is not enough to prove the learner can read the written form.

### Step 4: Changed-Context Recognition

Current learner state:
Can read or decode it with support.

Target learner state:
Recognizes it in a changed context.

Exact visible information:
Two support-language situations: "Someone arrives" and "Someone leaves." Spanish
options: `Hola.` and a non-target placeholder in support language only, not a new
Spanish word.

Exact hidden information:
Pronunciation support is hidden; no translation of `Hola.` appears.

Teacher/system action:
Ask which Spanish word fits the arrival situation.

Learner action:
Choose `Hola.`

Evidence:
Correct choice in a situation that differs from the first teaching card.

Failure interpretation:
The learner may know the word in isolation but not recognize its greeting function.

Remediation:
Return to Step 2 meaning pairing, then Step 4 with the same situations.

Reason this step is necessary:
The learner must recognize the word outside the first form-meaning card.

### Step 5: Guided Recall

Current learner state:
Recognizes it in a changed context.

Target learner state:
Recalls it with support.

Exact visible information:
Support-language prompt: "Write the Spanish word for `привіт`." Non-leaking cue:
"It is the word from the arrival situation."

Exact hidden information:
`Hola.`; `ола`; first letter; model answer; answer options.

Teacher/system action:
Ask for typed production with a communicative cue.

Learner action:
Type `Hola.`

Evidence:
Correct typed answer after the word has been hidden.

Failure interpretation:
The learner has not yet retrieved the written form.

Remediation:
Return to Step 4 recognition. Do not show the full answer inside the retry prompt.

Reason this step is necessary:
Recognition must become production before independent recall can be assessed.

### Step 6: Independent Recall After Brief Interference

Current learner state:
Recalls it with support.

Target learner state:
Recalls it independently.

Exact visible information:
One brief interference prompt using meaning only: "Is `привіт` a greeting or a
farewell?" Then the prompt: "Write `привіт` in Spanish."

Exact hidden information:
`Hola.`; `ола`; first letter; model answer; answer options.

Teacher/system action:
Insert one meaning-only interference decision, then request the Spanish form.

Learner action:
Answer the interference question, then type `Hola.`

Evidence:
Correct typed `Hola.` after the target form and pronunciation have been absent for one
intervening task.

Failure interpretation:
Independent recall is not established.

Remediation:
If meaning failed, return to Step 2. If spelling failed, return to Step 5 with no full
answer visible.

Reason this step is necessary:
The assessment must control for immediate copying and prove short-term independent
recall.

## Support Plan

Translation appears in Steps 1-2 and disappears before Steps 4-6.

Pronunciation appears in Steps 1 and 3 and disappears before Steps 4-6.

Examples appear only as situations, not as repeated model sentences.

Typed recall begins in Step 5. Independent recall begins in Step 6 after brief
interference.

## Assessment

Claimed capability:
The learner independently reads, understands, and types `Hola.`

Task:
After one meaning-only interference decision, type `Hola.` from the support-language
meaning `привіт`.

Evidence produced:
Correct typed Spanish form with no visible target form, pronunciation, first letter, or
model answer.

Alternative explanation:
Immediate repetition or visual copying.

Why the alternative explanation is controlled:
The target form and pronunciation are hidden before the task, and one intervening
meaning decision occurs before typing.

Minimum passing evidence:
Correct `Hola` with accepted punctuation/capitalization behavior defined before
implementation.

## Remediation

Wrong meaning:
Return to Step 2.

Correct meaning but reading failure:
Return to Step 3.

Correct sound but incorrect spelling:
Restore Step 5 guided recall and provide spelling feedback after submission only.

Copying instead of recall:
Remove any visible target answer and retry Step 6 after the interference decision.

Confusion between expressions:
Not applicable inside Lesson 1.

Contextually inappropriate but grammatically correct answer:
Return to Step 4.

## Closure

Тепер ви можете прочитати й написати `Hola.`

## Unique Lesson Identity

This lesson is the only lesson in Lessons 1-5 where the learner primarily turns one
unknown Spanish word into independent written recall.

---

# Lesson 2

## Lesson Title

Hello To Ana

## Lesson Goal

The learner independently writes `Hola, Ana.` to greet Ana.

## Starting Learner State

The learner recalls `Hola.` independently.

## Ending Learner State

Uses it in a meaningful context.

## New Knowledge Budget

| Category | New units |
|---|---|
| Target-language forms | `Ana` - genuinely new; `Hola, Ana.` - genuinely new combination |
| Meanings | Ana as a person's name - genuinely new |
| Reading rules | None; `Ana` is taught with pronunciation support as a name |
| Spelling rules | Comma in direct address - contextual only, not independently assessed |
| Grammar | None |
| Communicative functions | Greeting a specific person - genuinely new |
| Interaction conventions | A name can show who receives the greeting - genuinely new |

This is acceptable for A0 because it adds one transparent name and one use of a known
greeting. The comma is not a separate learning target.

## Why This Lesson Exists

The learner can write `Hola.` in isolation. This lesson makes the word social by
directing it to one person.

## Lesson Scenario

### Step 1: Retrieve The Known Greeting

Current learner state:
Recalls `Hola.` independently.

Target learner state:
Recognizes known material in a changed context.

Exact visible information:
Support-language situation: "You see Ana." Prompt: "What Spanish word can start a
greeting?" No Spanish answer visible.

Exact hidden information:
`Hola.`; `ола`; any model sentence.

Teacher/system action:
Begin from retrieval of the previous lesson instead of direct presentation of a new
form.

Learner action:
Type or select `Hola.` from memory.

Evidence:
Correct retrieval of `Hola.` without pronunciation or model answer.

Failure interpretation:
Prerequisite from Lesson 1 is not stable.

Remediation:
Return to Lesson 1 Step 6 style recall for `Hola.` before continuing.

Reason this step is necessary:
The new lesson depends on `Hola` as known material.

### Step 2: Attend To The Addressee

Current learner state:
Recognizes known material in a changed context.

Target learner state:
Attends to the new unit.

Exact visible information:
Name `Ana`; pronunciation `Ана`; support-language note: "Ana is the person you greet."

Exact hidden information:
Full sentence `Hola, Ana.`; typed task; distractors.

Teacher/system action:
Introduce only the person name and its role.

Learner action:
Identify Ana as the person being greeted.

Evidence:
The learner chooses Ana when asked "Who is receiving the greeting?"

Failure interpretation:
The learner has not attended to the addressee.

Remediation:
Show `Ana` with `Ана` and the role note again.

Reason this step is necessary:
The learner cannot construct an addressed greeting without knowing who is addressed.

### Step 3: Understand The Addressed Greeting

Current learner state:
Attends to the new unit.

Target learner state:
Understands its meaning.

Exact visible information:
`Hola, Ana.`; pronunciation `ола, Ана`; meaning `Привіт, Ana.`

Exact hidden information:
No typed response; no alternative names; no grammar explanation.

Teacher/system action:
Model the full greeting once.

Learner action:
Choose the meaning of the full greeting.

Evidence:
Correct choice: greeting Ana, not thanking Ana or saying goodbye to Ana.

Failure interpretation:
The learner has not connected the name to the greeting action.

Remediation:
Return to Step 2, then show the full model again.

Reason this step is necessary:
The learner must understand the whole communicative action before producing it.

### Step 4: Decode The New Name In The Phrase

Current learner state:
Understands its meaning.

Target learner state:
Can read or decode it with support.

Exact visible information:
`Ana`; `Ана`; `Hola, Ana.`; `ола, Ана`.

Exact hidden information:
Translation; typed answer.

Teacher/system action:
Focus on reading the name inside the greeting.

Learner action:
Match `Ana` to `Ана` and then read the full greeting with support.

Evidence:
Correctly matches `Ana` to `Ана` and does not confuse it with `Hola`.

Failure interpretation:
Name decoding is not established.

Remediation:
Restore `Ana` -> `Ана` only; do not reteach `Hola`.

Reason this step is necessary:
The new written unit is the name, not the already learned greeting.

### Step 5: Changed-Context Recognition

Current learner state:
Can read or decode it with support.

Target learner state:
Recognizes it in a changed context.

Exact visible information:
Situation A: "You greet Ana." Situation B: "Ana greets you." Spanish options:
`Hola, Ana.` and `Hola.`; no pronunciation support.

Exact hidden information:
Translation; full model sentence explanation.

Teacher/system action:
Ask which expression fits greeting Ana.

Learner action:
Choose `Hola, Ana.` for Situation A.

Evidence:
Correct choice of addressed greeting when the addressee role changes.

Failure interpretation:
The learner may recall `Hola` but not the addressed pattern.

Remediation:
Return to Step 3.

Reason this step is necessary:
The learner must distinguish isolated greeting from greeting a specific person.

### Step 6: Independent Contextual Production

Current learner state:
Recognizes it in a changed context.

Target learner state:
Uses it in a meaningful context.

Exact visible information:
Situation only: "Ana arrives. Greet Ana in Spanish." No Spanish text.

Exact hidden information:
`Hola`; `Ana`; `ола`; `Ана`; full model answer; first letters.

Teacher/system action:
Ask for the addressed greeting.

Learner action:
Type `Hola, Ana.`

Evidence:
Correct greeting to Ana with no visible Spanish support.

Failure interpretation:
If only `Hola.` appears, contextual use of addressee failed. If `Ana` is misspelled,
name spelling failed.

Remediation:
Only `Hola.` -> return to Step 5. Name spelling failure -> return to Step 4. Full
meaning failure -> return to Step 3.

Reason this step is necessary:
The lesson goal requires independent use of the addressed greeting.

## Support Plan

Translation appears only when the full addressed greeting is first taught. It is hidden
for changed-context recognition and final production.

Pronunciation appears for `Ana` and the full greeting before decoding. It is hidden for
final production.

Examples appear as one addressed greeting and then disappear before production.

Typed recall begins only in Step 6. Step 6 is both independent recall of the phrase and
contextual use.

## Assessment

Claimed capability:
The learner independently writes `Hola, Ana.` to greet Ana.

Task:
Given only the situation "Ana arrives. Greet Ana in Spanish," type the greeting.

Evidence produced:
Correct addressed greeting without visible target forms or pronunciation support.

Alternative explanation:
Memorizing the model sentence from moments earlier.

Why the alternative explanation is controlled:
The final task follows changed-context recognition where `Hola.` and `Hola, Ana.` were
contrasted, and all Spanish support is hidden.

Minimum passing evidence:
The answer includes the greeting and the name Ana. Punctuation/capitalization handling
must be defined before implementation and must not be the primary failure criterion.

## Remediation

Wrong meaning:
Return to Step 3.

Correct meaning but reading failure:
Return to Step 4.

Correct sound but incorrect spelling:
Restore Step 4 for the failed form only and retry Step 6.

Copying instead of recall:
Hide all Spanish support and retry Step 6 with the same situation after one brief
known-material prompt.

Confusion between two expressions:
Return to Step 5.

Contextually inappropriate but grammatically correct answer:
Return to Step 5 and contrast isolated greeting with addressed greeting.

## Closure

Тепер ви можете привітатися з Ana.

## Unique Lesson Identity

This lesson is the only lesson in Lessons 1-5 where the learner primarily transforms a
known greeting into a greeting addressed to a specific person.

---

# Lesson 3

## Lesson Title

Ana Asks A Greeting Question

## Lesson Goal

The learner independently reads and understands `¿Qué tal?` as the question `як справи?`
in a greeting exchange.

## Starting Learner State

The learner uses `Hola, Ana.` in a meaningful context.

## Ending Learner State

Recognizes it in a changed context.

## New Knowledge Budget

| Category | New units |
|---|---|
| Target-language forms | `¿Qué tal?` - genuinely new |
| Meanings | `як справи?` - genuinely new |
| Reading rules | Supported reading `ке таль` for this phrase - genuinely new support, not a broad rule |
| Spelling rules | Spanish question marks and accent are contextual only, not productively assessed in this lesson |
| Grammar | None |
| Communicative functions | Recognizing a friendly greeting question - genuinely new |
| Interaction conventions | After hello, someone may ask how you are - genuinely new |

This lesson deliberately does not teach `Bien.` The answer is deferred to Lesson 4 to
avoid overloading two new chunks in one lesson.

## Why This Lesson Exists

The learner can greet Ana but cannot yet understand the next move in a simple greeting
exchange. This lesson teaches the question only, so comprehension is secure before an
answer is introduced.

## Lesson Scenario

### Step 1: Predict The Next Move

Current learner state:
Uses `Hola, Ana.` in a meaningful context.

Target learner state:
Attends to the new unit.

Exact visible information:
Known line `Hola, Ana.`; support-language situation: "Ana replies with a question."
The Spanish question is shown: `¿Qué tal?`; pronunciation `ке таль`; meaning `як
справи?`

Exact hidden information:
No answer phrase; no typing task; no grammar explanation.

Teacher/system action:
Open with an incomplete interaction and reveal the question as Ana's next move.

Learner action:
Notice that `¿Qué tal?` is the new question.

Evidence:
The learner identifies `¿Qué tal?` as the new line, not `Hola, Ana.`

Failure interpretation:
The learner is attending to old material instead of the new question.

Remediation:
Hide the known greeting briefly and show only `¿Qué tal?` with its support.

Reason this step is necessary:
The new unit must enter as a conversational move, not a phrasebook entry.

### Step 2: Meaning Recognition

Current learner state:
Attends to the new unit.

Target learner state:
Understands its meaning.

Exact visible information:
`¿Qué tal?`; `ке таль`; answer options: `як справи?`, `привіт`, `до побачення`.

Exact hidden information:
No answer phrase; no model response; no typed task.

Teacher/system action:
Ask what Ana's question means.

Learner action:
Choose `як справи?`

Evidence:
Correct meaning against plausible greeting-domain distractors.

Failure interpretation:
Question meaning is not established.

Remediation:
Return to direct pairing `¿Qué tal?` -> `як справи?`, then retry with reordered
options.

Reason this step is necessary:
The learner must understand the question before later answering it.

### Step 3: Supported Decoding

Current learner state:
Understands its meaning.

Target learner state:
Can read or decode it with support.

Exact visible information:
`¿Qué tal?`; `ке таль`; reading prompt: "Read Ana's question."

Exact hidden information:
Translation choices; any answer phrase; typing.

Teacher/system action:
Focus on reading the question.

Learner action:
Match `¿Qué tal?` to `ке таль`.

Evidence:
Correctly chooses `ке таль` over `ке талі` and `куе таль`.

Failure interpretation:
Supported decoding is not established.

Remediation:
Restore `¿Qué tal?` -> `ке таль`, then retry the contrast.

Reason this step is necessary:
The learner must be able to read the question before recognizing it without support.

### Step 4: Changed-Context Recognition

Current learner state:
Can read or decode it with support.

Target learner state:
Recognizes it in a changed context.

Exact visible information:
Two short situations in support language: "Ana asks how you are" and "You greet Ana."
Spanish options: `¿Qué tal?` and `Hola, Ana.` No pronunciation support.

Exact hidden information:
Translations; pronunciation; answer phrase.

Teacher/system action:
Ask which Spanish line fits Ana asking how you are.

Learner action:
Choose `¿Qué tal?`

Evidence:
Correctly discriminates question from known greeting without pronunciation support.

Failure interpretation:
The learner may recognize the form only with support or may confuse greeting and
question.

Remediation:
If reading failed, return to Step 3. If meaning/function failed, return to Step 2.

Reason this step is necessary:
The lesson goal is independent recognition of the question in a greeting exchange.

### Step 5: Comprehension After Brief Interference

Current learner state:
Recognizes it in a changed context.

Target learner state:
Recognizes it in a changed context.

Exact visible information:
Brief interference: ask the learner to identify `Hola, Ana.` as a greeting. Then show
`¿Qué tal?` without pronunciation and ask what Ana is doing.

Exact hidden information:
`ке таль`; translation `як справи?`; any answer phrase.

Teacher/system action:
Insert a known-material recognition task, then return to the question.

Learner action:
Recognize `¿Qué tal?` as asking how someone is.

Evidence:
Correct comprehension after one intervening known-material task.

Failure interpretation:
The learner recognized the question only by immediate exposure.

Remediation:
Return to Step 2 or Step 3 depending on error.

Reason this step is necessary:
It controls for immediate recognition without claiming long-term retention.

## Support Plan

Translation appears in Steps 1-2 only. It is hidden for Steps 4-5.

Pronunciation appears in Steps 1 and 3 only. It is hidden for Steps 4-5.

No answer phrase appears in this lesson.

No typed recall of `¿Qué tal?` is assessed. The lesson outcome is reading and
understanding the question, not producing it.

## Assessment

Claimed capability:
The learner independently reads and understands `¿Qué tal?` as `як справи?`.

Task:
After a brief known-material interference task, identify what `¿Qué tal?` means/does in
the greeting exchange without pronunciation or translation support.

Evidence produced:
Correct discrimination of the question from `Hola, Ana.`

Alternative explanation:
Immediate recognition from the teaching card or elimination of weak distractors.

Why the alternative explanation is controlled:
The prompt includes one intervening known-material task and uses a previously taught
greeting as a plausible distractor.

Minimum passing evidence:
Correctly identifies `¿Qué tal?` as the "how are you?" question without pronunciation or
translation visible.

## Remediation

Wrong meaning:
Return to Step 2.

Correct meaning but reading failure:
Return to Step 3.

Correct sound but incorrect spelling:
Not assessed in this lesson.

Copying instead of recall:
Not applicable because production is not assessed; remove pronunciation/translation and
retry Step 5.

Confusion between two expressions:
Return to Step 4.

Contextually inappropriate but grammatically correct answer:
Not applicable because no answer is produced.

## Closure

Тепер ви розумієте питання `¿Qué tal?`

## Unique Lesson Identity

This lesson is the only lesson in Lessons 1-5 where the learner primarily understands a
new question without yet answering it.

---

# Lesson 4

## Lesson Title

Answer The Question

## Lesson Goal

The learner independently answers `¿Qué tal?` with `Bien.`

## Starting Learner State

The learner recognizes `¿Qué tal?` in a changed context.

## Ending Learner State

Uses it in a meaningful context.

## New Knowledge Budget

| Category | New units |
|---|---|
| Target-language forms | `Bien.` - genuinely new |
| Meanings | `добре` - genuinely new |
| Reading rules | Supported reading `б'єн` for this word - genuinely new support, not a broad rule |
| Spelling rules | None productively isolated; spelling of `Bien` is assessed only as part of the answer |
| Grammar | None |
| Communicative functions | Answering a greeting question - genuinely new |
| Interaction conventions | A question can invite a short answer - genuinely new |

This is acceptable because `¿Qué tal?` was taught in Lesson 3. Lesson 4 adds only the
answer.

## Why This Lesson Exists

The learner can understand the question but cannot yet respond. This lesson turns
comprehension into a short, useful answer.

## Lesson Scenario

### Step 1: Retrieve The Question Meaning

Current learner state:
Recognizes `¿Qué tal?` in a changed context.

Target learner state:
Recognizes known material after brief interference.

Exact visible information:
`¿Qué tal?` without pronunciation; support-language question: "What is Ana asking?"

Exact hidden information:
`ке таль`; `як справи?`; `Bien.`

Teacher/system action:
Start from comprehension of the known question.

Learner action:
Choose or state that Ana asks how you are.

Evidence:
Correct recognition of the question without support.

Failure interpretation:
Lesson 3 prerequisite is not established.

Remediation:
Return to Lesson 3 Step 5 style comprehension before continuing.

Reason this step is necessary:
The answer cannot be meaningful if the question is not understood.

### Step 2: Attend To The Answer

Current learner state:
Recognizes known material after brief interference.

Target learner state:
Attends to the new unit.

Exact visible information:
`Bien.`; pronunciation `б'єн`; meaning `добре`; known question `¿Qué tal?` as context.

Exact hidden information:
No typed task; no alternate answers; no grammar explanation.

Teacher/system action:
Present `Bien.` as the answer to the known question.

Learner action:
Notice that `Bien.` is the answer.

Evidence:
The learner identifies `Bien.` as the new answer line.

Failure interpretation:
The learner has not attended to the answer as a separate new unit.

Remediation:
Show only `¿Qué tal?` -> `Bien.` with `Bien.` highlighted as the new line.

Reason this step is necessary:
`Bien.` cannot enter as unexplained decoration.

### Step 3: Meaning Recognition

Current learner state:
Attends to the new unit.

Target learner state:
Understands its meaning.

Exact visible information:
`Bien.`; `б'єн`; answer options: `добре`, `привіт`, `як справи?`

Exact hidden information:
Question context; typed task; model sentence.

Teacher/system action:
Ask what `Bien.` means.

Learner action:
Choose `добре`.

Evidence:
Correct meaning against plausible greeting-domain distractors.

Failure interpretation:
The meaning of the answer is not established.

Remediation:
Return to direct pairing `Bien.` -> `добре`, then retry with reordered options.

Reason this step is necessary:
The learner must know what the answer means before using it.

### Step 4: Supported Decoding

Current learner state:
Understands its meaning.

Target learner state:
Can read or decode it with support.

Exact visible information:
`Bien.`; `б'єн`; reading options `б'єн`, `бієн`, `бін`.

Exact hidden information:
Translation; question context; typing.

Teacher/system action:
Focus on reading the answer.

Learner action:
Match `Bien.` to `б'єн`.

Evidence:
Correct reading selection.

Failure interpretation:
Supported decoding is not established.

Remediation:
Restore `Bien.` -> `б'єн` and retry.

Reason this step is necessary:
The learner must read the answer before producing it.

### Step 5: Changed-Context Recognition

Current learner state:
Can read or decode it with support.

Target learner state:
Recognizes it in a changed context.

Exact visible information:
Known question `¿Qué tal?`; answer options `Bien.` and `Hola, Ana.`; no pronunciation.

Exact hidden information:
Translation; pronunciation; model answer.

Teacher/system action:
Ask which line answers the question.

Learner action:
Choose `Bien.`

Evidence:
Correctly selects `Bien.` as an answer, not a greeting.

Failure interpretation:
The learner does not yet connect the answer to the question.

Remediation:
Return to Step 2 if role is unclear, Step 3 if meaning is unclear, Step 4 if reading is
unclear.

Reason this step is necessary:
The learner must recognize the answer function before producing it.

### Step 6: Guided Recall

Current learner state:
Recognizes it in a changed context.

Target learner state:
Recalls it with support.

Exact visible information:
`¿Qué tal?`; support-language cue: "Answer: добре." No Spanish answer.

Exact hidden information:
`Bien.`; `б'єн`; first letter; answer options.

Teacher/system action:
Ask the learner to write the Spanish answer with meaning support.

Learner action:
Type `Bien.`

Evidence:
Correct typed answer with no visible Spanish form.

Failure interpretation:
The answer is recognized but not recalled.

Remediation:
Return to Step 5, then retry Step 6.

Reason this step is necessary:
The learner must move from choosing the answer to producing it.

### Step 7: Independent Contextual Answer

Current learner state:
Recalls it with support.

Target learner state:
Uses it in a meaningful context.

Exact visible information:
`¿Qué tal?` only. No translation of the question. No support-language answer cue.

Exact hidden information:
`Bien.`; `б'єн`; `добре`; model answer; answer options.

Teacher/system action:
Ask the learner to answer Ana.

Learner action:
Type `Bien.`

Evidence:
Correct answer to the known question with all answer support hidden.

Failure interpretation:
The learner cannot yet use the answer in context.

Remediation:
If the question is misunderstood, return to Step 1. If the answer is forgotten, return
to Step 6. If spelling fails, provide feedback after submission and retry Step 7.

Reason this step is necessary:
This is the first independent use of `Bien.` as an answer.

## Support Plan

Translation for `Bien.` appears in Steps 2-3 and disappears before Steps 5-7.

Pronunciation for `Bien.` appears in Steps 2 and 4 and disappears before Steps 5-7.

The known question remains visible in Steps 5-7 because the task is answering it, not
recalling the question.

Typed recall begins in Step 6. Independent contextual recall begins in Step 7.

## Assessment

Claimed capability:
The learner independently answers `¿Qué tal?` with `Bien.`

Task:
Given only `¿Qué tal?`, type the Spanish answer.

Evidence produced:
Correct `Bien.` with no visible answer form, pronunciation, translation, first letter,
or options.

Alternative explanation:
One-to-one memorization of the immediately previous guided task.

Why the alternative explanation is controlled:
The learner first retrieved the question meaning, then recognized answer function, then
produced the answer with support before independent use. No answer support is visible in
the final task.

Minimum passing evidence:
Correct `Bien` with accepted punctuation/capitalization behavior defined before
implementation.

## Remediation

Wrong meaning:
Return to Step 3.

Correct meaning but reading failure:
Return to Step 4.

Correct sound but incorrect spelling:
Provide spelling feedback after submission only, then retry Step 7 without showing the
answer in the prompt.

Copying instead of recall:
Remove all answer support and retry Step 7 after Step 1 question retrieval.

Confusion between two expressions:
Return to Step 5.

Contextually inappropriate but grammatically correct answer:
Return to Step 5 and contrast greeting versus answer.

## Closure

Тепер ви можете відповісти `Bien.` на `¿Qué tal?`

## Unique Lesson Identity

This lesson is the only lesson in Lessons 1-5 where the learner primarily turns a
question they understand into an independent answer.

---

# Lesson 5

## Lesson Title

A Tiny Spanish Greeting

## Lesson Goal

The learner independently completes a tiny two-turn greeting exchange:
`Hola, Ana.` -> `¿Qué tal?` -> `Bien.`

## Starting Learner State

The learner can use `Hola, Ana.`, recognize `¿Qué tal?`, and answer it with `Bien.` in
separate lesson contexts.

## Ending Learner State

Uses known expressions in a meaningful multi-step context after brief interference.

## New Knowledge Budget

| Category | New units |
|---|---|
| Target-language forms | None |
| Meanings | None |
| Reading rules | None |
| Spelling rules | None |
| Grammar | None |
| Communicative functions | Combining known greeting and answer in one exchange - genuinely new skill |
| Interaction conventions | The exchange has roles and order - genuinely new skill |

No new Spanish words are introduced. Contextual material must not become assessed
material.

## Why This Lesson Exists

The learner has separate abilities. This lesson checks whether those abilities can be
coordinated in one small interaction without adding new language.

## Lesson Scenario

### Step 1: Interpret The Situation Before Seeing Lines

Current learner state:
Uses known expressions separately in meaningful contexts.

Target learner state:
Recognizes the communicative sequence.

Exact visible information:
Support-language situation only: "You meet Ana. You greet Ana. Ana asks how you are.
You answer."

Exact hidden information:
All Spanish lines; pronunciation; translations of individual lines.

Teacher/system action:
Start from the communicative situation, not from Spanish forms.

Learner action:
Identify the three communicative moves: greet Ana, understand the question, answer.

Evidence:
Correctly orders the moves in support language.

Failure interpretation:
The learner does not understand the interaction structure.

Remediation:
Show the three support-language moves one at a time, then retry ordering them.

Reason this step is necessary:
The learner must know the intended interaction before choosing Spanish lines.

### Step 2: Match Known Lines To Roles

Current learner state:
Recognizes the communicative sequence.

Target learner state:
Recognizes known expressions in a changed context.

Exact visible information:
Spanish lines `Hola, Ana.`, `¿Qué tal?`, `Bien.`; role labels in support language:
"greet Ana", "Ana asks how you are", "answer well."

Exact hidden information:
Pronunciation; translations as full sentences; typed response.

Teacher/system action:
Ask the learner to match each known Spanish line to its role.

Learner action:
Match all three lines to roles.

Evidence:
All three lines matched correctly.

Failure interpretation:
A specific known expression is not recognized in the integrated context.

Remediation:
Return only to the failed expression's prior lesson state: Lesson 2 Step 5, Lesson 3
Step 5, or Lesson 4 Step 5.

Reason this step is necessary:
Integration requires recognizing each known line's function before production.

### Step 3: Supported Reconstruction

Current learner state:
Recognizes known expressions in a changed context.

Target learner state:
Recalls known expressions with support.

Exact visible information:
Support-language sequence:
1. Greet Ana.
2. Ana asks how you are.
3. Answer well.
Spanish line bank: the three known lines, shuffled.

Exact hidden information:
Pronunciation; translations below the Spanish lines; model ordered exchange.

Teacher/system action:
Ask the learner to reconstruct the exchange from the shuffled known lines.

Learner action:
Place the lines in order.

Evidence:
Correct order without pronunciation or translation support.

Failure interpretation:
The learner recognizes individual lines but cannot coordinate them.

Remediation:
Return to Step 1 for sequence misunderstanding or Step 2 for line-function confusion.

Reason this step is necessary:
The learner must coordinate known pieces before free typing the exchange.

### Step 4: Independent Production After Brief Interference

Current learner state:
Recalls known expressions with support.

Target learner state:
Uses known expressions in a meaningful multi-step context after brief interference.

Exact visible information:
Brief interference: identify whether `¿Qué tal?` is a greeting question or an answer.
Then the support-language situation only: "You meet Ana. Greet Ana. Ana asks how you
are. Answer well."

Exact hidden information:
All Spanish lines; pronunciation; translations of individual lines; line bank; first
letters; model answer.

Teacher/system action:
Insert one known-material discrimination task, then ask for the exchange.

Learner action:
Type the three Spanish lines in order.

Evidence:
Correct production of the three-line exchange after the line bank and support have been
removed.

Failure interpretation:
The learner has not yet integrated the known expressions independently.

Remediation:
If one line fails, return to that line's prior state. If order fails, return to Step 3.
If the whole situation fails, return to Step 1.

Reason this step is necessary:
This is the only evidence that separate lesson capabilities can be coordinated without
visible answers.

## Support Plan

Translation appears only as whole-situation role descriptions. Line-by-line translations
are hidden before reconstruction and production.

Pronunciation does not appear by default because all Spanish forms were previously
taught. It returns only as remediation for a specific reading failure.

Examples appear as known lines in a shuffled line bank, not as a model answer. The line
bank disappears before independent production.

Typed recall begins in Step 4. Independent recall begins after brief interference and
without line bank support.

## Assessment

Claimed capability:
The learner independently completes the tiny greeting exchange using known expressions.

Task:
After one brief discrimination task, type the three-line exchange from a support-language
situation.

Evidence produced:
Correct production of `Hola, Ana.`, `¿Qué tal?`, and `Bien.` in order without visible
Spanish support.

Alternative explanation:
Memorizing the immediately preceding ordered model.

Why the alternative explanation is controlled:
No ordered model is shown in Step 3; only a shuffled line bank is used. Step 4 inserts a
known-material discrimination task and removes all Spanish lines.

Minimum passing evidence:
All three communicative moves are present and ordered correctly. Punctuation/accent
strictness must follow implementation policy and must not obscure the main capability.

## Remediation

Wrong meaning:
Return to the prior lesson state for the failed line.

Correct meaning but reading failure:
Restore pronunciation for the failed expression only.

Correct sound but incorrect spelling:
Provide feedback after submission, then retry the failed line or full exchange depending
on severity.

Copying instead of recall:
Remove the line bank and retry Step 4 after the discrimination task.

Confusion between two expressions:
Return to Step 2.

Contextually inappropriate but grammatically correct answer:
Return to Step 1 for role sequence, then Step 2 for line-role matching.

## Closure

Тепер ви можете привітатися з Ana, зрозуміти `¿Qué tal?` і відповісти `Bien.`

## Unique Lesson Identity

This lesson is the only lesson in Lessons 1-5 where the learner primarily coordinates
previously learned expressions into one complete greeting exchange.

---

# Cross-Lesson Dependency Table

| Lesson | Assumes from earlier lessons | Establishes for later lessons | Deferred capability |
|---|---|---|---|
| 1 | None | Independent recall of `Hola.` | Long-term retention of `Hola.` |
| 2 | Independent recall of `Hola.` | Contextual use of `Hola, Ana.` | Greeting other names; strict punctuation mastery |
| 3 | Contextual use of `Hola, Ana.` | Independent recognition/comprehension of `¿Qué tal?` | Producing the question; answering the question |
| 4 | Recognition/comprehension of `¿Qué tal?` | Independent answer `Bien.` | Alternate answers; asking back |
| 5 | Separate use/recognition of `Hola, Ana.`, `¿Qué tal?`, `Bien.` | Integrated use after brief interference | Long-term retention; farewell expressions; open-ended conversation |

Continuity verification:

- No forward references are assessed.
- No secondary chunk is treated as known without a prior state path.
- Contextual punctuation and accents are not silently treated as primary assessed
  material.
- No lesson claims long-term retention.

---

# Cognitive-Operation Comparison

| Lesson | Cognitive-operation sequence |
|---|---|
| 1 | observe new form -> choose meaning -> decode with support -> recognize function -> retrieve form -> retrieve after brief interference |
| 2 | retrieve prior word -> identify addressee -> understand addressed action -> decode new name -> discriminate isolated/addressed greeting -> construct addressed greeting |
| 3 | predict next conversational move -> choose question meaning -> decode question -> discriminate question from greeting -> recognize after brief interference |
| 4 | retrieve known question meaning -> attend to answer -> choose answer meaning -> decode answer -> link answer to question -> produce answer -> answer in context |
| 5 | interpret whole situation -> match known lines to roles -> reconstruct sequence from shuffled known lines -> produce full exchange after brief interference |

At least three lessons do not begin with direct target-form presentation:

- Lesson 2 begins with retrieval of prior knowledge.
- Lesson 3 begins with an incomplete interaction.
- Lesson 4 begins with retrieval of the known question.
- Lesson 5 begins with situation interpretation.

No two lessons have substantially identical operation sequences.

---

# State Paths For New Units

| Unit | State path established in Lessons 1-5 |
|---|---|
| `Hola.` | L1 Not introduced -> Attends -> Understands meaning -> Decodes with support -> Recognizes changed context -> Recalls with support -> Recalls independently. L2 uses it in meaningful context. |
| `Ana` | L2 Not introduced -> Attends -> Understands role in phrase -> Decodes with support -> Recognizes in addressed context -> Uses in meaningful context as part of `Hola, Ana.` |
| `Hola, Ana.` | L2 Not introduced as combination -> Attends -> Understands meaning -> Decodes with support -> Recognizes changed context -> Uses in meaningful context. L5 integrates it. |
| `¿Qué tal?` | L3 Not introduced -> Attends -> Understands meaning -> Decodes with support -> Recognizes changed context -> Recognizes after brief interference. L4/L5 use it as known prompt. |
| `Bien.` | L4 Not introduced -> Attends -> Understands meaning -> Decodes with support -> Recognizes changed context -> Recalls with support -> Uses in meaningful context. L5 integrates it. |
| Goodbye expression | Deferred. No goodbye expression is introduced or assessed in Lessons 1-5. |
| Polite expression | Deferred. No polite expression is introduced or assessed in Lessons 1-5. |
| Reading/spelling rules | Only local reading supports for `Hola`, `Ana`, `¿Qué tal?`, and `Bien` are taught. Broad spelling or punctuation rules are deferred. |

---

# Dictionary Test

The revised sequence is not a vocabulary catalog because:

- Lesson 1 teaches one complete first recall.
- Lesson 2 starts from retrieving a known word and addressing a person.
- Lesson 3 teaches only comprehension of a question.
- Lesson 4 teaches only answering that known question.
- Lesson 5 adds no new words and checks integration.

Remaining risk:
Lessons 1 and 4 can still feel card-like if implemented without clear situations. The
scenario therefore fixes visible/hidden information and requires changed-context
evidence before production.
