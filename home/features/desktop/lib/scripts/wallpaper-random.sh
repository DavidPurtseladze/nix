#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
mkdir -p "$WALLPAPER_DIR"

mapfile -t files < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
  \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \))

[ ${#files[@]} -eq 0 ] && exit 0
path="${files[RANDOM % ${#files[@]}]}"

hyprctl hyprpaper preload "$path"
hyprctl hyprpaper wallpaper ",$path"
hyprctl hyprpaper unload unused

if command -v matugen >/dev/null 2>&1; then
  matugen image "$path"
fi
