return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        vim.lsp.config("html", {
            filetypes = { "html", "blade" },
        })

        vim.lsp.config("intelephense", {
            filetypes = { "php", "blade" },
        })

        vim.lsp.config("zls", {
            cmd = { vim.fn.expand("~/Documents/Projects/OpenSource/zls/zig-out/bin/zls") },
        })

        vim.lsp.enable({
            "html",
            "cssls",
            "tailwindcss",
            "ts_ls",
            "intelephense",
            "gopls",
            "rust_analyzer",
            "zls",
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
            callback = function(args)
                local buf = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)

                local function map(keys, fn, desc)
                    vim.keymap.set("n", keys, fn, { buffer = buf, desc = desc })
                end

                map("gd", vim.lsp.buf.definition, "lsp: definition")
                map("gi", vim.lsp.buf.implementation, "lsp: implementation")
                map("gr", vim.lsp.buf.references, "lsp: references")
                map("gt", vim.lsp.buf.type_definition, "lsp: type definition")

                map("<leader>lr", vim.lsp.buf.rename, "lsp: rename")
                map("<leader>la", vim.lsp.buf.code_action, "lsp: code action")
                map("<leader>lh", vim.lsp.buf.hover, "lsp: hover")
                map("<leader>ls", vim.lsp.buf.signature_help, "lsp: signature help")
                map("<leader>ld", vim.diagnostic.open_float, "lsp: line diagnostics")
                map("<leader>lf", function()
                    vim.lsp.buf.format({ async = true })
                end, "lsp: format")

                map("[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, "prev diagnostic")
                map("]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, "next diagnostic")

                if client and client:supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
                end
            end,
        })
    end,
}
