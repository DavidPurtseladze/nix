{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.opts = {
    foldenable = true;
    foldmethod = "manual";
    foldlevel = 99;
    foldcolumn = "0";
  };

  programs.nixvim.plugins.nvim-ufo = {
    enable = true;

    settings = {
      provider_selector = ''
        function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end
      '';
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "zR";
      action.__raw = "require('ufo').openAllFolds";
      options.desc = "open all folds";
    }
    {
      mode = "n";
      key = "zM";
      action.__raw = "require('ufo').closeAllFolds";
      options.desc = "close all folds";
    }
    {
      mode = "n";
      key = "zr";
      action.__raw = "require('ufo').openFoldsExceptKinds";
      options.desc = "open folds (except kinds)";
    }
    {
      mode = "n";
      key = "zm";
      action.__raw = "require('ufo').closeFoldsWith";
      options.desc = "close folds with";
    }
  ];
}
