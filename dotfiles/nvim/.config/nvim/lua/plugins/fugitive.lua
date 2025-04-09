return {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>sG', 'y<Esc>:GBrowse https://www.google.com/search?q=<C-R>"<CR>', mode = { 'x' } },
    },
    cmd = { 'G', 'Git', 'GBrowse' },
  },
  { 'tpope/vim-rhubarb', cmd = { 'GGrowse' } },
}
