# Live Tutor Lesson Corpus Analysis
Status: EVIDENCE
Scope: Spanish course design or implementation evidence
Normative authority: SPANISH_A0_CURRICULUM_BLUEPRINT.md

## Purpose and evidence policy

This is a docs-only analysis of the real tutor-material corpus in lesson_exersize/. It informs Spanish A0 authoring and the curriculum/learning-engine boundary; it does not authorize copying source content into the app.

**OBSERVED** means directly visible. **INFERRED** means a cautious interpretation of repeated observations. **HYPOTHESIS** means a design possibility requiring validation.

## Scope, inventory, and limitations

I recursively inspected every file in lesson_exersize/. There are 30 files, all PDFs, totaling 130 pages. pdfinfo and pdftotext -layout succeeded for every file with zero extraction errors. The source directory was not modified and no generated file was placed inside it.

This is a small mixed corpus: lesson plans, sequences, homework, a third-party worksheet, handouts, revisions, multiple learners, learner annotations, and A1–A2 material. It contains no attendance, recording, delayed-retention, or comparative-outcome data. It supports analysis of tutor workflow and authored-task patterns, not claims of causal learning efficacy.

| File | Pages | Classification after reading contents |
|---|---:|---|
| 1. Warm-up Speaking (5 minutes).pdf | 5 | Lesson 3 hotel: warm-up, mini-dialogues, role-play, grammar, reading, test; annotated |
| 1. Warm-up — 5 min.pdf | 6 | A1 food/favorite plate: adjectives, articles, ordering, reading, homework/test; annotated |
| 1. Warm-up — Shopping & Clothes.pdf | 5 | A1 online shopping: clothes, prices, have got, reading, role-play, homework; annotated |
| 14.pdf | 4 | Lesson 4 bag/everyday items: vocabulary, possessive 's, exercises, homework; anonymous filename; annotated |
| A1 English Lesson – Family.pdf | 4 | A1 family vocabulary, be, possessives, reading, speaking; annotated |
| A1 English Lesson – My Home and Family.pdf | 4 | A1 family review, home vocabulary, be, possessives, there is/are; annotated |
| A1 English Lesson – My Room and Prepositions.pdf | 5 | A1 family/home review, room vocabulary, prepositions, reading/homework; annotated |
| A1 English Lesson – Talents and Skills.pdf | 5 | A1 demonstrative review, skills, can/can't, quiz/homework; annotated |
| A1 English Lesson – This  That  These  Those.pdf | 4 | A1 room review, demonstratives, prepositions, reading/homework; annotated |
| Around Town  У місті.pdf | 5 | A1+ town places, there is/are, some/any, reading, speaking, homework; annotated |
| Clothes-A1-Students-worksheet.pdf | 5 | External A1 clothing/colour/descriptions/bingo worksheet; University of Kent copyright |
| Do you have a phone —.pdf | 4 | Lesson 8 A1 wishlist/phone, much/many, reading, mini-test/homework; annotated |
| Food & Daily Life.pdf | 4 | Lesson 1 A1 cooking actions, imperatives, recipe reading, homework; annotated |
| Homework.pdf | 6 | Full 55-minute weather/seasons lesson plus homework despite filename; annotated |
| I am hungry  thirsty..pdf | 5 | Lesson 5 A1 feelings/self-care, can, dialogue, game, homework; annotated |
| Lesson Clothes & Style.pdf | 2 | Short clothes/style lesson: wearing, reading, quiz; annotated |
| Lesson Plan (A2, Adult Students, Pair Work)-5.pdf | 3 | A1+ adult everyday objects, some/any, reading, discussion; filename/body level mismatch |
| Lesson Plan Question Words (“In the City”).pdf | 5 | A1 city places, question words, pair work, reading, quiz/homework; annotated |
| Lesson Plan — “Jobs and Work” (2).pdf | 5 | A2 jobs, reading, discussion, homework; one learner; annotated |
| Lesson — Weather & Seasons.pdf | 4 | A1/A1+/early-A2 weather, idioms/slang, reading, practice/homework; annotated |
| Lesson_Plan_Daily_Routine_&_Present_Simple_A1–A2,_60_min_3.pdf | 4 | A1–A2 daily routine/present simple, reading, production homework; annotated |
| Level_A1_Focus_Review_—_Body_parts,_To_be,_Numbers,_Colours,_There.pdf | 6 | Broad A1 review/test: body, be, numbers, colours, there is/are; annotated |
| Slang_🕓_“See_you_later!”_–_Побачимось_пізніше!.pdf | 5 | A1 daily time, at/on/in, idiom/slang, reading, pair speaking/homework; annotated |
| The Body + Have got  Has got (A1).pdf | 4 | A1 body vocabulary and have/has got, translation, reading, quiz; annotated |
| Time 60 minutes Focus Vocabulary • Reading • Speaking-2.pdf | 4 | A1+ city transport, spoken chunks, reading, homework; annotated |
| Word_Bank_desk_•_chair_•_bed_•_sofa_•_shelf_•_lamp_•_armchair_•.pdf | 4 | A1–A1+ furniture/comfort word bank, grammar, reading/homework |
| Word_Bank_tired_•_neighbour_•_late_•_busy_•_problem_•_rules_•_noise.pdf | 3 | A1–A1+ rules/problems/advice word bank and exercises |
| have_got_handout.pdf | 2 | Standalone have got/has got worksheet with monster task |
| healthy_–_здоровий_unhealthy_–_нездоровий.pdf | 4 | Lesson 6 A1 healthy food, food habits, reading/homework; annotated |
| лера.pdf | 4 | Named-learner A2 diagnostic/lesson: hobbies and present simple vs continuous; annotated |

