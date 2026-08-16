{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.gtk;
in {
  options.features.desktop.gtk.enable = mkEnableOption "Catppuccin Mocha GTK theming (used by Thunar and other GTK apps)";

  config = mkIf cfg.enable {
    gtk = {
      enable = true;

      theme = {
        name = "catppuccin-mocha-blue-standard";
        package = pkgs.catppuccin-gtk.override {
          variant = "mocha";
          accents = ["blue"];
        };
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
    };

    home.sessionVariables = {
      GTK_THEME = "catppuccin-mocha-blue-standard:dark";
    };
  };
}
