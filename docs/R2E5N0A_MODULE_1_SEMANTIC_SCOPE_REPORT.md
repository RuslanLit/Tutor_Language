# R2E5N0A Module 1 Semantic Scope Report

## Verdict

PASS. The canonical Module 1 semantic scope extractor, scaffold generator and independent scope-only audit now reconcile. This phase did not author Ukrainian text and did not activate runtime localization.

## Starting State

- HEAD at start of this worktree pass: `a070fa0e1238661259e553d52ce95e94ec11662d`
- worktree was clean
- Ukrainian and Russian readiness stayed in reset/rebuilding state

## Canonical Scope

- course ID: `es.a0`
- module ID: `es.a0.m01`
- source: `Course.modules[0]`
- lesson IDs:
  - `es.a0.m06.l016`
  - `es.a0.m01.l001`
  - `es.a0.m06.l017`
  - `es.a0.m01.l002`
  - `es.a0.m01.l003`
  - `es.a0.m01.l006`
  - `es.a0.m04.l010`

## Original Gap

- old scaffold identities: `121`
- old audit required identities: `420`
- old missing identities: `299`

Root causes:
- the old generator read reset legacy localization entries instead of the canonical content graph;
- reusable dependencies outside module-id substring matches were missed;
- pronunciation and ReadingRule localization were not included in scaffold output;
- the old audit counted target-language-owned Spanish fields, IPA and ReadingRule orthographic patterns as localizable support-language units.

## Final Reconciled Inventory

- required identities: `263`
- scaffold identities: `263`
- shared identities: `2`
- module identities: `261`
- reusable dependency references: `68`
- missing: `0`
- extra: `0`
- duplicate identities: `0`
- ambiguous: `0`
- unresolved dependencies: `0`
- non-empty localized values: `0`
- approved units: `0`

## Semantic Type Breakdown

- `accessibilityDescription`: `1`
- `answerOptionLabel`: `15`
- `articulationHint`: `1`
- `commonMistakeExplanation`: `1`
- `communicativeOutcome`: `7`
- `courseTitle`: `1`
- `dialogueTitle`: `5`
- `dialogueTranslation`: `22`
- `exercisePrompt`: `30`
- `grammarExplanation`: `4`
- `grammarTitle`: `4`
- `graphemeExplanation`: `2`
- `learnerInstruction`: `7`
- `lessonDescription`: `7`
- `lessonObjective`: `7`
- `lessonTitle`: `7`
- `metadataLabel`: `36`
- `moduleTitle`: `1`
- `pronunciationExplanation`: `10`
- `pronunciationHint`: `20`
- `readingRuleDetailedExplanation`: `11`
- `readingRuleShortExplanation`: `11`
- `readingRuleTitle`: `11`
- `readingTitle`: `7`
- `readingTranslation`: `7`
- `vocabularyMeaning`: `20`
- `vocabularyUsageNote`: `8`

## Asset Category Breakdown

- `course`: `1`
- `dialogue`: `27`
- `exercise_template`: `45`
- `grammar`: `8`
- `lesson`: `21`
- `lesson_activity`: `29`
- `lesson_objective`: `7`
- `lesson_section`: `7`
- `lesson_summary`: `7`
- `module`: `1`
- `pronunciation_unit`: `30`
- `reading`: `14`
- `reading_rule`: `38`
- `vocabulary`: `28`

## Source Asset Breakdown

- `assets/languages/spanish/curriculum/spanish_a0_course.json`: `73`
- `assets/languages/spanish/dialogues/module_1_first_words.json`: `17`
- `assets/languages/spanish/dialogues/unit_1_first_contact.json`: `10`
- `assets/languages/spanish/grammar/module_1_first_words.json`: `6`
- `assets/languages/spanish/grammar/module_2_names.json`: `2`
- `assets/languages/spanish/pronunciation/reference_slice.json`: `68`
- `assets/languages/spanish/readings/module_1_first_words.json`: `6`
- `assets/languages/spanish/readings/module_2_names.json`: `2`
- `assets/languages/spanish/readings/unit_1_first_contact.json`: `6`
- `assets/languages/spanish/templates/module_1_first_words.json`: `28`
- `assets/languages/spanish/templates/module_2_names.json`: `7`
- `assets/languages/spanish/templates/unit_1_first_contact.json`: `10`
- `assets/languages/spanish/vocabulary/a0_c2_core.json`: `3`
- `assets/languages/spanish/vocabulary/module_2_names.json`: `2`
- `assets/languages/spanish/vocabulary/unit_1_first_contact.json`: `23`

## Generator Independence

The generator writes scaffold units from a canonical scope extractor. The audit re-extracts canonical scope and compares a scaffold JSON file against the independently computed required identities. It does not import a generated expected list from the scaffold.

## Determinism

- two Ukrainian scaffold runs were byte-identical via `cmp`;
- Ukrainian and Russian scaffold identity tuples matched exactly;
- no timestamps or volatile metadata are emitted.

## Exclusions

Excluded as localization units: Spanish target text, IPA, canonical answers, accepted answers, ReadingRule orthographic patterns, stable IDs, hidden metadata, developer issue codes and Flutter UI ARB strings. These can appear only as context or protected spans.

## Runtime Integrity

No readiness manifest, production bundle, Lesson Player runtime behavior, fallback policy or learner progress path was changed. Production Ukrainian and Russian semantic units remain `0`.

## Next Phase

R2E5N1 — Clean Ukrainian Shared and Module 1 Semantic Authoring.
