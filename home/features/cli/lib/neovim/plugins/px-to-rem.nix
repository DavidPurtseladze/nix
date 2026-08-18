{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  # Not packaged in nixpkgs/nixvim - build it directly from source.
  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "nvim-px-to-rem";
      version = "2025-02-05";
      src = pkgs.fetchFromGitHub {
        owner = "jsongerber";
        repo = "nvim-px-to-rem";
        rev = "da22e3d7cc067dc459d84b67e830edf7d264c5b5";
        hash = "sha256-14MblsUFeBpTxipN7AGn5uz8QiLWKbZggUCLyv5foI8=";
      };
    })
  ];

  programs.nixvim.extraConfigLua = ''
    require("nvim-px-to-rem").setup({
      root_font_size = 16,
      decimal_count = 4,
      show_virtual_text = true,
      add_cmp_source = true,
      filetypes = { "css", "scss", "sass", "html", "blade", "twig" },
    })
  '';

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>px";
      action = "<cmd>PxToRemCursor<CR>";
      options.desc = "px to rem (cursor)";
    }
    {
      mode = "v";
      key = "<leader>px";
      action = "<cmd>PxToRemCursor<CR>";
      options.desc = "px to rem (selection)";
    }
    {
      mode = "n";
      key = "<leader>pxl";
      action = "<cmd>PxToRemLine<CR>";
      options.desc = "px to rem (line)";
    }
    {
      mode = "v";
      key = "<leader>pxl";
      action = "<cmd>PxToRemLine<CR>";
      options.desc = "px to rem (selection line)";
    }
  ];
}
