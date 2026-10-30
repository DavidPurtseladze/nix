{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.sdks.zig;
in {
  options.features.sdks.zig.enable = mkEnableOption ''
    Zig toolchain - zig (0.16) and zls, the Zig language server.
  '';

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.zig
      pkgs.zls
    ];
  };
}
