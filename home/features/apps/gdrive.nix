# NOTE: On a new system, after enabling this and rebuilding, sync won't actually
# start until you do this once:
#   cd ~/Drive/
#
#   rclone config
#     -> n (new remote), name it exactly "gdrive", type "drive"
#     -> leave client_id/client_secret/service_account_file blank
#     -> scope: full access, advanced config: n, use auto config: y
#     -> log in and approve in the browser it opens, then keep the remote
#
#   systemctl --user start rclone-gdrive-bisync
#     -> triggers the first sync immediately instead of waiting for the timer
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.apps.gdrive;

  bisync = pkgs.writeShellScript "rclone-gdrive-bisync" ''
    set -euo pipefail

    STATE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/rclone/bisync"
    LOCAL_DIR="$HOME/Drive"

    # bisync needs one baseline --resync run before it can diff normally,
    if ! compgen -G "$STATE_DIR"/*.lst >/dev/null 2>&1; then
      ${pkgs.rclone}/bin/rclone bisync gdrive: "$LOCAL_DIR" --resync -v
    else
      ${pkgs.rclone}/bin/rclone bisync gdrive: "$LOCAL_DIR" -v
    fi
  '';
in {
  options.features.apps.gdrive.enable = mkEnableOption ''
    Google Drive as a real local folder, two-way synced via rclone bisync.
    Needs a one-time `rclone config` to authorize first.
  '';

  config = mkIf cfg.enable {
    home.packages = [pkgs.rclone];

    home.activation.createGdriveDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$HOME/Drive"
    '';

    systemd.user.services.rclone-gdrive-bisync = {
      Unit = {
        Description = "Two-way sync ~/Drive with Google Drive";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${bisync}";
      };
    };

    systemd.user.timers.rclone-gdrive-bisync = {
      Unit.Description = "Run the Google Drive sync periodically";

      Timer = {
        OnBootSec = "1min";
        OnUnitActiveSec = "5min";
      };

      Install.WantedBy = ["timers.target"];
    };
  };
}
