{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.flash.enable = true;

  programs.nixvim.keymaps = [
    {
      mode = ["n" "x" "o"];
      key = "s";
      action.__raw = "function() require('flash').jump() end";
      options.desc = "flash jump";
    }
  ];
}
