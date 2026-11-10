return {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_WindowLayout = 2
    end,
    keys = {
        { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "toggle undotree" },
    },
}
