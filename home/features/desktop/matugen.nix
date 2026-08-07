{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.matugen;

  matugenApply = pkgs.writeShellScriptBin "matugen-apply" ''
    #!/usr/bin/env bash
    # Regenerates waybar/rofi colors from the currently active hyprpaper
    # wallpaper. Bound to $mainMod SHIFT, T in hyprland.nix.
    set -euo pipefail

    wallpaper=$(${pkgs.hyprland}/bin/hyprctl hyprpaper listactive 2>/dev/null | head -n1 | sed 's/.* = //')

    if [ -z "''${wallpaper:-}" ]; then
      echo "matugen-apply: couldn't find an active hyprpaper wallpaper" >&2
      exit 1
    fi

    exec ${pkgs.matugen}/bin/matugen image "$wallpaper"
  '';
in {
  options.features.desktop.matugen.enable = mkEnableOption "matugen dynamic (wallpaper-based) theming for waybar and rofi";

  config = mkIf cfg.enable {
    home.packages = [pkgs.matugen matugenApply];

    # matugen only ever *reads* config.toml and the templates below, so these
    # are safe to manage declaratively as normal Nix-store symlinks.
    xdg.configFile."matugen/config.toml".text = ''
      [templates.waybar]
      input_path = "${./matugen/templates/waybar-colors.css}"
      output_path = "~/.config/waybar/colors.css"
      post_hook = "pkill -SIGUSR2 waybar || true"

      [templates.rofi]
      input_path = "${./matugen/templates/rofi-colors.rasi}"
      output_path = "~/.config/rofi/colors.rasi"
    '';

    # matugen *writes* colors.css / colors.rasi, so those two must be real,
    # mutable files rather than home-manager-managed store symlinks (matugen
    # can't write through a read-only /nix/store target). We only seed a
    # fallback the first time, so a fresh generation is not clobbered on
    # every `home-manager switch`.
    home.activation.matugenDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p "$HOME/.config/waybar" "$HOME/.config/rofi"
      if [ ! -e "$HOME/.config/waybar/colors.css" ]; then
        run install -m644 ${./matugen/defaults/waybar-colors.css} "$HOME/.config/waybar/colors.css"
      fi
      if [ ! -e "$HOME/.config/rofi/colors.rasi" ]; then
        run install -m644 ${./matugen/defaults/rofi-colors.rasi} "$HOME/.config/rofi/colors.rasi"
      fi
    '';
  };
}
