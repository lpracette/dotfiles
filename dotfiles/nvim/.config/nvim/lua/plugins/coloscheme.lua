-- Randomly select and set a colorscheme
local colorschemes = {
  'vscode',
  -- 'tokyonight',
  -- 'github_dark_default', -- for github-theme, adjust if you use a different variant
  -- 'nightfox',
  -- 'catppuccin',
  -- 'cyberdream',
  -- 'rose-pine',
  -- 'onedark',
  -- 'kanagawa',
  -- 'everforest',
  -- 'gruvbox-material',
  -- 'sonokai',
  -- 'edge',
  -- 'oxocarbon',
}

local function set_random_colorscheme()
  math.randomseed(os.time())
  local choice = colorschemes[math.random(#colorschemes)]
  vim.cmd.colorscheme(choice)
  vim.notify('Colorscheme set to: ' .. choice, vim.log.levels.INFO)
end

-- Uncomment the next line to set a random colorscheme on startup
vim.api.nvim_create_autocmd('VimEnter', {
  callback = set_random_colorscheme,
})

-- Add key binding <leader>rx to change colorscheme randomly
vim.keymap.set('n', '<leader>rx', set_random_colorscheme, { desc = 'Random colorscheme' })

return {
  -- Automalically switch between light and dark mode based on system settings
  { 'f-person/auto-dark-mode.nvim', opts = {} },

  -- colorschemes
  { 'Mofiqul/vscode.nvim', lazy = false },
  { 'folke/tokyonight.nvim', lazy = true, opts = { style = 'night' } },
  { 'projekt0n/github-nvim-theme', name = 'github-theme' },
  { 'EdenEast/nightfox.nvim' },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'scottmckendry/cyberdream.nvim', lazy = false, priority = 1000 },
  { 'rose-pine/neovim', name = 'rose-pine', priority = 1000 },
  { 'navarasu/onedark.nvim', priority = 1000 },
  { 'rebelot/kanagawa.nvim', priority = 1000 },
  { 'sainnhe/everforest', priority = 1000 },
  { 'sainnhe/gruvbox-material', priority = 1000 },
  { 'sainnhe/sonokai', priority = 1000 },
  { 'sainnhe/edge', priority = 1000 },
  { 'nyoom-engineering/oxocarbon.nvim', priority = 1000 },
}
