local function ufo(fn)
    return function()
        require("ufo")[fn]()
    end
end

return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    init = function()
        vim.o.foldenable = true
        vim.o.foldmethod = "manual"
        vim.o.foldlevel = 99
        vim.o.foldcolumn = "0"
    end,
    keys = {
        { "zR", ufo("openAllFolds"), desc = "open all folds" },
        { "zM", ufo("closeAllFolds"), desc = "close all folds" },
        { "zr", ufo("openFoldsExceptKinds"), desc = "open folds (except kinds)" },
        { "zm", ufo("closeFoldsWith"), desc = "close folds with" },
    },
    opts = {
        provider_selector = function()
            return { "treesitter", "indent" }
        end,
    },
}
