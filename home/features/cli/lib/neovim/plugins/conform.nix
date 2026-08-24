{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    autoInstall.enable = true;

    settings = {
      formatters_by_ft = {
        lua = ["stylua"];

        html = ["prettier"];
        css = ["prettier"];
        scss = ["prettier"];
        javascript = ["prettier"];
        typescript = ["prettier"];
        typescriptreact = ["prettier"];
        json = ["prettier"];
        yaml = ["prettier"];
        markdown = ["prettier"];
        blade = ["prettier-html"];
        php = ["php_cs_fixer"];
      };

      formatters = {
        prettier-html = {
          command = lib.getExe pkgs.prettier;
          args = ["--parser" "html" "--stdin-filepath" "$FILENAME"];
        };
      };

      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>fm";
      action.__raw = "function() require('conform').format({ async = true, lsp_format = 'fallback' }) end";
      options.desc = "format buffer";
    }
  ];
}
