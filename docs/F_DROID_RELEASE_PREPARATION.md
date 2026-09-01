# F-Droid release preparation

This public repository is being prepared for a future F-Droid submission. No
submission has been made. The canonical multi-channel release procedure is
[`RELEASE_DISTRIBUTION.md`](RELEASE_DISTRIBUTION.md), the policy/dependency
result is [`FDROID_READINESS_AUDIT.md`](FDROID_READINESS_AUDIT.md), and the
non-submittable metadata draft is under `fdroid/`.

## Public project references

- SourceCode: <https://github.com/RuslanLit/Tutor_Language>
- IssueTracker: <https://github.com/RuslanLit/Tutor_Language/issues>

No project website or personal support email is declared.

## Current blockers

- Different absolute Flutter source paths still produce different `libapp.so`
  because the generated Dart plugin registrant URI is embedded. A real
  fdroidserver/upstream fixed-path match has not yet passed.
- `fdroidserver` is not installed in the current environment, so `fdroid lint`,
  `fdroid scanner` and `fdroid build` remain pending.
- No GitHub Release asset exists yet, so `Binaries` in the recipe template
  stays commented out.
- An annotated `v1.0.0` tag already exists locally and on `origin`, pointing to
  `816cc5f9a1bd9b4791a8e0c67c9ca7e8c3cd7f27`. It predates the release
  engineering changes in this audit. The owner must resolve that release
  identity deliberately; this audit does not move or delete public tags.

## Resolved

- Reference-audio rights: commit `cc1792d` replaced the Piper/Sharvard voice
  with Google Cloud TTS Generated Output (Customer Data under the GCP Terms
  "Generative AI Services" section). Basis in `THIRD_PARTY_NOTICES.md`, dated
  terms archived under `docs/legal/`. The recipe declares `NonFreeAssets`.
- The permanent developer key and its certificate SHA-256 exist; the
  fingerprint is filled into `AllowedAPKSigningKeys` in the recipe template,
  and a signed `1.0.1` APK has been produced for the GitHub/4PDA channel.

Do not invent a GitHub binary URL, exact release commit or support contact.
Complete those values only after their gates pass.

## Required fdroidserver checks

Following the current official setup, copy the completed template into an
fdroiddata checkout and run at least:

```sh
fdroid readmeta
fdroid rewritemeta org.tutorlanguage.app
fdroid lint org.tutorlanguage.app
fdroid scanner org.tutorlanguage.app
fdroid build org.tutorlanguage.app
```

Do not add `scanignore` for an unexplained finding. The template's
`scandelete: .pub-cache` removes the isolated build cache after Flutter
dependency resolution; it is not justification for a non-FLOSS dependency.

Official references:

- <https://f-droid.org/en/docs/Inclusion_Policy/>
- <https://f-droid.org/docs/Reproducible_Builds/>
- <https://fdroid.gitlab.io/jekyll-fdroid/en/docs/Build_Metadata_Reference/>
- <https://fdroid.gitlab.io/jekyll-fdroid/docs/Submitting_to_F-Droid_Quick_Start_Guide/>
- <https://f-droid.org/docs/Building_Applications/>
