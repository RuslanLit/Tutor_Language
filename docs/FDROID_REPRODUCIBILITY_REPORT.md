# F-Droid reproducibility investigation — v1.0.1

Consolidated record. Original investigation: 2026-08-27 (Sections 1–6 below).
The full narrative (Этапы 0–6) is preserved verbatim in
[`fdroid-reproducibility-investigation-full.md`](fdroid-reproducibility-investigation-full.md).
This file is the durable summary that survives `/tmp` cleanup: APK hashes and
the exact commands that produced the canonical-path match.

---

## Status update — 2026-09-01

Supersedes the "No signing key / no publication" framing of the original
investigation.

| Item | State |
|---|---|
| Permanent developer key | **Exists.** Keystore `tutor-language-release.jks`, alias `tutor-language-release`, RSA 4096. Certificate SHA-256 `4f5244d1f7a1c1801947397d8b48a736e8de0baf4132db13042e500cd14ea2c0` (recorded in `AllowedAPKSigningKeys`). |
| GitHub Release `v1.0.1` | **Published.** <https://github.com/RuslanLit/Tutor_Language/releases/tag/v1.0.1>, asset `TutorLanguage-1.0.1-signed.apk` (SHA-256 `9aefd7033c0248a17b255af4d43dfebaf15a8e4e3b4505b2c76c35c1dc396c82`), signed with the developer key. Also the 4PDA artifact. |
| Actual build commit of the published APK | **`02573807f1e8ddedf3aedc3c39c49c7e2585062d`** — the 1.0.1 code (slow playback 0.6x) plus the Android build pins and the jni `-Wl,--build-id=none` workaround. NOT `4ef91e4` (Section 1) and NOT the `v1.0.1` tag commit `42cb6e5`: the reproducibility fixes were uncommitted in the working tree when the APK was built on 2026-08-28 and were committed on 2026-09-01. |
| Byte-reproducibility of the published APK | **Proven.** A clean `flutter build apk --release` of commit `02573807` at the absolute path `/home/master/Tutor_Language` (the path embedded in `libapp.so`) produced an unsigned APK byte-identical to the unsigned form of the published signed APK: SHA-256 `e5a449612d753935a1dd41a02eadcf2774bfe9c593a52764662c59afadc3699d` (matches `APK_INFO.txt` / `SHA256SUMS.txt`). All 373 zip entries identical. `apksigcopier compare` transplants the developer signature and the result verifies (v2+v3). |
| Same test at commit `42cb6e5` (tag `v1.0.1`) | **Fails** — `libdartjni.so` ×3 differ (that tree has no `-Wl,--build-id=none`; the build-id is path/environment sensitive). |
| Path sensitivity | Confirmed still real: `libapp.so` ×3 embed the absolute Dart plugin-registrant URI. Byte-match requires the F-Droid build path to equal the upstream build path. The published APK's path is `/home/master/Tutor_Language` — a developer-machine path, unsuitable for a public recipe. |
| Real `fdroid build` (fdroidserver 2.4.5, local mode, commit `02573807`) | **Succeeds.** `INFO: Successfully built version 1.0.1 of org.tutorlanguage.app from 02573807…`. Output APK 73 162 784 bytes; **370 / 373 zip entries byte-identical** to the published APK, the only difference being `lib/{arm64-v8a,armeabi-v7a,x86_64}/libapp.so` (F-Droid's build path `/build/…` vs the developer's). `libdartjni.so` ×3 now match — the committed `-Wl,--build-id=none` workaround holds. Confirms the recipe drives a clean source build end-to-end; for v1.0.1 F-Droid signs this itself (no `Binaries`). |

### Plan for `Binaries` / upstream-signature transfer

Deferred to **v1.0.2**:

- v1.0.1 ships on F-Droid **built from source and F-Droid-signed** (its own key).
  No `Binaries:` field this release. `AllowedAPKSigningKeys` is recorded now so a
  later `Binaries` release verifies against it.
- v1.0.2 will be built from the start at a **neutral canonical path** (not
  `/home/master/...`), its recipe will relocate the checkout to that same path,
  and `Binaries:` will point at the v1.0.2 GitHub Release asset. From v1.0.2
  onward F-Droid publishes the developer-signed APK via `apksigcopier`.
- The recipe `commit:` deliberately differs from the `v1.0.1` tag and this is
  accepted: the tag drives `UpdateCheckMode: Tags`, `commit:` pins the exact
  build point. `fdroid lint` raises no objection.

---

