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
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewFileHistory',
      'DiffviewRefresh',
    },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview: open' },
      { '<leader>gD', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview: file history' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Diffview: repo history' },
      { '<leader>gQ', '<cmd>DiffviewClose<cr>', desc = 'Diffview: close' },
    },
    opts = {
      enhanced_diff_hl = false,
      view = {
        default = {
          disable_diagnostics = true,
          winbar_info = false,
        },
        merge_tool = {
          disable_diagnostics = true,
        },
        file_history = {
          disable_diagnostics = true,
          winbar_info = false,
        },
      },
      hooks = {
        -- Trim buffer-local work so opening a file from the panel stays snappy
        diff_buf_read = function(bufnr)
          vim.bo[bufnr].swapfile = false
          pcall(vim.diagnostic.enable, false, { bufnr = bufnr })
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            pcall(vim.lsp.buf_detach_client, bufnr, client.id)
          end
          pcall(vim.treesitter.stop, bufnr)
        end,
      },
      keymaps = {
        file_panel = {
          { 'n', 'cc', '<Cmd>Git commit <bar> wincmd J<CR>', { desc = 'Commit staged changes' } },
          { 'n', 'ca', '<Cmd>Git commit --amend <bar> wincmd J<CR>', { desc = 'Amend the last commit' } },
          { 'n', 'c<space>', ':Git commit ', { desc = 'Populate command line with :Git commit ' } },
        },
      },
    },
  },
}
