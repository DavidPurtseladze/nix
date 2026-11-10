return {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTelescope" },
    keys = {
        { "<leader>tf", "<cmd>TodoTelescope<CR>", desc = "find todos" },
    },
    opts = {
        signs = true,
        highlight = {
            multiline = true,
        },
    },
}
