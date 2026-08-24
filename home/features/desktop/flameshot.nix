{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.flameshot;

  # `flameshot gui` cannot skip the monitor picker on a multi-head Wayland
  # session. Its own "capture active monitor" setting is refused outright -
  # screengrabber.cpp bails with "not supported on Wayland due to Wayland
  # security model" - because Wayland gives no client the cursor position,
  # so Flameshot cannot tell which screen to pick.
  #
  # The compositor can, though. This asks Hyprland where the cursor is and
  # hands Flameshot the answer as an explicit screen number, using the one
  # subcommand that accepts one: `screen -n N -e` builds the same
  # GRAPHICAL_MODE request `gui` does, but calls setSelectedMonitor(), which
  # short-circuits the picker before it is ever constructed.
  flameshot-monitor = pkgs.writeShellApplication {
    name = "flameshot-monitor";
    runtimeInputs = [config.services.flameshot.package pkgs.hyprland pkgs.jq];
    text = ''
      monitors=$(hyprctl -j monitors)
      cursor=$(hyprctl -j cursorpos)

      # -n indexes QGuiApplication::screens(), which Qt fills in wl_output
      # registry order - the same order Hyprland lists its monitors in. So
      # the position in the array is the screen number, NOT the monitor's
      # `id` field, which stops matching after a hotplug.
      #
      # Verified on this machine: -n 0 grabs 1920x1080 (HDMI-A-4) and -n 1
      # grabs 3440x1440 (DP-4), matching `hyprctl monitors` positionally.
      #
      # width/height are the mode's pixel dimensions, so they need dividing
      # by scale to compare against the cursor's logical coordinates.
      index=$(jq -n --argjson m "$monitors" --argjson c "$cursor" '
        [ $m | to_entries[]
          | select(
              $c.x >= .value.x
              and $c.x < (.value.x + (.value.width / .value.scale))
              and $c.y >= .value.y
              and $c.y < (.value.y + (.value.height / .value.scale))
            )
          | .key
        ]
        # Falls back to the focused monitor if the cursor sits in a gap no
        # output covers, then to 0, so a capture always happens rather than
        # the keybind doing nothing.
        + [ $m | to_entries[] | select(.value.focused) | .key ]
        + [ 0 ]
        | first
      ')

      exec flameshot screen -n "$index" -e "$@"
    '';
  };
in {
  options.features.desktop.flameshot = {
    enable = mkEnableOption ''
      Flameshot as the screenshot tool, replacing the grim/slurp scripts
      that used to live in ./lib/scripts.

      Those scripts could only take a picture: select a region, write a
      PNG, copy it. Flameshot draws an editor over the frozen screen
      first, so arrows, boxes, blur and text happen before anything is
      saved - which is the part that actually matters when a screenshot
      is going into a bug report or a message

      On Wayland it never touches the screen directly. Capture goes
      through the xdg-desktop-portal Screenshot interface, which
      ../../../hosts/nik-a73/configuration.nix already points at
      xdg-desktop-portal-hyprland (`config.common.default`). That is why
      this needs no Ozone/Qt platform env of its own - see the env block
      in ./hyprland.nix for the apps that do
    '';

    savePath = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/Pictures/Screenshots";
      example = "/home/nik-a73/Screenshots";
      description = ''
        Directory screenshots are written to. Kept as an option rather
        than hardcoded because ./hyprland.nix has to name the same path
        on the Print keybind, and the two drifting apart would mean the
        full-screen key silently saving somewhere else.

        Created at login via systemd-tmpfiles: Flameshot's `-p` fails on
        a missing directory, and the old scripts got away with it only
        because they ran `mkdir -p` on every capture.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [flameshot-monitor];

    systemd.user.tmpfiles.rules = [
      "d ${cfg.savePath} 0755 - - -"
    ];

    services.flameshot = {
      enable = true;

      # Enabling the service is what gets the tray icon, and the tray icon
      # is the only place the config GUI, capture history and "Take
      # screenshot" live once the old scripts are gone. It lands in the
      # waybar tray module (./lib/wayland/modules.nix).
      #
      # Note that Home Manager owns flameshot.ini once `settings` is
      # non-empty - it symlinks it out of the store, so it is read-only
      # and anything changed in Flameshot's own preferences window is
      # discarded on restart. Change it here instead.
      settings.General = {
        savePath = cfg.savePath;

        # Save straight to savePath instead of opening a file dialog and
        # then remembering wherever it last pointed. Matches what the
        # grim scripts did: one keypress, file on disk, no prompt.
        savePathFixed = true;

        # Both, like the old scripts - the file for later, the clipboard
        # for pasting into whatever is already open.
        copyPathAfterSave = false;
        saveAfterCopy = false;

        # The "Flameshot has been started" toast fires on every login
        # otherwise, since the daemon is a graphical-session service now.
        showStartupLaunchMessage = false;

        # The onboarding overlay covering the selection on first capture.
        showHelp = false;

        # Same accent the Hyprland borders use
        # (general."col.active_border" in ./hyprland.nix), so the
        # selection handles do not clash with the rest of the desktop.
        uiColor = "#9742b5";
        contrastUiColor = "#1e1e2e";
        drawColor = "#9742b5";
      };
    };
  };
}
