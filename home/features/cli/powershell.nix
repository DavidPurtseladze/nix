{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.powershell;
in {
  options.features.cli.powershell.enable = mkEnableOption ''
    PowerShell 7 (pwsh) plus docker-compose, awscli2, and the mariadb client -
    common shell-out targets for PowerShell-based deploy tooling.
  '';

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.powershell
      pkgs.docker-compose 
      pkgs.awscli2
      pkgs.mariadb 
    ];
  };
}
