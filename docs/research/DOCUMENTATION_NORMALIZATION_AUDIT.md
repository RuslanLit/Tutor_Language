# Documentation Normalization Audit
Status: EVIDENCE
Scope: documentation authority and lifecycle audit
Normative authority: DOCUMENTATION_AUTHORITY.md

## 1. Executive Summary

This is a documentation-only audit of the repository documentation as found on
2026-08-09. It does not change the existing documentation, implementation,
content, schemas, tests, localization or build configuration.

The corpus is substantial and contains useful standards, contracts, authoring
guides, inventories and phase reports. Its main structural problem is not a
lack of guidance but a lack of an explicit authority registry and lifecycle
metadata. Several documents use “canonical”, “source of truth”, or mandatory
language, while adjacent documents repeat the same rule at a different level.
The repository therefore has a high risk of an agent selecting a plausible but
stale source.

The strongest current authority candidates are `PROJECT_CONTRACT.md` for
project-wide priorities, `ARCHITECTURE.md` for active runtime architecture,
`CONTENT_MODEL.md` for content structure, `CURRICULUM_SPEC.md` for course
sequencing, `LEARNING_STATE_MACHINE.md` for learner-state transitions,
`PEDAGOGICAL_SCENARIO_MODEL.md` for scenario contracts,
`CONTENT_REVIEW_PROTOCOL.md` for review workflow, and the subject standards for
language-specific concerns. This is an observed candidate model, not a new
normative rule.

`V1_IMPLEMENTATION_CONTRACT.md` is an active-looking contract but
`V1_TECHNICAL_SPEC.md` explicitly says that parts of it are historical and
partially superseded. Phase and research reports contain valuable evidence but
should not silently become permanent authority.

Recommended next step: D2 should establish a small authority registry,
document lifecycle labels, precedence rules, and cross-links. It should not
begin by mass-rewriting every document.

## 2. Current Documentation Inventory

The inventory below covers every Markdown and TSV file under `docs/`, plus the
relevant root `README.md`. “Authority” describes the apparent current owner of
the topic, not a formally registered precedence decision.

