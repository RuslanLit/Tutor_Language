# F-Droid readiness audit

Audit baseline: `816cc5f9a1bd9b4791a8e0c67c9ca7e8c3cd7f27` plus the uncommitted release
engineering changes described by this report.

The reference-audio finding below was superseded by commit `cc1792d`, which
replaced the Piper/Sharvard voice with Google Cloud Text-to-Speech Generated
Output and recorded the redistribution basis in `THIRD_PARTY_NOTICES.md`. The
`## Assets` section reflects that change; the rejected voice candidates are kept
as an archived sub-section.

## Result

F-Droid main-repository eligibility is **blocked only by an unresolved
cross-environment reproducibility recipe**, not by proprietary app code, SDKs
or asset licensing. The bundled speech is proprietary TTS Generated Output and
is declared with the `NonFreeAssets` anti-feature (see `## Assets`).

The existing local/remote annotated `v1.0.0` tag points to the baseline commit
and predates this audit's required source changes. That release-identity
conflict is an additional publication blocker; no tag was changed here.

## Source and runtime behavior

| Item | FLOSS | License | Source | F-Droid compatible | Reason |
|---|---|---|---|---|---|
| Original app source/content | YES | GPL-3.0-or-later | This repository | YES | Complete GPLv3 text is tracked. |
| Runtime networking/code download | YES | N/A | Manifest and source audit | YES | No INTERNET permission or executable-code download. |
| Ads/analytics/tracking/Firebase/GMS | YES | N/A | Source, lockfile and Gradle graph audit | YES | None found. |
| Secrets/API keys | YES | N/A | Tracked-file scan | YES | No release keystore, private key or service secret found. |

## Dart and Flutter dependencies

Every one of the 123 exact locked packages in `app/pubspec.lock` was mapped to
its package license. The five SDK pseudo-packages use the Flutter SDK/engine
BSD-3-Clause notices; the other 118 package archives contain local license
files. No package is accepted merely because it is hosted on pub.dev.

| Dependency set | FLOSS | License | Source | F-Droid compatible | Reason |
|---|---|---|---|---|---|
| `flutter`, `flutter_localizations`, `flutter_test`, `flutter_web_plugins`, `sky_engine` | YES | BSD-3-Clause plus engine third-party notices | Flutter revision pinned in `TOOLCHAIN.env` | YES | Source SDK and notices are available; Flutter is a supported F-Droid build tool. |
| `drift`, `drift_flutter`, `flutter_riverpod`, `go_router`, `just_audio`, `path`, `path_provider`, `record` | YES | MIT, BSD-3-Clause, or Apache-2.0 | Exact versions in `pubspec.lock`; package repositories/license files | YES | All direct runtime packages are under OSI-approved permissive licenses. |
| `_fe_analyzer_shared`, `analyzer`, `args`, `async`, `boolean_selector`, `build`, `build_config`, `build_daemon`, `built_collection`, `built_value`, `characters`, `charcode`, `checked_yaml`, `cli_config`, `cli_util`, `clock`, `collection`, `convert`, `coverage`, `crypto`, `dart_style`, `fake_async`, `ffi`, `file`, `fixnum`, `flutter_lints`, `frontend_server_client`, `glob`, `graphs`, `http_multi_server`, `http_parser`, `intl`, `io`, `json_annotation`, `leak_tracker`, `leak_tracker_flutter_testing`, `leak_tracker_testing`, `lints`, `logging`, `matcher`, `material_color_utilities`, `meta`, `mime`, `node_preamble`, `package_config`, `platform`, `plugin_platform_interface`, `pool`, `pub_semver`, `pubspec_parse`, `recase`, `shelf`, `shelf_packages_handler`, `shelf_static`, `shelf_web_socket`, `source_gen`, `source_map_stack_trace`, `source_maps`, `source_span`, `stack_trace`, `stream_channel`, `stream_transform`, `string_scanner`, `term_glyph`, `test`, `test_api`, `test_core`, `typed_data`, `uuid`, `vector_math`, `vm_service`, `watcher`, `web`, `web_socket`, `web_socket_channel`, `webkit_inspection_protocol`, `xdg_directories`, `yaml` | YES | BSD-3-Clause, MIT, or Apache-2.0 | Exact pub package archives and local license files | YES | Build/test or shared Dart libraries; no proprietary binary service. |
| `audio_session`, `just_audio_platform_interface`, `just_audio_web`, `path_provider_android`, `path_provider_foundation`, `path_provider_linux`, `path_provider_platform_interface`, `path_provider_windows`, `record_android`, `record_ios`, `record_linux`, `record_macos`, `record_platform_interface`, `record_use`, `record_web`, `record_windows` | YES | MIT, BSD-3-Clause, or Apache-2.0 | Exact plugin source archives and license files | YES | Platform plugins are source-available and contain no proprietary SDK. |
| `code_assets`, `hooks`, `jni`, `jni_flutter`, `native_toolchain_c`, `objective_c` | YES | BSD-3-Clause | Dart/Flutter package sources | YES | Native build tooling/source is available; produced `libdartjni.so` is built from source. A path-dependent build ID required the documented workaround. |
| `riverpod`, `rxdart`, `state_notifier`, `synchronized` | YES | MIT or Apache-2.0 | Exact package sources/license files | YES | Source-only state/stream libraries. |
| `sqlcipher_flutter_libs`, `sqlite3_flutter_libs` | YES | MIT | Exact `+eol` package sources | YES | Current EOL releases are compatibility no-op packages and ship no native SQLCipher blob. |
| `sqlite3`, `sqlparser` | YES | MIT; SQLite itself public domain | Exact source package and SQLite source | YES | `libsqlite3.so` is built/provided from auditable SQLite source. |
| `build_runner`, `drift_dev` and their remaining locked transitive graph | YES | BSD-3-Clause, MIT, or Apache-2.0 | Exact package sources/license files | YES | Build-time only; no closed generator or downloaded executable service. |

