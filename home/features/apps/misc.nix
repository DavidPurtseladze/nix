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
  ];
}