| Document | Role | Scope | Normative? | Authority | Status | Overlaps | Notes |
|---|---|---|---|---|---|---|---|
| `README.md` | entrypoint | project | mixed | none declared | current | all core docs | Says documentation is source of truth; gives reading order. |
| `docs/PROJECT_VISION.md` | vision | project | principles | project | current | contract, pedagogy | Strategic intent, not implementation precedence. |
| `docs/PROJECT_CONTRACT.md` | contract | platform/project | yes | project | current | vision, architecture | Contains explicit priority order and done criteria. |
| `docs/ARCHITECTURAL_DECISIONS.md` | decision log | platform | mixed | architecture | append-only/current log | architecture, V1 docs | Historical decisions and current decisions are not uniformly labeled. |
| `docs/ARCHITECTURE.md` | architecture | platform/runtime | yes | architecture | current | V1 docs, structure | Best current runtime authority candidate. |
| `docs/TECH_STACK.md` | technology policy | platform | mixed | project | current | contract, release | Stack and compatibility constraints. |
| `docs/PROJECT_STRUCTURE.md` | repository map | platform | descriptive | architecture | current | architecture, tech stack | Structural guidance. |
| `docs/V1_IMPLEMENTATION_CONTRACT.md` | implementation contract | V1 platform/content | yes, versioned | V1 | current-with-scope | architecture, content, learning | Active-looking contract; precedence against later architecture is unclear. |
| `docs/V1_TECHNICAL_SPEC.md` | original technical target | V1 | historical/mixed | V1 | partially superseded | architecture, implementation contract | Explicitly marks some claims as historical target scope. |
| `docs/RELEASE_CHECKLIST.md` | release gate | platform | yes | release | current | contract, tech stack | Operational checklist. |
| `docs/CONTENT_MODEL.md` | data/content model | platform + language subject | yes | content | current | authoring, V1 | Canonical object/storage responsibilities and audio boundary. |
| `docs/CONTENT_AUTHORING_GUIDE.md` | authoring guide | content/pedagogy | yes | content | current | course, style, model | Repeats educational and validation rules. |
| `docs/COURSE_AUTHORING_GUIDE.md` | course authoring | curriculum | yes | curriculum | current | curriculum spec, scenario | Course and lesson construction. |
| `docs/CURRICULUM_SPEC.md` | curriculum contract | curriculum | yes | curriculum | current | course blueprint, Spanish blueprint | Sequencing and prerequisites. |
| `docs/LANGUAGE_COURSE_BLUEPRINT.md` | course blueprint | language subject | mixed | language subject | current | curriculum, Spanish blueprint | General language-course framing with language terminology. |
| `docs/COMMUNICATIVE_COMPETENCY_MAP.md` | competency map | language pedagogy | mixed | pedagogy/subject | current | curriculum, learning model | Language-specific competency decomposition. |
| `docs/LESSON_AUTHORING_ENTRYPOINT.md` | workflow entrypoint | authoring | procedural | authoring | current | authoring guides | Entry workflow, not model authority. |
| `docs/LESSON_SCENARIO_REMEDIATION_L01_L05.md` | scenario report | Spanish course | evidence | none | report | scenario model | Lesson-specific remediation review. |
| `docs/LESSON_SCENARIO_REVIEW_L01_L05.md` | scenario report | Spanish course | evidence | none | report | scenario model | Lesson-specific scenario review. |
| `docs/AUTHORING_STYLE_GUIDE.md` | style guide | learner-facing language | yes | language authoring | current | educational language standard | Tone, clarity and examples. |
| `docs/AUTHORING_DECISIONS.md` | decision log | authoring | mixed | authoring | append-only/current log | authoring guides | Needs lifecycle labels and decision links. |
| `docs/CONTENT_REVIEW_PROTOCOL.md` | review process | content | yes | review | current | checklist, standards | Full staged review workflow. |
| `docs/CONTENT_REVIEW_CHECKLIST.md` | review checklist | content | procedural | review | current | review protocol | Condensed operational checks; precedence not stated. |
| `docs/EDUCATIONAL_PRINCIPLES.md` | principles | pedagogy | yes | pedagogy | current | learning model, research | High-level educational principles. |
| `docs/LEARNING_MODEL.md` | learning model | pedagogy/runtime | yes | pedagogy | current | state machine, architecture | Broad model and current runtime mapping. |
| `docs/LEARNING_STATE_MACHINE.md` | state machine | pedagogy | yes | pedagogy | current | learning model, scenario | Explicit states, transitions and consolidation guidance. |
| `docs/PEDAGOGICAL_SCENARIO_MODEL.md` | scenario contract | pedagogy/authoring | yes | pedagogy | current | course authoring, review | Activity state/evidence contract. |
| `docs/PEDAGOGICAL_ARCHITECTURE_AUDIT.md` | audit | pedagogy | evidence | none | report | principles, learning model | Findings, not automatically normative. |
| `docs/PEDAGOGICAL_COMPLIANCE_EXAMINATION.md` | examination | pedagogy | evidence | none | report | principles, scenario | Compliance findings and gaps. |
| `docs/EDUCATIONAL_LANGUAGE_STANDARD.md` | language quality standard | language subject | yes | language authoring | current | style, review | Learner-facing language quality; explicitly excludes runtime/data concerns. |
| `docs/WRITING_SYSTEM_STANDARD.md` | writing system standard | language subject | yes | language subject | current | grapheme, pronunciation | Generalizable writing units with language examples. |
| `docs/WRITING_UNIT_INTRODUCTION_STANDARD.md` | introduction standard | language pedagogy | yes | language subject | current | writing system, reading rules | Early writing/reading presentation. |
| `docs/GRAPHEME_PRESENTATION_STANDARD.md` | grapheme standard | language subject | yes | language subject | current | writing system, pronunciation | Grapheme presentation and support. |
| `docs/PRONUNCIATION_MODEL.md` | pronunciation model | language subject | yes | pronunciation | current | writing, reading, Spanish reports | Data model and ownership classes. |
| `docs/PRONUNCIATION_AUTHORING_GUIDE.md` | pronunciation authoring | language subject | yes | pronunciation | current | pronunciation model, review | Authoring and review workflow. |
| `docs/READING_RULE_PREREQUISITE_STANDARD.md` | reading prerequisite standard | language subject | yes | reading | current | writing, pronunciation | Reading-rule dependency semantics. |
| `docs/AUDIO_LEARNING_STANDARD.md` | audio learning standard | language subject/cross-cutting | yes | audio | current | pronunciation, AF reports | Calls itself the canonical cross-cutting audio specification. |
| `docs/SEMANTIC_LOCALIZATION_UNIT_STANDARD.md` | localization data standard | educational localization | yes | localization | current | educational localization, reports | Unit fields and status workflow. |
| `docs/EDUCATIONAL_CONTENT_LOCALIZATION.md` | localization architecture | educational localization | yes | localization | current | semantic standard, reports | Separates UI, support and target language; declares readiness sources. |
| `docs/EDUCATIONAL_LOCALIZATION_REQUIREMENTS_GAP_MATRIX.md` | gap matrix | localization | evidence | none | report | localization reports | Analysis, not a stable standard. |
| `docs/EDUCATIONAL_LOCALIZATION_RESET_INVENTORY.md` | reset inventory | localization | evidence | none | report | localization reports | Migration inventory. |
| `docs/EDUCATIONAL_LOCALIZATION_ROOT_CAUSE_REPORT.md` | root-cause report | localization | evidence | none | report | localization reports | Diagnosis and recommendations. |
| `docs/CONTENT_LOCALIZATION_R2E1_INVENTORY.md` | phase inventory | localization | evidence | R2E1 | report | localization standard | Historical/phase state. |
| `docs/CONTENT_LOCALIZATION_R2E2A_QUALITY_REPORT.md` | phase quality report | localization | evidence | R2E2A | report | localization standard | Historical/phase state. |
| `docs/CONTENT_LOCALIZATION_R2E2_RUSSIAN_REPORT.md` | phase report | localization | evidence | R2E2 | report | lexicon, localization | Russian-specific findings. |
| `docs/CONTENT_LOCALIZATION_R2E3_UKRAINIAN_REPORT.md` | phase report | localization | evidence | R2E3 | report | lexicon, localization | Ukrainian-specific findings. |
| `docs/CONTENT_LOCALIZATION_R2E4_REPORT.md` | phase report | localization | evidence | R2E4 | report | localization | Phase report. |
| `docs/R2E4B_SEMANTIC_LOCALIZATION_FOUNDATION_REPORT.md` | phase report | localization | evidence | R2E4B | report | semantic standard | Foundation status. |
| `docs/R2E4C_SEMANTIC_LOCALIZATION_PILOT_REPORT.md` | phase report | localization | evidence | R2E4C | report | semantic standard | Pilot evidence. |
| `docs/R2E5A_MODULE_1_SEMANTIC_UKRAINIAN_REPORT.md` | phase report | Ukrainian subject localization | evidence | R2E5A | report | localization standard | Subject/course-specific. |
| `docs/R2E5N0A_MODULE_1_SCOPE_GAP_REPORT.md` | gap report | Ukrainian localization | evidence | R2E5N0A | report | localization standard | Scope findings. |
| `docs/R2E5N0A_MODULE_1_SEMANTIC_SCOPE_REPORT.md` | scope report | Ukrainian localization | evidence | R2E5N0A | report | localization standard | Scope findings. |
| `docs/R2E5N1_CLEAN_UKRAINIAN_MODULE_1_REPORT.md` | migration report | Ukrainian localization | evidence | R2E5N1 | report | localization standard | Migration evidence. |
| `docs/R2E5N1_MODULE_1_UKRAINIAN_AUTHORING_REPORT.md` | authoring report | Ukrainian localization | evidence | R2E5N1 | report | authoring/localization | Course-specific. |
| `docs/R2E5R_EDUCATIONAL_LOCALIZATION_RESET_REPORT.md` | reset report | localization | evidence | R2E5R | report | localization standard | Declares a transition/supersession. |
| `docs/R2E5_SEMANTIC_UKRAINIAN_MIGRATION_REPORT.md` | migration report | Ukrainian localization | evidence | R2E5 | report | localization standard | Course-specific migration. |
| `docs/RUSSIAN_SEMANTIC_AUTHORING_LEXICON.md` | lexicon | Russian subject localization | subject standard | localization | current | localization reports | Language-specific authoring resource. |
| `docs/UKRAINIAN_SEMANTIC_AUTHORING_LEXICON.md` | lexicon | Ukrainian subject localization | subject standard | localization | current | localization reports | Language-specific authoring resource. |
| `docs/SPANISH_A0_CURRICULUM_BLUEPRINT.md` | course blueprint | Spanish subject | yes, subject | Spanish course | current | curriculum | Spanish A0 specialization. |
| `docs/SPANISH_A0_FOUNDATIONAL_READING_SEQUENCE.md` | sequence | Spanish reading | subject standard | Spanish course | current | reading standard | Spanish A0 sequence. |
| `docs/SPANISH_A0_PRONUNCIATION_INVENTORY.md` | inventory | Spanish pronunciation | evidence/subject | Spanish course | current | pronunciation model | Spanish asset inventory. |
| `docs/SPANISH_A0_COMPLETE_PRONUNCIATION_REPORT.md` | completion report | Spanish pronunciation | evidence | Spanish course | report | pronunciation docs | Completion evidence. |
| `docs/SPANISH_LLY_PRONUNCIATION_POLICY.md` | policy | Spanish pronunciation | subject standard | Spanish course | current | pronunciation model | Spanish-specific ll/y policy. |
| `docs/AF4A_AUDIO_INVENTORY.tsv` | asset inventory | Spanish audio | evidence | audio authoring | phase artifact | audio standard | Machine-readable phase inventory. |
| `docs/AF4A1_AUDIO_EVALUATION.md` | evaluation | Spanish audio | evidence | AF4A1 | phase report | audio standard | Human evaluation phase. |
| `docs/AF4A1_AUDIO_EVALUATION.tsv` | evaluation data | Spanish audio | evidence | AF4A1 | phase artifact | audio standard | Machine-readable phase data. |
| `docs/AF4A2_AUDIO_PROFILE_B_VALIDATION.md` | validation | Spanish Piper audio | evidence | AF4A2 | phase report | audio standard | Profile decision evidence. |
| `docs/AF4A2_AUDIO_PROFILE_B_VALIDATION.tsv` | validation data | Spanish Piper audio | evidence | AF4A2 | phase artifact | audio standard | Machine-readable validation data. |
| `docs/AF4B_AUDIO_TECHNICAL_QA.md` | QA report | Spanish audio | evidence | AF4B | phase report | audio standard | Production QA state, not global audio policy. |
| `docs/AF4B_AUDIO_TECHNICAL_QA.tsv` | QA data | Spanish audio | evidence | AF4B | phase artifact | audio standard | Machine-readable QA data. |
| `docs/PRONUNCIATION_R2E2B_IMPLEMENTATION_REPORT.md` | implementation report | pronunciation runtime | evidence | R2E2B | report | pronunciation model | Historical implementation evidence. |
| `docs/PRONUNCIATION_R2E2C_RUNTIME_REPORT.md` | runtime report | pronunciation runtime | evidence | R2E2C | report | pronunciation model | Historical runtime evidence. |
| `docs/R2E2D2_READING_RULE_SEQUENCE_REPORT.md` | implementation report | reading rules | evidence | R2E2D2 | report | reading standard | Historical evidence. |
| `docs/R2E2D3_FOUNDATIONAL_READING_REPORT.md` | implementation report | reading | evidence | R2E2D3 | report | reading standard | Historical evidence. |
| `docs/READING_RULE_R2E2D_RUNTIME_REPORT.md` | runtime report | reading rules | evidence | R2E2D | report | prerequisite standard | Historical runtime evidence. |
| `docs/archive/UKRAINIAN_TRANSLATION_MEMORY_LEGACY.md` | legacy archive | Ukrainian localization | no | none | archived | localization lexicon/reports | Explicitly historical/non-normative by location. |
| `docs/research/BEGINNER_COURSE_BLUEPRINT_AUDIT.md` | audit | course research | evidence | none | research | curriculum | Research finding. |
| `docs/research/BEGINNER_COURSE_REPAIR_REPORT.md` | repair report | course research | evidence | none | research | curriculum | Historical repair. |
| `docs/research/BEGINNER_COURSE_SEQUENCE.md` | sequence | course research | evidence | none | research | curriculum | Candidate sequence, authority unclear. |
| `docs/research/BEGINNER_LESSON_PROGRESSION.md` | progression research | course pedagogy | evidence | none | research | learning model | Candidate/research material. |
| `docs/research/CANONICAL_LESSONS_1_5_PEDAGOGICAL_AUDIT.md` | audit | Spanish course | evidence | none | research | Spanish blueprint | Audit. |
| `docs/research/CANONICAL_LESSON_1_DESIGN.md` | design | Spanish course | evidence | none | research | Spanish blueprint | Lesson-specific design. |
| `docs/research/CANONICAL_LESSON_1_IMPLEMENTATION_REPORT.md` | implementation report | Spanish course | evidence | none | research | architecture | Historical implementation evidence. |
| `docs/research/CANONICAL_LESSON_1_REVIEW.md` | review | Spanish course | evidence | none | research | review protocol | Lesson-specific review. |
| `docs/research/COURSE_RESET_REPORT.md` | reset report | course | evidence | none | research | curriculum/localization | Historical transition evidence. |
| `docs/research/FIRST_15_LESSONS_RATIONALE.md` | rationale | Spanish course | evidence | none | research | curriculum | Design rationale, not authority. |
| `docs/research/LIVE_TUTOR_DOCUMENTATION_RECONCILIATION.md` | reconciliation | project/docs | evidence | none | research | all core docs | Useful conflict inventory; no registry authority. |
| `docs/research/LIVE_TUTOR_LESSON_CORPUS_ANALYSIS.md` | corpus analysis | Spanish course | evidence | none | research | curriculum | Analysis. |
| `docs/research/PEDAGOGICAL_EVIDENCE.md` | evidence | pedagogy | evidence | none | research | principles | Research support. |
| `docs/research/PEDAGOGICAL_PRINCIPLES_CRITIQUE.md` | critique | pedagogy | evidence | none | research | principles | Critique, not replacement standard. |
| `docs/research/PEDAGOGICAL_STANDARD.md` | proposed standard | pedagogy | mixed | none | research | educational principles | Name suggests authority but location/status do not. |
| `docs/research/SPANISH_PEDAGOGICAL_FOUNDATION.md` | foundation | Spanish pedagogy | subject standard | Spanish course | research | Spanish blueprint | Subject rationale. |
| `docs/research/SPANISH_TEACHING_PRINCIPLES.md` | principles | Spanish pedagogy | mixed | Spanish course | research | educational principles | Subject-specific principles. |
| `docs/research/TUTOR_LANGUAGE_PEDAGOGICAL_PRINCIPLES.md` | principles | project pedagogy | mixed | none | research | educational principles | Candidate project principles. |
| `docs/research/TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md` | rules | project pedagogy | mixed | none | research | state machine, scenario | Strong imperative wording without registered precedence. |

