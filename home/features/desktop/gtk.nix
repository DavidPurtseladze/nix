{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.gtk;

  # Written by theme-switcher on every palette change; loaded after the theme.
  paletteCss = ''
    @import url("file://${config.home.homeDirectory}/.local/state/theme/gtk-colors.css");
  '';
in {
  options.features.desktop.gtk.enable = mkEnableOption "GTK theming (used by Thunar and other GTK apps)";

  config = mkIf cfg.enable {
    gtk = {
      enable = true;

      # Derives from GTK's named colours, so gtk.css overrides reach GTK3.
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      # Keep GTK4 apps on the same theme as GTK3 (this used to be the
      # implicit default; newer home-manager wants it set explicitly).
      gtk4.theme = config.gtk.theme;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk3.extraCss = paletteCss;
      gtk4.extraCss = paletteCss;
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
