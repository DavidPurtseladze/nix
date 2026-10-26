{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprlock;
in {
  options.features.desktop.hyprlock.enable = mkEnableOption "hyprlock lock screen";

  config = mkIf cfg.enable {
    # Package only; the styling lives in config/hypr/hyprlock.conf.
    programs.hyprlock.enable = true;
  };
}
