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
    # Electron. Picks up Wayland from NIXOS_OZONE_WL, which the nixpkgs
    # wrapper turns into --ozone-platform=wayland plus Wayland window
    # decorations and IME - see the env block in ../desktop/hyprland.nix.
    (mkIf config.features.apps.discord.enable {
      home.packages = [pkgs.discord];
    })
    # Also Electron, but shipped as an AppImage, so there is no nixpkgs
    # wrapper reading NIXOS_OZONE_WL. It goes native on Wayland only via
    # ELECTRON_OZONE_PLATFORM_HINT, set alongside it in the same env block.
    (mkIf config.features.apps.hydralauncher.enable {
      home.packages = [pkgs.hydralauncher];
    })
  ];
}