Summary: 30 raw; 30 successfully inspected; 28 lesson-bearing packets; 2 support-only items (external worksheet and have-got handout); 0 unreadable files. SHA-256 and extracted-text comparison found 0 byte-identical duplicates. There are 8 thematic overlap/version clusters: clothing, food/health, family/home/room, body/have got, city, weather, objects, and daily-life/time. These are analytical clusters, not claims that files are duplicates.

## Duplicate/version and sequence findings

**OBSERVED:** Repeated topics include food/cooking → favorite-plate description → healthy food; shopping/clothes/style plus an external clothing worksheet; family → home/family → room/prepositions → demonstratives; body/have got plus a handout and broad review; weather/seasons in two packets; and city places/question words plus transport.

**INFERRED:** This is a tutor working-assets folder, not one canonical chronological course. Numbered labels are unreliable: “Lesson 3” appears for hotel and shopping, while 14.pdf is internally Lesson 4 and the phone packet is Lesson 8.

The strongest supported chain is Family → My Home and Family → My Room and Prepositions → This / That / These / Those → Talents and Skills. The food chain is probable but not proven as chronology. Other links are topical rather than chronological.

## Recurring live-tutor micro-structure

**OBSERVED:** Most full packets use a flexible 55–70 minute arc: 5–10 minute personal warm-up; vocabulary list and translation/matching; one grammar focus; controlled gap-fill/choice/translation; short reading or model dialogue; speaking, pair work, role-play or guessing; homework, often with a quiz/test.

**INFERRED:** The transferable unit is an objective-coherent arc from personal activation to supported production and a final meaningful-use attempt. The app should not hard-code all sections; current authoring guidance correctly says the resource list is not a default sequence.

## Warm-up, retrieval, and communicative expansion

**OBSERVED:** Warm-ups are personal questions with sentence starters: hotel experience, food, clothing, bag contents, feelings, town, routine and hobbies. Learner answers and corrections are frequently written into the PDFs.

| Retrieval type | Evidence | Confidence |
|---|---|---|
| Adjacent review | Family/home/room/demonstratives chain; explicit previous-topic reviews | Strong |
| Cued recall | Many gap-fills, matching, translation and sentence completion tasks | Strong |
| Reading retrieval | True/False, short answers, vocabulary-find tasks | Moderate |
| Communicative reuse | Hotel requests/problems, food ordering, shopping budget, town discussion, transport, self-care | Moderate/strong in selected packets |
| Nonadjacent review | Repeated body, food, weather, clothes and have-got themes without timing data | Weak/moderate |
| Formal review | Broad A1 review/test packet | Strong as a packet, not a course schedule |
| Delayed retrieval | No delayed learner results or schedule | None |

**Retrieval verdict:** useful evidence for active-recall authoring, not evidence of robust spaced retrieval. Most review is adjacent and recognition/cued recall; free production occurs in personal writing, role-play and discussion.

**Communicative-expansion verdict: USEFUL BUT UNEVEN.** Room language gains location and demonstrative functions; city language moves from definitions to there is/are, questions, reading and discussion; food moves into description, ordering and health; hotel language moves into requests and problem handling. Other packets stop at matching, gap-fill or scripted repetition. Completion must not be treated as independent communication.

## Vocabulary, grammar, scaffolding, rhythm, personalization

**OBSERVED:** Packets commonly list roughly 8–15 target words, then add bonus words, translations, pronunciation spellings, adjectives, idioms or scenario vocabulary. Readings sometimes contain unexplained burden. A live tutor can select, translate, correct or skip in real time.

