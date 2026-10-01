{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.system.qbittorrent;
in {
  options.features.system.qbittorrent.enable =
    mkEnableOption "qBittorrent, sandboxed with firejail";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.qbittorrent];

    xdg.mime.defaultApplications = {
      "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
      "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
    };

    programs.firejail = {
      enable = true;
      wrappedBinaries.qbittorrent = {
        executable = "${pkgs.qbittorrent}/bin/qbittorrent";
        profile = pkgs.runCommand "qbittorrent-firejail-profile" {} ''
          sed -e 's|^dbus-user none$|dbus-user filter\ndbus-user.own org.qbittorrent.qBittorrent\ndbus-user.talk org.kde.StatusNotifierWatcher\ndbus-user.talk org.freedesktop.Notifications|' \
            ${pkgs.firejail}/etc/firejail/qbittorrent.profile > $out
        '';
      };
    };
  };
}
