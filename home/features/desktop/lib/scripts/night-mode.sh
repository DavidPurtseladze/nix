#!/usr/bin/env bash
# night-mode {on|off|toggle|status}
set -uo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
STATE_FILE="$STATE_DIR/night-mode"
TEMPERATURE="4000"
ICON_ON=$'\uf186' # moon
ICON_OFF=$'\uf185' # sun

mkdir -p "$STATE_DIR"

is_on() { [ -f "$STATE_FILE" ]; }

turn_on() {
  if hyprctl hyprsunset temperature "$TEMPERATURE" >/dev/null 2>&1; then
    touch "$STATE_FILE"
    notify-send -h string:x-canonical-private-synchronous:night-mode "Night mode on"
  else
    notify-send -u critical -h string:x-canonical-private-synchronous:night-mode \
      "Night mode failed" "hyprsunset isn't responding - is it running?"
  fi
}

turn_off() {
  if hyprctl hyprsunset identity >/dev/null 2>&1; then
    rm -f "$STATE_FILE"
    notify-send -h string:x-canonical-private-synchronous:night-mode "Night mode off"
  else
    notify-send -u critical -h string:x-canonical-private-synchronous:night-mode \
      "Night mode failed" "hyprsunset isn't responding - is it running?"
  fi
}

case "${1:-}" in
  on) turn_on ;;
  off) turn_off ;;
  toggle)
    if is_on; then turn_off; else turn_on; fi
    ;;
  status)
    if is_on; then
      printf '{"text":"%s","tooltip":"Night mode: on (click to disable)","class":"on"}\n' "$ICON_ON"
    else
      printf '{"text":"%s","tooltip":"Night mode: off (click to enable)","class":"off"}\n' "$ICON_OFF"
    fi
    ;;
  *)
    echo "usage: night-mode {on|off|toggle|status}" >&2
    exit 1
    ;;
esac
