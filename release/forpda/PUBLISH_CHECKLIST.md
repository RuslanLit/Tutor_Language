# Tutor Language 1.0.1 — 4PDA publication checklist

Prepared: 2026-08-28

## Application identity

- [PASS] Package name: `org.tutorlanguage.app` (verified from APK).
- [PASS] Application label: `Tutor Language` (verified from APK).
- [PASS] Version name: `1.0.1` (verified from APK).
- [PASS] Version code: `2` (verified from APK).
- [PASS] minSdk: API 26 / Android 8.0+ (verified from APK).
- [PASS] targetSdk: API 36 (verified from APK).
- [PASS] compileSdk: API 36 (verified from APK).

## Build and installation

- [PASS] Universal release build completed with `flutter build apk --release`.
- [PASS] ABI set verified: `armeabi-v7a`, `arm64-v8a`, `x86_64`.
- [PASS] 16 KB page alignment: `zipalign -c -P 16 4` passes.
- [PASS] Release signing: `apksigner verify` reports `Verifies` (schemes v2 + v3; v1 not required for minSdk 26).
- [PASS] Signing certificate SHA-256 matches the authorized release key:
  `4F:52:44:D1:F7:A1:C1:80:19:47:39:7D:8B:48:A7:36:E8:DE:0B:AF:41:32:DB:13:04:2E:50:0C:D1:4E:A2:C0`
- [PASS] Final publishable APK prepared: `TutorLanguage-1.0.1-signed.apk`
  (SHA-256 `9aefd7033c0248a17b255af4d43dfebaf15a8e4e3b4505b2c76c35c1dc396c82`).
- [PASS] APK installs on a physical Redmi Note 8T (`adb install`), Android 16 / API 36.
- [PASS] App startup from this exact release artifact: launches to the course screen, no crash.
- [PASS] Offline behaviour from this exact artifact: navigated the course, opened a lesson,
  completed several activities and played reference audio with airplane mode enabled the whole time.
- [PASS] Reference audio from this exact artifact: normal and 0.6× slow playback both start the
  bundled player (verified via `ExoPlayerImpl`/`AudioTrack` while offline).
- [PASS] Progress persistence: lesson exit/return and completion state behave as expected.

## Quality validation

- [PASS] `flutter analyze`: no issues.
- [PASS] `flutter test`: 619 tests passed.
- [PASS] 179 reference WAV assets are bundled in the APK
  (`assets/flutter_assets/assets/languages/spanish/audio/reference/`).

## Privacy and dependencies

- [PASS] `android.permission.INTERNET` is absent from the release APK.
- [PASS] `android.permission.RECORD_AUDIO` is present for voluntary local spoken rehearsal.
- [PASS] `android.permission.ACCESS_NETWORK_STATE` is merged from AndroidX Media3 1.4.1 and does not grant network access.
- [PASS] Signature-level app-scoped `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` is merged from AndroidX Core 1.13.1.
- [PASS] No camera, contacts, location, broad storage or advertising-ID permission is present.
- [PASS] No account, advertising or analytics dependency is declared in the application dependencies.
- [PASS] Runtime learning content and reference audio are bundled locally; no runtime TTS or speech recognition.
- [PASS] Reference audio was generated ahead of time with Google Cloud Text-to-Speech; only the resulting
  WAV files ship in the APK.
- [PASS] Reference-audio redistribution rights are cleared: the WAVs are Google Cloud TTS Generated
  Output, treated as Customer Data under the GCP Terms of Service "Generative AI Services" section,
  which permit redistribution and commercial use. Basis recorded in `THIRD_PARTY_NOTICES.md`
  ("Spanish reference audio"); the earlier Piper/Sharvard voice research is retained there as an
  archived, no-longer-used section.

## Publication materials

- [PASS] Icon is a rasterization of the existing launcher artwork and is exactly 200×200 PNG.
- [PASS] Five real, full-resolution 1080×2340 Russian screenshots are included without advertising mockups.
- [PASS] Russian topic and release-post text prepared for the current 4PDA Topic Wizard.
- [PASS] SHA-256 recorded for the signed APK.
- [PASS] Public source exists: <https://github.com/RuslanLit/Tutor_Language>.
- [MANUAL CHECK REQUIRED] Repeat title and package-name searches while signed in to 4PDA immediately before creating the topic.
- [USER INPUT REQUIRED] 4PDA account/session, CAPTCHA and final Topic Wizard submission remain manual.

## Open items

- [DECISION] Version numbering: this build reuses `1.0.1+2`. If an earlier `1.0.1` (0.75× slow playback)
  was published anywhere, bump to `1.0.2+3` and rebuild so users receive the update.
- [MANUAL STEP] Retain a dated copy of the Google Cloud Platform Terms of Service and Service Specific
  Terms with the release records, and re-check the "Generative AI" section for any attribution or
  non-endorsement clause relevant to store metadata (recurring step required by `THIRD_PARTY_NOTICES.md`).

## Final decision

- [READY] Signed APK, metadata, icon and screenshots are prepared and verified for manual upload.
  No blocking issues remain; the items above are a version-numbering decision and a records-keeping step.
