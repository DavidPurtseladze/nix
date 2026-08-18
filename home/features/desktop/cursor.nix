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
      default = pkgs.adwaita-icon-theme;
      defaultText = literalExpression "pkgs.adwaita-icon-theme";
      description = ''
        Package providing the cursor theme. adwaita-icon-theme ships the
        cursors under share/icons/Adwaita/cursors; nothing in this config
        pulled it in before, so the session was falling back to whatever
        stray theme happened to be on the icon path.
      '';
    };

    name = mkOption {
      type = types.str;
      default = "Adwaita";
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
    # Backend-independent settings plus the GTK and X11 generators. The
    # dotIcons generator is on by default and writes ~/.icons/default with
    # Inherits=<name>, which is what apps that ignore both GTK settings and
    # the environment fall back to reading.
    #
    # hyprcursor generation is deliberately left off. It would export
    # HYPRCURSOR_THEME, and there is no hyprcursor-format Adwaita theme to
    # resolve it to - Hyprland would warn and fall back to XCursor anyway.
    # Only HYPRCURSOR_SIZE is worth setting, which hyprland.nix does.
    home.pointerCursor = {
      inherit (cfg) package name size;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
