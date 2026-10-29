{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.kubectl;
in {
  options.features.cli.kubectl.enable = mkEnableOption "kubectl (Kubernetes CLI)";

  config = mkIf cfg.enable {
    home.packages = [pkgs.kubectl];
  };
}