The inspected documentation set contains exactly 96 artifacts: 91 Markdown and
4 TSV files under `docs/`, plus the relevant root `README.md`. The table
intentionally preserves every path and treats TSV files as evidence artifacts
rather than prose standards. `Books/README.md` is a book-archive README and is
outside the product documentation authority surface; it should not be used for
implementation routing.

## 3. Current Authority Model

The repository has an implicit layered model, but no machine-readable or
single-page authority registry. Evidence for the implicit model includes:

- `README.md` defines a required reading order and says documentation is the
  source of truth.
- `PROJECT_CONTRACT.md` defines project-wide priority order.
- `ARCHITECTURE.md` and `LEARNING_MODEL.md` describe current runtime behavior.
- `LEARNING_STATE_MACHINE.md` and `PEDAGOGICAL_SCENARIO_MODEL.md` explicitly
  consolidate narrower pedagogical rules.
- `EDUCATIONAL_CONTENT_LOCALIZATION.md` declares readiness manifests as source
  of truth for localization state.
- `V1_TECHNICAL_SPEC.md` explicitly limits itself to historical target scope
  where later architecture or implementation differs.

The missing piece is precedence between documents at the same level and a
consistent way to distinguish current rule, proposal, evidence, and history.
“Canonical” currently means a data field, a topic owner, a course artifact, or
an entire document depending on context.

