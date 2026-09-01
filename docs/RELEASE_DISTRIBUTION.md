# Release distribution

This is the canonical release workflow for Tutor Language. One source tree,
one package identity, one unsigned APK payload and one permanent developer
certificate are used for GitHub Releases, 4PDA and (after successful F-Droid
reproducibility verification) F-Droid.

## Immutable release identity

| Field | Value |
|---|---|
| Name | Tutor Language |
| Application ID | `org.tutorlanguage.app` |
| Version | `1.0.1` |
| Version code | `2` |
| Official APK name | `TutorLanguage-1.0.1-signed.apk` |
| Source tag | `v1.0.1` |

Do not create channel-specific package IDs, flavors or APKs. An F-Droid-signed
APK is a fallback only; it is not update-compatible with the developer-signed
GitHub/4PDA APK.

Audit note: an annotated `v1.0.0` tag already exists locally and on `origin`
and points to `816cc5f9a1bd9b4791a8e0c67c9ca7e8c3cd7f27`. It predates this release
engineering work. Public tags should not be silently moved; the owner must
resolve this identity conflict before a release commit or binary is published.

## Pinned toolchain

`tool/release/TOOLCHAIN.env` is machine-readable authority for the release:

| Component | Pin |
|---|---|
| Flutter | 3.44.9, revision `6b182d2c7585eba26d4edce0f97630effd256c33` |
| Flutter engine | `5a2a6a42cce67f965cf540fcecf616faca624aa1` |
| Dart | 3.12.2 |
| Java | 17 |
| Gradle | 9.1.0 |
| Android Gradle Plugin | 9.0.1 |
| Kotlin plugin | 2.3.20 |
| compileSdk / targetSdk / minSdk | 36 / 36 / 26 |
| Build Tools used to build | 36.1.0 |
| NDK | 28.2.13676358 |
| Build Tools used to sign | 34.0.0 |

Android Build Tools 34 is intentional: current F-Droid documentation warns
that signatures made by `apksigner` 35 or newer cannot currently be verified
by `apksigcopier`.

## Release gates and sequence

1. Resolve all source, dependency and asset licensing gates. In particular,
   do not ship the current reference WAV set while its generated-output rights
   remain unclear.
2. Bump `version` in `app/pubspec.yaml` and update release metadata once.
3. Run `flutter pub get --enforce-lockfile`, `flutter analyze`, `flutter test`
   and the content/audio validators.
4. From a clean exact commit, run `tool/release/build_unsigned.sh`.
5. Independently rebuild with the same pinned toolchain and compare SHA-256 and
   all APK bytes using `tool/release/compare_unsigned.sh BUILD_A BUILD_B`. Do
   not normalize an already-built APK to conceal differences.
6. Only after a byte-identical result, sign once with the permanent key:

   ```sh
   tool/release/sign_apk.sh \
     release/build/TutorLanguage-1.0.1-unsigned.apk \
     /path/outside/repository/tutor-language-release.jks \
     tutor-language-release
   ```

7. Verify the signed APK with Build Tools 34 `apksigner`, record both the APK
   SHA-256 and signing-certificate SHA-256, and install that exact APK on the
   QA device without clearing data.
8. Test launch, navigation, typed recall, listening, microphone permission,
   local persistence, restart, Settings/About, all three release locales and
   offline operation. Test a higher-version upgrade with the same certificate.
9. Tag the exact clean source commit only after all gates pass.
10. Attach the unchanged `TutorLanguage-<version>.apk` to the GitHub release.
11. Copy that exact signed APK, never a rebuild, into the 4PDA package.
12. Complete F-Droid `Binaries` and `AllowedAPKSigningKeys` from the real
    GitHub asset and certificate, then submit the exact-commit recipe.

## Creating the permanent key (manual owner action)

Codex and automated builds must not run this command. The key owner may create
the one production identity outside the repository:

```sh
keytool -genkeypair -v \
  -keystore /path/outside/repository/tutor-language-release.jks \
  -alias tutor-language-release \
  -keyalg RSA -keysize 4096 -validity 10000
```

Back up the keystore and passwords offline. Obtain the certificate fingerprint
without exposing private material:

```sh
keytool -list -v \
  -keystore /path/outside/repository/tutor-language-release.jks \
  -alias tutor-language-release
```

`AllowedAPKSigningKeys` is the SHA-256 certificate fingerprint, not the APK
file hash.

## Reproducibility status for 1.0.0 audit

Two clean builds at commit
`816cc5f9a1bd9b4791a8e0c67c9ca7e8c3cd7f27` were performed under different
absolute source paths. ZIP names, ordering, timestamps, resources and DEX were
identical. Differences were limited to `libapp.so` and `libdartjni.so` for all
three ABIs:

- `libapp.so` embeds the absolute URI of
  `.dart_tool/flutter_build/dart_plugin_registrant.dart`;
- `libdartjni.so` differed only by its path-dependent GNU build ID. The tracked
  Android configuration now disables this build ID using F-Droid's documented
  `jni` workaround.

A cross-path rebuild after the `jni` fix produced
`4d5bf8311924d66f13f862ffa3a2bcddc7c63f1c0566f474c45f37b2cd93565f`
and `5d72540a26463874dfa5ab8559d73a6b05da3ff8b9c71956765e41de0fe67d6d`;
only the three `libapp.so` entries still differed. A third clean build in the
same absolute source path was byte-identical to the first fixed build
(`4d5bf8311924d66f13f862ffa3a2bcddc7c63f1c0566f474c45f37b2cd93565f`).
This proves deterministic same-path output but not yet an F-Droid/upstream
cross-environment match. F-Droid documents a fixed working directory as the
usual Flutter workaround. The final upstream APK must therefore be built in a
path mirrored by the fdroidserver recipe, then verified with fdroidserver
before signing/publication. Until that succeeds, upstream-signed F-Droid
publication is blocked; do not claim reproducibility from the same-path test
alone.

## Current no-publication gates

- Authoritative redistribution/commercial-use status for the generated WAVs.
- Cross-environment F-Droid/upstream byte match.
- User-created permanent key and certificate fingerprint.
- Signed APK verification, installation and device QA.
- Real GitHub Release asset URL (created only after all prior gates).
- Existing public `v1.0.0` tag points to the pre-audit commit and cannot also
  identify a later commit containing this workflow without an explicit owner
  decision.
