local function list()
    return require("harpoon"):list()
end

local keys = {
    {
        "<leader>a",
        function()
            list():add()
        end,
        desc = "harpoon: add file",
    },
    {
        "<C-h>",
        function()
            require("harpoon").ui:toggle_quick_menu(list())
        end,
        desc = "harpoon: toggle menu",
    },
}

for n = 1, 10 do
    table.insert(keys, {
        "<leader>" .. (n % 10),
        function()
            list():select(n)
        end,
        desc = "harpoon: file " .. n,
    })
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = keys,
    config = function()
        require("harpoon"):setup({
            settings = {
                save_on_toggle = true,
            },
        })
        local ok, telescope = pcall(require, "telescope")
        if ok then
            telescope.load_extension("harpoon")
        end
    end,
}
