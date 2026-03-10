#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_BIN="${FLUTTER_BIN:-$ROOT_DIR/.sdk/flutter/bin/flutter}"
PORT="${PORT:-8945}"
DISPLAY_ID="${DISPLAY_ID:-:99}"
OUT_DIR="$ROOT_DIR/artifacts"
CLIP_DIR="$OUT_DIR/live-demo-clips"
VIDEO_FILE="$OUT_DIR/ihsan-live-feature-test.mp4"
LIST_FILE="$OUT_DIR/live-demo-inputs.txt"
SERVER_LOG="$OUT_DIR/live-http-server.log"

mkdir -p "$CLIP_DIR"
rm -f "$CLIP_DIR"/*.mp4 "$LIST_FILE" "$VIDEO_FILE"

if [[ ! -d "$ROOT_DIR/build/web" ]]; then
  "$FLUTTER_BIN" build web --release
fi

cleanup() {
  pkill -f "python3 -m http.server $PORT" >/dev/null 2>&1 || true
  pkill -f "$DISPLAY_ID" >/dev/null 2>&1 || true
  pkill -f "google-chrome.*127.0.0.1:$PORT" >/dev/null 2>&1 || true
}

trap cleanup EXIT
cleanup

Xvfb "$DISPLAY_ID" -screen 0 430x932x24 >/dev/null 2>&1 &
XVFB_PID=$!
export DISPLAY="$DISPLAY_ID"

pushd "$ROOT_DIR/build/web" >/dev/null
python3 -m http.server "$PORT" >"$SERVER_LOG" 2>&1 &
SERVER_PID=$!
popd >/dev/null

sleep 2

launch_app() {
  local route="$1"
  google-chrome \
    --no-sandbox \
    --disable-dev-shm-usage \
    --no-first-run \
    --no-default-browser-check \
    --window-position=0,0 \
    --window-size=430,932 \
    --app="http://127.0.0.1:$PORT/$route" >/dev/null 2>&1 &
  APP_PID=$!
  sleep 5
}

kill_app() {
  kill "${APP_PID:-}" >/dev/null 2>&1 || true
  pkill -P "${APP_PID:-0}" >/dev/null 2>&1 || true
  pkill -f "google-chrome.*127.0.0.1:$PORT" >/dev/null 2>&1 || true
  sleep 1
}

record_clip() {
  local name="$1"
  local route="$2"
  local duration="$3"
  local action="$4"
  local clip="$CLIP_DIR/$name.mp4"

  launch_app "$route"

  xdotool search --sync --onlyvisible --pid "$APP_PID" >/dev/null 2>&1 || true
  sleep 1

  ffmpeg \
    -y \
    -video_size 430x932 \
    -framerate 30 \
    -f x11grab \
    -i "$DISPLAY_ID" \
    -t "$duration" \
    -c:v libx264 \
    -pix_fmt yuv420p \
    "$clip" >/dev/null 2>&1 &
  local recorder_pid=$!
  sleep 1

  case "$action" in
    home)
      xdotool click 5
      sleep 1
      xdotool click 5
      sleep 1
      xdotool click 4
      ;;
    community)
      xdotool click 5
      sleep 1
      xdotool click 5
      sleep 1
      ;;
    zakat)
      xdotool mousemove 210 578 click 1
      sleep 1
      ;;
    ai)
      xdotool mousemove 160 790 click 1
      sleep 1
      xdotool type --delay 60 "ramadan plan"
      sleep 1
      xdotool mousemove 387 790 click 1
      sleep 4
      ;;
    family)
      xdotool click 5
      sleep 1
      xdotool click 5
      ;;
    search)
      xdotool mousemove 190 150 click 1
      sleep 1
      xdotool key ctrl+a BackSpace
      xdotool type --delay 70 "zakat"
      sleep 2
      ;;
    atlas)
      xdotool click 5
      sleep 1
      xdotool click 5
      sleep 1
      ;;
    *)
      sleep 2
      ;;
  esac

  wait "$recorder_pid"
  kill_app
}

record_clip "01_home" "?tab=0" 6 "home"
record_clip "02_quran" "?screen=18" 5 "idle"
record_clip "03_prayer_timeline" "?screen=14" 5 "idle"
record_clip "04_community_feed" "?screen=27" 6 "community"
record_clip "05_masjid_finder" "?screen=29" 5 "idle"
record_clip "06_zakat_calculator" "?screen=43" 6 "zakat"
record_clip "07_ai_scholar" "?screen=50" 10 "ai"
record_clip "08_ramadan_mode" "?screen=53" 5 "idle"
record_clip "09_family_dashboard" "?screen=55" 6 "family"
record_clip "10_global_search" "?screen=62" 7 "search"
record_clip "11_screen_atlas" "?atlas=1" 7 "atlas"

: >"$LIST_FILE"
for clip in \
  "$CLIP_DIR/01_home.mp4" \
  "$CLIP_DIR/02_quran.mp4" \
  "$CLIP_DIR/03_prayer_timeline.mp4" \
  "$CLIP_DIR/04_community_feed.mp4" \
  "$CLIP_DIR/05_masjid_finder.mp4" \
  "$CLIP_DIR/06_zakat_calculator.mp4" \
  "$CLIP_DIR/07_ai_scholar.mp4" \
  "$CLIP_DIR/08_ramadan_mode.mp4" \
  "$CLIP_DIR/09_family_dashboard.mp4" \
  "$CLIP_DIR/10_global_search.mp4" \
  "$CLIP_DIR/11_screen_atlas.mp4"
do
  printf "file '%s'\n" "$clip" >>"$LIST_FILE"
done

ffmpeg -y -f concat -safe 0 -i "$LIST_FILE" -c copy "$VIDEO_FILE" >/dev/null 2>&1

echo "Live demo video saved to $VIDEO_FILE"
