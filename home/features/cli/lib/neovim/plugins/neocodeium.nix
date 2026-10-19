{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "neocodeium";
      version = "2026-06-22";
      src = pkgs.fetchFromGitHub {
        owner = "monkoose";
        repo = "neocodeium";
        rev = "ab8a3da3a66d299ad5422b76ce5ee21b68719296";
        hash = "sha256-rvlTa5nj9Aoelk7taqW5nBSqLZXrLt52jfWc+23toEs=";
      };

      nvimRequireCheck = "neocodeium";
    })
  ];

  programs.nixvim.extraConfigLua = ''
    require("neocodeium").setup({
      manual = true,
      bin = "${pkgs.codeium}/bin/codeium_language_server",
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "NeoCodeiumCompletionDisplayed",
      callback = function()
        local ok, cmp = pcall(require, "cmp")
        if ok then
          cmp.abort()
        end
      end,
    })
  '';

  programs.nixvim.keymaps = [
    {
      mode = "i";
      key = "<A-e>";
      action.__raw = "function() require('neocodeium').cycle_or_complete() end";
      options.desc = "neocodeium suggest/cycle";
    }
    {
      mode = "i";
      key = "<A-f>";
      action.__raw = "function() require('neocodeium').accept() end";
      options.desc = "neocodeium accept";
    }
    {
      mode = "i";
      key = "<A-w>";
      action.__raw = "function() require('neocodeium').accept_word() end";
      options.desc = "neocodeium accept word";
    }
    {
      mode = "i";
      key = "<A-a>";
      action.__raw = "function() require('neocodeium').accept_line() end";
      options.desc = "neocodeium accept line";
    }
    {
      mode = "i";
      key = "<A-c>";
      action.__raw = "function() require('neocodeium').clear() end";
      options.desc = "neocodeium clear";
    }
  ];
}
