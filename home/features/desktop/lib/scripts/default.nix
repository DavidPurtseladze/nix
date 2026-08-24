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
  # screenshot-region / screenshot-full lived here until Flameshot took
  # over both keybinds - see ../../flameshot.nix.
  (pkgs.writeShellScriptBin "clipboard-history" (builtins.readFile ./clipboard-history.sh))
  (pkgs.writeShellScriptBin "volume" (builtins.readFile ./volume.sh))
  (pkgs.writeShellScriptBin "brightness" (builtins.readFile ./brightness.sh))
  (pkgs.writeShellScriptBin "night-mode" (builtins.readFile ./night-mode.sh))
]
