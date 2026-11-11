{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.sdks.php;
in {
  options.features.sdks.php.enable = mkEnableOption ''
    PHP toolchain - php and intelephense, the PHP language server.
  '';

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.php
      pkgs.intelephense
    ];
  };
}
