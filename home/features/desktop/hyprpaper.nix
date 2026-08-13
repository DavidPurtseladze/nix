{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprpaper;
  wallpaper = ./assets/wallpapers/purple-tree.jpg;
in {
  options.features.desktop.hyprpaper.enable = mkEnableOption "hyprpaper wallpaper daemon";

  config = mkIf cfg.enable {
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${wallpaper}
      wallpaper = ,${wallpaper}
      splash = false
    '';
  };
}
