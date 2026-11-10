{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.notch;
in {
  options.features.desktop.notch.enable =
    mkEnableOption "notch quickshell panel and notification daemon";

  config = mkIf cfg.enable {
    home.packages = [pkgs.notch];

    systemd.user.services.notch = {
      Unit = {
        Description = "notch quickshell panel";
        PartOf = ["hyprland-session.target"];
        After = ["hyprland-session.target"];
        # Same startup race as waybar; give it room to retry.
        StartLimitBurst = 20;
      };

      Service = {
        ExecStart = "${pkgs.notch}/bin/notch";
        Restart = "always";
        RestartSec = 2;
        Environment = [
          "PATH=${config.home.profileDirectory}/bin:/run/wrappers/bin:/run/current-system/sw/bin"
        ];
      };

      Install.WantedBy = ["hyprland-session.target"];
    };
  };
}
