-- Setup lazy.nvim plugin manager
require('config.lazy')

-- Filetype settings
vim.cmd('syntax on')
vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('filetype indent on')

-- General settings
vim.opt.compatible = false
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = false
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.visualbell = true
vim.opt.encoding = 'UTF-8'
vim.opt.path:append('**')
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.wildmode = { 'longest', 'list', 'full' }
vim.opt.wildmenu = true
vim.opt.omnifunc = 'syntaxcomplete#Complete'
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.undofile = true
vim.opt.undodir = '~/.vim/undo//'
vim.opt.backupdir = { '~/.vim/swap//', '/tmp//' }
vim.opt.directory = { '~/.vim/swap//', '/tmp//' }
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.virtualedit = 'block'
vim.opt.mouse = 'a'
vim.opt.scrolloff = 5
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }
vim.opt.laststatus = 2

-- Key mappings
vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = true })
vim.api.nvim_set_keymap('c', 'bb', 'b#', { noremap = true })

-- Highlighting
vim.api.nvim_set_hl(0, 'CopilotSuggestion', { fg = '#808080' })

-- Source local configuration
vim.cmd([[source ~/.vimrc.local]])
