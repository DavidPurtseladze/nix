{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  # NOTE: Use runtime picker with (<leader>tt)
  programs.nixvim.colorschemes.catppuccin = {
    enable = true;
    settings.flavour = "mocha";
  };

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    tokyonight-nvim
    gruvbox-nvim
    kanagawa-nvim
    rose-pine
    nord-nvim
    onedark-nvim
    dracula-nvim
    everforest
  ];

  # NOTE: Remember whichever colorscheme was last picked and reapply it on startup.
  programs.nixvim.extraConfigLua = ''
    local state_file = vim.fn.stdpath("state") .. "/theme"

    if vim.fn.filereadable(state_file) == 1 then
      local saved = vim.fn.readfile(state_file)[1]
      if saved and saved ~= "" then
        pcall(vim.cmd.colorscheme, saved)
      end
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.fn.writefile({ vim.g.colors_name }, state_file)
      end,
    })
  '';
}
