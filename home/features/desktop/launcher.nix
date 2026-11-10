{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.launcher;
in {
  options.features.desktop.launcher.enable =
    mkEnableOption "quickshell app launcher ported from caelestia";

  config = mkIf cfg.enable {
    home.packages = [pkgs.launcher];
  };
}
