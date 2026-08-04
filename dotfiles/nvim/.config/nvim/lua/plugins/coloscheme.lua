-- Pool for optional random switching via <leader>rx (default remains vscode)
local colorschemes = {
  'vscode',
  'tokyonight',
  'github_dark_default',
  'nightfox',
  'catppuccin',
  'cyberdream',
  'rose-pine',
  'onedark',
  'kanagawa',
  'everforest',
  'gruvbox-material',
  'sonokai',
  'edge',
  'oxocarbon',
}

local function set_random_colorscheme()
  math.randomseed(os.time())
  local choice = colorschemes[math.random(#colorschemes)]
  vim.cmd.colorscheme(choice)
end

vim.keymap.set('n', '<leader>rx', set_random_colorscheme, { desc = 'Random colorscheme' })

return {
  -- Automatically switch between light and dark mode based on system settings
  { 'f-person/auto-dark-mode.nvim', opts = {} },

  -- Default theme at startup; others deferred until :colorscheme / <leader>rx
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme('vscode') end,
  },
  { 'folke/tokyonight.nvim', lazy = true, opts = { style = 'night' } },
  { 'projekt0n/github-nvim-theme', name = 'github-theme', lazy = true },
  { 'EdenEast/nightfox.nvim', lazy = true },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'scottmckendry/cyberdream.nvim', lazy = true },
  { 'rose-pine/neovim', name = 'rose-pine', lazy = true },
  { 'navarasu/onedark.nvim', lazy = true },
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'sainnhe/everforest', lazy = true },
  { 'sainnhe/gruvbox-material', lazy = true },
  { 'sainnhe/sonokai', lazy = true },
  { 'sainnhe/edge', lazy = true },
  { 'nyoom-engineering/oxocarbon.nvim', lazy = true },
}