## 1. Release under test

| Item | Value |
|---|---|
| Release | v1.0.1 |
| Commit | `4ef91e4a7ec50934bbefa360287a3415822af259` |
| versionName / versionCode | `1.0.1` / `2` |
| Flutter | `3.44.9` → git tag `3.44.9` in flutter/flutter = `6b182d2c7585eba26d4edce0f97630effd256c33` |
| Flutter engine | `5a2a6a42cce67f965cf540fcecf616faca624aa1` (artifact `b9499e4c25212536ba3a4eec4f5c1905fb3214fe`) |
| Dart | `3.12.2` |
| APK size (all builds) | 73 162 784 bytes, unsigned, 373 zip entries |

---

## 2. APK SHA-256 — key artifacts

| Label | How built | Path | SHA-256 |
|---|---|---|---|
| **A** | `fdroid build -l -v org.tutorlanguage.app:2`, isolated `GRADLE_USER_HOME` | `/tmp/tutor-fdroiddata/build/org.tutorlanguage.app/app` | `369bc63693fede5e68f2c0de70cbeed90037d13ae05e60da62ad36ae0ccc64a8` |
| **B** | same recipe, different checkout dir | `/tmp/tutor-fdroiddata-B/build/org.tutorlanguage.app/app` | `ec9e87937d5f69a6af50f5f2fb5c45c668ee69485fa55feaa2bfaa5bcbdb4eba` |
| **"contaminated"** | first accidental build, reused a machine Gradle daemon + shared `~/.gradle` | `/tmp/tutor-fdroiddata/build/org.tutorlanguage.app/app` (same path as A) | `369bc63693fede5e68f2c0de70cbeed90037d13ae05e60da62ad36ae0ccc64a8` — **byte-identical to A** |
| **C1** | raw `flutter build apk --release`, canonical shared path | `/tmp/tlrepro-canon/org.tutorlanguage.app/app` | `a87b88ca3479ce289483a375af7caa4d57ef29d35ee8f8c1b252aae66d526e82` |
| **C2** | independent `git clone`, same canonical path as C1 | `/tmp/tlrepro-canon/org.tutorlanguage.app/app` | `a87b88ca3479ce289483a375af7caa4d57ef29d35ee8f8c1b252aae66d526e82` — **byte-identical to C1** |

### What the hashes prove

- **A ≠ B**: two builds of the same commit at *different absolute paths* differ.
  367 / 373 zip entries are byte-identical; the 6 that differ are
  `lib/{arm64-v8a,armeabi-v7a,x86_64}/libapp.so` and
  `lib/{arm64-v8a,armeabi-v7a,x86_64}/libdartjni.so`.
  - `libapp.so`: `.text` (compiled Dart AOT) is byte-identical; `.rodata`
    differs because it embeds the absolute build path verbatim via the
    `dart_plugin_registrant.dart` `file://` URI. `.note.gnu.build-id` differs
    as a downstream consequence.
  - `libdartjni.so`: **only** `.note.gnu.build-id` differs (lld hashes the
    object-file paths on its link command line). Proven by
    `objcopy --remove-section=.note.gnu.build-id` → A and B become identical.
- **"contaminated" == A**: a reused Gradle daemon / shared `~/.gradle` did
  **not** change output bytes. Gradle-home isolation is not the variable.
- **C1 == C2**: two independent clones built at the **same absolute path**
  produce a **byte-identical unsigned APK** — including the GNU build-id.
  => At a fixed canonical path the Flutter APK is fully reproducible, and the
  jni `--build-id=none` workaround is not strictly required.

**Conclusion:** the only reproducibility variable for this app is the
**absolute build path**. Hold it constant upstream and on F-Droid → byte match.

---

## 3. Exact commands — canonical-path reproducibility test (C1 / C2)

Toolchain used: the Flutter checkout produced by fdroidserver from
`srclibs: [flutter@3.44.9]`, located at
`/tmp/tutor-fdroiddata/build/srclib/flutter` (Flutter 3.44.9, framework rev
`6b182d2c75`, engine `5a2a6a42cc`, Dart 3.12.2).

