{
  config,
  lib,
  pkgs,
  ...
}:
let
  phpCsFixerDefaultConfig = pkgs.writeText "php-cs-fixer.default.php" ''
    <?php

    return (new PhpCsFixer\Config())
        ->setRules([
            '@PSR12' => true,
        ]);
  '';
in
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

        rust = ["rustfmt"];
      };

      formatters = {
        prettier-html = {
          command = lib.getExe pkgs.prettier;
          args = ["--parser" "html" "--stdin-filepath" "$FILENAME"];
        };

        rustfmt.command.__raw = ''
          function(self, ctx)
            local toolchain = vim.fs.find(
              "rust-toolchain.toml",
              { path = ctx.dirname, upward = true }
            )[1]
            if toolchain and vim.fn.executable("rustfmt-nightly") == 1 then
              local pinned = table.concat(vim.fn.readfile(toolchain), "\n")
              if pinned:match('channel%s*=%s*"nightly') then
                return "rustfmt-nightly"
              end
            end
            return "rustfmt"
          end
        '';

        php_cs_fixer.args.__raw = ''
          function(self, ctx)
            local has_config = vim.fs.find(
              { ".php-cs-fixer.php", ".php-cs-fixer.dist.php", ".php_cs", ".php_cs.dist" },
              { path = ctx.dirname, upward = true }
            )[1]
            if has_config then
              return { "fix", "$FILENAME" }
            end
            return { "fix", "$FILENAME", "--config=${phpCsFixerDefaultConfig}" }
          end
        '';
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
