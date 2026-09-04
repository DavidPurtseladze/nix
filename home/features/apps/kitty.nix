{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.kitty;
in {
  options.features.apps.kitty = {
    enable = mkEnableOption "kitty terminal emulator";

    mouseHideWait = mkOption {
      type = types.str;
      default = "3.0";
      example = "15.0";
      description = ''
        Seconds of no mouse movement before kitty hides the pointer over its
        own windows. This is kitty's doing, not the compositor's - Hyprland
        has cursor:inactive_timeout, but it defaults to 0 (never hide) and
        nothing here sets it, so kitty's 3 second default is the only thing
        in this config that makes a resting cursor vanish.

        Zero disables hiding entirely; a negative value hides the pointer
        the moment you start typing.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      themeFile = "Catppuccin-Mocha";

      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+v" = "paste_from_clipboard";
      };

      font = {
        name = "FiraCode Nerd Font";
        size = 12;
      };

      settings = {
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";

        background_opacity = 0.9;
        confirm_os_window_close = 0;

        # Animated cursor trail
        cursor_trail = 1;

        # How long the mouse pointer survives sitting still - see the option
        # description. kitty's own default is 3.0.
        mouse_hide_wait = cfg.mouseHideWait;

        linux_display_server = "auto";

        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;

        enable_audio_bell = false;

        window_padding_width = 0;
      };
    };
  };
}
