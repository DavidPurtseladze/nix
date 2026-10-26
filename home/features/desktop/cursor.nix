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

    softwareCursors = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Composite the pointer into the frame instead of handing it to a DRM
        overlay plane.

        A hardware cursor is scanned out independently of the desktop image,
        and on nouveau that plane stops being re-committed once the screen
        goes static - so the pointer blanks the instant it stops moving and
        returns as soon as motion forces a new commit. Compositing it into
        the frame cannot fail that way.

        Costs a full redraw per cursor movement, so leave it off unless the
        driver actually needs it. Worth retesting after a GPU driver change:
        this is a nouveau defect, not a Hyprland one.

        Note this supersedes WLR_NO_HARDWARE_CURSORS, which was a wlroots
        variable that Hyprland has ignored since it moved to aquamarine.
      '';
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
