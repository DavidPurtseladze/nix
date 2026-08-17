{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.awww;
in {
  options.features.desktop.awww = {
    enable = mkEnableOption "awww animated wallpaper daemon";

    defaultWallpaper = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Wallpaper shown at Hyprland startup, before any manual switch.
        No default is set here on purpose - this module is shared, so each
        user config (e.g. home/zero/zero.nix) should set its own.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.awww];
  };
}
