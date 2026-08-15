#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
mkdir -p "$WALLPAPER_DIR"

selected=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
  \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) \
  -printf '%f\n' | sort | rofi -dmenu -p "Wallpaper")

[ -z "$selected" ] && exit 0
path="$WALLPAPER_DIR/$selected"

hyprctl hyprpaper preload "$path"
# Empty monitor name = apply to every connected output.
hyprctl hyprpaper wallpaper ",$path"
hyprctl hyprpaper unload unused

if command -v matugen >/dev/null 2>&1; then
  matugen image "$path"
fi
