# RELEASE_CHECKLIST.md

Status: Active

Version: 1.0

Created: 2026-07-14

---

# Purpose

This document defines the release readiness criteria for Tutor Language.

Its purpose is to ensure that every public release satisfies the project's
requirements for educational quality, technical quality, privacy, stability,
and user experience.

No release should be published while mandatory release gates remain incomplete.

This document applies to all future releases unless explicitly superseded.

---

# Release Status

Current Release Target

Version:
1.0

Current Phase:
R2E2 — Complete Russian Support Localization

Overall Readiness:
IN PROGRESS

---

# Release Gates

A public release is allowed only after all mandatory gates are complete.

| Gate | Status |
|-------|--------|
| Functional completeness | ✅ |
| Educational completeness | ✅ |
| User interface completeness | ✅ |
| Localization | ⏳ |
| Branding | ⏳ |
| Legal documentation | ⏳ |
| Release packaging | ⏳ |
| F-Droid compliance | ⏳ |
| Community review | ⏳ |

Legend

```
[ ] not started
[~] in progress
[x] complete
[-] not applicable
```

---

# R1 — Production Readiness

Core Quality

```
[x] flutter analyze passes

[x] all automated tests pass

[x] release build succeeds

[x] application installs successfully

[x] application starts successfully

[x] no known crash on startup
```

Lesson System

```
[x] lesson navigation works

[x] lesson completion works

[x] remediation works

[x] competency sessions work

[x] persistence works

[x] learner history preserved
```

User Interface

```
[x] no placeholder screens

[x] landscape layout verified

[x] portrait layout verified

[x] accessibility reviewed

[x] scrolling verified

[x] lesson controls always reachable
```

---

# R2 — Localization Foundation

Architecture

```
[x] Flutter gen-l10n configured

[x] ARB localization files created

[x] English source locale established

[x] locale resolution implemented

[x] automatic system language selection
```

Languages

```
[x] English

[x] Ukrainian

[x] Russian

[x] Polish

[x] German
```

Application

```
[x] no learner-facing hardcoded strings

[x] Settings localized

[x] Lesson Player localized

[x] Course screens localized

[x] competency flow localized

[x] validation messages localized

[x] accessibility labels localized
```

Verification

```
[x] fallback language tested

[x] unsupported locale tested

[x] localization widget tests pass

[x] complete interface translation tests pass

[x] Redmi Note 8T debug APK installed with adb install -r

[x] existing learner progress preserved after install

[x] Russian system locale verified on device

[x] Home screen localized on device

[x] Course screen localized on device

[x] Settings/About localized on device
```

Educational Content

```
[x] educational-content localization architecture defined

[x] support locale separated from UI locale

[x] target language separated from support language

[x] deterministic English fallback defined

[x] localized content loading/resolution implemented

[x] localization validation implemented

[x] translation coverage reporting implemented

[x] minimal production reference slice validated

[x] Spanish A0 English support content normalized

[ ] Spanish A0 Ukrainian support translation complete

[x] Spanish A0 Russian support translation complete

[x] Russian educational-content smoke QA on Redmi Note 8T

[ ] Spanish A0 Polish support translation complete

[ ] Spanish A0 German support translation complete

[ ] full localized course device QA
```

---

# R3 — Branding & Identity

Identity

```
[x] final application name

[x] launcher icon

[x] adaptive icon

[x] monochrome icon

[x] splash screen
```

Visual Identity

```
[x] application colors reviewed

[x] typography reviewed

[x] About screen reviewed

[x] consistent terminology
```

Store Assets

```
[ ] feature graphic

[ ] screenshots

[ ] application description

[ ] short description
```

---

# R4 — Release UX

First Experience

```
[ ] first launch reviewed

[ ] onboarding decision finalized

[ ] empty states reviewed

[ ] error messages reviewed

[ ] progress feedback reviewed
```

Accessibility

```
[ ] screen reader review

[ ] touch targets verified

[ ] landscape usability verified

[ ] long text verified
```

Performance

```
[ ] cold start acceptable

[ ] lesson loading acceptable

[ ] scrolling smooth

[ ] no visible jank
```

---

# R5 — F-Droid Compliance

Licensing

```
[ ] LICENSE

[ ] copyright notices

[ ] third-party licenses
```

Privacy

```
[ ] Privacy Policy

[ ] privacy statement reviewed

[ ] permissions reviewed

[ ] INTERNET permission reviewed

[ ] no analytics

[ ] no tracking

[ ] offline behaviour verified
```

Packaging

```
[ ] release signing

[ ] reproducible build

[ ] version finalized

[ ] changelog prepared
```

Metadata

```
[ ] fastlane metadata

[ ] F-Droid metadata

[ ] release notes

[ ] screenshots

[ ] application icon assets
```

---

# R6 — Release Candidate

Regression

```
[ ] complete regression testing

[~] manual device testing

[ ] clean Git tree

[ ] release APK verified
```

Approval

```
[ ] release candidate approved

[ ] release tag prepared
```

---

# R7 — Publish to F-Droid

Publication

```
[ ] release tag created

[ ] source archive available

[ ] submission completed

[ ] package accepted
```

---

# R8 — Community Feedback

Initial Release

```
[ ] early issues collected

[ ] crash reports reviewed

[ ] usability feedback reviewed

[ ] documentation updated
```

Maintenance

```
[ ] priority fixes identified

[ ] roadmap updated
```

---

# R9 — Google Play Release

Preparation

```
[ ] Play Store assets

[ ] Play privacy information

[ ] Play signing

[ ] Play testing
```

Publication

```
[ ] internal testing

[ ] production rollout

[ ] first production review
```

---

# Release Principles

Every public release should satisfy the following principles.

## Educational First

Educational correctness always has higher priority than release speed.

---

## Privacy First

No learner data leaves the device unless the learner explicitly exports it.

---

## Offline First

The application must remain fully usable without Internet access.

---

## Stability First

A stable release is preferred over a feature-rich release.

---

## Accessibility First

Every learner should be able to complete every lesson regardless of screen size or orientation.

---

## Deterministic Behaviour

Learning outcomes must never depend on nondeterministic behaviour.

---

## Documentation First

Every architectural or release decision should be documented before publication.

---

# Definition of Release Ready

Tutor Language is considered Release Ready only when:

• every mandatory Release Gate is complete;

• no known Critical or High severity defects remain;

• all automated tests pass;

• manual device validation succeeds;

• release packaging is reproducible;

• licensing and privacy documentation are complete;

• the application satisfies the Educational Principles of the project.
