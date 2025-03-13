return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {},
  keys = {
    { '<leader>e', ':FzfLua files<CR>', 'search files' },
    { '<leader>b', ':FzfLua buffers<CR>', 'search buffers' },
    { '<leader>z', ':FzfLua spell_suggest<CR>', 'search spell suggestions' },
    { '<leader>g', ':FzfLua live_grep<CR>', 'search grep' },
    { '<leader>h', ':FzfLua help_tags<CR>', 'search help tags' },
    { '<leader>q', ':FzfLua quickfix<CR>', 'search quickfix' },
    { '<leader>/', ':FzfLua search_history<CR>', 'search search history' },
    { '<leader>.', ':FzfLua marks<CR>', 'search marks' },
    { '<leader>:', ':FzfLua command_history<CR>', 'search command history' },
  },
  cmd = { 'FzfLua' },
}
