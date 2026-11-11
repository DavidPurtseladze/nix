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
    PHP toolchain - php, intelephense (language server) and php-cs-fixer.
  '';

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.php
      pkgs.intelephense
      pkgs.php.packages.php-cs-fixer
    ];
  };
}
