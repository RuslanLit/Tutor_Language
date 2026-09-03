DRAFT comment for MR !46906 — NOT posted. Post only if a reviewer asks
about the commit hash differing from the v1.0.1 tag; otherwise wait.

---

Note on `commit:` for versionCode 2.

`commit: 02573807…` is intentionally not the `v1.0.1` git tag (`42cb6e5…`).

The 1.0.1 APK on the GitHub Release was built from a working tree that
already had the Android build-config pins and the jni
`-Wl,--build-id=none` reproducibility workaround applied but not yet
committed; those landed in `02573807` right after. `42cb6e5` (the tag)
has the same app code (slow reference-audio playback at 0.6×) but lacks
the jni workaround, so its `libdartjni.so` carries a path/environment
sensitive build-id and does not reproduce.

`02573807` is the exact tree the published APK was built from. A local
`fdroid build` from it produces an APK whose ZIP entries are
byte-identical to the published one except the three `libapp.so` files,
which differ only by the embedded absolute build path. For this reason
there is no `Binaries:` line yet — F-Droid builds and signs 1.0.1
itself. From 1.0.2 the tag and the build commit will coincide, the app
will be built at a neutral canonical path from the start, and
`Binaries:` + `AllowedAPKSigningKeys` will be added for
upstream-signature reproducibility.
