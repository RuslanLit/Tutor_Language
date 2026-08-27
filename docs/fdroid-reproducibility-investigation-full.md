# F-Droid reproducibility — Priority 1 — full investigation (v1.0.1)

Date 2026-08-27. Repo/main NOT modified. No signing key. No publication.
All builds in `/tmp` isolated environments.

================================================================
ЭТАП 0 — CURRENT STATE (проверено, не предположения)
================================================================

## 0.1 Git
HEAD = main = tag v1.0.1 = origin/main = `4ef91e4a7ec50934bbefa360287a3415822af259`

## 0.2 fdroid/org.tutorlanguage.app.yml.template  (committed in 4ef91e4)
- `Builds[0].commit`: **`EXACT_RELEASE_COMMIT`** — placeholder, NOT filled
- versionName/versionCode: `1.0.1` / `2`; CurrentVersion/Code: `1.0.1` / `2`
- `srclibs: [flutter@3.44.9]` (version name, not a 40-char SHA)
- `prebuild`: flutter config --no-analytics; flutter pub get --enforce-lockfile
- `scandelete: [.pub-cache]` — **WRONG for this repo** (see Этап 2)
- No `mv`-to-canonical-path step (the F-Droid reproducibility mechanism)

## 0.3 Gradle pins + jni build-id workaround — PHYSICALLY in the working tree, UNCOMMITTED
`git status`: ` M app/android/app/build.gradle.kts`, ` M app/android/build.gradle.kts`
- app/android/app/build.gradle.kts working tree: `compileSdk = 36`,
  `buildToolsVersion = "36.1.0"`, `ndkVersion = "28.2.13676358"`, `targetSdk = 36`
- app/android/build.gradle.kts working tree: jni `-Wl,--build-id=none`
- **HEAD (v1.0.1) has NEITHER** — uses `flutter.compileSdkVersion` etc.
- => any `fdroid build` of `commit: 4ef91e4` builds WITHOUT them.

## 0.4 /tmp environment
- `/tmp/tutor-fdroid-venv`: SURVIVED. fdroidserver 2.4.5, androguard 4.1.4,
  apkInspector 1.3.6, Python 3.11.15. Functional.
- `/tmp/tutor-fdroiddata`: SURVIVED. Metadata was stale (1.0.0 / vc1 / commit
  816cc5f) — updated in-place to 1.0.1 / vc2 / commit 4ef91e4 for this test
  (repo template NOT touched).
- `build/srclib/flutter`: was ABSENT (clone aborted last round at ~69 MB).
  This round the FULL clone completed (~1.5 GB working tree).

## 0.5 Flutter version — SOURCES DISAGREE
| Source | Value | In git (v1.0.1)? |
|---|---|---|
| tool/release/TOOLCHAIN.env | 3.44.9, rev 6b182d2c7585eba26d4edce0f97630effd256c33 | NO (untracked) |
| docs/RELEASE_DISTRIBUTION.md | same | NO (untracked) |
| fdroid/…template srclibs | flutter@3.44.9 (name only) | YES |
| app/.metadata | rev 559ffa3f75e7402d65a8def9c28389a9b2e6fe42 — **stale scaffold rev, NOT 3.44.9** | YES (committed) |
| app/pubspec.lock sdks | flutter: ">=3.44.0" — floor, not a pin | YES |

The v1.0.1 tag has **no committed exact Flutter-revision pin**. The only
committed constraint F-Droid can use is `srclibs: [flutter@3.44.9]`.

## Extra: fdroid lint
`fdroid readmeta` OK. `fdroid lint`: 1 finding — **`Categories 'Education' is
not valid`** (needs a current F-Droid category, e.g. "Science & Education").
Metadata, not a reproducibility blocker.

================================================================
ЭТАП 1 — Flutter revision for the F-Droid recipe
================================================================

- The official fdroiddata `srclibs/flutter.yml` is minimal:
  `RepoType: git` / `Repo: https://github.com/flutter/flutter.git`.
- `srclibs: [flutter@3.44.9]` => fdroidserver does
  `git clone https://github.com/flutter/flutter.git` then `git checkout -f 3.44.9`.
- **git tag `3.44.9` in flutter/flutter → commit
  `6b182d2c7585eba26d4edce0f97630effd256c33`** (verified live via
  `git ls-remote --tags`). Matches TOOLCHAIN.env and the local machine.