```sh
FLUTTER=/tmp/tutor-fdroiddata/build/srclib/flutter/bin/flutter
CANON=/tmp/tlrepro-canon/org.tutorlanguage.app     # the fixed absolute path — identical for C1 and C2

# --- C1 ---
rm -rf "$CANON"
git clone https://github.com/RuslanLit/Tutor_Language.git "$CANON"
cd "$CANON"
git checkout -f 4ef91e4a7ec50934bbefa360287a3415822af259
cd "$CANON/app"
export PUB_CACHE="$CANON/app/.pub-cache"
"$FLUTTER" config --no-analytics
"$FLUTTER" pub get --enforce-lockfile
"$FLUTTER" build apk --release
sha256sum build/app/outputs/flutter-apk/app-release.apk
cp build/app/outputs/flutter-apk/app-release.apk /tmp/repro_C1.apk

# --- C2 : delete the checkout, clone again into the SAME path, rebuild ---
cd /tmp
rm -rf "$CANON"
git clone https://github.com/RuslanLit/Tutor_Language.git "$CANON"
cd "$CANON"
git checkout -f 4ef91e4a7ec50934bbefa360287a3415822af259
cd "$CANON/app"
export PUB_CACHE="$CANON/app/.pub-cache"
"$FLUTTER" config --no-analytics
"$FLUTTER" pub get --enforce-lockfile
"$FLUTTER" build apk --release
sha256sum build/app/outputs/flutter-apk/app-release.apk
cp build/app/outputs/flutter-apk/app-release.apk /tmp/repro_C2.apk

cmp /tmp/repro_C1.apk /tmp/repro_C2.apk   # -> no output: byte-identical
```

Both runs: `libapp.so` embeds the same canonical path; both `libdartjni.so`
build-ids match (`fdd2b794…`).

---

## 4. Exact commands — F-Droid builds (A / B)

Recipe used (temp metadata in the isolated fdroiddata checkout — NOT the repo
template). Differs from `fdroid/org.tutorlanguage.app.yml.template` only in the
two applied fixes, `commit:` and `scandelete:`:

```yaml
Builds:
  - versionName: 1.0.1
    versionCode: 2
    commit: 4ef91e4a7ec50934bbefa360287a3415822af259
    subdir: app
    output: build/app/outputs/flutter-apk/app-release.apk
    srclibs:
      - flutter@3.44.9
    prebuild:
      - export PUB_CACHE=$(pwd)/.pub-cache && $$flutter$$/bin/flutter config --no-analytics
      - export PUB_CACHE=$(pwd)/.pub-cache && $$flutter$$/bin/flutter pub get --enforce-lockfile
    build:
      - export PUB_CACHE=$(pwd)/.pub-cache && $$flutter$$/bin/flutter build apk --release
    scandelete:
      - app/.pub-cache
```

```sh
# Build A
cd /tmp/tutor-fdroiddata
GRADLE_USER_HOME=/tmp/tutor-fdroid-gradle-A \
  fdroid build -l -v org.tutorlanguage.app:2 -Dorg.gradle.daemon=false
sha256sum build/org.tutorlanguage.app/app/build/app/outputs/flutter-apk/app-release.apk

# Build B — identical recipe, checkout in /tmp/tutor-fdroiddata-B
cd /tmp/tutor-fdroiddata-B
GRADLE_USER_HOME=/tmp/tutor-fdroid-gradle-B \
  fdroid build -l -v org.tutorlanguage.app:2 -Dorg.gradle.daemon=false
sha256sum build/org.tutorlanguage.app/app/build/app/outputs/flutter-apk/app-release.apk
```

---

## 5. Practical path to F-Droid reproducibility

1. The F-Droid recipe must relocate the checkout to a fixed absolute path
   before building (the `export repo=…; mv …` pattern from fdroiddata
   `templates/build-flutter.yml`).
2. The upstream developer builds the official (to-be-signed) APK at that
   **same** absolute path.
3. F-Droid's build == upstream build byte-for-byte (unsigned); `apksigcopier`
   transplants the developer signature.
4. Optionally commit the jni `-Wl,--build-id=none` workaround so a path
   mismatch degrades to 3 differing files (`libapp.so`) instead of 6.

`build-tools 34.0.0` is **not** a reproducibility requirement (builds used
36–37). It matters only later: `apksigner` ≤ 34 so `apksigcopier` can verify
the developer signature during F-Droid's signature-copy step.

---

## 6. Not done (as of the 2026-08-27 investigation)

At the time of the original investigation: no signing key, no signed APK, no
GitHub Release, no F-Droid MR, `main` at `4ef91e4`.

**All of these except the F-Droid MR changed on 2026-08-28 / 2026-09-01 — see
the "Status update — 2026-09-01" section at the top of this file.** The F-Droid
MR (!46906) is still pending and is out of scope for the local preparation
work.
