# Spanish A0 Foundational Reading Sequence

Status: Active

Version: 1.0

Related documents:

- READING_RULE_PREREQUISITE_STANDARD.md
- PRONUNCIATION_MODEL.md
- PRONUNCIATION_AUTHORING_GUIDE.md
- SPANISH_A0_CURRICULUM_BLUEPRINT.md
- RELEASE_CHECKLIST.md

---

# Purpose

This document defines the learner-visible reading foundation sequence for the
first Spanish A0 modules.

It exists to prevent active recall of Spanish target forms before the learner
has seen the ReadingRules required to decode those forms.

---

# Canonical Early Sequence

The first visible Spanish A0 lessons must introduce reading support in this
order:

1. `es.a0.m06.l016` - Spanish vowels, silent `h`, stress, and the high-frequency
   reading patterns needed for early greetings.
2. `es.a0.m01.l001` - greetings and goodbye phrases that reuse the introduced
   reading foundation.
3. `es.a0.m06.l017` - `ñ`, `j`, and `ll/y` for names and first-contact words.
4. `es.a0.m01.l002` and later lessons - courtesy, clarification, and name
   lessons that reuse the foundation.
5. `es.a0.m02.l004` - `me llamo` recall, after `ll/y` has already been
   introduced.

Stable lesson IDs are preserved for learner progress compatibility.

---

# Rule Selection Method

The first foundation is selected from actual early content, not from a full
Spanish phonology checklist.

Rules are promoted into the first foundation when they satisfy all of these:

- they are required by an active target form in Modules 1-2;
- they affect several early words or an especially early typed-recall item;
- the learner cannot reasonably infer the pronunciation from previous
  instruction;
- the rule can be presented at A0 without turning the lesson into a dense
  phonetics lecture.

Rules may remain deferred when they appear only in passive vocabulary previews
or when the current lesson does not ask the learner to decode, type, or recall
the affected form.

---

# First-Use Matrix

| Rule | First introduction | First active use | Representative forms |
|---|---|---|---|
| `silent_h` | `es.a0.m06.l016` | `es.a0.m06.l016.activity.reading` | `hola`, `hambre`, `hasta luego` |
| `stable_vowels` | `es.a0.m06.l016` | `es.a0.m06.l016.activity.reading` | `hola`, `adiós`, `gracias` |
| `primary_stress` | `es.a0.m06.l016` | `es.a0.m06.l016.activity.practice` | `adiós`, `gracias`, `perdón` |
| `r` | `es.a0.m06.l016` | `es.a0.m06.l016.activity.practice` | `hambre`, `gracias`, `por favor` |
| `c_z` | `es.a0.m06.l016` | `es.a0.m01.l002` | `gracias` |
| `b_v` | `es.a0.m06.l016` | `es.a0.m01.l002` | `por favor` |
| `diphthong_ue` | `es.a0.m06.l016` | `es.a0.m01.l001` | `hasta luego` |
| `g_e_i` | `es.a0.m06.l016` | `es.a0.m01.l001` | `luego` |
| `enye` | `es.a0.m06.l017` | `es.a0.m06.l017` | `España` |
| `j` | `es.a0.m06.l017` | `es.a0.m06.l017` | `José` |
| `ll_y` | `es.a0.m06.l017` | `es.a0.m06.l017` | `llamo`, `llave` |

The generated audit report is the executable source for exact current first-use
data. This table summarizes the intended learner-facing sequence.

---

# Required Invariants

- Active recall must not require a ReadingRule before that rule is introduced.
- `ll/y` must be introduced before active `llamo` or `me llamo` recall.
- `gracias` must reference its complete PronunciationUnit, not a partial `/r/`
  sound unit.
- Lesson-level and activity-level ReadingRule metadata must describe the
  authored pedagogical sequence.
- Passive vocabulary previews may contain deferred pronunciation coverage only
  when the learner is not asked to decode or type the form.

---

# Audit Tool

The deterministic audit is:

```text
app/tool/audit_spanish_a0_reading_sequence.dart
```

It checks Modules 1-2 for:

- actual visible lesson order;
- first ReadingRule introduction;
- first active ReadingRule use;
- active target forms before introduction;
- release-required vocabulary missing PronunciationUnit references;
- partial sound-unit references used as whole-word pronunciation.

Warnings for deferred passive vocabulary remain allowed until full-course
pronunciation migration is complete.

---

# Deferred Scope

The full Spanish A0 course still has passive vocabulary without complete
PronunciationUnit coverage. That is a pronunciation migration task, not a
reading-order blocker for the migrated Modules 1-2 active sequence.

Deferred entries must not render misleading fragmentary word IPA. A ReadingRule
sound such as `/r/` may appear only as a rule outcome, never as the whole-word
IPA for a vocabulary card.

---

End of document.
