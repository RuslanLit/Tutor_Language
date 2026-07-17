# LESSON_AUTHORING_ENTRYPOINT.md

Status: Active

Version: 1.0

---

# Purpose

This is the compact entry point for authoring or reviewing a Tutor Language lesson.

Do not load every project document as equal-priority lesson-authoring context.
Architecture and schema documents are consulted only after the pedagogical scenario is
approved and must be mapped into implementation.

---

# Required Reading Order

Read in this order before creating or rewriting a lesson:

1. `LEARNING_STATE_MACHINE.md`
   - Defines learner states, valid transitions, support fading, repetition, and
     remediation.

2. `PEDAGOGICAL_SCENARIO_MODEL.md`
   - Defines how to turn a measurable lesson outcome into scenario steps before any
     JSON or content assets are written.

3. Curriculum objective documents
   - Use `COURSE_AUTHORING_GUIDE.md`, `CURRICULUM_SPEC.md`, and the relevant
     language-specific curriculum blueprint to confirm the lesson's place in the
     course.

4. Content authoring rules
   - Use `CONTENT_AUTHORING_GUIDE.md`, `CONTENT_MODEL.md`, and
     `AUTHORING_STYLE_GUIDE.md` after the scenario is approved.

5. Pronunciation, writing-system, and localization rules as applicable
   - Use `PRONUNCIATION_AUTHORING_GUIDE.md`, `WRITING_SYSTEM_STANDARD.md`,
     `EDUCATIONAL_LANGUAGE_STANDARD.md`, and localization standards when the scenario
     contains new written forms, reading rules, pronunciation support, or
     support-language learner text.

6. Review protocol
   - Use `CONTENT_REVIEW_PROTOCOL.md` and `CONTENT_REVIEW_CHECKLIST.md` before
     production approval.

7. Architecture and schema documents
   - Use `ARCHITECTURE.md`, `ARCHITECTURAL_DECISIONS.md`, and implementation-specific
     references only when mapping an approved scenario into runtime-supported content.

---

# Authoring Rule

The required workflow is:

```text
learner state -> scenario -> learner action -> support plan -> assessment plan
-> content mapping -> JSON/assets
```

The prohibited workflow is:

```text
existing JSON -> content category -> wording edits -> lesson
```

If the scenario cannot be mapped cleanly to current Tutor Language mechanisms, record
the gap. Do not redesign the scenario around a convenient storage category.
