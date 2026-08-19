{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
  ptt = cfg.pushToTalk;
  cursorCfg = config.features.desktop.cursor;
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  defaultWallpaper = config.features.desktop.awww.defaultWallpaper;
in {
  options.features.desktop.hyprland = {
    enable = mkEnableOption "hyprland config";

    pushToTalk = {
      enable =
        mkEnableOption ''
          compositor-level push-to-talk. Holds the default PipeWire source
          muted and unmutes it only while the bound key is held.

          This has to live in the compositor rather than in Discord (or any
          other app): Wayland gives no client a way to grab a key globally,
          so an app's own push-to-talk hotkey only ever fires while that app
          is focused - useless the moment you tab into a game. Hyprland sees
          every key before any client does, so a bind here works everywhere.

          The app must then be set to voice-activity mode, since the gating
          is happening below it at the device level
        '';

      key = mkOption {
        type = types.str;
        default = "mouse:276";
        example = "F13";
        description = ''
          Hyprland bind key held to talk. Defaults to the forward thumb
          button: nothing else here binds it, and a 60% keyboard has no
          spare key to give up. Override per host if the mouse lacks one.

          The bind consumes the button, so it stops reaching applications
          (no more "forward" in the browser). Use a key nothing else wants.
        '';
      };
    };

    monitors = mkOption {
      type = types.listOf (types.submodule {
        options = {
          output = mkOption {
            type = types.str;
            example = "desc:BNQ ZOWIE XL LCD EBV2R00681SL0";
            description = ''
              Which display this applies to: a connector name (`DP-4`) or a
              `desc:` match against the EDID string `hyprctl monitors`
              prints as "description".

              Prefer `desc:`. Connector names are positional - moving a
              cable from HDMI to DisplayPort renames the output and
              silently drops the rule, which lands the panel back on its
              preferred mode (60Hz on both panels here). A `desc:` match
              follows the monitor across ports.
            '';
          };

          mode = mkOption {
            type = types.str;
            default = "preferred";
            example = "1920x1080@239.96";
            description = ''
              `WIDTHxHEIGHT@RATE`, or `preferred` / `highres` / `highrr`.

              Spell the mode out rather than using `highrr`: that keyword
              maximises refresh rate over every mode, resolution included,
              so a panel offering 1024x768@240 and 1920x1080@239.96 gets
              the 1024x768 one. Take the exact string from the
              `availableModes` line of `hyprctl monitors all` - a mode the
              display does not advertise makes Hyprland warn and fall back
              to preferred, i.e. 60Hz.
            '';
          };

          position = mkOption {
            type = types.str;
            default = "auto";
            example = "1920x0";
            description = ''
              Top-left corner in layout space, `XxY`, or `auto` to have
              Hyprland place it to the right of the others.
            '';
          };

          scale = mkOption {
            type = types.str;
            default = "1";
            description = "Scale factor, or `auto`.";
          };
        };
      });
      default = [];
      description = ''
        Per-display mode lines. Left empty, Hyprland picks each panel's
        preferred mode, which for a high-refresh gaming monitor is the 60Hz
        entry its EDID lists first - the refresh rate is only reached by
        asking for it.

        A catch-all rule is emitted ahead of these, so any display not
        listed still comes up at its preferred mode instead of not at all.
      '';
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
      settings = {
        xwayland = {
          force_zero_scaling = true;
        };

        # Wildcard first: rules are applied in order and the last match
        # wins, so this only covers displays no entry below names.
        monitor =
          [",preferred,auto,1"]
          ++ map
          (m: "${m.output},${m.mode},${m.position},${m.scale}")
          cfg.monitors;

        exec-once =
          [
            "waybar"
            "awww-daemon"
            "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
          ]
          ++ optional (defaultWallpaper != null) "sleep 1 && awww img ${defaultWallpaper}"
          # Start muted, or push-to-talk would be push-to-mute on a fresh
          # login: the key only ever unmutes while held.
          ++ optional ptt.enable "${wpctl} set-mute @DEFAULT_SOURCE@ 1";

        input = {
          kb_layout = "us,ge";
          kb_variant = "";
          kb_model = "";
          kb_rules = "";
          kb_options = "ctrl:nocaps,grp:alt_shift_toggle";
          follow_mouse = 1;

          touchpad = {
            natural_scroll = true;
          };

          sensitivity = 0;
        };

        env =
          # Cursor theme and size. These have to be here and not only in
          # home.pointerCursor: that writes home.sessionVariables, which land
          # in hm-session-vars.sh and are only read by login shells, and
          # greetd execs Hyprland directly. HYPRCURSOR_SIZE keeps the size
          # consistent if a hyprcursor theme is ever installed, since
          # Hyprland sizes that path separately from XCursor.
          (
            if cursorCfg.enable
            then [
              "XCURSOR_THEME,${cursorCfg.name}"
              "XCURSOR_SIZE,${toString cursorCfg.size}"
              "HYPRCURSOR_SIZE,${toString cursorCfg.size}"
            ]
            else ["XCURSOR_SIZE,32"]
          )
          ++ [
            # Was "WLR_NO_HARDWARE_CURSORS,1" - a wlroots variable Hyprland
            # has ignored since it moved to aquamarine, so it had been doing
            # nothing. The working equivalent is cursor.no_hardware_cursors
            # below, driven by features.desktop.cursor.softwareCursors.

            # Was "GTK_THEME=Catppuccin-..." - Hyprland's env syntax splits
            # on the first comma, so a line with no comma set nothing at all
            # (confirmed: no GTK_THEME in the environment of anything
            # Hyprland spawned). The value was also a theme name this config
            # never builds; gtk.nix installs
            # "catppuccin-mocha-blue-standard".
            #
            # Setting it here rather than relying on the
            # home.sessionVariables entry in gtk.nix, because those land in
            # hm-session-vars.sh, which only login shells source - greetd
            # execs Hyprland directly, so apps launched from rofi or a
            # keybind never saw them.
            "GTK_THEME,catppuccin-mocha-blue-standard:dark"

            # Native Wayland for Electron/Chromium apps (discord, slack,
            # obsidian) instead of XWayland. On the 3440x1440 panel XWayland
            # costs sharpness and gives these apps a stale idea of scale;
            # native also fixes fractional-scale blur and IME.
            #
            # Two variables because the two families of app read different
            # things: NIXOS_OZONE_WL is a nixpkgs convention that wrappers
            # translate into --ozone-platform=wayland, while AppImages like
            # hydralauncher have no such wrapper and only respond to
            # Electron's own hint. "auto" rather than "wayland" so an app
            # still starts on X11 if it is ever run outside a Wayland
            # session.
            "NIXOS_OZONE_WL,1"
            "ELECTRON_OZONE_PLATFORM_HINT,auto"
          ];

        # Emitted only when asked for, so hosts that do not need it keep
        # Hyprland's own auto behaviour rather than being pinned to either
        # answer. See the option for why nouveau needs this.
        cursor = optionalAttrs cursorCfg.softwareCursors {
          no_hardware_cursors = true;
        };

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
          "opacity 0.9 0.7 1, match:class ^(zen-beta)$"
          "float on, match:class ^(org.pulseaudio.pavucontrol)$"
          "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"

          # No "workspace N" rules here on purpose.
          #
          # Pinning apps to fixed workspaces (kitty -> 1, zen-beta -> 2,
          # telegram/slack/discord -> 4) fights multi-monitor use: workspaces
          # are claimed by whichever monitor is focused when they are first
          # opened, so a rule sending kitty to workspace 1 drags it onto
          # whatever monitor happens to own workspace 1 - not the one the
          # cursor is on. Since those rules covered nearly every app that
          # gets launched here, new windows almost always landed on the
          # wrong screen.
          #
          # Without them a window opens on the active workspace, which
          # follows the cursor via input.follow_mouse and
          # misc.mouse_move_focuses_monitor.
        ];

        layerrule = [
          "blur on, match:namespace waybar"
          "ignore_alpha 0.5, match:namespace waybar"
          "blur on, match:namespace logout_dialog"
          "blur on, match:namespace swaync-control-center"
          "blur on, match:namespace swaync-notification-window"
        ];

        "$mainMod" = "SUPER";

        bind = [
          # Handle Applications & Default
          "$mainMod, t, exec, kitty -e zsh -c 'fastfetch; exec zsh'"
          "$mainMod, W, killactive"
          "$mainMod, P, pseudo"
          "$mainMod, M, exit"
          "$mainMod, D, exec, rofi -show drun"
          "$mainMod, Escape, exec, wlogout -p layer-shell"
          "$mainMod, Space, togglefloating"
          "$mainMod, F, fullscreen"
          "$mainMod, B, exec, zen-beta"
          "$mainMod, L, exec, pidof hyprlock || hyprlock"
          "$mainMod, E, exec, thunar"
          "$mainMod SHIFT, S, exec, screenshot-region"
          ", Print, exec, screenshot-full"
          "$mainMod, R, exec, wallpaper-select"
          "$mainMod SHIFT, R, exec, wallpaper-random"
          "$mainMod, V, exec, clipboard-history"

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
        ]
        # Push-to-talk, press half: unmute the default source. This gates the
        # microphone device itself, so it covers whatever is listening -
        # Discord, a browser call, OBS - rather than one app. That is the
        # point: on Wayland the compositor is the only thing that sees the
        # key regardless of what has focus. Release half is in bindr below.
        ++ optionals ptt.enable [
          ", ${ptt.key}, exec, ${wpctl} set-mute @DEFAULT_SOURCE@ 0"
        ];

        binde = [
          # Volume / brightness (repeat while held)
          ", XF86AudioRaiseVolume, exec, volume up"
          ", XF86AudioLowerVolume, exec, volume down"
          ", XF86MonBrightnessUp, exec, brightness up"
          ", XF86MonBrightnessDown, exec, brightness down"

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
          ", XF86AudioMute, exec, volume mute"
        ];

        # Push-to-talk, release half. bindr fires on key up, so this re-mutes
        # the moment the key is let go; the press half lives at the end of
        # the bind list above.
        bindr = optionals ptt.enable [
          ", ${ptt.key}, exec, ${wpctl} set-mute @DEFAULT_SOURCE@ 1"
        ];
      };
    };
  };
}
