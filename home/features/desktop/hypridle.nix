{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hypridle;
in {
  options.features.desktop.hypridle.enable = mkEnableOption "hypridle idle daemon";

  config = mkIf cfg.enable {
    # Unit only; the timers live in config/hypr/hypridle.conf.
    services.hypridle.enable = true;
  };
}
