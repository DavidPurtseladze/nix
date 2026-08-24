{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.noice = {
    enable = true;

    settings = {
      messages = {
        view = "mini";
        view_error = "mini";
        view_warn = "mini";
      };

      notify.view = "mini";
    };
  };
}
