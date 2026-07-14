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

# Spanish A0 Module 5 Shopping Scope

Module 5 teaches a controlled shopping exchange, not a broad commerce unit.

The selected seller/customer register is a polite fixed-form interaction:

- learner asks `¿Tiene...?`;
- seller answers with `tenemos`;
- the module does not teach the full `tú` versus `usted` contrast.

The controlled price and quantity range is intentionally small:

- one, two, three, five and ten;
- prices use `euro/euros`;
- broad numbers, dates, time, bargaining and payment methods are out of scope.

The demonstrative scope is limited to:

- `esto` in `¿Qué es esto?`;
- `este` with practiced masculine nouns;
- `esta` with practiced feminine nouns.

Integrated shopping assessment is bounded and deterministic. It may combine
greeting, availability, price, item request and polite closing, but it must not
require arbitrary free-form shopping dialogue.

---

# QA1 Meaning Equivalence and Active Review Corrections

Spanish A0 Modules 1-4 use deterministic answer acceptance for learner-facing
meaning checks.

Meaning-equivalent English support answers may be accepted when they preserve
the intended meaning. Controlled full-form/contraction pairs such as `I do not`
and `I don't` are equivalent unless the exercise explicitly tests the written
form.

Weak punctuation such as a comma in `repite, por favor` must not create a hard
failure when punctuation is not the learning objective.

Question punctuation and Spanish accents remain pedagogically meaningful and
must not be globally stripped. They should continue to produce either correct,
accepted-with-correction or incorrect according to the existing answer
evaluation policy.

Review tasks in Modules 1-4 must require active learner retrieval,
discrimination or application. Passive display of both sides of a pair is not a
valid review activity.

---

# QA4 Competency Sequence Tolerance

Competency diagnostics may use authored accepted-with-feedback answers when a
learner supplies all required communicative components in a less natural order.

Implemented decisions:

- Module 3 accepts `Me llamo Marta. Hola` for the greeting plus self-
  introduction diagnostic, with feedback preferring `Hola. Me llamo Marta`.
- Module 3 accepts the reversed origin/language question pair with feedback
  preferring the authored order.
- Module 4 accepts reversed independent person-identification facts such as
  `Se llama Marta. Es Marta` with feedback preferring `Es Marta. Se llama
  Marta`.
- Module 5 shopping purchase exchange remains strict-order because the order
  represents a customer/seller interaction sequence.

No global sentence reordering or semantic parsing is allowed. Every tolerated
sequence variant must be authored explicitly.

---

# QA5 Prompt-Intent Misconception Feedback

Prompt-intent mistakes are represented with existing authored misconceptions,
not semantic inference.

Implemented response-type feedback keys include:

- question expected, statement or answer provided;
- statement expected, question provided;
- answer expected, question provided;
- translation expected, source language copied;
- greeting expected, farewell provided;
- farewell expected, greeting provided.

Module 3 origin-question tasks now explain when the learner writes an origin
answer instead of the requested question. Module 1 greeting tasks now explain
copied source-language input and greeting/farewell swaps.

Progressive hints may add deterministic structural support after repeated
local attempts, but no learner-history, persistence or remediation policy is
changed.

---

# Spanish A0 Module 6 Transport and Directions Scope

Module 6 teaches a controlled A0 directions exchange, not broad travel,
transport schedules or map navigation.

The selected route register is a small fixed informal command set:

- `sigue recto`;
- `gira a la izquierda`;
- `gira a la derecha`;
- `toma el metro`;
- `ve en autobús`;
- `ve a pie`.

The module does not teach the full imperative system, formal/informal command
contrast, timetables, ticket buying, addresses, time, platform numbers or
city-map reading.

Route-sequence production tasks may require strict authored order when the
order changes the physical path. Any tolerated alternate sequence must be
authored explicitly; no global sentence reordering or route inference is
allowed.

Transport and directions competency recovery may use earlier conversation
content when the learner fails the predictable question-answer exchange, but
the route and transport knowledge remains owned by Module 6.

---

End of document.
