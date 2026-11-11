local function nc(fn, ...)
    local args = { ... }
    return function()
        require("neocodeium")[fn](unpack(args))
    end
end

return {
    "monkoose/neocodeium",
    commit = "ab8a3da3a66d299ad5422b76ce5ee21b68719296",
    event = "InsertEnter",
    cmd = "NeoCodeium",
    keys = {
        { "<A-n>", nc("cycle_or_complete"), mode = "i", desc = "ai: next suggestion" },
        { "<A-p>", nc("cycle_or_complete", -1), mode = "i", desc = "ai: previous suggestion" },
        { "<A-a>", nc("accept"), mode = "i", desc = "ai: accept" },
        { "<A-A>", nc("accept_line"), mode = "i", desc = "ai: accept line" },
        { "<A-w>", nc("accept_word"), mode = "i", desc = "ai: accept word" },
        { "<A-c>", nc("clear"), mode = "i", desc = "ai: clear suggestion" },
        { "<A-t>", "<cmd>NeoCodeium toggle<CR>", mode = { "n", "i" }, desc = "ai: toggle suggestions" },
    },
    config = function()
        local neocodeium = require("neocodeium")
        local ok, cmp = pcall(require, "cmp")

        neocodeium.setup({
            manual = false,
            debounce = true,
            bin = vim.fn.exepath("codeium_language_server"),
            filter = function()
                return not (ok and cmp.visible())
            end,
            filetypes = {
                help = false,
                gitcommit = false,
                gitrebase = false,
                markdown = false,
                TelescopePrompt = false,
                ["neo-tree"] = false,
                ["neo-tree-popup"] = false,
                harpoon = false,
                ["."] = false,
            },
        })

        if ok then
            cmp.event:on("menu_opened", function()
                neocodeium.clear()
            end)
        end
    end,
}
