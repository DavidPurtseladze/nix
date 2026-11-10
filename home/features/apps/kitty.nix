{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.apps.kitty;
in {
  options.features.apps.kitty.enable = mkEnableOption "kitty terminal emulator";

  config = mkIf cfg.enable {
    home.packages = [pkgs.kitty];
  };
}
