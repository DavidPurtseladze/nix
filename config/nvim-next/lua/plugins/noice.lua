return {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = "VeryLazy",
    opts = {
        messages = {
            view = "mini",
            view_error = "mini",
            view_warn = "mini",
        },
        notify = {
            view = "mini",
        },
    },
}
