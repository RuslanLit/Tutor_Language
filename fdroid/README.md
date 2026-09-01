# F-Droid submission draft

`org.tutorlanguage.app.yml.template` is a review aid, not submit-ready metadata.
It still comments out `Binaries` (no GitHub Release asset exists yet) even though
`AllowedAPKSigningKeys` and the exact `commit:` are now filled in, so it must not
be copied to fdroiddata as-is.

Before copying it to fdroiddata:

1. Resolve the WAV rights blocker in `docs/FDROID_READINESS_AUDIT.md`.
2. Keep `commit:` pointed at the exact clean release commit (the one whose
   `versionName`/`versionCode` match the shipped APK). Bump it every release.
3. Reproduce the unsigned APK in an fdroidserver-compatible fixed working
   directory. Confirm a byte match; specifically inspect all `libapp.so` and
   `libdartjni.so` entries.
4. Create and protect the permanent key outside Git, sign once with Android
   Build Tools 34, and record the certificate SHA-256 without separators.
   `AllowedAPKSigningKeys` in the template already carries this fingerprint;
   re-verify it against the signed APK.
5. After device QA, tag and create the real GitHub Release with the exact asset
   `TutorLanguage-1.0.1-signed.apk`; verify the URL, then uncomment `Binaries`.
6. Run current `fdroid lint`, `fdroid scanner` and a local `fdroid build`.

The upstream Fastlane metadata under `app/fastlane/metadata/android/` is the
canonical store listing source. Ukrainian, Russian and English each contain a
title, short/full description, a changelog and five screenshots. Do not claim
complete Polish or German educational localization.
