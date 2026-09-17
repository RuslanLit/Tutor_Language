#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "$script_dir/../.." && pwd -P)"
# shellcheck source=TOOLCHAIN.env
source "$script_dir/TOOLCHAIN.env"

if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo "Usage: $0 UNSIGNED_APK KEYSTORE KEY_ALIAS [SIGNED_APK]" >&2
  exit 2
fi

unsigned_apk="$(realpath -- "$1")"
keystore="$(realpath -- "$2")"
key_alias="$3"
signed_apk="${4:-$(dirname -- "$unsigned_apk")/TutorLanguage-$VERSION_NAME.apk}"

[[ -f "$unsigned_apk" ]] || { echo "Unsigned APK not found: $unsigned_apk" >&2; exit 1; }
[[ -f "$keystore" ]] || { echo "Keystore not found: $keystore" >&2; exit 1; }
case "$keystore" in
  "$repo_root"/*)
    echo "The production keystore must be stored outside the repository." >&2
    exit 1
    ;;
esac
[[ ! -e "$signed_apk" ]] || { echo "Refusing to overwrite: $signed_apk" >&2; exit 1; }

sdk_dir="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"
if [[ -z "$sdk_dir" && -f "$repo_root/app/android/local.properties" ]]; then
  sdk_dir="$(sed -n 's/^sdk.dir=//p' "$repo_root/app/android/local.properties" | head -n 1)"
fi
# apksigner and zipalign come from different Build Tools on purpose.
# apksigner must stay on ANDROID_SIGNING_BUILD_TOOLS (34.x): signatures made by
# apksigner 35+ cannot be verified by apksigcopier, which F-Droid uses to copy
# this signature onto its reproducible build (docs/RELEASE_DISTRIBUTION.md:46).
# zipalign comes from ANDROID_BUILD_TOOLS because the 16 KB page-alignment
# check below needs `-P`, which zipalign only supports from 35.0.0 onwards.
apksigner="$sdk_dir/build-tools/$ANDROID_SIGNING_BUILD_TOOLS/apksigner"
zipalign="$sdk_dir/build-tools/$ANDROID_BUILD_TOOLS/zipalign"
[[ -x "$apksigner" ]] || {
  echo "apksigner from Android Build Tools $ANDROID_SIGNING_BUILD_TOOLS not found at $apksigner (required for apksigcopier-compatible signatures)." >&2
  exit 1
}
[[ -x "$zipalign" ]] || {
  echo "zipalign from Android Build Tools $ANDROID_BUILD_TOOLS not found at $zipalign (required for the 16 KB page-alignment check)." >&2
  exit 1
}

if "$apksigner" verify "$unsigned_apk" >/dev/null 2>&1; then
  echo "Input APK is already signed; refusing to re-sign it." >&2
  exit 1
fi
"$zipalign" -c -P 16 4 "$unsigned_apk"

read -r -s -p "Keystore password: " keystore_password
echo
read -r -s -p "Key password (press Enter to reuse keystore password): " key_password
echo
if [[ -z "$key_password" ]]; then
  key_password="$keystore_password"
fi

cp -- "$unsigned_apk" "$signed_apk"
printf '%s\n%s\n' "$keystore_password" "$key_password" | \
  "$apksigner" sign \
    --ks "$keystore" \
    --ks-key-alias "$key_alias" \
    --ks-pass stdin \
    --key-pass stdin \
    --out "$signed_apk.signed" \
    "$signed_apk"
mv -- "$signed_apk.signed" "$signed_apk"
unset keystore_password key_password

"$apksigner" verify --verbose --print-certs "$signed_apk"
echo "Signed APK SHA-256: $(sha256sum "$signed_apk" | cut -d' ' -f1)"
