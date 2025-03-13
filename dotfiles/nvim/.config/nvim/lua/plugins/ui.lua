return {
  { 'nvim-tree/nvim-web-devicons' },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  { 'AndreM222/copilot-lualine' },
  { 'kshenoy/vim-signature' },
  { 'pedrohdz/vim-yaml-folds' },
  { 'arecarn/vim-clean-fold' },
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        numbers = 'buffer_id',
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      sections = {
        lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    main = 'nvim-treesitter.configs',
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        'bash',
        'dockerfile',
        'go',
        'javascript',
        'json',
        'lua',
        'markdown',
        'python',
        'toml',
        'typescript',
        'vim',
        'yaml',
      },
    },
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = 'nvim-tree/nvim-web-devicons',
    cmd = { 'NvimTreeOpen', 'NvimTreeFindFileToggle' },
    keys = {
      { '=', ':NvimTreeFindFileToggle!<CR>', 'toggle tree' },
    },
    config = function()
      require('nvim-tree').setup {
        update_focused_file = {
          enable = false,
        },
      }
      vim.api.nvim_create_autocmd('VimEnter', {
        desc = 'Open NvimTree',
        pattern = '*',
        callback = function()
          if not vim.v.std_in then
            if vim.fn.argc() == 0 and vim.filetype ~= 'man' then
              vim.cmd('NvimTreeOpen')
            elseif vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv()[1]) ~= 0 then
              vim.cmd("execute 'NvimTreeOpen' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0]")
            end
          end
        end,
      })
    end,
  },
}