Candidate current authority map (to be confirmed in D2):

| Layer | Candidate authority | Boundary |
|---|---|---|
| Project | `PROJECT_CONTRACT.md` | Safety, data preservation, architecture and delivery priorities. |
| Active runtime architecture | `ARCHITECTURE.md` | Runtime boundaries and persistence behavior. |
| Content model | `CONTENT_MODEL.md` | Educational object ownership and references. |
| Curriculum | `CURRICULUM_SPEC.md` | Course/module/lesson sequencing and prerequisites. |
| Learning state | `LEARNING_STATE_MACHINE.md` | Learner-state transitions and remediation. |
| Scenario/assessment | `PEDAGOGICAL_SCENARIO_MODEL.md` | Activity purpose, evidence and response. |
| Review | `CONTENT_REVIEW_PROTOCOL.md` | Human review gates. |
| Language quality | `EDUCATIONAL_LANGUAGE_STANDARD.md` | Learner-facing educational language. |
| Subject language | `WRITING_SYSTEM_STANDARD.md`, `PRONUNCIATION_MODEL.md`, `AUDIO_LEARNING_STANDARD.md` | Language-specific structures and media. |
| Spanish course | `SPANISH_A0_CURRICULUM_BLUEPRINT.md` plus subject standards | Spanish A0 only. |

## 4. Normative Rule Clusters

