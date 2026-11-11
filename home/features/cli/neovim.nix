{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.features.cli.neovim;

  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    with p; [
      html
      css
      javascript
      typescript
      tsx
      php
      blade
      go
      rust
      lua
      vim
      vimdoc
      query
      bash
      json
      yaml
      markdown
      markdown_inline
      regex
    ]);

  treesitterBundle = pkgs.symlinkJoin {
    name = "nvim-treesitter-bundle";
    paths = [treesitter] ++ treesitter.dependencies;
  };
in {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./lib/neovim/plugins
  ];

  options.features.cli.neovim.enable = mkEnableOption "Neovim (nixvim)";

  config = mkIf cfg.enable {
    xdg.dataFile."nvim-nix/nvim-treesitter".source = treesitterBundle;

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
