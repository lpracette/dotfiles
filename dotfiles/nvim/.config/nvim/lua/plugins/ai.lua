return {
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = '<C-E>',
          },
        },
        filetypes = {
          markdown = true,
          yaml = true,
        },
      })
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'lalitmee/codecompanion-spinners.nvim',
      'nvim-lualine/lualine.nvim',
    },
    opts = {
      opts = {
        log_level = 'INFO',
      },
      extensions = {
        spinner = {
          opts = {
            style = 'snacks',
          },
        },
      },
    },
    keys = {
      { '<leader>cc', ':CodeCompanionChat<CR>', desc = 'CodeCompanion: Chat' },
      { '<leader>cp', ':CodeCompanion<CR>', desc = 'CodeCompanion: prompt' },
      { '<leader>ca', ':CodeCompanionActions<CR>', mode = { 'v', 'n' }, desc = 'CodeCompanion: actions' },
      { '<leader>ce', ':CodeCompanion /doc<CR>', mode = 'v', desc = 'CodeCompanion: add documentation to selection' },
    },
    cmd = {
      'CodeCompanion',
      'CodeCompanionChat',
      'CodeCompanionActions',
      'CodeCompanionCmd',
    },
  },
}
