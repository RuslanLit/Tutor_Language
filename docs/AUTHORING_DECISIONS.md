# AUTHORING_DECISIONS.md

Status: Active

Version: 1.0

Related documents:

- CONTENT_MODEL.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- CURRICULUM_SPEC.md
- LANGUAGE_COURSE_BLUEPRINT.md

---

# Purpose

This document records stable editorial decisions for Tutor Language educational authors.

It explains why certain modelling choices are preferred when creating educational content.

It is not an architecture document.

It is not a tutorial.

Architecture is defined in ARCHITECTURE.md, ARCHITECTURAL_DECISIONS.md and CONTENT_MODEL.md.

Practical writing guidance is defined in CONTENT_AUTHORING_GUIDE.md and COURSE_AUTHORING_GUIDE.md.

---

# Exercise Templates

Exercise Templates define interaction patterns.

They do not contain educational knowledge.

Concrete educational material should be referenced from Educational Content.

This keeps exercises reusable and prevents the same knowledge from being hidden inside multiple templates.

---

# LessonDefinitions

LessonDefinition organizes Educational Content.

LessonDefinition never duplicates Educational Content.

A LessonDefinition may define order, activities, objectives and completion structure, but vocabulary, grammar explanations, dialogues, readings and exercise material belong in Educational Content.

---

# Vocabulary Items

Vocabulary Items represent lexical concepts.

Single words, numbers, names and multi-word fixed expressions may all be Vocabulary Items when they are taught as meaningful lexical units.

Multi-word fixed expressions remain Vocabulary Items unless they are explicitly being taught as productive grammar.

This keeps early beginner content simple and avoids turning every useful phrase into a grammar topic.

---

# Grammar Topics

Grammar Topics represent reusable language patterns.

Grammar Topics should explain generative behaviour rather than isolated examples.

If a learner is expected to reuse a pattern productively across new words or contexts, it usually belongs in a Grammar Topic.

If a learner is only expected to recognize or use a fixed phrase as a chunk, it usually belongs in a Vocabulary Item.

---

# Dialogues

Dialogue demonstrates communication.

Dialogue should reuse existing Vocabulary Items and Grammar Topics.

Dialogue should not duplicate educational knowledge.

A dialogue may show how knowledge behaves in context, but the reusable vocabulary and grammar should remain independently referenceable.

---

# Reading Texts

Reading Text demonstrates recognition and contextual understanding.

Reading Texts should reference Vocabulary Items and Grammar Topics whenever practical.

Not every word in a Reading Text must become a Vocabulary Item.

Only words or expressions that are intentionally taught, reviewed or tracked as educational knowledge need independent Vocabulary Items.

---

# Presentation Assets

Presentation assets such as audio, images and video are representations of Educational Content.

They are not Educational Content themselves.

Media should support existing knowledge objects rather than create parallel knowledge models.

---

# Simplicity

Prefer the simplest educational model that preserves meaning.

Do not introduce additional modelling complexity unless educational meaning would otherwise be lost.

Convenience for a single lesson is not enough reason to create a new modelling pattern.

---

# Reference-First Authoring

When introducing a new educational modelling pattern into the project:

1. Create one complete reference implementation.
2. Validate it.
3. Review it.
4. Only then replicate it across additional lessons.

Reference-first authoring is the preferred strategy for Tutor Language.

It keeps large-scale content production consistent, testable and easier to improve.

---

End of document.