| Cluster | Repeated rule family | Likely owner | Current risk |
|---|---|---|---|
| Project integrity | preserve data, offline operation, simplicity, evidence | `PROJECT_CONTRACT.md` | Later documents repeat parts without linking. |
| Runtime boundary | content -> curriculum -> planner -> lesson/session -> persistence | `ARCHITECTURE.md` | V1 documents present parallel descriptions. |
| Content identity | stable IDs, references, validation, canonical objects | `CONTENT_MODEL.md` | Authoring and V1 guides restate field rules. |
| Progression | states, support fading, mastery and remediation | `LEARNING_STATE_MACHINE.md` | `LEARNING_MODEL.md` also presents a complete model. |
| Lesson construction | goal, state, learner action, evidence, failure response | `PEDAGOGICAL_SCENARIO_MODEL.md` | Course and review documents repeat it. |
| Curriculum | canonical order and prerequisites | `CURRICULUM_SPEC.md` | Spanish and research blueprints can look authoritative. |
| Language quality | naturalness, clarity, target/support separation | `EDUCATIONAL_LANGUAGE_STANDARD.md` | Style guide and review protocol overlap. |
| Reading/pronunciation | writing units, reading rules, IPA, pronunciation support | subject standards | Boundaries are present but cross-links are numerous. |
| Localization | UI locale versus educational support locale; status and coverage | `EDUCATIONAL_CONTENT_LOCALIZATION.md` | Phase reports use transitional vocabulary. |
| Audio QA | deterministic assets, approval state, no runtime generation | `AUDIO_LEARNING_STANDARD.md` plus AF reports | Recent phase documents are evidence, not stable global policy. |

## 5. Duplicate Rules

| Rule/Topic | Documents | Duplication Type | Risk | Proposed Canonical Source |
|---|---|---|---|---|
| Project priority order | `README.md`, `PROJECT_CONTRACT.md`, vision and release docs | summary versus contract | High | `PROJECT_CONTRACT.md` |
| Runtime architecture | `ARCHITECTURE.md`, `V1_TECHNICAL_SPEC.md`, `V1_IMPLEMENTATION_CONTRACT.md`, `PROJECT_STRUCTURE.md` | parallel descriptions | High | `ARCHITECTURE.md` |
| Content object responsibilities | `CONTENT_MODEL.md`, `CONTENT_AUTHORING_GUIDE.md`, V1 contract | field and workflow repetition | High | `CONTENT_MODEL.md`; authoring guide links to it |
| Lesson sequencing | `CURRICULUM_SPEC.md`, `COURSE_AUTHORING_GUIDE.md`, language blueprints | general plus specialized restatement | Medium | `CURRICULUM_SPEC.md` |
| Learner states and mastery | `LEARNING_MODEL.md`, `LEARNING_STATE_MACHINE.md`, research pedagogy rules | model plus rules plus research | High | `LEARNING_STATE_MACHINE.md` |
| Activity purpose/evidence | `PEDAGOGICAL_SCENARIO_MODEL.md`, course guide, review protocol | workflow repetition | Medium | `PEDAGOGICAL_SCENARIO_MODEL.md` |
| Review gates | `CONTENT_REVIEW_PROTOCOL.md`, checklist, educational language standard | process/checklist/quality overlap | Medium | protocol owns stages; checklist is derived |
| Natural learner-facing language | `AUTHORING_STYLE_GUIDE.md`, `EDUCATIONAL_LANGUAGE_STANDARD.md` | substantial overlap | Medium | language standard owns quality; style guide owns tone |
| Writing/pronunciation support | writing, grapheme, reading, pronunciation documents | adjacent rules repeated | Medium | separate standards with explicit boundaries |
| Localization status | educational localization standard and R2E/R2E5 reports | current rules plus phase evidence | High | localization standard; reports are historical evidence |
| Pedagogical principles | educational principles, research standard, research rules, audits | principles, proposals and findings mixed | High | `EDUCATIONAL_PRINCIPLES.md` after D2 confirmation |

## 6. Contradictions

These are documentation-governance conflicts or likely semantic conflicts. A
phase report is not treated as a contradiction merely because it records an
older state. D2 should verify the underlying claims before changing authority.

| Topic | Source A | Source B | Conflict | Severity | Evidence | Proposed Resolution Owner |
|---|---|---|---|---|---|---|
| Documentation precedence | `README.md` | `PROJECT_CONTRACT.md` and many standards | README says documentation has higher priority, but does not say which document wins when docs conflict. | Critical | README reading order; contract priority order, no document precedence registry. | Project/architecture owner |
| V1 scope versus active architecture | `V1_TECHNICAL_SPEC.md` | `ARCHITECTURE.md`, `LEARNING_MODEL.md` | V1 spec contains implementation-target claims but expressly says some are superseded; agents need a reliable override rule. | High | V1 purpose paragraph names partial supersession and points to architecture. | Architecture owner |
| Learner-state ownership | `LEARNING_MODEL.md` | `LEARNING_STATE_MACHINE.md` | Both present complete progression concepts; the state machine says it consolidates duplicate guidance, but the broader model remains independently normative-looking. | High | Both have canonical state/progression sections; state machine has “Duplicate Guidance Consolidation”. | Pedagogy owner |
| Review protocol versus checklist | `CONTENT_REVIEW_PROTOCOL.md` | `CONTENT_REVIEW_CHECKLIST.md` | Checklist is a second acceptance surface; precedence and derivation relationship are not explicit enough. | Medium | Both define final review and publication checks. | Content review owner |
| Localization transition | `EDUCATIONAL_CONTENT_LOCALIZATION.md` | R2E5 reports and legacy archive | Current rebuilding/fallback language can be confused with older release-ready or legacy claims if report status is not read. | High | Localization standard says R2E5R supersedes legacy state; archive is separate. | Localization owner |
| Pedagogy proposal status | `EDUCATIONAL_PRINCIPLES.md` | `docs/research/PEDAGOGICAL_STANDARD.md`, `TUTOR_LANGUAGE_PEDAGOGICAL_RULES.md` | Research files use standard/rules language without an explicit proposal banner. | Medium | Titles and imperative sections look normative despite research location. | Pedagogy owner |
| Domain boundary of “educational” models | `CONTENT_MODEL.md` | `EDUCATIONAL_LANGUAGE_STANDARD.md` | Content model presents language-oriented objects while the language standard excludes data/runtime concerns; agents may infer conflicting scope. | Medium | Content model includes language objects; language standard says it does not define JSON/runtime. | Content + subject owners |

