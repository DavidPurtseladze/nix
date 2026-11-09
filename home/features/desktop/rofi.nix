{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.rofi;
in {
  options.features.desktop.rofi.enable = mkEnableOption "rofi app launcher";

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      theme = ./lib/rofi/style/rofi-theme.rasi;

      settings = {
        terminal = "${pkgs.kitty}/bin/kitty";
        font = "FiraCode Nerd Font 11";
        location = 0;
        modes = ["window" "run" "drun"];

        show-icons = true;
        display-drun = "Applications";
        display-window = "Windows";
        display-run = "Run";
        drun-display-format = "{icon} {name}";
      };
    };
  };
}
