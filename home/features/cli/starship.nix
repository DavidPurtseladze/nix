{ config, lib, ... }:

with lib;

let
  cfg = config.features.cli.starship;
in
{
  options.features.cli.starship.enable = mkEnableOption "Enable Starship prompt";

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        palette = "catppuccin_mocha";

        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          blue = "#89b4fa";
          lavender = "#b4befe";
        };
      };
    };
  };
}
