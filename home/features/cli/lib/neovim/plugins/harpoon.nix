{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.harpoon = {
    enable = true;
    enableTelescope = true; # pick marks via Telescope too, on top of instant-jump

    settings = {
      settings = {
        save_on_toggle = true;
      };
    };
  };

  # Standard harpoon2 keymap set.
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>a";
      action.__raw = "function() require('harpoon'):list():add() end";
      options.desc = "harpoon: add file";
    }
    {
      mode = "n";
      key = "<C-e>";
      action.__raw = "function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end";
      options.desc = "harpoon: toggle menu";
    }
    {
      mode = "n";
      key = "<leader>1";
      action.__raw = "function() require('harpoon'):list():select(1) end";
      options.desc = "harpoon: file 1";
    }
    {
      mode = "n";
      key = "<leader>2";
      action.__raw = "function() require('harpoon'):list():select(2) end";
      options.desc = "harpoon: file 2";
    }
    {
      mode = "n";
      key = "<leader>3";
      action.__raw = "function() require('harpoon'):list():select(3) end";
      options.desc = "harpoon: file 3";
    }
    {
      mode = "n";
      key = "<leader>4";
      action.__raw = "function() require('harpoon'):list():select(4) end";
      options.desc = "harpoon: file 4";
    }
    {
      mode = "n";
      key = "<leader>5";
      action.__raw = "function() require('harpoon'):list():select(5) end";
      options.desc = "harpoon: file 5";
    }
    {
      mode = "n";
      key = "<leader>6";
      action.__raw = "function() require('harpoon'):list():select(6) end";
      options.desc = "harpoon: file 6";
    }
    {
      mode = "n";
      key = "<leader>7";
      action.__raw = "function() require('harpoon'):list():select(7) end";
      options.desc = "harpoon: file 7";
    }
    {
      mode = "n";
      key = "<leader>0";
      action.__raw = "function() require('harpoon'):list():select(8) end";
      options.desc = "harpoon: file 8";
    }
  ];
}
