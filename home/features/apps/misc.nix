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
    # Same story as hydralauncher - an Electron AppImage, so Wayland comes
    # from ELECTRON_OZONE_PLATFORM_HINT. Not from nixpkgs: this one is built
    # locally out of ../../../pkgs/iptvnator and reaches pkgs through the
    # `additions` overlay in ../../../overlays.
    #
    # Its "open in external player" mode shells out to mpv, which is already
    # installed by ../desktop/media.nix.
    (mkIf config.features.apps.iptvnator.enable {
      home.packages = [pkgs.iptvnator];
    })
    # Not Electron: `stremio` (the old Qt5 shell) was dropped from nixpkgs
    # over qt5-webengine CVEs, and upstream's replacement is a GTK4 shell,
    # so Wayland is native and needs none of the Ozone env above. Playback
    # is libmpv in-process, which is why this one does not shell out to the
    # mpv from ../desktop/media.nix.
    (mkIf config.features.apps.stremio.enable {
      home.packages = [pkgs.stremio-linux-shell];
    })
    (mkIf config.features.apps.bitwarden.enable {
      home.packages = [pkgs.bitwarden-desktop];
    })
  ];
}
