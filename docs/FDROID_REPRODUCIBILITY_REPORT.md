# F-Droid reproducibility investigation — v1.0.1

Consolidated record. Date of investigation: 2026-08-27.
Repo/`main` NOT modified. No signing key. No publication. All builds ran in
isolated `/tmp` environments.

The full narrative (Этапы 0–6) is preserved verbatim in
[`fdroid-reproducibility-investigation-full.md`](fdroid-reproducibility-investigation-full.md).
This file is the durable summary that survives `/tmp` cleanup: APK hashes and
the exact commands that produced the canonical-path match.

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

## 6. Not done (as instructed)

No signing key created. No signed APK. No GitHub Release. No F-Droid MR. No
publication. `main` unchanged (`4ef91e4`).
