# CURRICULUM_SPEC.md

Status: Active

Version: 1.3

Related documents:

- ARCHITECTURE.md
- ARCHITECTURAL_DECISIONS.md
- CONTENT_MODEL.md
- LEARNING_MODEL.md

---

# Purpose

This document defines the structure of educational curricula used by Tutor Language.

It specifies how educational content is organized independently of any particular language.

The curriculum is a data model.

It does not define pedagogy.

It does not define implementation.

---

# Scope

This specification applies to every Language Pack.

Every supported language follows the same curriculum structure.

Generation 1 ships only with the Spanish Language Pack.

This limits available content, not the curriculum architecture.

---

# Design Principles

The curriculum shall be:

- language-independent;
- deterministic;
- hierarchical;
- extensible;
- versionable;
- stable across releases;
- compatible with offline use.

---

# Curriculum Hierarchy

Every Language Pack follows the same hierarchy.

```text
Language Pack
    │
    └── Language
            │
            └── Course
                    │
                    └── Module
                            │
                            └── LessonDefinition
                                    │
                                    └── Activities
```

Each level owns exactly one responsibility.

Language Pack

A Language Pack is a complete package of educational data for one supported language.

A Language Pack may contain:

language metadata;
one or more courses;
modules;
LessonDefinitions;
vocabulary;
grammar topics;
dialogues;
readings;
listening materials;
exercises;
audio assets.

A Language Pack never contains learner progress.

A Language Pack should be replaceable and versionable.

Language

Language represents one supported target language.

Examples:

Spanish
English
German
French

Language defines only metadata.

Examples:

identifier;
ISO language code;
display name;
native name;
writing system;
text direction;
optional regional variant.

Language never contains learner progress.

Course

Course represents one complete learning program inside a Language Pack.

Examples:

Spanish A0
Spanish A1
English Beginner
German A1

A course contains one or more modules.

A Language Pack may contain multiple courses.

Module

Module groups LessonDefinitions around one educational theme.

Examples:

Greetings
Family
Travel
Food
Present Tense
Past Tense

Modules improve structure and navigation.

Modules do not perform pedagogy.

Modules do not store learner progress.

LessonDefinition

LessonDefinition is the smallest independently completable educational unit.

A LessonDefinition is static curriculum data.

It is not a generated Lesson Session.

It is not learner state.

It is not a generated exercise.

Every LessonDefinition has:

metadata;
objectives;
sections;
activities;
summary;
completion criteria;
references.

LessonDefinition metadata contains:

stable identifier;
title;
module identifier;
course identifier;
estimated duration;
difficulty level;
tags;
version;
prerequisites.

LessonDefinition sections group ordered activities.

LessonDefinition activities may include:

vocabulary;
dialogue;
grammar;
reading;
listening;
exercise;
review.

A LessonDefinition may contain any subset of activity types.

A LessonDefinition does not need every activity type.

LessonDefinition activities reference Educational Content.

LessonDefinitions must not embed vocabulary, grammar explanations, dialogues, readings or exercise definitions.

LessonDefinition activities describe the structure and referenced source material available to lesson planning and assembly.

The Rule-Based Lesson Planner may select a LessonDefinition.

The LessonAssemblyService may assemble lesson content from a selected LessonDefinition and referenced Educational Content without modifying the LessonDefinition.

Generated Exercises are runtime objects and must not be stored inside LessonDefinitions.

LessonDefinition summaries describe what should be reviewed without evaluating the learner.

Completion criteria are structural requirements.

They do not perform evaluation and do not calculate learner progress.

LessonDefinitions should remain small.

Recommended duration:

10–20 minutes.

LessonDefinition Identifiers

Every curriculum entity must have a stable identifier.

Identifiers should not change after release.

Stable identifiers are required for:

learner progress;
review scheduling;
content references;
migration between curriculum versions.

Examples:

es.a0.module_01.lesson_001
es.a0.vocabulary.hola
es.a0.grammar.ser_present_intro

Identifiers are implementation-neutral.

Exact file format is defined outside this document.

LessonDefinition Objectives

Objectives describe what the learner should achieve.

Examples:

learn vocabulary;
understand grammar;
improve reading;
practice listening;
reinforce previous knowledge;
complete a communicative task.

Objectives should be measurable.

A lesson may have multiple objectives.

A lesson should have one primary objective.

LessonDefinition Prerequisites

LessonDefinitions may require previous LessonDefinitions or specific knowledge items.

Generation 1 primarily uses linear prerequisites.

Future versions may support arbitrary dependency graphs.

