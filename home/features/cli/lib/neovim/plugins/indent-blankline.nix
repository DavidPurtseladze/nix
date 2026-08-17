{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.indent-blankline = {
    enable = true;

    settings = {
      scope.show_exact_scope = true;
    };
  };
}
