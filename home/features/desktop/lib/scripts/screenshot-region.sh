#!/usr/bin/env bash

set -euo pipefail

SCREENSHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}"
mkdir -p "$SCREENSHOT_DIR"

file="$SCREENSHOT_DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

geometry=$(slurp)
[ -z "$geometry" ] && exit 0

grim -g "$geometry" "$file"
wl-copy < "$file"
