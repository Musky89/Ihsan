#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_BIN="${FLUTTER_BIN:-$ROOT_DIR/.sdk/flutter/bin/flutter}"
RELEASE_DIR="$ROOT_DIR/artifacts/releases"

mkdir -p "$RELEASE_DIR"

"$FLUTTER_BIN" analyze
"$FLUTTER_BIN" test
"$FLUTTER_BIN" build web --release

rm -rf "$RELEASE_DIR/web"
cp -R "$ROOT_DIR/build/web" "$RELEASE_DIR/web"

if [[ -x "$ROOT_DIR/.android-sdk/platform-tools/adb" ]]; then
  export ANDROID_SDK_ROOT="$ROOT_DIR/.android-sdk"
  export ANDROID_HOME="$ROOT_DIR/.android-sdk"

  if "$FLUTTER_BIN" build apk --release; then
    cp "$ROOT_DIR/build/app/outputs/flutter-apk/app-release.apk" "$RELEASE_DIR/" || true
  else
    echo "Android APK build skipped or failed. Check signing/SDK configuration." >&2
  fi

  if "$FLUTTER_BIN" build appbundle --release; then
    cp "$ROOT_DIR/build/app/outputs/bundle/release/app-release.aab" "$RELEASE_DIR/" || true
  else
    echo "Android app bundle build skipped or failed. Check signing/SDK configuration." >&2
  fi
else
  echo "Ready Android SDK not found at $ROOT_DIR/.android-sdk. Web release was still generated." >&2
fi

echo "Release artifacts available in $RELEASE_DIR"
