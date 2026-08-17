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
  (pkgs.writeShellScriptBin "screenshot-region" (builtins.readFile ./screenshot-region.sh))
  (pkgs.writeShellScriptBin "screenshot-full" (builtins.readFile ./screenshot-full.sh))
]
