return {
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    config = function() vim.cmd([[colorscheme vscode]]) end,
  },
  {
    'f-person/auto-dark-mode.nvim',
    opts = {},
  },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    opts = { style = 'night' },
  },
}