- Reproducible: YES. A git tag on flutter/flutter is immutable in practice.
- Retrieval verified END-TO-END: `fdroid build` cloned flutter.git and checked
  out `3.44.9`, engine artifact `5a2a6a42cce67f965cf540fcecf616faca624aa1`
  (== TOOLCHAIN.env FLUTTER_ENGINE_REVISION), Dart 3.12.2. The clone that
  aborted last round completed this round.
- Canonical F-Droid Flutter template uses `flutter@stable` + a prebuild
  `git -C $$flutter$$ checkout -f $version`. Our `flutter@3.44.9` (direct tag
  checkout) is equivalent and slightly stricter. Optional hardening:
  `flutter@6b182d2c7585eba26d4edce0f97630effd256c33` (pin the SHA directly).

================================================================
ЭТАП 2 — Clean build via fdroidserver
================================================================

Environment: `fdroid build -l -v org.tutorlanguage.app:2` in
`/tmp/tutor-fdroiddata` (isolated fdroidserver checkout, NOT the working copy).

### Recipe fix required (1)
`scandelete: [.pub-cache]` → **`scandelete: [app/.pub-cache]`**
Reason: the recipe has `subdir: app`; prebuild runs with cwd = the `app/`
subdir so `PUB_CACHE=$(pwd)/.pub-cache` lands at `<repo>/app/.pub-cache`, but
`fdroidserver.scanner.scan_source(build_dir=…)` resolves `scandelete` relative
to the **repo root**, so `.pub-cache` "did not match any files/dirs" and the
build aborted before `flutter build apk`. Fixed in the temp metadata (NOT the
repo template — that decision is deferred until the pipeline is signed off).

### First-ever successful `fdroid build`
After the fix: **SUCCESS.** "Successfully built version 1.0.1 (2) of
org.tutorlanguage.app from 4ef91e4…". APK 73 162 784 bytes, unsigned,
`org.tutorlanguage.app` (unchanged), versionCode 2, versionName 1.0.1,
compileSdk 36, targetSdk 36 (Flutter 3.44.9 defaults — the tag has no SDK
pins), ABIs arm64-v8a / armeabi-v7a / x86_64, 373 zip entries.

### Toolchain actually used (all builds)
| Component | Value |
|---|---|
| Flutter | 3.44.9, framework rev `6b182d2c75`, engine `5a2a6a42cc` (artifact `b9499e4c25…`) |
| Dart | 3.12.2 |
| Gradle | 9.1.0 (wrapper) |
| Java | OpenJDK 17.0.19 |
| Android Gradle Plugin / Kotlin | 9.0.1 / 2.3.20 (from settings.gradle.kts) |
| compileSdk / targetSdk / minSdk | 36 / 36 / 26 |
| NDK (jni libdartjni.so) | 28.2.13676358 (`.note.android.ident` = 13676358) |
| build-tools | AGP auto-selected; fdroidserver's apksigner line used 37.0.0 (verify-only on the unsigned APK) |

### Isolation
- Build A used `GRADLE_USER_HOME=/tmp/tutor-fdroid-gradle-A` +
  `-Dorg.gradle.daemon=false` — no `~/.gradle`, no daemon.
- The first (accidental) build reused a machine Gradle daemon from earlier
  `flutter build apk` QA runs (shared `~/.gradle`; log showed
  "Already watching /home/master/Development/flutter"). **But that
  non-isolated build and the isolated Build A produced BYTE-IDENTICAL APKs**
  (`369bc636…`). => shared gradle home / reused daemon did NOT affect output
  bytes. (Consistent with F-Droid: real builds run in a fresh VM anyway.)

================================================================
ЭТАП 3 — Two independent builds + byte comparison
================================================================

| Build | Absolute build path | APK SHA-256 |
|---|---|---|
| Build A (fdroid) | `/tmp/tutor-fdroiddata/build/org.tutorlanguage.app/app` | `369bc63693fede5e68f2c0de70cbeed90037d13ae05e60da62ad36ae0ccc64a8` |
| Build B (fdroid) | `/tmp/tutor-fdroiddata-B/build/org.tutorlanguage.app/app` | `ec9e87937d5f69a6af50f5f2fb5c45c668ee69485fa55feaa2bfaa5bcbdb4eba` |

**Result: A ≠ B.** Both APKs: same size (73 162 784), 373 entries.
**367 of 373 entries byte-identical.** The 6 that differ:
`lib/{arm64-v8a,armeabi-v7a,x86_64}/libapp.so`
`lib/{arm64-v8a,armeabi-v7a,x86_64}/libdartjni.so`

