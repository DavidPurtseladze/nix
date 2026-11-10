return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
        { "<leader>tt", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "pick colorscheme" },
        { "<leader>td", "<cmd>Telescope find_files<cr>", desc = "find files" },
        { "<leader>tg", "<cmd>Telescope live_grep<cr>", desc = "live grep" },
        { "<leader>tk", "<cmd>Telescope keymaps<cr>", desc = "search keymaps" },
        { "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "search help docs" },
    },
    opts = {},
}
