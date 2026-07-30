return {
  {
    'tpope/vim-fugitive',
    dependencies = {
      { 'tpope/vim-rhubarb' },
    },
    opts = {},
    config = function()
      -- Visual mode: Search Google for selected text
      vim.keymap.set('x', '<leader>sG', 'y<Esc>:GBrowse https://www.google.com/search?q=<C-R>"<CR>', { desc = 'Google selected text' })

      -- Normal mode: Open file|line|col and copy GitHub link with GBrowse
      vim.keymap.set('n', '<leader>gj', function()
        local line = vim.fn.getline('.')
        local file, lnum, col = string.match(line, '([^|]+)|(%d+)%s*col%s*(%d+)')
        if file and lnum and col then
          vim.cmd('edit ' .. file)
          vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
          vim.cmd('GBrowse!')
        else
          vim.notify('No file|line|col pattern found on this line', vim.log.levels.WARN)
        end
      end, { desc = 'Open file|line|col and copy GitHub link with GBrowse' })
    end,
  },
}
