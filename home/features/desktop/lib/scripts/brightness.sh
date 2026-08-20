#!/usr/bin/env bash
# brightness {up|down|get}
set -euo pipefail

STEP="5%"

notify() {
  local pct
  pct=$(brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}')
  notify-send -h string:x-canonical-private-synchronous:brightness \
    -h int:value:"$pct" "Brightness: ${pct}%"
}

case "${1:-}" in
  up)
    brightnessctl set "${STEP}+"
    notify
    ;;
  down)
    brightnessctl set "${STEP}-"
    notify
    ;;
  get)
    brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}'
    ;;
  *)
    echo "usage: brightness {up|down|get}" >&2
    exit 1
    ;;
esac
