{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.features.cli.neovim;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./lib/neovim/plugins
  ];

  options.features.cli.neovim.enable = mkEnableOption "Neovim (nixvim)";

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      # NOTE: Reuse already configured pkgs, to allow unfree software
      nixpkgs.pkgs = pkgs;

      globals.mapleader = " ";
    };
  };
}