No direct evidence was found in this audit that the current audio QA reports
contradict the audio standard; they appear to be phase-specific state and
validation evidence. They should nevertheless be labeled as such.

## 7. Platform vs Subject-Domain Classification

| Concept | Platform Core | Generic Pedagogy | Language Domain | Spanish Specific | Mixed/Unclear | Evidence |
|---|---:|---:|---:|---:|---:|---|
| Learner/course/module/lesson identity | yes |  |  |  |  | `CONTENT_MODEL.md`, architecture |
| Attempt, step, persistence, resume | yes |  |  |  |  | `ARCHITECTURE.md`, learning model |
| Mastery, remediation, review |  | yes |  |  |  | state machine, learning model |
| Activity purpose and evidence |  | yes |  |  |  | pedagogical scenario model |
| Vocabulary/grammar/dialogue/reading |  |  | yes |  |  | content model and V1 contract |
| Target/support language and locale |  |  | yes |  |  | educational localization standard |
| WritingUnit, grapheme, reading rule, IPA |  |  | yes |  |  | writing/pronunciation standards |
| Reference audio and pronunciation practice |  |  | yes |  |  | audio learning standard |
| Spanish A0 curriculum and ll/y policy |  |  |  | yes |  | Spanish blueprint and policy |
| `EducationalContent` activity union |  |  |  |  | yes | Current content model is language-shaped despite generic naming. |
| `LessonDefinition` | yes |  |  |  | mixed | Reusable lesson container, but current references and examples are language-course shaped. |
| `LessonActivityReference` | yes |  |  |  | mixed | Platform reference/assembly concept; referenced activity kinds are currently language-domain. |
| `LessonContent` |  |  | yes |  | mixed | Generic-sounding content boundary currently carries vocabulary, grammar, dialogue, reading and exercises. |
| `competency` |  | yes |  |  | mixed | Competency is pedagogically generic, but the current competency map is communicative/language-specific. |
| `learner history` | yes |  |  |  |  | Persistence/evidence history is platform core; mastery events have pedagogical semantics. |
| `answer evaluation` |  | yes | yes |  | mixed | Evaluating a response is generic pedagogy; current implementation semantics are language-oriented. |
| `accepted answers` |  | yes | yes |  | mixed | Accepted-result concept is generic; linguistic variants and canonical forms are language-domain. |
| `misconceptions` |  | yes |  |  |  | Generic pedagogical evidence concept; current examples are largely language learning. |
| `remediation` |  | yes |  |  |  | Generic pedagogical response to evidence. |
| `review` |  | yes |  |  |  | Generic scheduling/activity concept, with language examples in current content. |
| `mastery` |  | yes |  |  |  | Generic learner-state outcome as defined by the state machine. |
| `lesson planning` | yes | yes |  |  | mixed | Deterministic platform planning with pedagogical selection policy. |
| `lesson session` | yes | yes |  |  | mixed | Runtime session is platform core; progression and evidence are pedagogical. |
| `writing system` |  |  | yes |  |  | Orthography and graphemes are language-domain, not platform core. |
| `pronunciation` |  |  | yes |  |  | Pronunciation model, IPA and support are language-domain. |
| `localization` | yes |  |  |  | mixed | UI localization is application scope; educational localization is cross-subject; target/support semantics are language-learning. |
| `curriculum` | yes | yes | yes |  | mixed | Hierarchy/order are reusable; current curriculum specification is substantially language-domain. |
| `dialogues` |  |  | yes |  |  | Current dialogue objects encode communicative language learning. |
| `vocabulary` |  |  | yes |  |  | Language-domain knowledge object. |
| `grammar` |  |  | yes |  |  | Language-domain knowledge object. |
| `reading` |  |  | yes |  | mixed | Activity concept is pedagogically reusable; current rules/graphemes are language-domain. |
| `typed recall` |  | yes | yes |  | mixed | Recall/evidence is generic; typed orthographic response and normalization are language-specific. |
| Answer evaluation and accepted variants |  |  | yes |  | yes | Generic evaluator boundary currently reflects language answers. |
| Localization |  |  |  |  | yes | App UI localization and educational content localization are separate concerns. |
| Offline/privacy/accessibility | yes |  |  |  |  | project contract and technical docs |

## 8. Language-Coupling Findings

The architecture has a useful generic shell: curriculum, lesson, activity,
attempt, persistence, planning and evidence concepts are reusable. The current
content union and evaluator are not fully subject-neutral, however. Concrete
language objects and language-oriented answer normalization sit behind generic
names. `CURRICULUM_SPEC.md` is language-independent in the sense that it does
not hard-code Spanish, but it is not subject-independent: its hierarchy and
learning progression assume a Language Pack/Language and language activities
such as vocabulary, grammar, dialogue, reading and listening. Course, module
and `LessonDefinition` can be reused; the current full curriculum contract
cannot be treated as a neutral math/physics/chemistry curriculum without
subject extensions.

Evaluation has a similar boundary. Learner response, evaluation result,
correctness, accepted/partial result, evidence, misconception, feedback,
retry and remediation are generic pedagogical concepts. The current language
mechanisms—string normalization, case and punctuation tolerance, accents,
contractions, orthographic variants and linguistic accepted answers—are subject
semantics, not platform invariants. The documentation does not yet define a
generic evaluator API; this audit does not propose one.

Audio also has two layers. Asset identity, loading, offline availability and
playback are generic media/platform capabilities. Reference pronunciation,
pronunciation training, phonetic support, listening pedagogy and
grapheme/phoneme relationships are language-domain semantics owned by the
audio, pronunciation and writing standards. The current AF documents are
Spanish production evidence, not proof that all future audio is pronunciation
audio.

