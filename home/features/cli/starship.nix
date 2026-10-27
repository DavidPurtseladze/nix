{ config, lib, ... }:

with lib;

let
  cfg = config.features.cli.starship;
in
{
  options.features.cli.starship.enable = mkEnableOption "Enable Starship prompt";

  config = mkIf cfg.enable {
    # Prompt config lives in config/starship.toml.
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
