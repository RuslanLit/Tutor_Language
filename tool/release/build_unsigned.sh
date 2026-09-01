#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "$script_dir/../.." && pwd -P)"
app_dir="$repo_root/app"

# shellcheck source=TOOLCHAIN.env
source "$script_dir/TOOLCHAIN.env"

allow_dirty=false
output_dir="$repo_root/release/build"
while (($#)); do
  case "$1" in
    --allow-dirty)
      allow_dirty=true
      shift
      ;;
    --output-dir)
      [[ $# -ge 2 ]] || { echo "--output-dir requires a path" >&2; exit 2; }
      output_dir="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--allow-dirty] [--output-dir DIR]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

for command_name in git flutter dart java sha256sum; do
  command -v "$command_name" >/dev/null || {
    echo "Required command not found: $command_name" >&2
    exit 1
  }
done

if ! $allow_dirty; then
  if [[ -n "$(git -C "$repo_root" status --porcelain=v1 --untracked-files=all)" ]]; then
    echo "The worktree is not completely clean; commit/remove release inputs or use --allow-dirty for an audit build." >&2
    exit 1
  fi
fi

flutter_json="$(flutter --version --machine)"
actual_flutter_version="$(printf '%s' "$flutter_json" | sed -n 's/.*"frameworkVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
actual_flutter_revision="$(printf '%s' "$flutter_json" | sed -n 's/.*"frameworkRevision"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
actual_engine_revision="$(printf '%s' "$flutter_json" | sed -n 's/.*"engineRevision"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
actual_dart_version="$(printf '%s' "$flutter_json" | sed -n 's/.*"dartSdkVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
actual_java_major="$(java -version 2>&1 | sed -n '1s/.*version "\([0-9]*\).*/\1/p')"

[[ "$actual_flutter_version" == "$FLUTTER_VERSION" ]] || {
  echo "Flutter version mismatch: expected $FLUTTER_VERSION, got $actual_flutter_version" >&2
  exit 1
}
[[ "$actual_flutter_revision" == "$FLUTTER_REVISION" ]] || {
  echo "Flutter revision mismatch: expected $FLUTTER_REVISION, got $actual_flutter_revision" >&2
  exit 1
}
[[ "$actual_engine_revision" == "$FLUTTER_ENGINE_REVISION" ]] || {
  echo "Flutter engine mismatch: expected $FLUTTER_ENGINE_REVISION, got $actual_engine_revision" >&2
  exit 1
}
[[ "$actual_dart_version" == "$DART_VERSION"* ]] || {
  echo "Dart version mismatch: expected $DART_VERSION, got $actual_dart_version" >&2
  exit 1
}
[[ "$actual_java_major" == "$JAVA_MAJOR" ]] || {
  echo "Java major mismatch: expected $JAVA_MAJOR, got $actual_java_major" >&2
  exit 1
}

sdk_dir="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"
if [[ -z "$sdk_dir" && -f "$app_dir/android/local.properties" ]]; then
  sdk_dir="$(sed -n 's/^sdk.dir=//p' "$app_dir/android/local.properties" | head -n 1)"
fi
[[ -n "$sdk_dir" && -d "$sdk_dir" ]] || {
  echo "Android SDK not found; set ANDROID_SDK_ROOT or configure android/local.properties." >&2
  exit 1
}
[[ -d "$sdk_dir/platforms/android-$COMPILE_SDK" ]] || {
  echo "Missing Android platform android-$COMPILE_SDK" >&2
  exit 1
}
[[ -d "$sdk_dir/build-tools/$ANDROID_BUILD_TOOLS" ]] || {
  echo "Missing Android Build Tools $ANDROID_BUILD_TOOLS" >&2
  exit 1
}
[[ -d "$sdk_dir/ndk/$ANDROID_NDK" ]] || {
  echo "Missing Android NDK $ANDROID_NDK" >&2
  exit 1
}

grep -q "^version: $VERSION_NAME+$VERSION_CODE$" "$app_dir/pubspec.yaml" || {
  echo "pubspec version mismatch: expected $VERSION_NAME+$VERSION_CODE" >&2
  exit 1
}
grep -q "applicationId = \"$APPLICATION_ID\"" "$app_dir/android/app/build.gradle.kts" || {
  echo "applicationId mismatch: expected $APPLICATION_ID" >&2
  exit 1
}
grep -q "gradle-$GRADLE_VERSION-all.zip" "$app_dir/android/gradle/wrapper/gradle-wrapper.properties" || {
  echo "Gradle wrapper mismatch: expected $GRADLE_VERSION" >&2
  exit 1
}
grep -q "com.android.application\") version \"$ANDROID_GRADLE_PLUGIN_VERSION\"" "$app_dir/android/settings.gradle.kts" || {
  echo "Android Gradle Plugin mismatch: expected $ANDROID_GRADLE_PLUGIN_VERSION" >&2
  exit 1
}
grep -q "org.jetbrains.kotlin.android\") version \"$KOTLIN_PLUGIN_VERSION\"" "$app_dir/android/settings.gradle.kts" || {
  echo "Kotlin plugin mismatch: expected $KOTLIN_PLUGIN_VERSION" >&2
  exit 1
}
for expected_config in \
  "compileSdk = $COMPILE_SDK" \
  "buildToolsVersion = \"$ANDROID_BUILD_TOOLS\"" \
  "ndkVersion = \"$ANDROID_NDK\"" \
  "minSdk = $MIN_SDK" \
  "targetSdk = $TARGET_SDK"; do
  grep -q "$expected_config" "$app_dir/android/app/build.gradle.kts" || {
    echo "Android release configuration mismatch: expected $expected_config" >&2
    exit 1
  }
done

commit="$(git -C "$repo_root" rev-parse HEAD)"
source_date_epoch="$(git -C "$repo_root" log -1 --format=%ct)"
worktree_state=clean
if $allow_dirty && [[ -n "$(git -C "$repo_root" status --porcelain=v1 --untracked-files=all)" ]]; then
  worktree_state=dirty-audit-build
fi
export CI=true
export DART_SUPPRESS_ANALYTICS=true
export FLUTTER_SUPPRESS_ANALYTICS=true
export SOURCE_DATE_EPOCH="$source_date_epoch"

echo "Flutter: $actual_flutter_version ($actual_flutter_revision)"
echo "Engine:  $actual_engine_revision"
echo "Dart:    $actual_dart_version"
echo "Java:    $actual_java_major"
echo "Commit:  $commit"

cd "$app_dir"
flutter clean
flutter pub get --enforce-lockfile
flutter build apk --release

built_apk="$app_dir/build/app/outputs/flutter-apk/app-release.apk"
[[ -f "$built_apk" ]] || { echo "Expected APK not found: $built_apk" >&2; exit 1; }

verify_apksigner="$sdk_dir/build-tools/$ANDROID_BUILD_TOOLS/apksigner"
if "$verify_apksigner" verify "$built_apk" >/dev/null 2>&1; then
  echo "Release APK is unexpectedly signed; refusing to label it unsigned." >&2
  exit 1
fi

mkdir -p "$output_dir"
output_apk="$output_dir/TutorLanguage-$VERSION_NAME-unsigned.apk"
output_metadata="$output_dir/TutorLanguage-$VERSION_NAME-unsigned.build-info.txt"
cp -- "$built_apk" "$output_apk"
apk_sha256="$(sha256sum "$output_apk" | cut -d' ' -f1)"

{
  echo "applicationId=$APPLICATION_ID"
  echo "versionName=$VERSION_NAME"
  echo "versionCode=$VERSION_CODE"
  echo "gitCommit=$commit"
  echo "worktreeState=$worktree_state"
  echo "sourceDateEpoch=$source_date_epoch"
  echo "flutterVersion=$actual_flutter_version"
  echo "flutterRevision=$actual_flutter_revision"
  echo "flutterEngineRevision=$actual_engine_revision"
  echo "dartVersion=$actual_dart_version"
  echo "javaMajor=$actual_java_major"
  echo "gradleVersion=$GRADLE_VERSION"
  echo "androidGradlePluginVersion=$ANDROID_GRADLE_PLUGIN_VERSION"
  echo "kotlinPluginVersion=$KOTLIN_PLUGIN_VERSION"
  echo "compileSdk=$COMPILE_SDK"
  echo "targetSdk=$TARGET_SDK"
  echo "buildTools=$ANDROID_BUILD_TOOLS"
  echo "ndkVersion=$ANDROID_NDK"
  echo "apkSha256=$apk_sha256"
} > "$output_metadata"

echo "Unsigned APK: $output_apk"
echo "Build info:   $output_metadata"
echo "SHA-256:      $apk_sha256"
