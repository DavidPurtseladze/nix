{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprpaper;
  wallpaper = ./assets/wallpapers/purple-tree.jpg;
in {
  options.features.desktop.hyprpaper.enable = mkEnableOption "hyprpaper wallpaper daemon";

  config = mkIf cfg.enable {
    home.packages = [pkgs.hyprpaper];

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${wallpaper}
      wallpaper {
        monitor =
        fit_mode = cover
        path = ${wallpaper}
      }
      splash = false
    '';
  };
}
