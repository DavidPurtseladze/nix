{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.networkmanagerapplet;
in {
  options.features.desktop.networkmanagerapplet.enable = mkEnableOption ''
    nm-connection-editor and nm-applet, the NetworkManager GUI - including
    OpenVPN connections, through the networkmanager-openvpn plugin enabled in
    hosts/*/configuration.nix. Shows up in rofi's app launcher.
  '';

  config = mkIf cfg.enable {
    home.packages = [pkgs.networkmanagerapplet];
  };
}