Prerequisites should reference stable identifiers.

Activities

LessonDefinitions consist of activities.

Examples:

vocabulary;
dialogue;
grammar;
reading;
listening;
exercises;
review.

The order of activities is defined by the curriculum.

Activities reference educational content.

Activities do not store learner progress.

Vocabulary

Vocabulary introduces lexical items.

Each vocabulary item should have:

stable identifier;
target-language form;
learner-language meaning or explanation;
part of speech when useful;
example usage when useful;
optional pronunciation or audio reference;
optional tags.

Vocabulary may appear in later lessons and reviews.

A vocabulary item should be introduced once.

Reuse should happen through references.

Dialogue

Dialogues demonstrate vocabulary and grammar in realistic situations.

Dialogues should reinforce communication.

Dialogues may contain:

speakers;
lines;
translations;
audio references;
related vocabulary;
related grammar topics.

Dialogues should avoid introducing excessive unknown material.

Grammar

Grammar introduces one concept at a time.

Grammar topics should have:

stable identifier;
short explanation;
examples;
related exercises;
optional notes.

Grammar explanations should remain concise.

Grammar is always accompanied by practice.

Reading

Reading develops comprehension.

Reading should primarily reinforce known vocabulary and grammar.

Unknown vocabulary should remain limited.

Reading materials may contain:

title;
text;
translation or explanation;
vocabulary references;
grammar references;
comprehension exercises.
Listening

Listening develops comprehension of spoken language.

Listening should correspond to previously introduced material.

Listening materials may contain:

transcript;
audio asset reference;
related vocabulary;
related grammar;
comprehension exercises.

If audio is unavailable, the lesson should remain usable in text mode when practical.

Exercises

Exercises reinforce lesson objectives.

Examples include:

multiple choice;
fill blanks;
ordering;
matching;
translation;
listening;
speaking;
typing.

Exercises should reference the knowledge they practice.

Exercise implementation is defined elsewhere.

Review LessonDefinitions

Review LessonDefinitions consolidate previously studied material.

They introduce little or no new knowledge.

Review LessonDefinitions may include:

vocabulary recall;
grammar reinforcement;
dialogue reconstruction;
reading comprehension;
listening comprehension;
mixed exercises.

Review scheduling is controlled by the learning engine.

Assessment

LessonDefinition completion depends on measurable criteria.

Examples:

required activities completed;
minimum score achieved;
mandatory exercise passed;
completion evaluator accepted the session.

Assessment rules belong to the learning engine.

The curriculum may define completion criteria.

Completion criteria are structural data.

Examples:

required activities;
minimum completed activities;
mandatory sections.

The engine decides whether those criteria are satisfied.

Difficulty

LessonDefinitions should increase in difficulty gradually.

Difficulty progression should remain smooth.

Large jumps should be avoided.

Difficulty may be expressed as metadata.

Examples:

beginner;
elementary;
intermediate;
numeric level;
CEFR-like level.

Exact difficulty representation is implementation-specific.

Reuse

Educational objects should be reusable.

Vocabulary introduced once may appear in:

dialogues;
readings;
reviews;
future lessons;
exercises.

Content duplication should be avoided.

References should be preferred over copying.

Content Independence

Educational content must remain independent from learner progress.

The same lesson is shared by every learner.

Personalization is performed by the learning engine.

Curriculum data describes what can be taught.

It does not decide what should be taught next.

Localization

Curriculum structure is identical across languages.

Only educational content changes.

The learning engine remains unchanged.

Language-specific properties should be represented as metadata.

Examples:

writing system;
text direction;
pronunciation notes;
regional variant;
transliteration support.
Versioning

Curricula should evolve without breaking learner progress whenever practical.

New lessons may be added.

Existing identifiers should remain stable.

Released identifiers should not be reused for different educational meaning.

When breaking changes are unavoidable, migration should be explicit.

Validation

A curriculum should be validated before release.

Validation should check:

stable identifiers exist;
references resolve;
prerequisites are valid;
lesson order is valid;
required activities exist;
required content exists;
no obvious circular prerequisite chain exists;
language metadata exists.

Validation should be deterministic.

Future Extensions

Future versions may introduce:

elective lessons;
branching curricula;
adaptive curricula;
cultural modules;
certification tracks;
placement tests;
dialect-specific courses;
pronunciation tracks.

These extensions should not invalidate this specification.

Final Principle

The curriculum defines what can be taught.

The learning engine decides what should be taught next.

Educational content provides the material.

Learner models store learner-specific state.

These responsibilities remain independent.

End of document.
