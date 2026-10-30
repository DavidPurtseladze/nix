{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.lazysql;
in {
  options.features.cli.lazysql.enable = mkEnableOption "lazysql (TUI database client)";

  config = mkIf cfg.enable {
    home.packages = [pkgs.lazysql];
  };
}
