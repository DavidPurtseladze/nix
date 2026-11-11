local function ai(path)
    return function()
        local target = require("99")
        for part in path:gmatch("[^.]+") do
            target = target[part]
        end
        target()
    end
end

return {
    "ThePrimeagen/99",
    commit = "c17422457027c913c76c75a921fca1e623d2678e",
    dependencies = { "hrsh7th/nvim-cmp" },
    keys = {
        { "<A-v>", ai("visual"), mode = "v", desc = "ai: rewrite selection" },
        { "<A-s>", ai("search"), desc = "ai: search into quickfix" },
        { "<A-b>", ai("vibe"), desc = "ai: vibe" },
        { "<A-o>", ai("open"), desc = "ai: open last result" },
        { "<A-x>", ai("stop_all_requests"), desc = "ai: stop all requests" },
        { "<A-d>", ai("clear_previous_requests"), desc = "ai: clear previous requests" },
        { "<A-l>", ai("view_logs"), desc = "ai: view logs" },
        { "<A-m>", ai("Extensions.Worker.set_work"), desc = "ai: set work item" },
        { "<A-M>", ai("Extensions.Worker.search"), desc = "ai: search remaining work" },
    },
    config = function()
        local _99 = require("99")

        _99.setup({
            provider = _99.Providers.ClaudeCodeProvider,
            model = "claude-opus-5",
            display_errors = true,
            auto_add_skills = true,
            logger = {
                level = _99.WARN,
                path = vim.fn.stdpath("cache") .. "/99.log",
                print_on_error = true,
            },
            md_files = {
                "AGENTS.md",
                "CLAUDE.md",
            },
            completion = {
                source = "cmp",
            },
        })
    end,
}
