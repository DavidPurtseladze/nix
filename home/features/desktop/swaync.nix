{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.swaync;
in {
  options.features.desktop.swaync.enable = mkEnableOption "swaync notification daemon";

  config = mkIf cfg.enable {
    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        notification-icon-size = 48;
      };
    };
  };
}
