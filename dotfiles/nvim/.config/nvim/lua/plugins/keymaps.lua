return {
  { 'vim-utils/vim-husk' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-abolish' },
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      local splits = require('smart-splits')

      splits.setup({
        -- The 'at_edge' hook triggers when you try to move out of a Vim split
        -- but are already at the border.
        at_edge = function(ctx)
          local direction = ctx.direction

          -- 1. Configuration: Map directions to Tmux variables and Flags
          local tmux_config = {
            left = { var = 'pane_at_left', flag = '-L' },
            down = { var = 'pane_at_bottom', flag = '-D' },
            up = { var = 'pane_at_top', flag = '-U' },
            right = { var = 'pane_at_right', flag = '-R' },
          }

          local config = tmux_config[direction]
          if not config then return end

          -- 2. Check: Are we at the edge of the Tmux window?
          -- We use vim.fn.system to query Tmux directly.
          -- The result usually contains a newline (e.g., "1\n"), so we strip it or check substring.
          local result = vim.fn.system('tmux display-message -p "#{' .. config.var .. '}"')

          -- 3. Decision Logic
          if result:find('1') then
            -- CASE A: Double Edge (Vim Edge + Tmux Edge) -> Switch AeroSpace Window
            vim.fn.system('aerospace focus --boundaries all-monitors-outer-frame ' .. direction)
          else
            -- CASE B: Vim Edge only -> Switch Tmux Pane manually
            vim.fn.system('tmux select-pane ' .. config.flag)
          end
        end,
      })

      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<M-h>` will `resize_left` by `(10 * config.default_amount)`
      vim.keymap.set('n', '<M-h>', splits.resize_left)
      vim.keymap.set('n', '<M-j>', splits.resize_down)
      vim.keymap.set('n', '<M-k>', splits.resize_up)
      vim.keymap.set('n', '<M-l>', splits.resize_right)
      -- moving between splits
      vim.keymap.set('n', '<C-h>', splits.move_cursor_left)
      vim.keymap.set('n', '<C-j>', splits.move_cursor_down)
      vim.keymap.set('n', '<C-k>', splits.move_cursor_up)
      vim.keymap.set('n', '<C-l>', splits.move_cursor_right)
      vim.keymap.set('n', '<C-\\>', splits.move_cursor_previous)
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        '<leader>?',
        function() require('which-key').show({ global = false }) end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },
}
