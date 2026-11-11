{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprland;
in {
  options.features.desktop.hyprland = {
    enable = mkEnableOption "hyprland config";
  };

  config = mkIf cfg.enable {
    home.packages = import ./lib/scripts {inherit pkgs;};

    systemd.user.targets.hyprland-session = {
      Unit = {
        Description = "Hyprland compositor session";
        Documentation = ["man:systemd.special(7)"];
        BindsTo = ["graphical-session.target"];
        Wants = ["graphical-session-pre.target"];
        After = ["graphical-session-pre.target"];
        PropagatesStopTo = ["graphical-session.target"];
      };
    };
  };
}
