{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprsunset;
in {
  options.features.desktop.hyprsunset.enable = mkEnableOption "hyprsunset colour temperature daemon";

  config = mkIf cfg.enable {
    services.hyprsunset = {
      enable = true;
      extraArgs = ["-i"];
    };
  };
}
