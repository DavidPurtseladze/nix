{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.sdks.node;

  nvm-src = pkgs.fetchFromGitHub {
    owner = "nvm-sh";
    repo = "nvm";
    rev = "v0.40.1";
    hash = "sha256-PMeFHjJ3qcphXV8MceZwleOgJrDfEeS3m/ZGvKlWbeg=";
  };
in {
  options.features.sdks.node.enable = mkEnableOption ''
    Node.js toolchain - nodejs (with npm bundled), yarn, and nvm for
    switching between Node versions outside of what Nix pins.
  '';

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.nodejs
      pkgs.yarn
      pkgs.pnpm
    ];

    programs.zsh.initContent = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "${nvm-src}/nvm.sh" ] && \. "${nvm-src}/nvm.sh"
    '';
  };
}