**INFERRED:** A0 app lessons should keep active vocabulary stricter than many source packets and distinguish active targets from contextual exposure.

Grammar is usually a concise bilingual rule table followed by controlled practice: articles, have got, can, there is/are, some/any, demonstratives, prepositions, present simple and question words. The useful mechanism is “communicative need → short model → guided contrast → use,” not the source quantity; some packets combine review grammar and contain inconsistent examples.

Scaffolds include Ukrainian translations, pronunciation spellings, sentence starters, word banks, choices, model dialogues and role assignment. Sentence starters and role constraints are portable. Live translation, reformulation, omission, probing and real-time reordering are teacher-dependent. Support often decreases toward speaking/homework, but not systematically.

Activity rhythm is usually 5–15 minutes per mode with several changes. This is a useful attention/diagnostic pattern, not a reason for decorative switching.

Portable personalization: personal prompts, “my home/town/day/food,” bounded choices, short writing, role selection and learner-specific examples. Teacher-dependent personalization: interpreting free answers, selective correction, instant translation, omission, probing, emotional support and real-time reordering.

## Teacher role and app boundary

| Live tutor function | App replacement/boundary |
|---|---|
| Elicit experience and keep conversation moving | Authored prompts, bounded response modes, competency tasks |
| Diagnose pronunciation/grammar/vocabulary | Supported evaluator and authored misconception feedback; pronunciation remains separately validated |
| Translate/paraphrase instantly | Localized support and hints; engine must not invent teaching text |
| Select/reorder/shorten activities | Curriculum constraints plus deterministic planner/session consequences |
| Model the other role | Authored dialogues, role branches and controlled application |
| Repair communication and offer alternatives | Authored accepted-with-feedback variants and deterministic remediation |
| Encourage and personalize | Tone, pacing, optional supports and safe closure; do not claim human empathy equivalence |

The engine should replace operational decisions, not generate educational content.

## Weaknesses and practices not to copy

**OBSERVED:** The packets contain spelling and grammar errors, answer leakage, mismatched labels, ambiguous prompts, repeated/malformed numbering, level/title conflicts and teacher annotations embedded beside learner material. Some readings/tests contain hidden or inconsistent burden. A live tutor can repair these defects; a deterministic app cannot depend on that compensation.

Do not copy large unbounded word lists, unexplained idiom/slang bundles, multiple new grammar concepts in one assessment, answer-leaking quizzes, teacher annotations as learner-facing text, exact numbering/topic sequence, third-party worksheet content, or unreviewed translations/pronunciation hints.

## Classroom session versus app lesson

| Dimension | Live corpus | App implication |
|---|---|---|
| Duration | Usually 55–70 minutes | Preserve objective/progression; allow shorter resumable sessions |
| Adaptation | Continuous teacher reaction | Explicit constraints, support levels, retry and authored review references |
| Speaking | Tutor/pair role-play and open answers | Bounded production and competency checks; open response may be diagnostic |
| Feedback | Selective contextual correction | Authored feedback teaches the next attempt; engine selects consequence |
| Materials | Plan, worksheet, notes and homework coexist | Separate Educational Content, LessonDefinitions and runtime state |
| Assessment | Often a final quiz/test | Continuous assessment; meaningful use, not recognition alone |

## Comparison with normative documentation

| Normative rule | Corpus evidence | Assessment |
|---|---|---|
| EDUCATIONAL_PRINCIPLES: active retrieval | Many gap-fills/translations/production, also many choice tasks | Direction confirmed; source mixed |
| Communicative expansion | Strong in hotel/city/food/room chains, weak elsewhere | Principle confirmed as criterion |
| Gradual removal of support | Scaffolds common, reduction inconsistent | Need confirmed; schedule not established |
| AUTHORING_STYLE_GUIDE: useful vocabulary/natural dialogues | Real-life topics and role prompts recur; some dialogues overloaded | Goal confirmed; source not release-ready |
| CONTENT_AUTHORING_GUIDE: introduce before use, limits, one grammar concept | Frequently supported, sometimes violated | Normative rule should stay stricter |
| COURSE_AUTHORING_GUIDE: review every 4–6 lessons | Review packet exists, no reliable schedule | Not empirically confirmed |
| LEARNING_MODEL: recognition → cued/free recall → application | Often visible locally | Strongly compatible |
| CURRICULUM_SPEC: order/content vs engine scheduling | Mixed folder has no stable order | Boundary strongly confirmed |
| Review protocol/checklist | Source exhibits hidden burden, leakage and language defects | Confirms why protocol is necessary |

## Curriculum versus Learning Engine

