{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprlock;
in {
  options.features.desktop.hyprlock.enable = mkEnableOption "hyprlock lock screen styling";

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };

        # path = "screenshot" instead of pointing at a specific wallpaper
        # file - stays in sync automatically with whatever's actually on
        # screen (including after wallpaper-select/wallpaper-random),
        # rather than hardcoding one image here too.
        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
            noise = 0.0117;
            contrast = 1.3;
            brightness = 0.6;
            vibrancy = 0.21;
            vibrancy_darkness = 0.0;
          }
        ];

        label = [
          # Clock
          {
            monitor = "";
            text = ''cmd[update:1000] echo "<b><big>$(date +'%H:%M')</big></b>"'';
            color = "rgb(248, 248, 242)";
            font_size = 90;
            font_family = "FiraCode Nerd Font";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
          # Date
          {
            monitor = "";
            text = ''cmd[update:60000] echo "$(date +'%A, %d %B')"'';
            color = "rgb(189, 147, 249)";
            font_size = 20;
            font_family = "FiraCode Nerd Font";
            position = "0, 120";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "250, 50";
            outline_thickness = 3;
            dots_center = true;
            fade_on_empty = true;
            outer_color = "rgb(189, 147, 249)";
            inner_color = "rgba(255, 255, 255, 0.1)";
            font_color = "rgb(248, 248, 242)";
            placeholder_text = "<i>Password...</i>";
            rounding = 22;
            position = "0, -120";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
