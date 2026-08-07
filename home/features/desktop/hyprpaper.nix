{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.hyprpaper;
  # One of the wallpapers already committed under ../../../dotfiles (see the
  # "Add Claude Code & Background Images" commit) — picked to match the
  # purple accent already used in hyprland.nix/GTK_THEME. Swap the filename
  # below to use a different one from that folder.
  wallpaper = ../../../dotfiles + "/Wallpaper Alchemy - 4K High Resolution Purple Tree Wallpaper.jpg";
in {
  options.features.desktop.hyprpaper.enable = mkEnableOption "hyprpaper wallpaper";

  config = mkIf cfg.enable {
    # hyprpaper (exec-once'd in hyprland.nix) reads this on startup. Without
    # it, hyprpaper has nothing to display and the desktop is solid black.
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${wallpaper}
      wallpaper = , ${wallpaper}
      splash = false
    '';
  };
}
