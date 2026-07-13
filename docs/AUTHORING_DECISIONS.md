# AUTHORING_DECISIONS.md

Status: Active

Version: 1.0

Related documents:

- AUTHORING_STYLE_GUIDE.md
- CONTENT_MODEL.md
- CONTENT_AUTHORING_GUIDE.md
- COURSE_AUTHORING_GUIDE.md
- CONTENT_REVIEW_CHECKLIST.md
- CURRICULUM_SPEC.md
- LANGUAGE_COURSE_BLUEPRINT.md

---

# Purpose

This document records stable editorial decisions for Tutor Language educational authors.

It explains why certain modelling choices are preferred when creating educational content.

It is not an architecture document.

It is not a tutorial.

Architecture is defined in ARCHITECTURE.md, ARCHITECTURAL_DECISIONS.md and CONTENT_MODEL.md.

Practical writing style is defined in AUTHORING_STYLE_GUIDE.md.

Educational Content authoring guidance is defined in CONTENT_AUTHORING_GUIDE.md.

Course, Module and LessonDefinition authoring guidance is defined in COURSE_AUTHORING_GUIDE.md.

Publication readiness checks are defined in CONTENT_REVIEW_CHECKLIST.md.

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

Operational review steps belong in CONTENT_REVIEW_CHECKLIST.md.

---

# Spanish A0 Module 3 Identity Scope

Module 3 teaches a bounded personal identity exchange rather than a broad
geography or language-learning unit.

The controlled scope is:

- origin with `soy de`;
- residence with `vivo en`;
- spoken languages with `hablo`;
- limited language ability with `un poco de`;
- short personal identity profiles using known Module 1-3 patterns.

Countries, cities and languages are intentionally limited to a small reusable
pool. Ukraine, Kyiv and Ukrainian are included because they are useful to the
initial learner, but examples must rotate through other countries, cities and
speakers so the module does not become country-specific.

Origin and residence are authored as distinct communicative meanings. Prompts
must specify whether the learner should answer where someone is from or where
someone lives. Misconception feedback may explain `soy de` versus `vivo en`
only when the exercise objective makes the distinction explicit.

Integrated profile tasks must remain bounded and deterministic. They may ask
for a specified profile using authored canonical sentences, but they must not
require unrestricted creative writing or semantic inference.

---

# Spanish A0 Module 4 People Scope

Module 4 teaches controlled third-person people descriptions, not a broad
pronoun or adjective-agreement unit.

The controlled scope is:

- identifying a person with `¿Quién es?` and `es`;
- saying another person's name with `se llama`;
- simple roles and relationships such as `mi amigo/amiga` and
  `profesor/profesora`;
- controlled descriptions such as `simpático/simpática`, `alto/alta` and
  `joven`;
- third-person origin, residence and language facts using `es de`, `vive en`
  and `habla`;
- short yes/no questions and predictable everyday exchanges about another
  person.

Canonical Module 4 production lessons use `es.a0.m04.l020` through
`es.a0.m04.l027`. Existing older Module 4 lesson IDs must not be repurposed for
new meanings.

Module 4 competency recovery may use Module 3 prerequisite content for origin,
residence and language facts. That recovery does not transfer lesson ownership
across modules.

---

End of document.
