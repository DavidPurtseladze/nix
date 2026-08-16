{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.thunar;
in {
  options.features.desktop.thunar.enable = mkEnableOption "Thunar file manager";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      thunar
      thunar-archive-plugin
      thunar-volman
      gvfs
    ];

    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };
}
