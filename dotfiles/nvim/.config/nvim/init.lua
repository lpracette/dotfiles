-- Setup lazy.nvim plugin manager
require('config.lazy')

-- General settings
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = false
vim.opt.visualbell = true
vim.opt.path:append('**')
vim.opt.splitright = true
vim.opt.wildmode = { 'longest', 'list', 'full' }
vim.opt.foldlevelstart = 99
vim.opt.undofile = true
-- Preserve trailing "//" so swap/undo names encode the full path (do not normalize).
-- vim.fs.normalize collapses "//" and causes collisions like init.lua.swp across repos.
local state = vim.fn.stdpath('state')
vim.fn.mkdir(state .. '/undo', 'p')
vim.fn.mkdir(state .. '/swap', 'p')
vim.fn.mkdir(state .. '/backup', 'p')
vim.opt.undodir = state .. '/undo//'
vim.opt.directory = state .. '/swap//'
vim.opt.backupdir = state .. '/backup//'
-- Don't block plugins (e.g. Diffview) with the ATTENTION swap prompt
vim.opt.shortmess:append('A')
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.virtualedit = 'block'
vim.opt.mouse = 'a'
vim.opt.mousemoveevent = true
vim.opt.scrolloff = 10
vim.opt.spelllang = { 'en_us' }
vim.opt.laststatus = 2
vim.opt.winborder = 'rounded'

-- Spell only for prose / commit messages
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'gitcommit', 'text' },
  callback = function() vim.opt_local.spell = true end,
})

-- Brief highlight after yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})


-- Load cfilter plugin for enhanced quickfix filtering
vim.cmd('packadd cfilter')

-- interactive shell was -ic; -i sources full .zshrc (~seconds) on every :! / filter
vim.opt.shell = 'zsh'
vim.opt.shellcmdflag = '-c'

-- Key mappings
vim.keymap.set('i', 'jk', '<esc>', { noremap = true })
vim.keymap.set('c', 'bb', 'b#', { noremap = true })

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
vim.keymap.set('x', '<leader>ty', ":'<,'>!python3 -c 'import sys, json, yaml; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'<CR>", { silent = true, noremap = true })

-- Convert YAML to JSON with python3
vim.keymap.set('x', '<leader>tj', ":'<,'>!python3 -c 'import sys, json, yaml;print(json.dumps(yaml.load(sys.stdin,Loader=yaml.FullLoader), indent=2,default=str))'<CR>", { silent = true, noremap = true })

-- Smart gF: jump to file|line col or fallback to normal gF
vim.keymap.set('n', 'gF', function()
  local line = vim.fn.getline('.')
  local file, lnum, col = string.match(line, '([^|]+)|(%d+)%s*col%s*(%d+)')
  if file and lnum and col then
    vim.cmd('edit ' .. file)
    vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
  else
    vim.cmd('normal! gF')
  end
end, { desc = 'Smart gF: jump to file|line|col or fallback' })

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

local function gh_code_search(opts)
  local fargs = opts.fargs
  local query = fargs[1]
  if not query or query == '' then
    vim.notify('Usage: :GHSearch <query> [extension]', vim.log.levels.WARN)
    return
  end

  local extension = fargs[2]
  if not extension or extension == '' then
    local ft_to_ext = {
      javascript = 'js',
      typescript = 'ts',
      typescriptreact = 'tsx',
      javascriptreact = 'jsx',
      python = 'py',
      markdown = 'md',
      make = 'Makefile',
    }
    local ft = vim.bo.filetype
    extension = ft_to_ext[ft] or (ft ~= '' and ft or 'go')
  end

  local cmd = string.format(
    'gh search code %q --extension %s --json path,textMatches | jq -r \'.[] | .path as $p | .textMatches[] | "\\($p):1: \\(.fragment | gsub("\\n"; " ") | gsub("\\r"; " ") )"\'',
    query,
    extension
  )

  print(string.format('Searching GitHub (ext=%s)...', extension))

  local output = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 or #output == 0 then
    print('No results found or error executing gh.')
    return
  end

  vim.fn.setqflist({}, 'r', {
    title = string.format('GH Search [%s]: %s', extension, query),
    lines = output,
  })

  vim.cmd('copen')
end

vim.api.nvim_create_user_command('GHSearch', gh_code_search, {
  nargs = '+',
  desc = 'Search GitHub code (uses buffer filetype extension; optional 2nd arg overrides)',
})

-- Source local configuration
vim.cmd([[source ~/.vimrc.local]])
