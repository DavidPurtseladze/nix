{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.todo-comments = {
    enable = true;

    settings = {
      signs = true;
      highlight.multiline = true;
    };

    # Uses the telescope integration, so needs plugins.telescope.enable.
    keymaps.todoTelescope.key = "<leader>tf";
  };
}
