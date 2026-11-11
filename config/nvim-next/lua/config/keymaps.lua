local map = vim.keymap.set

map("n", ",m", function()
    vim.cmd([[%s/\r//g]])
end, { desc = "strip ^M" })

map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })

map("v", "x", '"_d', { silent = true })
map("n", "x", '"_x', { silent = true })

map("i", "<C-c>", "<Esc>")
map("n", "<C-c>", ":nohl<CR>", { desc = "clear search hl", silent = true })
