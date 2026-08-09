# R2E5N1 Clean Ukrainian Module 1 Report
Status: EVIDENCE
Scope: educational content localization phase evidence
Normative authority: EDUCATIONAL_CONTENT_LOCALIZATION.md

## Verdict

FAIL.

R2E5N1 did not create a production-ready Ukrainian Module 1 semantic bundle.
The phase stopped before device QA because the pre-device semantic coverage
gate failed.

## Starting State

HEAD:

```text
8229cd907ded7fff835224d0cbb59a3b66263a0d
```

Initial worktree status was clean and `git diff --check` was clean.

Reset readiness state remains active:

- Ukrainian UI is available.
- Russian UI is available.
- Ukrainian educational localization remains `rebuilding`.
- Russian educational localization remains `rebuilding`.
- English source fallback remains declared outside completed semantic scope.
- No Ukrainian module was added to `completedModules`.

## Canonical Scope

Canonical source: `Course.modules[0]` in
`app/assets/languages/spanish/curriculum/spanish_a0_course.json`.

Course ID:

```text
es.a0
```

Module 1 ID:

```text
es.a0.m01
```

Module 1 title source:

```text
First Words and Reading
```

Canonical lesson IDs:

```text
es.a0.m06.l016
es.a0.m01.l001
es.a0.m06.l017
es.a0.m01.l002
es.a0.m01.l003
es.a0.m01.l006
es.a0.m04.l010
```

Lesson count:

```text
7
```

The canonical scope is not a simple historical ID-prefix scope. It includes
lessons with `m06` and `m04` IDs because they are present in
`Course.modules[0].lessonIds`.

## Clean Authoring Attempt

The clean scaffold tool was run twice:

```text
dart run tool/create_semantic_localization_scaffold.dart --locale uk --module es.a0.m01 --output build/reports/uk_module_1_scaffold_a.json --force
dart run tool/create_semantic_localization_scaffold.dart --locale uk --module es.a0.m01 --output build/reports/uk_module_1_scaffold_b.json --force
```

Both runs produced:

```text
semantic scaffold units: 121
module: es.a0.m01
```

The two scaffold outputs were byte-identical (`cmp=0`).

Historical Ukrainian and Russian translations were not used as an authoring
source. No archived Ukrainian translation memory text was copied.

## Coverage Gate

The N1 module audit was updated to report coverage from the clean semantic
paths and to fail clearly when `uk/module_01.json` is absent.

Command:

```text
dart run tool/audit_semantic_ukrainian_module.dart --module es.a0.m01
```

Result:

```text
required identities in scope: 420
semantic covered fields: 0
coverage: 0.0%
legacy Ukrainian resolutions: 420
English source fallback inside scope: 420
Russian fallback: 0
missing values: 218
generated: 0
approved: 0
duplicate identities: 0
issues: 420
  semanticLesson.legacyFallback: 202
  semanticLesson.missingSemantic: 218
```

The clean scaffold currently covers only 121 candidate units and does not cover
the full N1 required scope. Missing or uncovered categories include:

- vocabulary target fields, examples, meanings and usage notes;
- older reusable `unit_1` vocabulary/dialogue/reading/template objects used by
  Module 1 lessons;
- Spanish target-owned fields that still need protected semantic identities;
- pronunciation IPA identities;
- Ukrainian pronunciation learner hints;
- pronunciation explanations;
- ReadingRule titles and explanations;
- ReadingRule articulation/common-mistake/grapheme presentation fields;
- WritingUnit-style introductory text where represented through reading and
  pronunciation data.

Because these gaps would leave Module 1 on English source fallback, the phase
met a stop condition and did not proceed to APK installation or device QA.

## Reset Integrity

The reset production validator still passes:

```text
dart run tool/validate_semantic_localization_units.dart
Semantic localization unit validation
units: 0
issues: 0
```

No partial Ukrainian Module 1 production bundle is active. The readiness
manifest was not advanced.

## Files Created

```text
docs/R2E5N1_CLEAN_UKRAINIAN_MODULE_1_REPORT.md
```

Scaffold diagnostics were generated under:

```text
app/build/reports/uk_module_1_scaffold_a.json
app/build/reports/uk_module_1_scaffold_b.json
```

## Files Modified

```text
app/tool/audit_semantic_ukrainian_module.dart
docs/R2E5N1_CLEAN_UKRAINIAN_MODULE_1_REPORT.md
```

The audit tool now behaves as an N1 diagnostic gate instead of throwing an
archived-tool exception.

## Device QA

Not run. Pre-device gates did not pass.

## Remaining Work

- Expand the clean scaffold/inventory to the full 420 required identities.
- Add semantic coverage for pronunciation, ReadingRule and WritingUnit-style
  educational support through production-approved semantic units.
- Author Ukrainian values from canonical English source and Spanish target
  context only.
- Re-run N1 gates until Module 1 coverage is 100%.
- Only then update readiness and run Redmi Note 8T device QA.

## Next Phase

Retry R2E5N1 after expanding the clean semantic inventory.
