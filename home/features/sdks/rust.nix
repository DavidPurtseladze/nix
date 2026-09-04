{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.sdks.rust;
in {
  options.features.sdks.rust.enable = mkEnableOption ''
    Rust toolchain - rustc, cargo, clippy, rustfmt, rust-analyzer - plus
    pkg-config, needed by most crates that link against a native C library.
  '';

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.rustc
      pkgs.cargo
      pkgs.clippy
      pkgs.rustfmt
      pkgs.rust-analyzer
      pkgs.pkg-config
    ];
  };
}
