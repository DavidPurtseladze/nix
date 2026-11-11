{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.sdks.go;
in {
  options.features.sdks.go.enable = mkEnableOption ''
    Go toolchain - go (1.27), gnumake, golangci-lint, gotools (goimports), and gopls.
  '';

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.go_1_27
      pkgs.gnumake
      pkgs.golangci-lint
      pkgs.gotools
      pkgs.gopls
    ];
  };
}