Identical: all DEX, all resources, all assets (incl. the 179 reference WAV),
`libflutter.so` ×3, `libsqlite3.so` ×3, `AndroidManifest.xml`, META-INF, res,
resources.arsc.

### Cause 1 — libapp.so — the absolute build path (exact)
`.rodata` embeds, verbatim:
```
A: file:///tmp/tutor-fdroiddata/build/org.tutorlanguage.app/app/.dart_tool/flutter_build/dart_plugin_registrant.dart
B: file:///tmp/tutor-fdroiddata-B/build/org.tutorlanguage.app/app/.dart_tool/flutter_build/dart_plugin_registrant.dart
```
Per-section SHA-256, A vs B:
- `.text` (compiled Dart AOT code): **BYTE-IDENTICAL** (all 3 ABI)
- `.rodata` (strings/const data): DIFFERS (arm64 also +64 bytes: `-B` is 2 chars longer)
- `.note.gnu.build-id`: DIFFERS — **consequence** of `.rodata` changing (linker
  build-id = hash of linked output)
- arm64 only: `.eh_frame`, `.dynsym` — offsets shift by the +64; **consequence**
Root cause = the embedded absolute build-path string, nothing else. Flutter
3.44.9 has no `flutter build apk` flag to omit that URI.

### Cause 2 — libdartjni.so — the GNU build-id (exact)
Per-section SHA-256, A vs B: **ONLY `.note.gnu.build-id` differs** (36 bytes);
all other 24–25 sections byte-identical, all 3 ABI.
Proof: `objcopy --remove-section=.note.gnu.build-id` on both → **x86_64
libdartjni.so A and B become IDENTICAL** (`d541df18…`).
Cause: lld computes the build-id over a hash that includes the object-file
paths on its command line (= the CMake build dir = the app build path).
Content of the linked `.so` is identical; only the id note differs.

### Fixes — demonstrated experimentally, not theorised

**(a) Same absolute build path → byte-identical APK. PROVEN twice.**
- Build#2 (non-isolated) == Build A (isolated), both at
  `/tmp/tutor-fdroiddata/…` → `369bc636…` == `369bc636…`
- **Canonical-path test C1/C2:** two independent `git clone`s of `4ef91e4`,
  both built at the identical path `/tmp/tlrepro-canon/org.tutorlanguage.app/app`
  (raw `flutter build apk --release` from the srclib Flutter 3.44.9,
  `pub get --enforce-lockfile`):
  ```
  C1: a87b88ca3479ce289483a375af7caa4d57ef29d35ee8f8c1b252aae66d526e82
  C2: a87b88ca3479ce289483a375af7caa4d57ef29d35ee8f8c1b252aae66d526e82
  cmp  →  BYTE-IDENTICAL
  ```
  Both `libapp.so` embed the same canonical path; both `libdartjni.so`
  build-ids match (`fdd2b794…`). => **at a fixed path, even the GNU build-id
  is deterministic** — the jni `--build-id=none` workaround is NOT strictly
  required if the path is fixed.
- (C1 vs Build A: same 6-file delta, 367/373 identical → raw `flutter build`
  and `fdroid build` are equivalent modulo the path-dependent files.)

**(b) jni `-Wl,--build-id=none` (the uncommitted workaround)** eliminates the
`libdartjni.so` difference by removing the id note entirely. Confirmed by the
section analysis + objcopy test. It is belt-and-suspenders on top of (a);
needed only if upstream and F-Droid CANNOT share a build path.

**(c) Gradle pins (compileSdk / buildToolsVersion / ndkVersion)** do NOT
affect the A-vs-B delta (both builds used Flutter 3.44.9's SDK defaults →
already identical). Their value is upstream↔F-Droid SDK-component consistency,
not build determinism. Not required for the reproducibility of a single
release, provided upstream and F-Droid use the same Flutter version.

### Answer to the round-1 open question
"Can the upstream APK be built at the same canonical path F-Droid uses, and
then a byte-match achieved?" — **YES. Proven (C1 == C2).** A path-independent
Flutter APK is still NOT achievable (the registrant URI is unavoidable in
3.44.9), but a fixed-canonical-path build IS fully reproducible.

### Practical path to F-Droid reproducibility for this app
1. The F-Droid recipe must relocate the checkout to a fixed absolute path
   before building (the `export repo=…; mv …` pattern from
   `templates/build-flutter.yml`), e.g. `/builds/fdroid/fdroiddata/build/org.tutorlanguage.app`
   or the F-Droid buildserver path.
