{
  config,
  lib,
  outputs,
  pkgs,
  ...
}: {
  # nixpkgs.overlays / nixpkgs.config are intentionally NOT set here.
  # home-manager.useGlobalPkgs = true (see hosts/zero/default.nix) makes it
  # reuse the system's pkgs instance, so overlays/config belong in
  # hosts/common/default.nix instead - anything set here would be ignored.

  options.hostId = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = ''
      Short identifier for this machine (e.g. "zero", "yoga"), used to toggle
      per-host desktop config such as the laptop-only battery module.
    '';
  };

  config.nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };
}
