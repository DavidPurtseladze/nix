{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.which-key.enable = true;

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>c";
      action.__raw = "function() require('which-key').show({ global = true }) end";
      options.desc = "cheatsheet (all keymaps)";
    }
  ];
}
