# DOCUMENTATION_AUTHORITY.md

Status: NORMATIVE
Scope: documentation governance and authority routing

## 1. Purpose

This registry tells humans and AI agents which document owns a topic, how
document lifecycle is interpreted and what to do when applicable requirements
conflict. Scope ownership comes first; there is no simplistic global ordering
such as “architecture overrides pedagogy”.

## 2. Lifecycle Vocabulary

- **NORMATIVE** — current source of requirements for its declared scope.
- **DERIVED** — operational guide or checklist derived from normative sources;
  it may simplify but may not redefine them.
- **DECISION_RECORD** — architectural or authoring decision and rationale. An
  active decision may constrain a normative document, but a log is not the
  implementation specification for every topic.
- **EVIDENCE** — audit, QA, implementation, inventory, migration or empirical
  record. It describes state and does not silently create requirements.
- **PROPOSAL** — research or design material not explicitly adopted.
- **HISTORICAL** — previously relevant material retained for provenance.
- **ARCHIVED** — explicitly retired material.

Location is a default signal, not a substitute for status: `docs/research/` is
PROPOSAL or EVIDENCE by default; `docs/archive/` is ARCHIVED; phase and QA
reports are EVIDENCE unless explicitly adopted.

## 3. Authority Principles

1. **Scope ownership first.** A document may override another only within a
   topic it actually owns.
2. **Project invariants first.** `PROJECT_INVARIANTS.md` has project-wide
   authority. A narrower normative document may not contradict it.
3. **One canonical owner.** Each major scope has one primary current authority,
   or an explicitly non-overlapping pair.
4. **Derived documents do not redefine.** Guides and checklists operationalize
   their owners and must defer when they appear to conflict.
5. **Evidence does not supersede.** Drift shown by a report requires an explicit
   update of the normative owner.
6. **Research is non-normative by default.** Imperative wording in research does
   not change its status.
7. **Archive is non-normative.** Archived material is retained for provenance.
8. **Conflict behavior.** An agent must not choose the newest or most plausible
   document. It must use this registry; if scope and registered precedence do
   not resolve a genuine conflict, stop the affected work and report both
   sources and the exact conflict.

## 4. Canonical Authority Registry

| Scope | Primary Authority | Secondary / Derived | Excluded as Authority |
|---|---|---|---|
| Project invariants | `PROJECT_INVARIANTS.md` | `PROJECT_CONTRACT.md` | research/phase reports |
| Project priorities and contract | `PROJECT_CONTRACT.md` | `PROJECT_VISION.md`, `README.md` | research reports |
| Runtime architecture | `ARCHITECTURE.md` | active `ARCHITECTURAL_DECISIONS.md` | superseded V1 claims, phase reports |
| Technology/platform | `TECH_STACK.md` | `PROJECT_CONTRACT.md`, release checklist | subject standards |
| Content model | `CONTENT_MODEL.md` | `CONTENT_AUTHORING_GUIDE.md`, V1 contract where compatible | lesson reports |
| Curriculum | `CURRICULUM_SPEC.md` | `COURSE_AUTHORING_GUIDE.md` | research sequences unless adopted |
| Generic pedagogy | `EDUCATIONAL_PRINCIPLES.md`, with boundaries in `LEARNING_MODEL.md` | pedagogical research | subject reports |
| Learner-state transitions | `LEARNING_STATE_MACHINE.md` | `LEARNING_MODEL.md` | research rules unless adopted |
| Learning model | `LEARNING_MODEL.md` | state machine and architecture for narrower topics | phase reports |
| Scenario/evidence model | `PEDAGOGICAL_SCENARIO_MODEL.md` | course and review guides | lesson audits |
| Review workflow | `CONTENT_REVIEW_PROTOCOL.md` | `CONTENT_REVIEW_CHECKLIST.md` | QA reports as process authority |
| Language authoring quality | `EDUCATIONAL_LANGUAGE_STANDARD.md` | `AUTHORING_STYLE_GUIDE.md` | localization reports |
| Writing systems | `WRITING_SYSTEM_STANDARD.md` | grapheme and writing-unit guides | Spanish reports |
| Pronunciation | `PRONUNCIATION_MODEL.md` | `PRONUNCIATION_AUTHORING_GUIDE.md`, reading standards | implementation reports |
| Language audio | `AUDIO_LEARNING_STANDARD.md` | AF production/QA evidence | generic platform docs for pedagogy |
| Application/UI localization | `ARCHITECTURE.md` for the boundary and policy | `app/lib/l10n/*.arb` as the operational source of concrete current UI strings, not normative authority; release checks | educational semantic reports |
| Educational content localization | `EDUCATIONAL_CONTENT_LOCALIZATION.md` | `SEMANTIC_LOCALIZATION_UNIT_STANDARD.md` | UI localization docs, legacy archive |
| Language-specific target/support policy | applicable language standards for linguistic correctness and language-specific authoring semantics | `EDUCATIONAL_CONTENT_LOCALIZATION.md` for localization structure and locale/support resolution | UI localization docs, cross-subject localization evidence |
| Spanish A0 curriculum | `SPANISH_A0_CURRICULUM_BLUEPRINT.md` | Spanish sequence and course reports as evidence | platform standards |
| Release | `RELEASE_CHECKLIST.md` | `PROJECT_CONTRACT.md`, relevant normative owners | research proposals |
| ADR/decision records | active entries in `ARCHITECTURAL_DECISIONS.md` / `AUTHORING_DECISIONS.md` | adopted source standards | inactive/history entries |
| Research | no primary normative owner; explicit adoption required | `docs/research/*` | treated as policy by default |
| Phase/implementation/QA reports | no primary normative owner; evidence only | relevant current standard | silent supersession |

### Important scoped boundaries

- `PROJECT_INVARIANTS.md` is the small durable constraint layer. The project
  contract remains broader and operational; it is not copied into invariants.
- `ARCHITECTURE.md` owns current runtime architecture. `V1_TECHNICAL_SPEC.md`
  is historical/partially superseded where it says so, and
  `V1_IMPLEMENTATION_CONTRACT.md` is V1-scoped; neither silently overrides the
  current architecture.
- `LEARNING_MODEL.md` owns the broad conceptual model. `LEARNING_STATE_MACHINE.md`
  owns executable learner-state transitions, support fading and remediation.
- `CONTENT_REVIEW_PROTOCOL.md` owns the review process. The checklist is a
  DERIVED operational view and cannot introduce a conflicting gate.
- `EDUCATIONAL_CONTENT_LOCALIZATION.md` owns educational localization
  architecture, field/source ownership and locale/support resolution. Applicable
  language standards own linguistic correctness, language-specific authoring
  semantics and target/support policy where those policies are language-specific.
  These responsibilities are complementary and non-overlapping.
- Active ADRs constrain their declared decision scope. A conflict between an
  active ADR and its current normative owner requires explicit reconciliation;
  it is not resolved by recency alone.
- `CURRICULUM_SPEC.md` is reusable and language-independent in intent, but is
  not fully subject-independent. Its current hierarchy includes Language Pack,
  Language, Course, Module and `LessonDefinition`, and its content assumptions
  include vocabulary, grammar, dialogue, reading and listening.

## 5. Applying the Registry

Before editing, identify the task scope and load the primary authority plus
only relevant derived or evidence documents. If a report shows that a primary
source is stale, record the drift and update the owner through an explicit
decision; do not silently promote the report.
