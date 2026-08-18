{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.web-devicons.enable = true;

  programs.nixvim.plugins.neo-tree = {
    enable = true;

    settings = {
      close_if_last_window = true;

      filesystem = {
        bind_to_cwd = true;
        filtered_items.hide_dotfiles = false;
        follow_current_file = {
          enabled = true;
          leave_dirs_open = false;
        };
      };

      window.width = 30;
    };
  };

  programs.nixvim.globals = {
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<C-n>";
      action = "<cmd>Neotree toggle<CR>";
      options.desc = "neo-tree toggle window";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle<CR>";
      options.desc = "neo-tree toggle window";
    }
  ];
}
