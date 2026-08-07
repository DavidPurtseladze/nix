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
      settings = {
        xwayland = {
          force_zero_scaling = true;
        };

        # waybar is intentionally NOT here: programs.waybar.systemd.enable = true
        # (wayland.nix) already starts it as a systemd user service. Having it
        # in both places spawns two competing waybar processes / two bars.
        exec-once = [
          "hyprpaper"
          "hypridle"
          "wl-paste -p -t text --watch clipman store -P --histpath=\"~/.local/share/clipman-primary.json\""
        ];

        env = [
          "XCURSOR_SIZE,32"
          "WLR_NO_HARDWARE_CURSORS,1"
          "GTK_THEME,Dracula"
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

        # Touchpad 3-finger workspace swipe. Off before, on to match upstream.
        gestures = {
          workspace_swipe = true;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(9742b5ee) rgba(9742b5ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
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
            color = "rgba(1a1a1aee)";
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
            "been2, 0, .94, .5, .99"
            "menu_decel, 0.1, 1, 0, 1"
            "linear, 0.0, 0.0, 1.0, 1.0"
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "slow, 0, 0.85, 0.3, 1"
            "overshot, 0.7, 0.6, 0.1, 1.1"
            "bounce, 1.1, 1.6, 0.1, 0.85"
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
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          vfr = true;
        };

        # windowrule/windowrulev2 both accepted (v2 is the modern syntax; kept
        # separate below only where the older short form was already in use).
        windowrule = [
          "float, file_progress"
          "float, confirm"
          "float, dialog"
          "float, download"
          "float, notification"
          "float, error"
          "float, splash"
          "float, confirmreset"
          "float, title:Open File"
          "float, title:branchdialog"
          "float, Lxappearance"
          "float, dunst"
          "float,viewnior"
          "float,feh"
          "float, pavucontrol-qt"
          "float, pavucontrol"
          "float, file-roller"
          "fullscreen, wlogout"
          "float, title:wlogout"
          "fullscreen, title:wlogout"
          "idleinhibit focus, mpv"
          "idleinhibit fullscreen, firefox"
          "float, title:^(Media viewer)$"
          "float, title:^(Volume Control)$"
          "float, title:^(Picture-in-Picture)$"
          "size 800 600, title:^(Volume Control)$"
          "move 75 44%, title:^(Volume Control)$"

          # Popups/dialogs
          "float, title:^(Save As|Save a File|Pick Files)$"
          "size 50% 60%, title:^(Save As|Save a File|Pick Files)$"
          "center, title:^(Save As|Save a File|Pick Files)$"
          "float, initialTitle:(Open Files)"
          "size 70% 60%, initialTitle:(Open Files)"

          # Ignore maximize requests from apps
          "suppressevent maximize, class:.*"
          # Fix XWayland drag-and-drop focus stealing
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];

        layerrule = [
          "blur, waybar"
          "ignorealpha 0.5, waybar"
          "blur, logout_dialog"
          "blur, swaync-control-center"
          "blur, swaync-notification-window"
          "ignorezero, swaync-control-center"
          "ignorezero, swaync-notification-window"
          "ignorealpha 0.5, swaync-control-center"
          "ignorealpha 0.5, swaync-notification-window"
          "xray 0, swaync-control-center"
          "xray 0, swaync-notification-window"
        ];

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, return, exec, kitty -e zellij-ps"
          "$mainMod SHIFT, return, exec, [float; size 800 550] kitty"
          "$mainMod, t, exec, kitty -e zsh -c 'fastfetch; exec zsh'"
          "$mainMod SHIFT, e, exec, kitty -e zellij_nvim"
          "$mainMod, o, exec, thunar"
          "$mainMod, Escape, exec, wlogout -p layer-shell"
          "$mainMod, Space, togglefloating"
          "$mainMod, q, killactive"
          "CTRL ALT, Delete, exec, hyprctl dispatch exit 0"
          "$mainMod SHIFT, q, exec, hyprctl kill"
          "$mainMod, M, exit"
          "$mainMod, F, fullscreen"
          "$mainMod, V, togglefloating"
          "$mainMod, D, exec, rofi -show drun"
          "$mainMod, B, exec, xdg-open \"https://\""
          "$mainMod, L, exec, hyprlock"
          "$mainMod, C, exec, hyprpicker -a"
          "$mainMod, R, exec, systemctl --user restart waybar.service"
          "$mainMod, H, exec, pkill -SIGUSR1 waybar"
          "$mainMod, S, exec, mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy"
          "$mainMod SHIFT, T, exec, matugen-apply"
          "$mainMod SHIFT, S, exec, bemoji"
          "$mainMod, P, exec, wofi-pass"
          "$mainMod SHIFT, P, pseudo"
          "$mainMod, J, layoutmsg, togglesplit"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod CTRL, left, movewindow, l"
          "$mainMod CTRL, right, movewindow, r"
          "$mainMod CTRL, up, movewindow, u"
          "$mainMod CTRL, down, movewindow, d"
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
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        binde = [
          "$mainMod SHIFT, left, resizeactive, -50 0"
          "$mainMod SHIFT, right, resizeactive, 50 0"
          "$mainMod SHIFT, up, resizeactive, 0 -50"
          "$mainMod SHIFT, down, resizeactive, 0 50"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        # ,-prefixed = no modifier: laptop multimedia keys.
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ];

        # bindl = fires on both press and release; used for media keys so they
        # still work while a lockscreen/inhibitor eats normal binds.
        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        windowrulev2 = [
          "workspace 1,class:(Emacs)"
          "workspace 3,opacity 1.0, class:(brave-browser)"
          "workspace 4,class:(com.obsproject.Studio)"

          # Tag-then-rule pairs ported from the source repo (Hyprland doesn't
          # have "tags" here so these just match by class directly)
          "noblur, class:^([Mm]pv|vlc)$"
          "opacity 1.0, class:^([Mm]pv|vlc)$"
          "float, class:^([Mm]pv|vlc)$"
          "size 900 506, class:^([Mm]pv|vlc)$"
          "opacity 0.9, class:^(kitty)$"
        ];
      };
    };
  };
}
