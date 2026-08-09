# SPANISH_LLY_PRONUNCIATION_POLICY.md

Status: NORMATIVE
Scope: Spanish pronunciation policy for ll/y
Authority: primary

Version: 1.0

Related documents:

- PRONUNCIATION_MODEL.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- READING_RULE_PREREQUISITE_STANDARD.md
- GRAPHEME_PRESENTATION_STANDARD.md
- EDUCATIONAL_CONTENT_LOCALIZATION.md
- SPANISH_A0_CURRICULUM_BLUEPRINT.md
- RELEASE_CHECKLIST.md

---

# Purpose

This document defines the Spanish A0 course policy for `ll` and consonantal
`y` pronunciation.

It is a course-level pronunciation policy. It does not redefine the universal
pronunciation model.

---

# Course Policy

Spanish A0 uses a broad general yeista production norm.

Stable policy identifier:

```text
llYPolicy: yeismo
```

Under this policy:

- `ll` and consonantal `y` share the same broad pronunciation category;
- the course represents that category with broad IPA `/ʝ/`;
- localized learner hints must match the selected yeista policy;
- regional non-yeista `/ʎ/` pronunciation is acknowledged but not taught as
  the Spanish A0 production norm;
- strongly region-specific sheismo or zheismo realizations are acknowledged as
  regional variation, not the primary A0 production norm.

Do not describe this policy as universal Spanish.

---

# Reference Forms

| Target form | IPA | Russian learner hint | English learner hint |
|---|---|---|---|
| `llamo` | `/ˈʝamo/` | `я́мо` | `YAH-moh` |
| `llave` | `/ˈʝaβe/` | `я́ве` | `YAH-veh` |
| `yo` | `/ʝo/` | `йо` | `yoh` |

The Russian production hint for `llamo` is `я́мо`.

Do not use `лья́мо`, `лья́ве` or similar `лья/лье/льё/лью` forms as
production learner hints for `ll` under this course policy.

---

# Grapheme Clarification

When `ll` is first introduced, explain the spelling explicitly:

```text
ll — это две строчные буквы l: l + l.
Не путайте их с двумя заглавными буквами I.
```

Where additional clarity is useful:

```text
строчная l — «эль»
заглавная I — «и»
```

Do not explain `ll` only as a "double letter" without naming the lowercase
letter `l`.

The first active use of `ll` in `llamo` must follow an explicit introduction of
`pronunciation.es.rule.ll_y.v1`. The learner-facing presentation must show the
contrast structurally, not only as prose:

```text
l + l -> ll
I + I -> II
```

The Russian presentation must name lowercase `l` as `«эль»` and uppercase `I`
as `«и»`.

---

# Authoring Rules

For Spanish A0 production content:

- use the `es-general` pronunciation variety unless a later course decision
  replaces it;
- mark `llYPolicy: yeismo` on the relevant pronunciation profile, ReadingRule
  or metadata;
- use `/ʝ/` for the broad `ll/y` IPA category;
- author Russian hints with a `й/я/е/ё/ю`-like onset where appropriate, not
  `ль`;
- keep English hints y-like, not ly-like;
- keep regional `/ʎ/`, sheismo and zheismo explanations as optional contrast
  notes, not production targets;
- do not mix `/ʝ/` IPA with a non-yeista learner hint.

---

# ReadingRule Ownership

The reusable `ll/y` ReadingRule owns:

- stable rule identity;
- target language;
- pronunciation variety;
- `llYPolicy`;
- orthographic pattern;
- broad phonetic outcome;
- example PronunciationUnit references;
- localized learner explanations.

PronunciationUnits such as `llamo`, `llave` and `yo` reference the rule.
Lessons and exercises reference these educational objects. They must not store
their own conflicting `ll/y` pronunciation policy.

---

# Validation Requirements

Validation should detect these deterministic issues:

- `pronunciation.varietyIpaMismatch`
- `pronunciation.varietyLearnerHintMismatch`
- `pronunciation.llYPolicyMismatch`
- `pronunciation.nonYeistaHintInYeistaProfile`
- `pronunciation.ambiguousGraphemeExplanation`
- `readingRule.varietyOutcomeMismatch`
- `readingRule.localizedExplanationContradictsBaseRule`

Coverage reporting should include:

- `ll/y` PronunciationUnits;
- units consistent with the selected variety;
- units with matching IPA;
- units with Russian learner hints;
- units with English learner hints;
- units with grapheme explanations;
- variety mismatches;
- non-yeista hints in a yeista profile.

---

# Current Runtime Status

The migrated Spanish A0 pronunciation reference slice implements this policy
for the release-reference `ll/y` units.

Full-course pronunciation migration remains incremental. Other words
containing `ll` or consonantal `y` must be migrated to PronunciationUnits
before their pronunciation data is treated as release-complete.

---

End of document.
