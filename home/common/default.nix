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

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };
}
