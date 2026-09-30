#!/usr/bin/env bash
# caffeine {on|off|toggle|status}
set -uo pipefail

UNIT="hypridle.service"
ICON_ON=$'\uf0f4'
ICON_OFF=$'\uf236'

has_unit() { systemctl --user cat "$UNIT" >/dev/null 2>&1; }
is_on() { ! systemctl --user is-active --quiet "$UNIT"; }

notify() {
  notify-send -h string:x-canonical-private-synchronous:caffeine "$@"
}

turn_on() {
  if systemctl --user stop "$UNIT"; then
    notify "Caffeine on" "Screen stays awake - no dim, lock or suspend"
  else
    notify -u critical "Caffeine failed" "Could not stop $UNIT"
  fi
}

turn_off() {
  if systemctl --user start "$UNIT"; then
    notify "Caffeine off" "Idle timers are back"
  else
    notify -u critical "Caffeine failed" "Could not start $UNIT"
  fi
}

if ! has_unit; then
  case "${1:-}" in
    status) printf '{"text":"","tooltip":"Caffeine unavailable: hypridle is not enabled","class":"unavailable"}\n' ;;
    *) echo "caffeine: $UNIT does not exist - enable features.desktop.hypridle" >&2; exit 1 ;;
  esac
  exit 0
fi

case "${1:-}" in
  on) is_on || turn_on ;;
  off) is_on && turn_off ;;
  toggle)
    if is_on; then turn_off; else turn_on; fi
    ;;
  status)
    if is_on; then
      printf '{"text":"%s","tooltip":"Caffeine: on - idle timers stopped (click to disable)","class":"on"}\n' "$ICON_ON"
    else
      printf '{"text":"%s","tooltip":"Caffeine: off - screen dims, locks and suspends (click to enable)","class":"off"}\n' "$ICON_OFF"
    fi
    ;;
  *)
    echo "usage: caffeine {on|off|toggle|status}" >&2
    exit 1
    ;;
esac
