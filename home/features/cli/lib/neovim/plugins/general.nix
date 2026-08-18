{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.globals.maplocalleader = "\\";

  programs.nixvim.opts = {
    # Clipboard / UI
    clipboard = "unnamedplus";
    scrolloff = 8;
    number = true;
    relativenumber = true;

    # Indentation
    tabstop = 4;
    softtabstop = 4;
    shiftwidth = 4;
    expandtab = true;
    smartindent = true;
    wrap = false;
  };

  programs.nixvim.keymaps = [
    # Strip ^M (carriage returns) - useful when pasting from Windows into WSL.
    {
      mode = "n";
      key = ",m";
      action.__raw = ''
        function()
          vim.cmd([[%s/\r//g]])
        end
      '';
      options.desc = "strip ^M";
    }

    # Indentation
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.silent = true;
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.silent = true;
    }

    # Delete (not yank) in visual mode / with normal-mode x.
    {
      mode = "v";
      key = "x";
      action = "\"_d";
      options.silent = true;
    }
    {
      mode = "n";
      key = "x";
      action = "\"_x";
      options.silent = true;
    }

    # Ctrl+C behaves like Esc in insert mode, and clears search highlight in normal mode.
    {
      mode = "i";
      key = "<C-c>";
      action = "<Esc>";
    }
    {
      mode = "n";
      key = "<C-c>";
      action = ":nohl<CR>";
      options = {
        desc = "clear search hl";
        silent = true;
      };
    }
  ];

  # highlight on yank
  programs.nixvim.autoCmd = [
    {
      event = ["TextYankPost"];
      callback.__raw = ''
        function()
          vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 200,
          })
        end
      '';
    }
  ];
}
