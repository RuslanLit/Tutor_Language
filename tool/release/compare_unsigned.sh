#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 BUILD_A.apk BUILD_B.apk" >&2
  exit 2
fi

apk_a="$(realpath -- "$1")"
apk_b="$(realpath -- "$2")"
[[ -f "$apk_a" && -f "$apk_b" ]] || { echo "Both APK paths must exist." >&2; exit 1; }

sha_a="$(sha256sum "$apk_a" | cut -d' ' -f1)"
sha_b="$(sha256sum "$apk_b" | cut -d' ' -f1)"
echo "Build A SHA-256: $sha_a"
echo "Build B SHA-256: $sha_b"

if cmp -s -- "$apk_a" "$apk_b"; then
  echo "Byte-identical: YES"
  exit 0
fi

echo "Byte-identical: NO"
for command_name in unzip find sort xargs diff; do
  command -v "$command_name" >/dev/null || exit 1
done

compare_dir="$(mktemp -d /tmp/tutor-language-apk-compare-XXXXXX)"
trap 'rm -rf -- "$compare_dir"' EXIT
mkdir -p "$compare_dir/a" "$compare_dir/b"
unzip -q "$apk_a" -d "$compare_dir/a"
unzip -q "$apk_b" -d "$compare_dir/b"
(cd "$compare_dir/a" && find . -type f -print0 | sort -z | xargs -0 sha256sum) > "$compare_dir/a.sha256"
(cd "$compare_dir/b" && find . -type f -print0 | sort -z | xargs -0 sha256sum) > "$compare_dir/b.sha256"
diff -u "$compare_dir/a.sha256" "$compare_dir/b.sha256" || true
exit 1
