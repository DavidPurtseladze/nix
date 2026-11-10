return {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    cmd = "ToggleTerm",
    opts = {
        direction = "float",
        open_mapping = { [[<C-\>]], [[<C-_>]] },
        shading_factor = 2,
        float_opts = {
            border = "rounded",
        },
    },
}
