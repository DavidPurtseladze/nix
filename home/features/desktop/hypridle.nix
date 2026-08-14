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
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          # Dim backlight
          {
            timeout = 60; # 1min
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          # Lock screen
          {
            timeout = 180; # 3min
            on-timeout = "loginctl lock-session";
          }
          # Turn off screen
          {
            timeout = 300; # 5min
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
          }
          # Suspend
          {
            timeout = 1800; # 30min
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
