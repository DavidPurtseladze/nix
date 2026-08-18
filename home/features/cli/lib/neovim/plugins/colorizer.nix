{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.colorizer = {
    enable = true;

    settings = {
      filetypes = ["*"];

      user_default_options = {
        css = true;
        RRGGBBAA = true;
        tailwind = true;

        mode = "virtualtext";
        virtualtext = "■";
        virtualtext_inline = true;
      };
    };
  };
}
