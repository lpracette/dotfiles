return {
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    config = function() vim.cmd([[colorscheme vscode]]) end,
  },
  {
    'olimorris/onedarkpro.nvim',
    priority = 1000, -- Ensure it loads first
  },
  {
    'f-person/auto-dark-mode.nvim',
    opts = {},
  },
}
