{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.toggleterm = {
    enable = true;

    settings = {
      direction = "float";
      open_mapping = "{[[<C-\\>]], [[<C-_>]]}";
      shading_factor = 2;
      float_opts.border = "rounded";
    };
  };
}
