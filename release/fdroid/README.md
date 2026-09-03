# F-Droid submission — MR !46906

Record of the recipe submitted to
<https://gitlab.com/fdroid/fdroiddata/-/merge_requests/46906>
("New app: Tutor Language"), fork branch
`fdroid-contributions-ruslanlit/fdroiddata:new-app-org.tutorlanguage.app`.

| File | What |
|---|---|
| `org.tutorlanguage.app.SUBMIT.yml` | The exact `metadata/org.tutorlanguage.app.yml` as submitted (fork commit `0c870dc9`). |
| `mr46906-recipe.patch` | Single diff: MR base `76179e91` → submitted `0c870dc9`. |
| `mr46906-commits.patch` | The 2-commit series on top of the MR base. |
| `mr46906-tag-vs-commit-comment.md` | Draft reply for the MR, to post only if a reviewer asks why `commit:` ≠ the `v1.0.1` tag. Not posted. |

## Submitted state (2026-09-03)

- `commit: 02573807f1e8ddedf3aedc3c39c49c7e2585062d` — the tree the published
  1.0.1 APK was built from (0.6× code + Android build pins + jni
  `-Wl,--build-id=none`). Deliberately ≠ tag `v1.0.1` (`42cb6e5`); see the
  draft comment and `docs/FDROID_REPRODUCIBILITY_REPORT.md`.
- **A3 scheme**: no `Binaries:`, no `AllowedAPKSigningKeys` — F-Droid builds
  from source and signs 1.0.1 with its own key. Upstream-signature
  reproducibility is planned for 1.0.2, built at a neutral canonical path.
- CI pipeline `2815492571`: **all 9 jobs pass**, including `fdroid build`
  (`Successfully built org.tutorlanguage.app:2 from 02573807…`) and
  `check apk`.
- MR moved out of Draft; awaiting F-Droid review.
