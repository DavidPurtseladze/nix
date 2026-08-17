{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.telescope = {
    enable = true;

    keymaps = {
      "<leader>tt" = {
        action = "colorscheme enable_preview=true";
        options.desc = "pick colorscheme";
      };
      "<leader>td" = {
        action = "find_files";
        options.desc = "find files";
      };
      "<leader>tg" = {
        action = "live_grep";
        options.desc = "live grep";
      };
      "<leader>tk" = {
        action = "keymaps";
        options.desc = "search keymaps";
      };
      "<leader>th" = {
        action = "help_tags";
        options.desc = "search help docs";
      };
    };
  };
}
