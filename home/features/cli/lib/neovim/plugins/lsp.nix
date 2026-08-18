{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.filetype.pattern.".*\\.blade\\.php$" = "blade";

  programs.nixvim.plugins.lsp = {
    enable = true;

    inlayHints = true;

    keymaps = {
      lspBuf = {
        gd = "definition";
        gD = "declaration";
        gi = "implementation";
        gr = "references";
        K = "hover";
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";
      };

      diagnostic = {
        "[d" = "goto_prev";
        "]d" = "goto_next";
      };
    };

    servers = {
      # Frontend
      html.enable = true;
      cssls.enable = true;
      tailwindcss.enable = true; # already covers .blade.php by default
      ts_ls.enable = true; # JS/TS

      # Backend
      intelephense.enable = true;
      gopls.enable = true;
      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
    };
  };

  programs.nixvim.plugins.lsp.servers.html.filetypes = ["html" "blade"];
  programs.nixvim.plugins.lsp.servers.intelephense.filetypes = ["php" "blade"];
}
