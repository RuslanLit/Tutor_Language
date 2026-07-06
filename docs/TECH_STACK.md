# TECH_STACK.md

Status: Active

Version: 1.0

---

# Purpose

This document defines the approved technology stack for Tutor Language.

Codex must not replace these choices without explicit approval.

---

# Platform

Target platform:

- Android only

Non-target platforms:

- iOS
- Web
- Desktop

---

# Framework

Primary framework:

- Flutter

Primary language:

- Dart

---

# Architecture Style

Preferred architecture:

- Feature-first structure
- Clear separation between:
  - domain logic
  - data storage
  - presentation UI

The application should avoid unnecessary abstraction.

---

# State Management

Approved state management:

- Riverpod

Reason:

- testable;
- explicit dependencies;
- suitable for modular Flutter apps.

---

# Navigation

Approved routing:

- GoRouter

Reason:

- standard Flutter routing solution;
- supports clean navigation structure.

---

# Local Database

Approved database:

- SQLite

Preferred Flutter package:

- drift

Reason:

- typed queries;
- migrations;
- testability.

---

# Simple Local Settings

Approved storage:

- shared_preferences

Use only for simple settings.

Do not store learning progress in shared_preferences.

---

# Testing

Approved testing tools:

- flutter_test
- unit tests for domain logic
- widget tests where practical

---

# AI

V1 must not depend on AI.

Future optional local AI may use:

- llama.cpp
- GGUF models

The app must remain functional without LLM.

---

# Speech

Not part of V1.

Future options:

- Whisper.cpp
- Vosk
- Piper TTS

---

# F-Droid Compatibility

Avoid:

- Firebase
- Google Play Services
- proprietary analytics
- mandatory online APIs
- closed-source SDKs

---

# Minimum Android Version

Minimum target:

- Android 8.0

This may be adjusted only if required by Flutter or dependencies.

---

End of document.