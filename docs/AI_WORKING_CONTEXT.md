# AI_WORKING_CONTEXT.md

Status: NORMATIVE
Scope: context routing for AI coding and authoring agents

## 1. Mandatory Initial Procedure

For every significant task:

1. Read `docs/PROJECT_INVARIANTS.md`.
2. Read `docs/DOCUMENTATION_AUTHORITY.md`.
3. Classify the task by platform, pedagogy, application or subject scope.
4. Load only the current normative owners required by that scope.
5. Load derived guides/checklists when operationally useful.
6. Load evidence/research only when history, QA findings or research is needed.
7. Identify the applicable subject; never infer a platform rule from a subject
   implementation.
8. Check for conflicts before editing.
9. Verify applicable normative constraints after changes.

## 2. Context-Minimization Rule

Do not load the complete documentation corpus by default. The objective is the
smallest sufficient authoritative context for the task. More documentation is
not automatically safer; irrelevant normative and historical material
increases ambiguity.

## 3. Task Routing

| Task scope | Read | Do not automatically load |
|---|---|---|
| Platform/runtime/state/persistence | invariants, authority registry, `ARCHITECTURE.md`, relevant state/persistence owner | Spanish authoring documents |
| Generic pedagogy | invariants, registry, `EDUCATIONAL_PRINCIPLES.md`, state/scenario authority as relevant | subject reports |
| Language-learning content authoring | platform/pedagogy owners needed by task, language standards, specific course authority | unrelated phase reports |
| Spanish course | language-domain standards, `SPANISH_A0_CURRICULUM_BLUEPRINT.md`, relevant current course evidence | treating Spanish rules as platform rules |
| Pronunciation/writing systems | pronunciation, writing, reading and applicable course policies only | unrelated runtime/research corpus |
| UI localization | application/UI localization authority and affected runtime docs | educational semantic localization reports |
| Educational content localization | cross-subject localization authority plus relevant subject/course authority | target-language pronunciation reports unless needed |
| Target/support language behavior | language-learning localization and authoring standards | UI localization and generic educational localization evidence |
| Future non-language subject | invariants, registry, architecture, generic pedagogy, that subject's standards | language-domain standards unless genuinely relevant |
| Release/QA | release authority plus normative owners for validated components | reports as authority; reports may be evidence |

## 4. Conflict Rule

If two applicable current normative sources appear to conflict:

1. consult `DOCUMENTATION_AUTHORITY.md`;
2. determine scope ownership;
3. follow registered supersession or precedence;
4. if unresolved, stop the affected implementation;
5. report both sources and the exact conflict.

Never silently choose the newer, longer or more plausible document.

## 5. Pre-Change Declaration

For significant implementation or content tasks, state before editing:

```text
Task scope:
Applicable project invariants:
Primary normative documents:
Subject-specific documents:
Derived guides:
Evidence/reports consulted:
Potential conflicts:
```

## 6. Post-Change Verification

Finish significant tasks with:

```text
Normative verification:
- invariant / rule -> PASS / FAIL / NOT APPLICABLE

Technical validation:
- relevant tests
- analyzer/lint
- git diff --check
```

This routing and verification convention does not replace machine tests,
human review or the authority of the scoped normative documents.
