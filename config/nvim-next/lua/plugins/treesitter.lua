local dir = (vim.env.XDG_DATA_HOME or vim.fn.expand("~/.local/share")) .. "/nvim-nix/nvim-treesitter"

return {
    dir = dir,
    name = "nvim-treesitter",
    cond = vim.uv.fs_stat(dir) ~= nil,
    lazy = false,
    config = function()
        require("nvim-treesitter").setup({})

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
            callback = function(args)
                local buf = args.buf
                local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
                if not lang or not vim.treesitter.language.add(lang) then
                    return
                end

                if vim.treesitter.query.get(lang, "highlights") then
                    vim.treesitter.start(buf, lang)
                end

                if vim.treesitter.query.get(lang, "indents") then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
