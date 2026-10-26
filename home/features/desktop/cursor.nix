{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.cursor;
in {
  options.features.desktop.cursor = {
    enable = mkEnableOption "pointer cursor theme";

    package = mkOption {
      type = types.package;
      default = pkgs.bibata-cursors;
      defaultText = literalExpression "pkgs.bibata-cursors";
      description = ''
        Package providing the cursor theme. bibata-cursors ships twelve
        variants under share/icons (Modern/Original x Ice/Classic/Amber,
        each with a -Right mirror), so {option}`name` picks one.
      '';
    };

    name = mkOption {
      type = types.str;
      default = "Bibata-Modern-Ice";
      description = "Cursor theme name inside {option}`package`.";
    };

    size = mkOption {
      type = types.int;
      default = 24;
      description = "Cursor size, in pixels.";
    };

  };

  config = mkIf cfg.enable {
    home.pointerCursor = {
      enable = true;
      inherit (cfg) package name size;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
