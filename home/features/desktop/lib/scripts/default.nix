{pkgs, ...}:
[
  (pkgs.writeShellScriptBin "wallpaper-select" (builtins.readFile ./wallpaper-select.sh))
  (pkgs.writeShellScriptBin "wallpaper-random" (builtins.readFile ./wallpaper-random.sh))
]
