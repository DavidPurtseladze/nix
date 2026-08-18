{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.lspkind = {
    enable = true;
    cmp.enable = false;
  };
}
