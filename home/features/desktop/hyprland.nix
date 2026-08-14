{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
in {
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
      settings = {
        xwayland = {
          force_zero_scaling = true;
        };

        # exec-once = nm-applet
        # exec-once = waybar  
        # exec-once = swww-daemon
        # exec-once = blueman-applet
        # exec-once = swaync
        # exec-once = systemctl --user start hyprpolkitagent
        # exec-once = hypridle
        # "hypridle"
        # "wl-paste -p -t text --watch clipman store -P --histpath=\"~/.local/share/clipman-primary.json\""

        exec-once = [
          "waybar"
          "hyprpaper"
        ];

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_rules = "";
          kb_options = "ctrl:nocaps";
          follow_mouse = 1;

          touchpad = {
            natural_scroll = true;
          };

          sensitivity = 0;
        };

        env = [
          "XCURSOR_SIZE,32"
          "WLR_NO_HARDWARE_CURSORS,1"
          "GTK_THEME=Catppuccin-Mocha-Standard-Blue-Dark"
        ];

        general = {
          layout = "dwindle";

          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;

          resize_on_border = false;
          allow_tearing = false;

          "col.active_border" = "rgba(9742b5ee) rgba(9742b5ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;

          active_opacity = 1.0;
          inactive_opacity = 0.8;

          shadow = {
            enabled = false;
            range = 4;
            render_power = 3;
            color = "0xee1a1a1a";
          };

          blur = {
            enabled = true;
            size = 5;
            passes = 3;

            ignore_opacity = true;
            new_optimizations = true;
            special = false;
            popups = true;
            xray = true;

            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;

          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
            "been, 0.24, 0.9, 0.25, 0.91"
            "been2, 0, 0.94, 0.5, 0.99"
            "menu_decel, 0.1, 1, 0, 1"
            "linear, 0.0, 0.0, 1.0, 1.0"
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "slow, 0, 0.85, 0.3, 1"
            "overshot, 0.7, 0.6, 0.1, 1.1"
            "bounce, 1.1, 1.6, 0.1, 0.85"
            "sligshot, 1, -1, 0.15, 1.25"
            "nice, 0, 6.9, 0.5, -4.20"
          ];

          animation = [
            "windowsIn, 1, 5, slow, popin"
            "windowsOut, 1, 7, been, popin 70%"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, linear"
            "fade, 1, 5, overshot"
            "workspaces, 1, 5, wind"
            "windows, 1, 5, bounce, popin"
          ];
        };

        dwindle = {
          preserve_split = true;
        };

        gesture = [
          "3, horizontal, workspace"
        ];

        windowrule = [
          "opacity 0.9, match:class ^(kitty)$"
          "opacity 0.85 0.7 1, match:class ^(discord|vesktop|org.telegram.desktop)$"
          "opacity 0.9 0.7 1, match:class ^(zen)$"
          "float on, match:class ^(org.pulseaudio.pavucontrol)$"
          "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
          "workspace 1, match:class ^(kitty)$"
          "workspace 2, match:class ^(zen)$"
          "workspace 4, match:class ^(org.telegram.desktop|Slack|discord|vesktop)$"
        ];

        layerrule = [
          "blur on, match:namespace waybar"
          "ignore_alpha 0.5, match:namespace waybar"
          "blur on, match:namespace logout_dialog"
        ];

        "$mainMod" = "SUPER";

        bind = [
          # Handle Applications & Default
          "$mainMod, t, exec, kitty -e zsh -c 'fastfetch; exec zsh'"
          "$mainMod, K, killactive"
          "$mainMod, P, pseudo"
          "$mainMod, M, exit"
          "$mainMod, D, exec, rofi -show drun"
          "$mainMod, Escape, exec, wlogout -p layer-shell"
          "$mainMod, Space, togglefloating"
          "$mainMod, F, fullscreen"
          "$mainMod, B, exec, zen"
          "$mainMod, W, exec, wallpaper-select"
          "$mainMod SHIFT, W, exec, wallpaper-random"

          # Moving between workspaces
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Move Windows
          "$mainMod CTRL, left, movewindow, l"
          "$mainMod CTRL, right, movewindow, r"
          "$mainMod CTRL, up, movewindow, u"
          "$mainMod CTRL, down, movewindow, d"

          # Switch workspaces with Super + mouse wheel
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        binde = [
          # Resize windows
          "$mainMod SHIFT, left, resizeactive, -50 0"
          "$mainMod SHIFT, right, resizeactive, 50 0"
          "$mainMod SHIFT, up, resizeactive, 0 -50"
          "$mainMod SHIFT, down, resizeactive, 0 50"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindl = [
          # Handle Music Player
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];
      };
    };
  };
}
