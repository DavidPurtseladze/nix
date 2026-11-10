local filetypes = { "css", "scss", "sass", "html", "blade", "twig" }

return {
    "jsongerber/nvim-px-to-rem",
    commit = "da22e3d7cc067dc459d84b67e830edf7d264c5b5",
    ft = filetypes,
    cmd = { "PxToRemCursor", "PxToRemLine" },
    keys = {
        { "<leader>px", "<cmd>PxToRemCursor<CR>", mode = "n", desc = "px to rem (cursor)" },
        { "<leader>px", "<cmd>PxToRemCursor<CR>", mode = "v", desc = "px to rem (selection)" },
        { "<leader>pxl", "<cmd>PxToRemLine<CR>", mode = "n", desc = "px to rem (line)" },
        { "<leader>pxl", "<cmd>PxToRemLine<CR>", mode = "v", desc = "px to rem (selection line)" },
    },
    opts = {
        root_font_size = 16,
        decimal_count = 4,
        show_virtual_text = true,
        add_cmp_source = true,
        filetypes = filetypes,
    },
}
