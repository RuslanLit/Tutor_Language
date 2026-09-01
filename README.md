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

- the exact toolchain pinned in `tool/release/TOOLCHAIN.env`;
- an Android device or emulator for installation testing.

The release build is deliberately split into an unsigned source-build stage
and a developer-signing stage. The private key is never required to build the
app from source and must remain outside this repository.

```sh
tool/release/build_unsigned.sh
# After a reproducibility comparison, the key owner runs:
tool/release/sign_apk.sh UNSIGNED_APK KEYSTORE KEY_ALIAS
```

Official GitHub and 4PDA releases use the permanent developer signature.
F-Droid builds independently from source and is intended to publish that same
developer-signed APK only after its reproducible-build verification succeeds.
Until then, unsigned artifacts are diagnostics and must not be distributed.
The canonical workflow and current release gates are documented in
[`docs/RELEASE_DISTRIBUTION.md`](docs/RELEASE_DISTRIBUTION.md).

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
