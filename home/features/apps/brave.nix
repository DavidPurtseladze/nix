{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.apps.brave;
in {
  options.features.apps.brave.enable = mkEnableOption ''
    Install Brave Browser. Used for website quick-lunch keybinds.
  '';

  config = mkIf cfg.enable {
    home.packages = [pkgs.brave];
  };
}
