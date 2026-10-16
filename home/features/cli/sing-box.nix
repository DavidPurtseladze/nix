{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.sing-box;
in {
  options.features.cli.sing-box.enable = mkEnableOption ''
    sing-box, a CLI proxy client (Shadowsocks/VMess/VLESS/Trojan/Hysteria2/
    TUIC/WireGuard). Not a GUI - it reads a JSON config and runs as a daemon:
    `sing-box run -c config.json`.
  '';

  config = mkIf cfg.enable {
    home.packages = [pkgs.sing-box];
  };
}
