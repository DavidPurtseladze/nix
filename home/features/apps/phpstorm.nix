{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.apps.phpstorm;
in {
  options.features.apps.phpstorm.enable = mkEnableOption "PhpStorm IDE";

  config = mkIf cfg.enable {
    home.packages = [pkgs.jetbrains.phpstorm];
  };
}
