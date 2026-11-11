local php_cs_fixer_default = vim.fn.stdpath("config") .. "/php-cs-fixer.default.php"

local function format()
    require("conform").format({ async = true, lsp_format = "fallback" })
end

return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
        { "<leader>lf", format, mode = { "n", "v" }, desc = "format buffer" },
    },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },

            html = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            blade = { "prettier-html" },
            php = { "php_cs_fixer" },

            rust = { "rustfmt" },
        },

        formatters = {
            ["prettier-html"] = {
                command = "prettier",
                args = { "--parser", "html", "--stdin-filepath", "$FILENAME" },
            },

            rustfmt = {
                command = function(_, ctx)
                    local toolchain = vim.fs.find("rust-toolchain.toml", { path = ctx.dirname, upward = true })[1]
                    if toolchain and vim.fn.executable("rustfmt-nightly") == 1 then
                        local pinned = table.concat(vim.fn.readfile(toolchain), "\n")
                        if pinned:match('channel%s*=%s*"nightly') then
                            return "rustfmt-nightly"
                        end
                    end
                    return "rustfmt"
                end,
            },

            php_cs_fixer = {
                args = function(_, ctx)
                    local has_config = vim.fs.find(
                        { ".php-cs-fixer.php", ".php-cs-fixer.dist.php", ".php_cs", ".php_cs.dist" },
                        { path = ctx.dirname, upward = true }
                    )[1]
                    if has_config then
                        return { "fix", "$FILENAME" }
                    end
                    return { "fix", "$FILENAME", "--config=" .. php_cs_fixer_default }
                end,
            },
        },

        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    },
}