Curriculum should own the communicative target, references, prerequisites, vocabulary/grammar scope, activity shape, review references and competency criteria. The Learning Engine should own eligibility, learner-state interpretation, retry, review priority, remediation selection from authored material and session progression. The corpus supports this split because plans contain authored objectives/tasks while tutor adaptation is situational; it does not support lesson generation in the engine.

## 70/30 and 80/20

The corpus cannot validate a numeric ratio. It labels minutes but records neither actual elapsed time nor learner/teacher turn counts. A five-minute warm-up is not evidence that 30% of a lesson was communication.

**Verdict:** treat 70/30 and 80/20 as provisional authoring heuristics, not empirical findings. If retained, define denominator and measurement first. The defensible qualitative rule is substantial evidence of learner retrieval and meaningful use while explanation/scaffolding remain bounded.

## Transferability matrix

| Practice | Portability | Condition |
|---|---|---|
| Personal warm-up | High | Declare response mode and support |
| Vocabulary list/translation | Medium | Cap active load; add examples/review |
| Short grammar model | High | One concept and reviewed localization |
| Gap-fill/translation | High | Deterministic evaluation and feedback |
| Reading + True/False | Medium | Known vocabulary; not mastery proof |
| Model dialogue | High | Clear purpose; limited unknown language |
| Role-play | Medium | Bounded branches or diagnostic-only open response |
| Pair discussion | Medium | Scaffolds and supported response path |
| Teacher reformulation | Low as automation | Encode variants/remediation explicitly |
| Homework packet | Medium | Optional/scheduled practice with provenance |
| Idiom/slang enrichment | Low for A0 | Only when immediately communicative |
| Mixed review test | Medium | Split by objective and fair retrieval |

## Empirical tutor model and recommendations

The most defensible model is: personal activation → small target set → concise form model → guided recall → short contextual input → personal/role-based use → correction/review → optional homework. This is recurring workflow, not a mandatory lesson template.

Recommendations: keep curriculum/engine separation; add guidance for personal warm-ups, bounded role prompts and support states; keep active vocabulary limits stricter; require each later lesson to name an earlier capability and a new function; preserve recognition → cued recall → freer production; treat annotations, third-party worksheets and source errors as review evidence; do not infer a chronological Spanish A0 sequence.

## Proposed documentation amendments (not implemented)

| Current rule/evidence | Proposed change | Why | Risk | Confidence |
|---|---|---|---|---|
| Warm-ups are common but unspecified | Require response mode, support and whether evidence affects planning | Makes diagnosis portable/reviewable | Over-formalization | Medium |
| Communicative expansion is a principle | Require each later LessonDefinition to name prior capability + new function | Makes it checkable | Artificial links/author burden | High |
| Active/exposure vocabulary is mixed | Distinguish active target from contextual exposure | Models tutor practice without overload | Schema/validator work | Medium |
| Corpus supports local review, not spacing | State this limitation; keep scheduling engine-owned | Prevents overclaiming | Less prescriptive | High |
| Role-play is common | Add guidance for bounded variants and diagnostic open response | Preserves interaction within determinism | Loses naturalness | Medium |
| Numeric ratios have no measure | Mark 70/30/80/20 as heuristics unless measured | Prevents false precision | Less memorable | High |

No normative document was modified.

## Implications for canonical Lessons 6–10

Principles only: one measurable communicative capability; short personal activation; small active lexical set; explicit reuse of an earlier capability in a new function; recognition → cued recall → controlled/independent application; concise grammar only when needed; bounded role/repair moves; authored support levels with reduced support later; mostly known reading/dialogue vocabulary; engine-owned adaptation/review priority; final evidence of meaningful use rather than quiz score.

## Open questions, confidence, verdict, and validation

Open questions: how often tutors used/reordered planned tasks; which warm-up answers changed the lesson; independent learner-turn proportion; immediate versus delayed correction; whether repeated topics reflect spacing, difficulty or different learners; delayed recall; role-play portability; and an operational definition of “communication time.”

Corpus-access confidence is **high**: 30/30 files found, typed, page-counted and extracted. Pattern confidence is **moderate**: recurring structures are clear but provenance/chronology are mixed. Efficacy confidence is **low**: no controlled or delayed-outcome data.

**Overall verdict: EMPIRICAL EVIDENCE USEFUL WITH LIMITATIONS.**

Created: docs/research/LIVE_TUTOR_LESSON_CORPUS_ANALYSIS.md. Modified: no app code, existing course content, canonical Lessons 1–5, normative documentation, tests or source corpus files.

Validation: recursive inventory 30; all 30 MIME PDFs; 130 pages; extraction 30/30 with zero errors; SHA-256 comparison found no byte-identical duplicates.
