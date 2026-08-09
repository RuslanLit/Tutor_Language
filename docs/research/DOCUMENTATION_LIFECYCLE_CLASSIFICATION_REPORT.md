# Documentation Lifecycle Classification Report

Status: EVIDENCE
Scope: D2B documentation lifecycle metadata migration
Normative authority: DOCUMENTATION_AUTHORITY.md

## Summary

D2B added one compact lifecycle metadata block to the existing Markdown
documentation corpus. The block uses the controlled vocabulary from
`DOCUMENTATION_AUTHORITY.md` and records `Status` and `Scope`, adding an owner
or supersession reference where useful. This report records the migration; it
does not create new normative policy.

The pre-report corpus contained **94 Markdown documents** under `docs/` plus
the applicable root `README.md`. Including this report, the resulting corpus
contains **96 classified Markdown documents**. The four TSV artifacts were not
modified; their associated audio reports and authority context identify them as
evidence artifacts.

## Summary Counts

Counts below include this EVIDENCE report itself:

| Lifecycle status | Count |
|---|---:|
| NORMATIVE | 23 |
| DERIVED | 15 |
| DECISION_RECORD | 2 |
| EVIDENCE | 43 |
| PROPOSAL | 8 |
| HISTORICAL | 4 |
| ARCHIVED | 1 |
| **Total** | **96** |

## Classification Rules Applied

- Current scoped owners were marked `NORMATIVE`.
- Operational guides and checklists were marked `DERIVED` and identify their
  canonical owner.
- `ARCHITECTURAL_DECISIONS.md` and `AUTHORING_DECISIONS.md` were marked
  `DECISION_RECORD`.
- Phase reports, audits, implementation reports, inventories, migration
  records and QA reports were marked `EVIDENCE`.
- Research designs, candidate standards and unadopted principles were marked
  `PROPOSAL` with explicit non-adoption language.
- V1 and explicitly superseded retained material was marked `HISTORICAL`.
- `docs/archive/` material was marked `ARCHIVED`.

Existing substantive bodies were not rewritten. Existing historical facts or
phase wording remain body content; the new controlled metadata is the lifecycle
classification used for authority routing.

## Authority Links Added

Explicit canonical/normative owner links were added to **57** derived/evidence
documents: 15 derived documents and 42 evidence documents with an unambiguous
current owner. Four historical documents also received explicit supersession
references.

### Derived documents

- `PROJECT_STRUCTURE.md` -> `ARCHITECTURE.md`
- root `README.md` -> `DOCUMENTATION_AUTHORITY.md`
- `CONTENT_AUTHORING_GUIDE.md` -> `CONTENT_MODEL.md`
- `COURSE_AUTHORING_GUIDE.md` -> `CURRICULUM_SPEC.md`
- `AUTHORING_STYLE_GUIDE.md` -> `EDUCATIONAL_LANGUAGE_STANDARD.md`
- `CONTENT_REVIEW_CHECKLIST.md` -> `CONTENT_REVIEW_PROTOCOL.md`
- `LESSON_AUTHORING_ENTRYPOINT.md` -> `CONTENT_MODEL.md` and
  `PEDAGOGICAL_SCENARIO_MODEL.md`
- `GRAPHEME_PRESENTATION_STANDARD.md` -> `WRITING_SYSTEM_STANDARD.md`
- `WRITING_UNIT_INTRODUCTION_STANDARD.md` -> `WRITING_SYSTEM_STANDARD.md`
- `PRONUNCIATION_AUTHORING_GUIDE.md` -> `PRONUNCIATION_MODEL.md`
- `SEMANTIC_LOCALIZATION_UNIT_STANDARD.md` ->
  `EDUCATIONAL_CONTENT_LOCALIZATION.md`
- `COMMUNICATIVE_COMPETENCY_MAP.md` -> `SPANISH_A0_CURRICULUM_BLUEPRINT.md`
- `SPANISH_A0_FOUNDATIONAL_READING_SEQUENCE.md` -> Spanish curriculum and
  reading-rule authorities
- `RUSSIAN_SEMANTIC_AUTHORING_LEXICON.md` ->
  `EDUCATIONAL_CONTENT_LOCALIZATION.md`
- `UKRAINIAN_SEMANTIC_AUTHORING_LEXICON.md` ->
  `EDUCATIONAL_CONTENT_LOCALIZATION.md`

### Evidence documents

Owner links were added to the following evidence families and reports:

- AF4A1, AF4A2 and AF4B audio reports -> `AUDIO_LEARNING_STANDARD.md`.
- `CONTENT_LOCALIZATION_R2E1_INVENTORY.md`, the R2E2/R2E3/R2E4 localization
  reports, the educational-localization gap/reset/root-cause reports, and all
  R2E4/R2E5 semantic localization reports ->
  `EDUCATIONAL_CONTENT_LOCALIZATION.md`.
- Pronunciation and reading implementation reports, including R2E2B, R2E2C,
  R2E2D2, R2E2D3 and the R2E2D runtime report -> `PRONUNCIATION_MODEL.md`.
- `SPANISH_A0_COMPLETE_PRONUNCIATION_REPORT.md` and
  `SPANISH_A0_PRONUNCIATION_INVENTORY.md` -> `PRONUNCIATION_MODEL.md`.
- Lesson scenario reports, pedagogical audits, compliance examinations and
  canonical lesson reviews -> `PEDAGOGICAL_SCENARIO_MODEL.md`.
- Beginner-course audits/repairs and canonical lesson implementation evidence
  -> `SPANISH_A0_CURRICULUM_BLUEPRINT.md` or the scenario authority according
  to the subject of the report.
- Research evidence such as `PEDAGOGICAL_EVIDENCE.md`, the pedagogical critique
  and live-tutor analyses -> their applicable current owner; unambiguous links
  were added where the evidence directly evaluated that owner.
- `DOCUMENTATION_NORMALIZATION_AUDIT.md` -> `DOCUMENTATION_AUTHORITY.md`.

## Exceptions and Ambiguous Classifications

- `PROJECT_VISION.md` is current supporting project guidance rather than the
  project-priority owner; `PROJECT_CONTRACT.md` owns project priorities.
- `LANGUAGE_COURSE_BLUEPRINT.md` is retained HISTORICAL/future design because
  its own text says current implementation is superseded.
- V1 documents remain HISTORICAL and V1-scoped; active architecture and current
  learning/content owners take precedence where applicable.
- Research documents with titles such as “standard”, “principles” or “rules”
  remain PROPOSAL unless explicitly adopted through the authority registry.
- Evidence reports whose relationship was not unambiguous use the descriptive
  phrase `applicable current normative owner` rather than inventing a link.
- Existing status words inside substantive historical/report text were not
  reinterpreted as lifecycle metadata; the controlled block at the top owns
  lifecycle classification.

## Unresolved Issues

D2B did not resolve semantic contradictions identified by D1/D1A, including
the remaining boundaries between broad learning-model prose and some older
research recommendations, or possible drift between current standards and
phase evidence. Those issues require a later semantic normalization or explicit
authority decision. No evidence or research document was promoted to normative
authority implicitly.

## Consistency Checks

- Every Markdown file under `docs/` and the applicable root `README.md` has exactly one controlled lifecycle
  `Status` and a declared `Scope`.
- Every `DERIVED` document with a known owner identifies that owner.
- Evidence and proposal documents do not claim independent permanent authority.
- The archive document is explicitly `ARCHIVED`.
- Spanish-specific documents carry Spanish/course/language scope.
- No document has multiple controlled lifecycle statuses.
- TSV artifacts were not edited.
