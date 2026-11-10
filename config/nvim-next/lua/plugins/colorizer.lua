return {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        filetypes = { "*" },
        user_default_options = {
            css = true,
            RRGGBBAA = true,
            tailwind = true,
            mode = "virtualtext",
            virtualtext = "■",
            virtualtext_inline = true,
        },
    },
}
