{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.features.sdks.rust;

  fenixPkgs = inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system};

  # fenix's nightly toolchain ships binaries under the same names as
  # nixpkgs' stable ones (rustc, cargo, ...), which would collide in
  # home.packages. Instead of picking one name to keep, symlink every
  # binary the toolchain provides under a "-nightly" suffix so stable
  # and nightly coexist on PATH (e.g. `cargo-nightly`, `rustc-nightly`).
  nightlyBins = pkgs.runCommand "rust-nightly-bins" {} ''
    mkdir -p $out/bin
    for f in ${fenixPkgs.latest.toolchain}/bin/*; do
      ln -s "$f" "$out/bin/$(basename "$f")-nightly"
    done
  '';
in {
  options.features.sdks.rust.enable = mkEnableOption ''
    Rust toolchain - rustc, cargo, clippy, rustfmt, rust-analyzer - plus
    pkg-config, needed by most crates that link against a native C library,
    and gcc, which supplies the cc linker rustc shells out to at link time.
  '';

  options.features.sdks.rust.enableNightly = mkEnableOption ''
    Nightly Rust toolchain (via fenix), installed alongside stable under
    "-nightly"-suffixed binary names (cargo-nightly, rustc-nightly, ...)
    to avoid colliding with the stable toolchain on PATH.
  '';

  config = mkIf cfg.enable {
    home.packages =
      [
        pkgs.rustc
        pkgs.cargo
        pkgs.clippy
        pkgs.rustfmt
        pkgs.rust-analyzer
        pkgs.pkg-config
        pkgs.gcc
      ]
      ++ optional cfg.enableNightly nightlyBins;
  };
}
