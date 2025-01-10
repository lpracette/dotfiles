return {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>s', 'y<Esc>:GBrowse https://www.google.com/search?q=<C-R>"<CR>', mode = { 'x' } },
    },
    cmd = { 'G', 'Git', 'Gbrowse' },
  },
  { 'tpope/vim-rhubarb', lazy = true },
}
