{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.lualine = {
    enable = true;

    settings = {
      options = {
        theme = "catppuccin";
        globalstatus = true;
        icons_enabled = true;
      };

      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch"];
        lualine_c = [
          "filename"
          "diff"
          "diagnostics"
        ];

        lualine_x = ["encoding" "fileformat" "filetype"];
        lualine_y = ["progress"];
        lualine_z = ["location"];
      };
    };
  };
}
