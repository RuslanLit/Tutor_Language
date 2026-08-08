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

Future Speech Intelligence options, explicitly deferred:

- Whisper.cpp
- Vosk

Piper is an authoring-time Spanish reference-audio tool only. It is not an
application runtime dependency.

AF1 uses WAV for its initial packaged reference assets. The authoring CLI is
explicitly invoked, accepts Piper/model paths as configuration, and never
installs Piper or downloads models.

AF2 adds `just_audio` 0.10.6 for local bundled WAV playback. It is isolated
behind the project-owned reference-audio playback service, uses one active
player, and has no network or runtime TTS role. The package is published under
Apache-2.0; its transitive platform packages and licenses remain tracked by
the package metadata before release.

AF3 adds `record` 7.1.1 for app-private temporary Android microphone capture.
It is BSD-3-Clause, uses the platform recorder without cloud services, and is
isolated behind `TemporaryLearnerRecordingService`. AF3 records mono 16 kHz
WAV because the package provides Android WAV/PCM support and the format is
locally playable without a transcoding pipeline. Recordings use temporary
cache storage, are never educational content, and are deleted on clear,
scope exit, interruption, or stale-file cleanup.

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
