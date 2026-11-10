{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.features.apps = {
    telegram.enable = mkEnableOption "Telegram Desktop";
    slack.enable = mkEnableOption "Slack";
    obsidian.enable = mkEnableOption "Obsidian";
    discord.enable = mkEnableOption "Discord";
    hydralauncher.enable = mkEnableOption "Hydra Launcher";
    iptvnator.enable = mkEnableOption "IPTVnator";
    stremio.enable = mkEnableOption "Stremio";
    bitwarden.enable = mkEnableOption "Bitwarden";
    dbeaver.enable = mkEnableOption "DBeaver Community (SQL client)";
    whatsapp.enable = mkEnableOption "WhatsApp (karere)";
    protonvpn.enable = mkEnableOption "Proton VPN";
  };

  config = mkMerge [
    (mkIf config.features.apps.telegram.enable {
      home.packages = [pkgs.telegram-desktop];
    })
    (mkIf config.features.apps.slack.enable {
      home.packages = [pkgs.slack];
    })
    (mkIf config.features.apps.obsidian.enable {
      home.packages = [pkgs.obsidian];
    })
    (mkIf config.features.apps.discord.enable {
      home.packages = [pkgs.discord];
    })
    (mkIf config.features.apps.hydralauncher.enable {
      home.packages = [pkgs.hydralauncher];
    })
    (mkIf config.features.apps.iptvnator.enable {
      home.packages = [pkgs.iptvnator];
    })
    (mkIf config.features.apps.stremio.enable {
      home.packages = [pkgs.stremio-linux-shell];
    })
    (mkIf config.features.apps.bitwarden.enable {
      home.packages = [pkgs.bitwarden-desktop];
    })
    (mkIf config.features.apps.dbeaver.enable {
      home.packages = [pkgs.dbeaver-bin];
    })
    (mkIf config.features.apps.whatsapp.enable {
      home.packages = [pkgs.karere];
    })
    (mkIf config.features.apps.protonvpn.enable {
      home.packages = [pkgs.proton-vpn];
    })
  ];
}
