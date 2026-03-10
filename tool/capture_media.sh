#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_BIN="${FLUTTER_BIN:-$ROOT_DIR/.sdk/flutter/bin/flutter}"
PORT="${PORT:-8935}"
OUT_DIR="$ROOT_DIR/artifacts"
SCREENSHOT_DIR="$OUT_DIR/screenshots"
VIDEO_FILE="$OUT_DIR/ihsan-feature-walkthrough.mp4"
LIST_FILE="$OUT_DIR/video-inputs.txt"

mkdir -p "$SCREENSHOT_DIR"

"$FLUTTER_BIN" build web --release

pushd "$ROOT_DIR/build/web" >/dev/null
python3 -m http.server "$PORT" >"$OUT_DIR/http-server.log" 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" >/dev/null 2>&1 || true' EXIT
popd >/dev/null

sleep 2

capture() {
  local filename="$1"
  local route="$2"
  timeout 30s google-chrome \
    --headless=new \
    --disable-gpu \
    --no-sandbox \
    --hide-scrollbars \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=12000 \
    --window-size=430,932 \
    --screenshot="$SCREENSHOT_DIR/$filename" \
    "http://127.0.0.1:$PORT/$route" >/dev/null 2>&1 || true
  pkill -f 'google-chrome.*--headless=new' >/dev/null 2>&1 || true
  if [[ ! -f "$SCREENSHOT_DIR/$filename" ]]; then
    echo "Failed to capture $filename" >&2
    exit 1
  fi
}

capture "01_home.png" "?tab=0"
capture "02_quran.png" "?screen=18"
capture "03_prayer_timeline.png" "?screen=14"
capture "04_community_feed.png" "?screen=27"
capture "05_masjid_finder.png" "?screen=29"
capture "06_zakat_calculator.png" "?screen=43"
capture "07_ai_scholar.png" "?screen=50"
capture "08_ramadan_mode.png" "?screen=53"
capture "09_family_dashboard.png" "?screen=55"
capture "10_global_search.png" "?screen=62"
capture "11_screen_atlas.png" "?atlas=1"

: >"$LIST_FILE"
for image in \
  "$SCREENSHOT_DIR/01_home.png" \
  "$SCREENSHOT_DIR/02_quran.png" \
  "$SCREENSHOT_DIR/03_prayer_timeline.png" \
  "$SCREENSHOT_DIR/04_community_feed.png" \
  "$SCREENSHOT_DIR/05_masjid_finder.png" \
  "$SCREENSHOT_DIR/06_zakat_calculator.png" \
  "$SCREENSHOT_DIR/07_ai_scholar.png" \
  "$SCREENSHOT_DIR/08_ramadan_mode.png" \
  "$SCREENSHOT_DIR/09_family_dashboard.png" \
  "$SCREENSHOT_DIR/10_global_search.png" \
  "$SCREENSHOT_DIR/11_screen_atlas.png"
do
  printf "file '%s'\n" "$image" >>"$LIST_FILE"
  printf "duration 2.4\n" >>"$LIST_FILE"
done
printf "file '%s'\n" "$SCREENSHOT_DIR/11_screen_atlas.png" >>"$LIST_FILE"

ffmpeg \
  -y \
  -f concat \
  -safe 0 \
  -i "$LIST_FILE" \
  -vf "fps=30,scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:0x0A0A14,format=yuv420p" \
  "$VIDEO_FILE" >/dev/null 2>&1

echo "Screenshots saved to $SCREENSHOT_DIR"
echo "Video saved to $VIDEO_FILE"
