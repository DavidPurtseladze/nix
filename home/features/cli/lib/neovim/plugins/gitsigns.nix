{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.gitsigns = {
    enable = true;

    settings = {
      on_attach = ''
        function(bufnr)
          local gs = require('gitsigns')
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          map('n', ']c', gs.next_hunk, 'Next git hunk')
          map('n', '[c', gs.prev_hunk, 'Prev git hunk')
          map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
          map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
          map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
          map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame line')
          map('n', '<leader>gd', gs.diffthis, 'Diff this')
        end
      '';
    };
  };
}
