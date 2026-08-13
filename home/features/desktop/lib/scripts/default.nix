{pkgs, ...}: let
  wallpaperDir = ../../assets/wallpapers;
in [
  (pkgs.writeShellScriptBin "wallpaper-select" ''
    export WALLPAPER_DIR="${wallpaperDir}"
    ${builtins.readFile ./wallpaper-select.sh}
  '')
  (pkgs.writeShellScriptBin "wallpaper-random" ''
    export WALLPAPER_DIR="${wallpaperDir}"
    ${builtins.readFile ./wallpaper-random.sh}
  '')
]