Appropriate coupling includes vocabulary, grammar, dialogue, reading,
orthography, pronunciation, target/support language, IPA and linguistic answer
variants. Likely leakage includes treating textual answer comparison as a
platform invariant, assuming every exercise has language content, and treating
Spanish A0/CEFR or Ukrainian support workflow as project-wide policy.

Localization has three distinct domains. Application/UI localization covers
product interface strings and is platform/application scope. Educational
content localization covers learner-facing explanations, prompts, instructions
and feedback and can also apply to mathematics, physics or chemistry. Target
language, support language, canonical target forms and linguistic variants are
language-learning semantics. Future routing must distinguish all three rather
than classify educational localization as language learning by default.

## 9. Math/Physics/Chemistry Compatibility Stress Test

This is a bounded thought experiment, not a request to design those subjects.

| Learning Activity | Math | Physics | Chemistry | Current Architectural Limitation |
|---|---|---|---|---|
| Numeric answer | extension needed | extension needed | extension needed | No subject-neutral numeric response/evaluation semantics; current evaluator centers on text. |
| Equivalent mathematical forms | extension needed | — | — | No mathematical expression equivalence model. |
| Intermediate reasoning | extension needed | extension needed | extension needed | Lesson/session evidence exists, but no documented multi-step subject reasoning model. |
| Misconception remediation | compatible | compatible | compatible | Generic state/remediation concepts are reusable if evidence is generalized. |
| Numerical answer with units | — | extension needed | extension needed | No quantity, unit or dimensional-analysis model. |
| Select/apply a physical law | — | extension needed | — | Requires subject-specific law/application semantics. |
| Graph interpretation | extension needed | extension needed | extension needed | No documented generic graph/structured visual response activity. |
| Dimensional error diagnosis | — | extension needed | — | Current misconception/evaluation concepts are reusable, but dimensions are absent. |
| Symbolic chemical notation | — | — | extension needed | No documented chemical-symbol syntax or evaluator. |
| Equation balancing | — | — | extension needed | Text can carry a response, but no reaction or balancing semantics. |
| Identification/classification | extension needed | extension needed | extension needed | Requires subject-specific knowledge objects and evaluation. |
| Recall a symbol/term | compatible | compatible | compatible | Generic recall flow is reusable; current content types remain language-shaped. |

Conclusion: the platform shell is extensible, but the current model should not
claim direct subject-independence. New subjects would need explicit subject
modules, content types, response/evaluation semantics and authoring standards.

## 10. Candidate Project Invariants

These are candidates for D2 discussion, not new rules in this report.

- Core learning remains usable offline; network is not required for the core
  learning loop.
- Learner data and progress are preserved; destructive migration requires
  explicit evidence and a recoverable path.
- Runtime does not silently invent or reinterpret canonical content.
- Stable identifiers and explicit references are the identity boundary.
- Lesson assembly and state transitions are deterministic and explainable.
- Content, curriculum, runtime, persistence and subject-specific evaluation
  have explicit ownership boundaries.
- Human review is required wherever a document or asset declares a human QA
  gate.
- UI localization and educational content localization are different concerns.
- Subject-specific rules must not be promoted to platform invariants implicitly.

Candidate language-domain invariants should remain outside the project core:
target/support separation, canonical orthography, pronunciation support timing,
linguistic answer-variant policy, and Spanish A0 production details.

## 11. Candidate Domain Standards

Future standards should be organized by owner rather than by phase:

- Platform: architecture, content/runtime boundary, persistence, validation,
  release and privacy/offline constraints.
- Generic pedagogy: learning states, assessment/evidence, remediation,
  feedback, progression and learner agency.
- Language subject: writing systems, reading rules, pronunciation, language
  audio, linguistic evaluation, target/support semantics and language
  authoring.
- Educational content localization: a cross-subject content concern for
  learner-facing explanations, prompts, instructions and feedback; it must be
  separate from UI localization and language-learning target/support policy.
- Spanish subject: Spanish A0 curriculum, Spanish pronunciation policy and
  course-specific inventories.
- Future subjects: separate math, physics or chemistry standards, with no need
  to import Spanish language rules.

## 12. Candidate Canonical Sources

The candidate map in section 3 is the smallest practical set. D2 should add a
registry with owner, scope, status (`current`, `proposed`, `historical`,
`evidence`), supersedes/superseded-by links, and conflict precedence. Reports
should link to the source they test and should not become authorities solely by
using “canonical” in a title.

## 13. Proposed Documentation Hierarchy

A future hierarchy could be:

```text
docs/
  PROJECT_INVARIANTS.md
  AI_WORKING_CONTEXT.md
  platform/       architecture, persistence, validation, release
  pedagogy/       learning model, state machine, assessment
  subjects/
    languages/    language standards, authoring, Spanish A0
  application/    UI localization and product workflows
  adr/            dated decisions with status
  reports/        implementation and QA evidence
  research/       proposals and audits
  archive/        explicitly non-normative legacy material
```

This is a proposal only. D2 should preserve paths initially, add lifecycle
metadata and cross-links, then consider moves only with an explicit migration
plan.

## 14. Proposed AI Context Routing

| Task | Minimum context | Exclude unless directly relevant |
|---|---|---|
| Any implementation | project invariants, active architecture, relevant contract | phase reports not named by task |
| Runtime/state/persistence | platform architecture, learning model/state machine, current implementation contract | Spanish authoring reports |
| Content authoring | content model, curriculum, scenario model, language standard if language subject | historical reports |
| Spanish pronunciation/audio | platform boundary, language standards, Spanish policy/inventory, applicable AF evidence | unrelated localization reports |
| UI localization | platform/application localization docs | educational semantic localization reports |
| Educational content localization | content localization standard, semantic unit standard, current phase evidence | target-language pronunciation reports unless directly relevant |
| Language-learning target/support semantics | language standards, relevant subject/course documents | UI localization and cross-subject educational localization reports |
| Future non-language subject | project invariants, platform, generic pedagogy, subject standard | language-specific standards |
| Release/QA | project contract, active architecture, release checklist, relevant QA report | research proposals |

