# Tutor Language

Tutor Language is an offline-first language-learning application for Android.

The current executable product contains:

- a complete Spanish A0 foundation;
- the first Spanish A1 routine module (Lessons 38–42);
- typed recall and sentence construction;
- reading comprehension and true listening comprehension;
- guided dialogues and spoken rehearsal;
- local progress and review data.

The app works offline. It does not require an account and does not use ads,
analytics, tracking, cloud AI, or cloud synchronization. Learning data is
stored locally. Spoken rehearsal uses the device microphone only while the
learner chooses to record.

## Current maturity

Tutor Language is an early public-release candidate. Spanish A0 is complete;
Spanish A1 is currently represented by its first daily-routine module and is
not claimed to be a complete A1 course. The release educational support
languages are Ukrainian, Russian, and English. Generic application UI is also
available in Polish and German, but Polish and German educational content is
not claimed to be release-complete.

## Build from source

Requirements:

- Flutter with Dart SDK compatibility declared in `app/pubspec.yaml`;
- an Android SDK and Java toolchain accepted by the Flutter/Android build
  configuration;
- an Android device or emulator for installation testing.

The repository does not currently pin a Flutter SDK revision. Use a current
stable Flutter installation compatible with the declared Dart SDK.

```sh
cd app
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

The release build is intentionally unsigned for upstream/F-Droid packaging.
Do not distribute a locally built APK as an official signed release. F-Droid
or a release maintainer supplies release signing separately.

Contributor workflow and project invariants are documented in
[`docs/PROJECT_CONTRACT.md`](docs/PROJECT_CONTRACT.md) and
[`docs/DOCUMENTATION_AUTHORITY.md`](docs/DOCUMENTATION_AUTHORITY.md).

## Privacy and permissions

The app requests microphone access for temporary spoken practice. Reference
audio is bundled locally; Piper and its voice model are authoring-time tools
and are not shipped in the application. See
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) for asset provenance.

## License

Original Tutor Language source code and original project content are licensed
under [GPL-3.0-or-later](LICENSE). Third-party assets retain their own terms;
see [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

## Support and screenshots

Source code: <https://github.com/RuslanLit/Tutor_Language>

Issue tracker: <https://github.com/RuslanLit/Tutor_Language/issues>

Release screenshots for Ukrainian, Russian, and English are included under
`app/fastlane/metadata/android/`.
