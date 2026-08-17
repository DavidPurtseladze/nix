#!/usr/bin/env bash

set -euo pipefail

selected=$(cliphist list | rofi -dmenu -p "Clipboard")
[ -z "$selected" ] && exit 0

echo "$selected" | cliphist decode | wl-copy
