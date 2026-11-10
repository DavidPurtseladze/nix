return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,
    keys = {
        { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "neo-tree toggle window" },
        { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "neo-tree toggle window" },
    },
    opts = {
        close_if_last_window = true,
        filesystem = {
            bind_to_cwd = true,
            filtered_items = {
                hide_dotfiles = false,
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
        },
        window = {
            width = 30,
        },
    },
}
