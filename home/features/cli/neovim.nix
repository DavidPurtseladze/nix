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

      # Default/active colorscheme. Others below are just installed so the
      # runtime picker (<leader>tt) can switch to them.
      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = "mocha";
      };

      globals.mapleader = " ";

      extraPlugins = with pkgs.vimPlugins; [
        tokyonight-nvim
        gruvbox-nvim
        kanagawa-nvim
        rose-pine
      ];

      extraConfigLua = ''
        local state_file = vim.fn.stdpath("state") .. "/theme"

        if vim.fn.filereadable(state_file) == 1 then
          local saved = vim.fn.readfile(state_file)[1]
          if saved and saved ~= "" then
            pcall(vim.cmd.colorscheme, saved)
          end
        end

        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            vim.fn.writefile({ vim.g.colors_name }, state_file)
          end,
        })
      '';
    };
  };
}