## Android/Gradle dependencies and native APK inventory

| Item | FLOSS | License | Source | F-Droid compatible | Reason |
|---|---|---|---|---|---|
| Gradle 9.1.0 + wrapper JAR | YES | Apache-2.0 | `services.gradle.org` / Gradle source | YES | Standard source-available build bootstrap; checksum/pin should be verified by fdroidserver. |
| Android Gradle Plugin 9.0.1 | YES | Apache-2.0 | Android tools source / Google Maven | YES | Build-time Android tool accepted by policy. |
| Kotlin Gradle plugin/stdlib 2.3.20, coroutines, JetBrains annotations | YES | Apache-2.0 | JetBrains source / Maven Central | YES | Source-available compiler/runtime. |
| AndroidX Core, Lifecycle, Fragment, Window, Media and Media3 ExoPlayer 1.4.1 | YES | Apache-2.0 | AndroidX source / Google Maven | YES | Source-available Android libraries; no Play Services. |
| Guava 33.0.0-android and support artifacts | YES | Apache-2.0 | Guava source / Maven Central | YES | Source-available Java library. |
| ReLinker 1.4.5, jspecify 1.0.0 | YES | Apache-2.0 | Upstream sources / Maven Central | YES | Source-available support libraries. |
| APK `libapp.so` | YES | GPL-3.0-or-later output plus Flutter runtime linkage | Built from project source | UNCLEAR pending reproducibility | Contains an absolute generated-registrant URI, causing cross-path mismatch. |
| APK `libflutter.so` | YES | Flutter engine BSD-3-Clause + notices | Pinned Flutter engine source/artifact | YES | Identical in both audit builds. |
| APK `libdartjni.so` | YES | BSD-3-Clause | `jni` 1.0.0 source | YES after rebuild validation | Source-built; tracked linker workaround removes path-dependent build ID. |
| APK `libsqlite3.so` | YES | SQLite public domain | SQLite source via `sqlite3` | YES | Identical in both audit builds. |

No tracked AAR, SO, APK, JKS, keystore, private key or certificate bundle was
found. The only tracked JAR is the standard Gradle wrapper.

## Assets

| Asset | FLOSS | License | Source | F-Droid compatible | Reason |
|---|---|---|---|---|---|
| Kurale-Regular.ttf | YES | SIL OFL 1.1 | Bundled font and `OFL.txt` | YES | Required license text is in the source tree. |
| Launcher/splash icons | YES | GPL-3.0-or-later project asset | This repository | YES | Original project artwork; vector sources and generated density PNGs are tracked. |
| Lesson JSON/text/localizations | YES | GPL-3.0-or-later | This repository | YES | Original project content. |
| Fastlane screenshots | YES | GPL-3.0-or-later project metadata | This repository/device captures | YES | Release-complete sets exist for uk/ru/en; they are metadata, not executable code. |
| 179 reference WAVs | NO (non-free asset) | Google Cloud TTS Generated Output; Customer Data under GCP Terms of Service "Generative AI Services" (Section 20), which permit redistribution and commercial use | Google Cloud Text-to-Speech, voice `es-ES-Chirp3-HD-Charon`, synthesized at authoring time in commit `cc1792d` | YES with `NonFreeAssets` | Proprietary TTS output with no upstream dataset-licensing chain. No Google SDK, model, API key or network call is a runtime dependency; nothing Google-side ships in the APK. Basis recorded in `THIRD_PARTY_NOTICES.md` and archived under `docs/legal/`. |

### Archived: rejected voice candidates (pre-`cc1792d`)

Retained for provenance. None of these ship in any release.

| Candidate | Why rejected |
|---|---|
| Piper + `es_ES-sharvard-medium` (Sharvard corpus) | Edinburgh DataShare record does not expose the CC BY 3.0 grant asserted by the model card; redistribution/commercial rights in the generated output were not established. |
| `es_ES-davefx-medium` | Fine-tuned from a Lessac Blizzard 2013 model whose linked dataset license is research-only and restricts redistribution. |
| CarlFM / friyin Chirp retrain, `es_ES-mls_*`, eSpeak NG | Undocumented single-speaker source (download gone), broken output, or insufficient formant quality respectively. |

The Piper engine itself is MIT and was authoring-only; it was never bundled.

## Anti-features and scanner

No ads, tracking, non-free network service, account dependency or runtime
network requirement was found. The `NonFreeAssets` anti-feature is declared for
the bundled Google Cloud TTS speech (see `## Assets`); no other AntiFeatures
field is indicated. `fdroidserver` was not installed in the audit environment,
so scanner/build results must remain a release gate; no `scanignore` or
concealment-oriented `scandelete` is proposed.
