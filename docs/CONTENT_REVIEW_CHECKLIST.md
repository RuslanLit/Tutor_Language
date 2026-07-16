# Content Review Checklist

Status: Active

Version: 1.0

Related documents:

- EDUCATIONAL_PRINCIPLES.md
- EDUCATIONAL_LANGUAGE_STANDARD.md
- AUTHORING_STYLE_GUIDE.md
- CONTENT_MODEL.md
- AUTHORING_DECISIONS.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- CONTENT_REVIEW_PROTOCOL.md
- WRITING_SYSTEM_STANDARD.md
- WRITING_UNIT_INTRODUCTION_STANDARD.md
- CURRICULUM_SPEC.md
- LEARNING_MODEL.md

---

# Purpose

This checklist defines when a lesson or content slice is ready for commit, release, or replication across additional lessons.

It is a practical Definition of Done for educational content review.

For learner-facing writing style, use AUTHORING_STYLE_GUIDE.md.

For the mandatory educational-language quality standard, use
EDUCATIONAL_LANGUAGE_STANDARD.md.

For Educational Content authoring rules, use CONTENT_AUTHORING_GUIDE.md.

For Course, Module and LessonDefinition sequencing, use COURSE_AUTHORING_GUIDE.md.

For the mandatory review process, use CONTENT_REVIEW_PROTOCOL.md.

---

# Scope

- [ ] The lesson implements only the intended curriculum scope.
- [ ] No future lesson content was introduced.
- [ ] The lesson matches its LessonDefinition objective and communicative outcome.
- [ ] The workload fits the expected learner duration.
- [ ] The content is appropriate for the target learner level.

---

# Curriculum and LessonDefinition

- [ ] LessonDefinition organizes Educational Content.
- [ ] LessonDefinition does not duplicate educational knowledge.
- [ ] Sections and activities are ordered pedagogically.
- [ ] All references are stable.
- [ ] All references resolve correctly.
- [ ] WritingUnit introductions, requirements and reviews use stable IDs where
      supported.
- [ ] No active use of a new written symbol occurs before its WritingUnit
      introduction.
- [ ] Symbol, designation, conventional name, reading, pronunciation and
      meaning/function are not conflated.
- [ ] Conventional names exist where applicable.
- [ ] Name pronunciation exists where a conventional spoken name is taught.
- [ ] All taught readings are represented.
- [ ] Contrastive stress, tone, length or other required pronunciation features
      are preserved.
- [ ] Confusable symbols include learner guidance where required.
- [ ] Accessibility descriptions distinguish confusable units.
- [ ] ReadingRule introductions, requirements and reviews use stable IDs.
- [ ] No active ReadingRule use occurs before explicit introduction.
- [ ] Visually confusable graphemes include decomposition, localized letter
      names and accessibility text.
- [ ] No Learner State is stored in LessonDefinition.
- [ ] Generated Exercises are not stored in LessonDefinition.

---

# Educational Content Integrity

- [ ] All Educational Content objects have stable identifiers.
- [ ] No duplicated educational meaning exists under different IDs.
- [ ] Existing Vocabulary Items and Grammar Topics are reused when appropriate.
- [ ] Relationships use references rather than duplication.
- [ ] Broken references are treated as content defects.
- [ ] Educational Content contains no learner progress.

---

# Vocabulary Items

- [ ] Each Vocabulary Item represents one lexical concept.
- [ ] Multi-word fixed expressions are Vocabulary Items when taught as chunks.
- [ ] Meaning is present.
- [ ] Pronunciation is present where the current schema supports it.
- [ ] CEFR level is present.
- [ ] Example usage is present.
- [ ] Vocabulary does not contain learner progress.

---

# Grammar Topics

- [ ] Each Grammar Topic represents a reusable pattern.
- [ ] Grammar is not created for isolated fixed phrases.
- [ ] Explanations are concise and level-appropriate.
- [ ] Examples are minimal and support the rule.
- [ ] Prerequisites are valid where used.
- [ ] Grammar Topics do not contain learner performance.

---

# Dialogue

- [ ] Dialogue demonstrates communication.
- [ ] Dialogue references existing Vocabulary Items and Grammar Topics where practical.
- [ ] Dialogue does not duplicate educational knowledge.
- [ ] Dialogue does not introduce unexplained material without purpose.
- [ ] Dialogue is appropriate for the learner level.
- [ ] Dialogue length fits the lesson scope.

---

# Reading Text

- [ ] Reading Text supports recognition, consolidation, or contextual understanding.
- [ ] Reading Text references known or target Vocabulary and Grammar where practical.
- [ ] Not every word is required to be referenced.
- [ ] Unexplained vocabulary is intentional and level-appropriate.
- [ ] Reading complexity fits the learner level.

---

# Exercise Templates

- [ ] Exercise Templates define interaction patterns.
- [ ] Exercise Templates do not contain educational knowledge.
- [ ] Concrete educational material is always referenced from Educational Content.
- [ ] Exercise Templates do not become hidden lesson content.
- [ ] Correct answers are derived from referenced Educational Content or explicit template structure.
- [ ] Exercises match the taught material.
- [ ] Exercises do not test untaught knowledge.
- [ ] The exercise mode matches the intended retrieval demand.
- [ ] Multiple choice is used as recognition or scaffolding, not as the only proof of active use.
- [ ] Distractors are plausible and do not make the correct answer obvious by absurdity.
- [ ] The learner cannot pass primarily by guessing.
- [ ] Recall follows recognition when the learner has enough support.
- [ ] Typed production is used where active recall or controlled application is the objective and the current implementation supports it.
- [ ] Prompts clearly state what kind of answer is expected.
- [ ] Accepted alternatives are intentional and documented.
- [ ] Orthographic differences are handled pedagogically where deterministic rules support them.
- [ ] Feedback explains a useful distinction rather than merely labelling an answer wrong.
- [ ] Authored misconception feedback is valid for the exact exercise objective and does not overgeneralize.

---

# Pedagogical Sequence

- [ ] The lesson teaches before testing.
- [ ] New vocabulary appears before exercises that require it.
- [ ] New grammar appears before productive use.
- [ ] The lesson starts simple and increases difficulty gradually.
- [ ] The lesson avoids unnecessary cognitive load.
- [ ] The recap reflects what was actually taught.
- [ ] Learner-facing wording follows AUTHORING_STYLE_GUIDE.md.

---

# Media and Presentation

- [ ] Audio, images, and video are treated as presentation assets.
- [ ] Media represents Educational Content rather than becoming a new knowledge type.
- [ ] Missing media does not break the knowledge model unless the lesson explicitly requires that modality.
- [ ] Presentation supports the educational objective.

---

# Validation

- [ ] JSON parses successfully.
- [ ] Educational Content validation passes.
- [ ] Curriculum validation passes.
- [ ] LessonAssemblyService resolves references.
- [ ] Content integrity checks pass.
- [ ] Migrated SemanticLocalizationUnit content has protected spans, context,
      named entity metadata and approved review status where required.
- [ ] Relevant tests pass.
- [ ] Any skipped tests are documented.

---

# Reference-First Review

- [ ] New modelling patterns are first implemented once.
- [ ] The reference implementation is validated.
- [ ] The reference implementation is reviewed.
- [ ] The pattern is not scaled until accepted.

---

# Final Acceptance

- [ ] Would this lesson be acceptable as a learner-facing lesson?
- [ ] Would this lesson be safe to use as a template for future lessons?
- [ ] Would scaling this pattern to 30+ lessons create maintainable content?

---

End of document.
