{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.undotree = {
    enable = true;

    settings = {
      SetFocusWhenToggle = true;
      WindowLayout = 2;
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>u";
      action = "<cmd>UndotreeToggle<CR>";
      options.desc = "toggle undotree";
    }
  ];
}
