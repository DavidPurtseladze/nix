{
config,
lib,
pkgs,
...
}:
with lib; let
cfg = config.features.desktop.wayland;
in {
options.features.desktop.wayland.enable = mkEnableOption "wayland extra tools and config";

config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      # "Islands" style ported from binnewbs/arch-hyprland (JaKooLit dots):
      # every module is its own separate rounded pill with gaps between them.
      # Colors come from ~/.config/waybar/colors.css, which matugen
      # (re)generates from your wallpaper. See matugen.nix for the fallback
      # used before matugen has run once.
      style = ''
        @import "colors.css";

        * {
          font-family: "FiraCode Nerd Font";
          font-weight: bold;
          min-height: 0;
          font-size: 98%;
        }

        window#waybar,
        window#waybar.empty,
        window#waybar.empty #window {
          background-color: transparent;
          padding: 0px;
          border: 0px;
        }

        tooltip {
          color: @inverse_surface;
          background: rgba(0, 0, 0, 0.8);
          border-radius: 20px;
        }

        tooltip label {
          color: @inverse_surface;
        }

        .modules-right,
        .modules-center,
        .modules-left {
          color: @secondary;
          padding-top: 2px;
          padding-bottom: 2px;
          padding-right: 4px;
          padding-left: 4px;
        }

        #workspaces button {
          color: @outline;
          box-shadow: none;
          text-shadow: none;
          padding: 0px 4px;
          border-radius: 9px;
          transition: all 0.3s cubic-bezier(.55, -0.68, .48, 1.682);
        }

        #workspaces button:hover {
          color: @primary;
          border-radius: 20px;
          padding: 0px 2px;
        }

        #workspaces button.active {
          color: @background;
          background-color: alpha(@primary_fixed, 0.75);
          padding: 0px 10px;
        }

        #workspaces button.urgent,
        #workspaces button.persistent {
          border-radius: 10px;
        }

        #custom-swaync,
        #battery,
        #clock,
        #cpu,
        #memory,
        #network,
        #pulseaudio,
        #temperature,
        #tray {
          background-color: alpha(@surface_container, 0.75);
          border-radius: 20px;
          padding: 8px 15px;
          margin: 0 0 0 5px;
        }

        #tray {
          margin-right: 5px;
        }

        #pulseaudio.muted {
          color: #cc3436;
        }

        #temperature.critical {
          color: red;
        }

        #battery.critical:not(.charging) {
          color: #f53c3c;
        }
      '';
      settings = [{
        height = 30;
        layer = "top";
        position = "top";
        spacing = 3;
        fixed-center = true;
        margin-top = 3;
        margin-left = 8;
        margin-right = 8;
        tray = { spacing = 10; };
        modules-left = [ "clock" "tray" ];
        modules-center = [ "hyprland/workspaces#kanji" ];
        modules-right = [
          "custom/swaync"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
        ] ++ (if config.hostId == "yoga" then [ "battery" ] else [ ])
        ++ [
          "custom/power"
        ];
        battery = {
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-charging = "{capacity}% ";
          format-icons = [ "" "" "" "" "" ];
          format-plugged = "{capacity}% ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = { format = "{}% "; };
        network = {
          interval = 1;
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ({signalStrength}%) ";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = [ "" "" "" ];
            handsfree = "";
            headphones = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
        "hyprland/workspaces#kanji" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
        };
        "custom/swaync" = {
          tooltip = true;
          tooltip-format = "Left click: notification center\nRight click: do not disturb";
          format = "{icon} {}";
          format-icons = {
            notification = " ";
            none = " ";
            dnd-notification = " ";
            dnd-none = " ";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
        "custom/power" = {
          format = "⏻";
          on-click = "wlogout -p layer-shell";
          tooltip = true;
          tooltip-format = "Logout menu";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
      }];
    };

  home.packages = with pkgs; [
    brightnessctl
    grim
    hyprlock
    hyprpicker
    playerctl
    qt6.qtwayland
    slurp
    waypipe
    wf-recorder
    wl-mirror
    wl-clipboard
    wlogout
    wtype
    ydotool
  ];
};
}
