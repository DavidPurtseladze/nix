local state_file = vim.fn.stdpath("state") .. "/theme"

local function restore()
    if vim.fn.filereadable(state_file) == 1 then
        local saved = vim.fn.readfile(state_file)[1]
        if saved and saved ~= "" and pcall(vim.cmd.colorscheme, saved) then
            return
        end
    end
    vim.cmd.colorscheme("catppuccin")
end

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({ flavour = "mocha" })
            restore()
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("remember_colorscheme", { clear = true }),
                callback = function()
                    if vim.g.colors_name then
                        vim.fn.writefile({ vim.g.colors_name }, state_file)
                    end
                end,
            })
        end,
    },
    { "folke/tokyonight.nvim", lazy = true },
    { "ellisonleao/gruvbox.nvim", lazy = true },
    { "rebelot/kanagawa.nvim", lazy = true },
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "shaunsingh/nord.nvim", lazy = true },
    { "navarasu/onedark.nvim", lazy = true },
    { "Mofiqul/dracula.nvim", lazy = true },
    { "sainnhe/everforest", lazy = true },
}