2. The upstream developer must build the official (to-be-signed) APK at that
   **same** absolute path.
3. Then F-Droid's build == upstream build byte-for-byte (unsigned), and
   `apksigcopier` can transplant the developer signature.
Optionally commit the jni `--build-id=none` workaround so a path mismatch
degrades to 3 differing files (libapp.so) instead of 6.

================================================================
ЭТАП 4 — build-tools 34.0.0
================================================================

**NOT needed for reproducibility.** Every build in Этапы 1–3 used
AGP-auto-selected / build-tools 36–37; the recipe never referenced 34.

build-tools 34.0.0 is relevant ONLY to the LATER signing step (Priority 3):
current F-Droid docs warn that signatures made by `apksigner` 35+ cannot be
verified by `apksigcopier` (the tool F-Droid uses to copy the upstream
developer signature onto its own reproducible build). So the DEVELOPER would
need `apksigner` 34 (build-tools 34.0.0) when signing the official APK.
That is a signing-workflow requirement, not a reproducibility one, and only
becomes actionable once the fixed-path recipe (Этап 3) is in place and a key
exists. Not installed.

================================================================
ЭТАП 5–6 — NOT DONE (as instructed)
================================================================
- No signing key created. `find` for *.jks / *.keystore: none (only the GNOME
  login keyring, unrelated).
- No signed APK, no GitHub Release, no F-Droid MR, no publication.
- RELEASE_CHECKLIST.md not touched.
- Repo/main unchanged (still `4ef91e4`); the only uncommitted changes are the
  pre-existing deferred release-engineering work (gradle pins, jni, README,
  docs, tool/, release/).

================================================================
ИТОГОВЫЙ ОТЧЁТ
================================================================

1. **CURRENT STATE**: see Этап 0. Key: gradle pins + jni workaround are in the
   working tree but NOT in the v1.0.1 tag; the tag's only Flutter pin is
   `srclibs: flutter@3.44.9`; `app/.metadata` carries a misleading stale
   scaffold revision.

2. **Flutter revision for the recipe**: `flutter@3.44.9` →
   `6b182d2c7585eba26d4edce0f97630effd256c33` (flutter/flutter git tag,
   immutable; engine `5a2a6a42cce…`). Reproducible retrieval verified end to
   end by a completed `fdroid build`.

3. **Two independent builds**: NOT byte-identical.
   - A `369bc636…` @ /tmp/tutor-fdroiddata
   - B `ec9e8793…` @ /tmp/tutor-fdroiddata-B
   - 367/373 entries identical; 6 differ: libapp.so ×3, libdartjni.so ×3.

4. **Exact cause** (not "possibly"):
   - libapp.so: `.rodata` embeds the absolute build path via the
     `dart_plugin_registrant.dart` `file://` URI. `.text` is byte-identical.
   - libdartjni.so: only `.note.gnu.build-id` (lld hashes object-file paths).
   - **Both vanish when the build path is held constant** —
     proven: C1 == C2 (`a87b88ca…`), byte-identical, at a shared canonical path.

5. **build-tools 34.0.0**: not needed for reproducibility (builds used 36–37).
   Needed later only for `apksigner` ≤34 so `apksigcopier` can verify the
   developer signature during F-Droid's signature-copy step (Priority 3).

6. **Signing key NOT created. No publication performed.** DO NOT PUBLISH
   remains in force.

## Artifacts (in /tmp, ~15 GB total — can be cleaned)
```
/tmp/fdroid_apk_A.apk                 369bc636…  (fdroid, path A)
/tmp/fdroid_apk_B.apk                 ec9e8793…  (fdroid, path B)
/tmp/fdroid_apk_build2_contaminated.apk 369bc636… (== A; non-isolated)
/tmp/repro_C1.apk /tmp/repro_C2.apk   a87b88ca…  (canonical path, both)
/tmp/fdroid_build_{A,B}.log  /tmp/repro_C{1,2}.log
/tmp/tutor-fdroiddata      (fdroiddata A, incl. build/srclib/flutter ~1.5G)
/tmp/tutor-fdroiddata-B    (fdroiddata B)
/tmp/tutor-fdroid-gradle-{A,B,C}  (isolated GRADLE_USER_HOME, ~2–3G each)
/tmp/tlrepro-canon        (canonical-path checkout)
```
