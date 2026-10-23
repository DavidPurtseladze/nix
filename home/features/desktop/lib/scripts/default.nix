{pkgs, ...}: [
  # screenshot-region / screenshot-full lived here until Flameshot took
  # over both keybinds - see ../../flameshot.nix.
  (pkgs.writeShellScriptBin "clipboard-history" (builtins.readFile ./clipboard-history.sh))
  (pkgs.writeShellScriptBin "volume" (builtins.readFile ./volume.sh))
  (pkgs.writeShellScriptBin "brightness" (builtins.readFile ./brightness.sh))
  (pkgs.writeShellScriptBin "night-mode" (builtins.readFile ./night-mode.sh))
  (pkgs.writeShellScriptBin "caffeine" (builtins.readFile ./caffeine.sh))
]
