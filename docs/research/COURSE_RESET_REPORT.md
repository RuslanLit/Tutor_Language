# Course Reset Report

Status: R2E14 course reset (historical baseline; superseded by canonical Lessons 1–5 rebuild).

## Summary

The Spanish A0 educational course was reset to a minimal placeholder. The
previous roughly 70-lesson Spanish course was treated as an experimental
prototype and removed from the active asset tree. This report records that
intentional reset; the placeholder was subsequently replaced by the canonical
five-lesson foundation described below.

The platform architecture remains intact. No lesson player, lesson session,
answer evaluation, learner progress, database, routing, content schema,
validator, localization framework or loading infrastructure redesign was
performed.

## Removed Assets

Removed Spanish educational content under `app/assets/languages/spanish/`:

- curriculum lessons and old course definitions;
- vocabulary assets;
- grammar assets;
- dialogue assets;
- reading assets;
- exercise templates;
- pronunciation assets;
- educational support localization;
- semantic localization bundles;
- semantic pilot assets;
- obsolete lesson references.

The only remaining non-placeholder language metadata is
`app/assets/languages/spanish/language.json`.

## Removed Tests

Removed obsolete tests that asserted the experimental Spanish course,
pronunciation assets, semantic localization assets or module-specific content:

- Spanish active-course acceptance and integrity tests;
- module-specific content tests;
- Spanish pronunciation content tests;
- semantic localization asset tests;
- semantic scope tests;
- semantic pilot QA tests;
- old canonical/reference lesson tests;
- Lesson Player pronunciation asset tests.

Preserved tests cover platform behavior using local fixtures, including:

- content schemas and parsers;
- educational content catalog and validator;
- answer evaluation;
- lesson session engine;
- learner progress;
- competency engine;
- navigation service and screen behavior;
- lesson player behavior;
- routing and application UI.

## Preserved Architecture

The following platform pieces were not redesigned:

- Flutter application architecture;
- Lesson Player;
- lesson assembly service;
- lesson session engine;
- answer evaluator;
- learner progress persistence;
- competency engine;
- database schema and migrations;
- localization framework;
- educational content schemas;
- validators;
- asset loading infrastructure;
- routing and application UI.

## Reset Baseline Files (Historical)

The reset baseline consisted of:

- `app/assets/languages/spanish/language.json`
- `app/assets/languages/spanish/curriculum/spanish_a0_course.json`
- `app/assets/languages/spanish/curriculum/course.json`
- `app/assets/languages/spanish/curriculum/lessons/index.json`
- `app/assets/languages/spanish/curriculum/lessons/es.a0.m01.l001.json`
- `app/assets/languages/spanish/grammar/placeholder.json`
- `app/assets/languages/spanish/vocabulary/empty.json`
- `app/assets/languages/spanish/dialogues/empty.json`
- `app/assets/languages/spanish/readings/empty.json`
- `app/assets/languages/spanish/templates/empty.json`
- `app/assets/languages/spanish/localization/support_localizations.json`
- `app/assets/languages/spanish/localization/semantic/manifests/educational_locales.json`
- `app/assets/languages/spanish/localization/semantic/uk/shared.json`
- `app/assets/languages/spanish/localization/semantic/ru/shared.json`
- `app/assets/languages/spanish/pronunciation/empty.json`

The reset baseline course shape was:

```text
Spanish A0
-> Module 1
-> Lesson 1
-> Content coming soon.
```

## Runtime Content References at Reset

The production semantic pilot scope is empty after reset. The bundled
pronunciation loader now points at the empty pronunciation bundle. The default
communicative competency registry contains no Spanish A0 competency definitions
or template references until new approved course content is authored. In the
current canonical five-lesson `es.a0.m01` course, no communicative competency
checkpoint is authored or displayed; the competency subsystem remains available
for future authored modules.

## Documentation Handling

Course-specific phase reports, blueprint reports, pronunciation inventories and
semantic localization reports for the experimental Spanish course were removed.
General architecture and authoring standards were preserved. Broad documents
that mix platform-level guidance with historical Spanish examples require a
separate documentation cleanup pass before they can be safely removed in full.

## Notes

The placeholder existed only to keep the offline application loadable while the
course was rebuilt from an approved blueprint. It contained no Spanish
instructional material.

## Canonical Lessons 1–5 Rebuild

The reset was intentionally followed by a canonical Spanish A0 foundation of
five lessons:

- `es.a0.m01.l001` through `es.a0.m01.l005`;
- one module, `es.a0.m01`;
- standalone LessonDefinition files indexed by
  `app/assets/languages/spanish/curriculum/lessons/index.json`;
- reusable canonical vocabulary, grammar, dialogue and exercise-template
  assets.

The runtime-authoritative course file is
`app/assets/languages/spanish/curriculum/spanish_a0_course.json`. The older
`curriculum/course.json` representation remains as a compatibility mirror and
is required to be byte-for-byte equivalent as parsed JSON by
`curriculum_loader_test.dart`; it is not an independently maintained course.

The rebuild intentionally preserves the platform architecture and does not
restore the prototype lessons. Tests that asserted the former 70-lesson
course were replaced by course-size-independent checks for lesson loading,
stable IDs, prerequisite validity, module references, content resolution and
deterministic assembly. The reset is separate from later pedagogical revision
of Lessons 1–5; it is not evidence that Lessons 6–10 exist or are approved.

No commit was created.
