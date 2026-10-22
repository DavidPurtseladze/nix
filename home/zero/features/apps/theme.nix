{
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.theme
    pkgs.matugen
    pkgs.base16-schemes
  ];

  home.activation.themeRestore = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${lib.getExe pkgs.theme} restore || true
  '';
}
