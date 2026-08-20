#!/usr/bin/env bash
# volume {up|down|mute|get}
set -euo pipefail

SINK="@DEFAULT_AUDIO_SINK@"
STEP="5%"

notify() {
  local pct muted
  pct=$(wpctl get-volume "$SINK" | awk '{print int($2 * 100)}')
  muted=$(wpctl get-volume "$SINK" | grep -q MUTED && echo 1 || echo 0)
  if [ "$muted" = "1" ]; then
    notify-send -h string:x-canonical-private-synchronous:volume \
      -h int:value:0 "Volume muted"
  else
    notify-send -h string:x-canonical-private-synchronous:volume \
      -h int:value:"$pct" "Volume: ${pct}%"
  fi
}

case "${1:-}" in
  up)
    wpctl set-mute "$SINK" 0
    wpctl set-volume "$SINK" "${STEP}+" -l 1.0
    notify
    ;;
  down)
    wpctl set-volume "$SINK" "${STEP}-"
    notify
    ;;
  mute)
    wpctl set-mute "$SINK" toggle
    notify
    ;;
  get)
    wpctl get-volume "$SINK" | awk '{print int($2 * 100)}'
    ;;
  *)
    echo "usage: volume {up|down|mute|get}" >&2
    exit 1
    ;;
esac
