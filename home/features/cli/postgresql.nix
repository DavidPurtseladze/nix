{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.postgresql;
in {
  options.features.cli.postgresql.enable = mkEnableOption "PostgreSQL client tools (psql, pg_dump)";

  config = mkIf cfg.enable {
    home.packages = [pkgs.postgresql];
  };
}
