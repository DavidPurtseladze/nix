{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "99-nvim";
      version = "2026-06-11";
      src = pkgs.fetchFromGitHub {
        owner = "ThePrimeagen";
        repo = "99";
        rev = "c17422457027c913c76c75a921fca1e623d2678e";
        hash = "sha256-iilpiG81kHIv7Y0qvPzZOanNA0lsPotlB18cvtmTy0o=";
      };

      nvimRequireCheck = "99";
    })
  ];

  programs.nixvim.extraConfigLua = ''
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
  '';

  programs.nixvim.keymaps = [
    {
      mode = "v";
      key = "<leader>9v";
      action.__raw = "function() require('99').visual() end";
      options.desc = "99: rewrite selection";
    }
    {
      mode = "n";
      key = "<leader>9s";
      action.__raw = "function() require('99').search() end";
      options.desc = "99: search into quickfix";
    }
    {
      mode = "n";
      key = "<leader>9b";
      action.__raw = "function() require('99').vibe() end";
      options.desc = "99: vibe";
    }
    {
      mode = "n";
      key = "<leader>9o";
      action.__raw = "function() require('99').open() end";
      options.desc = "99: open last result";
    }
    {
      mode = "n";
      key = "<leader>9x";
      action.__raw = "function() require('99').stop_all_requests() end";
      options.desc = "99: stop all requests";
    }
    {
      mode = "n";
      key = "<leader>9c";
      action.__raw = "function() require('99').clear_previous_requests() end";
      options.desc = "99: clear previous requests";
    }
    {
      mode = "n";
      key = "<leader>9l";
      action.__raw = "function() require('99').view_logs() end";
      options.desc = "99: view logs";
    }
    {
      mode = "n";
      key = "<leader>9w";
      action.__raw = "function() require('99').Extensions.Worker.set_work() end";
      options.desc = "99: set work item";
    }
    {
      mode = "n";
      key = "<leader>9W";
      action.__raw = "function() require('99').Extensions.Worker.search() end";
      options.desc = "99: search remaining work";
    }
  ];
}
