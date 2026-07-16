# R2E2D3 Foundational Reading Report

Status: Complete

Phase: R2E2D3 - Foundational Reading Sequence and Course-Order Correction

---

# Summary

R2E2D3 corrected the Spanish A0 early reading sequence so that foundational
ReadingRules appear before active target-form recall.

The visible Module 1 order now starts with `es.a0.m06.l016`, then introduces
greetings, then introduces `ñ`, `j`, and `ll/y` before the `me llamo` lesson.

---

# Corrected Issues

- `ll/y` now appears before active `me llamo` recall.
- `gracias` now references `pronunciation.es.word.gracias.v1` instead of a
  partial sound-level pronunciation reference.
- Early active forms in Modules 1-2 are checked against the introduced
  ReadingRule set.
- Russian support text for the affected early reading/name lessons was
  corrected where it contained visible English fragments or awkward machine
  wording.

---

# Before / After Course Order

Before R2E2D3, the relevant visible sequence was:

```text
Hello and Goodbye
Spanish Vowels / Silent h
Please, Thank You, Sorry
...
My Name Is
What Is Your Name?
ñ, j and ll in Names
```

After R2E2D3, the relevant visible sequence is:

```text
Spanish Vowels, h, and First Sounds
Hello and Goodbye
ñ, j and ll in Names
Please, Thank You, Sorry
...
My Name Is
What Is Your Name?
```

Stable lesson IDs were preserved. Learner progress remains keyed by lesson ID,
not by display position.

---

# Initial Defect Classes

| Defect class | Result |
|---|---|
| Active target form before ReadingRule introduction | Fixed for audited Modules 1-2. |
| `ll/y` after `me llamo` | Fixed by moving `es.a0.m06.l017` into Module 1 before Module 2. |
| Partial IPA shown as whole-word IPA | Fixed for `gracias` by adding a whole-word PronunciationUnit. |
| Missing active PronunciationUnit for release-required early forms | Fixed for `gracias`, `por favor`, `perdón`, `repite`, and `señor`. |
| Russian machine-like strings in affected lessons | Scoped repairs applied to early reading/name strings. |

---

# Added Audit

New deterministic tool:

```text
app/tool/audit_spanish_a0_reading_sequence.dart
```

Latest result:

```text
errors=0
warnings=35
```

The warnings are deferred passive-vocabulary PronunciationUnit coverage items,
not active reading-order failures.

---

# Coverage After Implementation

| Area | Status |
|---|---|
| Modules 1-2 active ReadingRule prerequisites | Passing. |
| `ll/y` before `me llamo` recall | Passing. |
| `gracias` whole-word IPA | Passing: `/ˈɡɾasjas/`. |
| Russian hint for `gracias` | Passing: `гра́сьяс`. |
| Full Spanish A0 PronunciationUnit coverage | Deferred. |
| Full Spanish A0 Russian editorial recovery | Deferred. |

---

# Device QA

Smoke QA was completed on Redmi Note 8T after installing the debug APK with
`adb install -r`, preserving existing app data.

Observed:

- application launched without crash;
- home screen rendered `Tutor Language`, `Spanish`, `Испанский A0`;
- course screen rendered Module 1 with the corrected first visible lessons:
  `Немая h и устойчивые гласные`, `Приветствие и прощание`,
  `ñ, j и ll в именах`;
- `ñ, j и ll в именах` opened as Lesson 17 in Module 1;
- the lesson rendered the ReadingRule card for `ñ`, `j`, and `ll`;
- Russian support text for the affected lesson rendered in the UI;
- no `AndroidRuntime`, `FATAL`, or `FlutterError` crash was observed in the
  filtered logcat output.

Not covered by this smoke check:

- complete manual traversal of every affected activity;
- visual inspection of the complete `gracias` card on device;
- full portrait and landscape pass across all early lessons.

---

# Deferred Items

- Full Spanish A0 passive vocabulary pronunciation coverage remains incomplete.
- Some non-affected Russian support localization strings outside the early
  reading/name sequence still require a later quality pass.
- The audit is intentionally scoped to Modules 1-2.

---

End of report.
