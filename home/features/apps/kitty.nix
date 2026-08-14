{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.kitty;
in {
  options.features.apps.kitty.enable = mkEnableOption "kitty terminal emulator";

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      themeFile = "Catppuccin-Mocha";

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

        linux_display_server = "auto";

        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;

        enable_audio_bell = false;

        window_padding_width = 4;
      };
    };
  };
}