Agents should be told explicitly that `reports`, `research` and `archive` are
evidence/history unless a task asks for their findings.

## 15. Executable Constraint Candidates

| Candidate Rule | Source | Current Enforcement | Automatable? | Proposed Enforcement |
|---|---|---|---|---|
| Every content reference resolves | content model/curriculum | loaders and tests | yes | schema/content validator in CI |
| Stable IDs are unique | content/audio standards | validators/tests | yes | repository lint |
| No broken audio IDs or paths | audio standard and AF evidence | `tool/audio_reference.dart`, tests | yes | manifest and file validator |
| Approved audio has valid asset and entry | AF QA workflow | `tool/audio_reference_qa.dart` and tests | yes | CI gate |
| Canonical order/prerequisites hold | curriculum spec | assembly/validation | yes | curriculum validator |
| Session ordering is deterministic | architecture/state docs | unit tests | yes | deterministic fixture tests |
| Resume/progress state is persisted | architecture/learning docs | application tests | yes | integration test |
| Unsupported content types fail explicitly | content model | loader/runtime switches | yes | validator plus exhaustive handling |
| Answers/support do not leak before allowed state | audio/pedagogy standards | activity tests | partly | integration tests and review checklist |
| Localization keys/required fields are covered | localization standards | Flutter l10n and semantic tools | yes | CI coverage/lint gate |
| No machine paths in content | authoring/audio docs | partial manual review | yes | path-pattern lint |
| Human review status transitions are explicit | AF reports/QA workflow | authoring CLI/tests | yes | state-transition validator |

## 16. Historical / Non-Normative Documents

All `R2*`, `AF4*`, pronunciation implementation/runtime reports, localization
inventories and migration reports, course repair/design/review reports, and
the `docs/research/` corpus should be treated as evidence unless a current
standard explicitly adopts a rule from them. `docs/archive/` is historical by
location. `ARCHITECTURAL_DECISIONS.md` and `AUTHORING_DECISIONS.md` are
decision logs, but their append-only form does not by itself identify which
decision is current.

The main operational risk is that many reports do not carry a consistent
header stating status, owner, date, supersession and normative force. D2 should
add that metadata policy before asking authors to rewrite content.

## 17. Critical Risks

1. No explicit document-level precedence registry.
2. Historical V1 and phase reports can be mistaken for current requirements.
3. Generic names conceal language-shaped content and evaluation assumptions.
4. “Canonical” is overloaded for documents, fields, assets and course slices.
5. Localization reports can be confused between UI, cross-subject educational
   content and language-learning target/support semantics.
6. Duplicate progression/review/authoring rules can drift.
7. Research proposals with imperative wording can be routed as policy.
8. A future non-language subject could inherit inappropriate language rules.

## 18. Recommended D2 Scope

1. Create an authority registry and lifecycle/status vocabulary.
2. Declare precedence for project, platform, pedagogy, subject and evidence
   documents.
3. Add a short status header to existing docs without rewriting their bodies.
4. Mark research, phase and archived material as evidence/history.
5. Resolve the `LEARNING_MODEL` / `LEARNING_STATE_MACHINE` ownership boundary.
6. Resolve `ARCHITECTURE` / V1 contract/spec precedence.
7. Separate UI localization routing from educational localization routing.
8. Add cross-links from secondary guides to canonical owners.
9. Only after the above, consider directory normalization or document moves.

## 19. Open Questions That Must NOT Be Resolved Implicitly

- Which document wins when `PROJECT_CONTRACT`, `ARCHITECTURE`, a V1 contract
  and a phase report disagree?
- Is `LEARNING_MODEL.md` the broad pedagogical model while
  `LEARNING_STATE_MACHINE.md` owns executable transitions, or should one be
  demoted to a reference?
- Are `ARCHITECTURAL_DECISIONS.md` and `AUTHORING_DECISIONS.md` normative
  authorities, or only logs whose adopted decisions must be copied into
  standards?
- Which rules are truly platform invariants versus language-subject rules?
- Is answer evaluation intended to be a generic extension point or currently a
  language-only boundary?
- What is the official status vocabulary for standards, proposals, reports and
  archived documents?
- Who owns the authority registry and approves supersession?
- Should Spanish A0 remain the reference implementation without becoming the
  implicit platform model?
- Which localization source is authoritative for UI strings, educational
  source text, support-language values and release readiness respectively?
- What evidence is required before a research recommendation becomes a
  normative standard?

## D1 Completion Summary and Final Verdict

- Documentation artifacts inspected: **96** (91 Markdown and 4 TSV under
  `docs/`, plus root `README.md`).
- Normative rule clusters: **10**.
- Duplicate-rule clusters: **10**.
- Contradictions by severity: **1 Critical, 3 High, 3 Medium, 0 Low**.

### B — MOSTLY GENERIC WITH LOCALIZED LANGUAGE COUPLING

The verdict is based on the reusable platform shell for lessons, activities,
sessions, persistence, planning and learner history, together with generic
pedagogical concepts for mastery, review, evidence and remediation. It is not
verdict A because the current curriculum specification, content union,
dialogue/vocabulary/grammar/reading objects, typed recall and answer semantics
are materially language-shaped; localization and audio also contain separate
cross-subject and language-learning layers that are not yet formally routed.
