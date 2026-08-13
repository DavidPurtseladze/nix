{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprpaper;
in {
  options.features.desktop.hyprpaper.enable = mkEnableOption "hyprpaper wallpaper daemon";

  config = mkIf cfg.enable {
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      splash = false
    '';
  };
}
