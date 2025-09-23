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
vim.opt.undodir = vim.fs.normalize('~/.vim/undo//')
vim.opt.backupdir = { vim.fs.normalize('~/.vim/swap//'), '/tmp//' }
vim.opt.directory = { vim.fs.normalize('~/.vim/swap//'), '/tmp//' }
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.virtualedit = 'block'
vim.opt.mouse = 'a'
vim.opt.mousemoveevent = true
vim.opt.scrolloff = 10
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }
vim.opt.laststatus = 2
vim.opt.winborder = 'rounded'

-- Key mappings
vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = true })
vim.api.nvim_set_keymap('c', 'bb', 'b#', { noremap = true })

-- Insert current date-time in normal mode
vim.keymap.set('n', '<leader>idn', function() vim.api.nvim_put({ os.date('%c') }, 'c', true, true) end, { silent = true, desc = '[i]nsert current [d]ate-time' })

-- Insert current date-time using commentstring
vim.keymap.set('n', '<leader>idc', function()
  local comment = vim.bo.commentstring
  if not comment or not comment:find('%%s') then comment = '# %s' end
  local text = string.format(comment, ' ' .. os.date('%c') .. ' ')
  vim.api.nvim_put({ text }, 'c', true, true)
end, { silent = true, desc = '[i]nsert current [d]ate-time as [c]omment' })

-- Add a markdown h3 with date
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('n', '<leader>idm', function()
      local title = vim.fn.input('Note title: ')
      local line = string.format('### %s (%s)', title, os.date('%c'))
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, { line })
    end, { buffer = true, silent = true, desc = '[i]nsert [d]ate-time as [m]arkdown h3' })
  end,
})

-- Open current file in vscode
vim.keymap.set('n', '<leader>v', function()
  local cmd = string.format('code %s --goto %s:%d:%d', vim.fn.getcwd(), vim.fn.expand('%'), vim.fn.line('.'), vim.fn.col('.'))
  vim.fn.system(cmd)
end, { silent = true })

-- Convert JSON to YAML with python3
vim.keymap.set('x', '<leader>ty', ":'<,'>!python3 -c 'import sys, json, yaml; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'<CR>", { silent = true, noremap = true, expr = false })

-- Convert YAML to JSON with python3
vim.keymap.set('x', '<leader>tj', ":'<,'>!python3 -c 'import sys, json, yaml;print(json.dumps(yaml.load(sys.stdin,Loader=yaml.FullLoader), indent=2,default=str))'<CR>", { silent = true, noremap = true, expr = false })

-- Highlighting
vim.api.nvim_set_hl(0, 'CopilotSuggestion', { fg = '#808080' })

-- Diagnostics signs
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
  },
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = '󰋼 ',
      [vim.diagnostic.severity.HINT] = '󰌵 ',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
})

-- Source local configuration
vim.cmd([[source ~/.vimrc.local]])
