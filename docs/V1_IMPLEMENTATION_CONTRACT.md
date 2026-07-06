# V1_IMPLEMENTATION_CONTRACT.md

Status: Active

Version: 2.0

Related documents:

- PROJECT_CONTRACT.md
- ARCHITECTURE.md
- LEARNING_MODEL.md
- CONTENT_MODEL.md
- V1_TECHNICAL_SPEC.md

---

# Purpose

This document defines the minimum implementation contract for Tutor Language Generation 1.

Its purpose is to eliminate architectural ambiguity during implementation.

Every object, responsibility and rule defined here is considered mandatory for V1.

If implementation conflicts with this document, this document has higher priority.

---

# Scope

This contract applies only to Generation 1.

Generation 1 supports:

- Spanish only;
- Android only;
- offline operation only;
- deterministic educational planning;
- template-based lesson generation.

Everything else is outside the scope of this contract.

---

# Canonical Terminology

The following names are mandatory.

Use exactly these names throughout the project.

Educational Content

Educational Structure

Learner State

Review Queue

Lesson Planner

Lesson Goal

Lesson Constraints

Lesson Generator

Lesson Session

Evaluation

Evaluation Result

Learner State Update

Generated Exercise

Do not introduce synonyms.

Do not use:

- Rule Engine
- Pedagogical Rule Engine
- Learner Profile Update

---

# Educational Content Packaging

Educational Content is bundled with the application.

Source of truth:

```text
app/assets/spanish/
```

Generation 1 uses:

```text
app/assets/spanish/

├── vocabulary/
├── grammar/
├── templates/
├── dialogues/
├── readings/
└── curriculum/
```

The application must never require downloading educational content.

---

# Stable Identifiers

Every Educational Object must have a stable string identifier.

Recommended format:

```text
category.slug.version
```

Examples:

```text
vocab.hola.v1

grammar.ser_present.v1

dialogue.introduction_001.v1

reading.family_001.v1

template.multiple_choice_basic.v1

topic.greetings.v1
```

Identifiers represent educational concepts.

Identifiers should remain stable across future application versions.

---

# Minimal Educational Objects

## Vocabulary Item

Required fields:

- id
- spanish
- native_translation
- cefr
- topic_ids
- example

Optional:

- pronunciation
- notes

---

## Grammar Topic

Required:

- id
- title
- explanation
- examples
- prerequisite_ids
- topic_ids

---

## Exercise Template

Required:

- id
- exercise_type
- supported_goal_types
- required_object_types
- prompt_template

Generation 1 required exercise types:

- multiple_choice
- fill_gap
- matching

Generation 2:

- translation
- sentence_ordering
- dialogue
- speaking

---

## Dialogue

Required:

- id
- title
- topic_ids
- vocabulary_ids
- grammar_ids
- lines

Optional in Generation 1.

---

## Reading Text

Required:

- id
- title
- topic_ids
- vocabulary_ids
- grammar_ids
- text
- native_translation

Optional in Generation 1.

---

# Generated Exercise

Generated Exercises are runtime objects.

They:

- are created by Lesson Generator;
- exist only during Lesson Session;
- are discarded after Evaluation.

Generated Exercises must never become Educational Content.

Only learning outcomes remain persistent.

---

# Learner State

Generation 1 stores learner state independently from Educational Content.

Every tracked educational object contains:

- object_id
- state
- mastery_score
- correct_count
- incorrect_count
- last_seen_at

Allowed states:

- unseen
- learning
- reviewing
- mastered

mastery_score range:

0.0 → 1.0

---

# Review Queue

Every Review Queue item contains:

- object_id
- object_type
- priority
- reason
- due_at

Allowed object types:

- vocabulary
- grammar

Allowed reasons:

- mistake
- scheduled_review
- low_mastery
- declining_retention

Priority range:

0 → 100

Higher priority means earlier review.

---

# Lesson Goal

Every lesson has exactly one primary goal.

Generation 1 supports:

- introduce_vocabulary
- review_vocabulary
- introduce_grammar
- review_grammar
- mixed_review

Minimal fields:

- goal_type
- target_topic_id
- target_object_ids

---

# Lesson Constraints

Every generated lesson must satisfy Lesson Constraints.

Required fields:

- lesson_goal
- max_new_items
- max_review_items
- allowed_exercise_types
- target_duration_minutes
- difficulty

Allowed difficulty:

- easy
- normal
- hard

Generation 1 default:

normal

---

# Evaluation Result

Every answered exercise produces exactly one Evaluation Result.

Required fields:

- exercise_id
- is_correct
- user_answer
- expected_answer
- related_object_ids
- error_category
- timestamp

Generation 1 error categories:

- vocabulary
- grammar
- spelling
- accent
- word_order
- missing_answer
- unknown

Generation 1 evaluation supports:

- exact match;
- lowercase normalization;
- whitespace normalization;
- predefined accepted alternatives.

---

# Learner State Update

Generation 1 update rules.

Correct answer:

- correct_count += 1
- mastery_score += 0.10
- update last_seen_at
- reduce review priority
- if mastery_score ≥ 0.80 → mastered

Incorrect answer:

- incorrect_count += 1
- mastery_score -= 0.15
- update last_seen_at
- state → reviewing
- create or update Review Queue item
- increase review priority

Clamp rule:

mastery_score always remains within:

0.0 → 1.0

---

# Lesson Planner Rules

Generation 1 intentionally keeps the planner simple.

Required rules:

1. No learner history → first curriculum topic.
2. High review pressure → review lesson.
3. Lesson accuracy < 70% → reduce new material.
4. Lesson accuracy > 85% and low review pressure → allow new material.
5. Repeated mistakes → remain in review.
6. Respect Lesson Constraints.
7. Respect curriculum prerequisites.

Generation 1 should remain below twenty deterministic planning rules.

---

# Content Loading

Generation 1 loads Educational Content from bundled JSON assets.

Educational Content is immutable.

Learner State is stored separately.

Educational Content must never be modified during learning.

---

# Persistence Principle

The following information is persistent:

- Educational Content
- Learner State
- Review Queue
- Evaluation Results
- Learning Statistics

The following information is temporary:

- Generated Exercises
- Lesson Sessions
- Runtime lesson objects

Educational interactions are temporary.

Learning outcomes are permanent.

---

# Acceptance Criteria

Generation 1 implementation satisfies this contract only if:

- the application runs fully offline;
- Educational Content loads from bundled assets;
- Educational Content and Learner State are stored separately;
- all Educational Objects use stable identifiers;
- Lesson Planner produces Lesson Goal and Lesson Constraints;
- Lesson Generator never violates Lesson Constraints;
- every exercise produces one Evaluation Result;
- Learner State Update is the only component allowed to modify Learner State;
- Review Queue influences future lesson planning;
- no AI is required;
- no Internet connection is required.

---

# Final Principle

Generation 1 prioritizes correctness over sophistication.

The goal is not to build the smartest tutor.

The goal is to build a deterministic educational system that can evolve safely over many years.

Future versions may increase intelligence.

They must not weaken architectural clarity.

---

End of document.