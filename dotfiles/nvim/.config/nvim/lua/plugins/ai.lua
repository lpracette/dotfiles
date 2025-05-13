return {
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup({
        panel = {
          keymap = {
            accept = '<C-E>',
          },
        },
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
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante', 'copilot-chat', 'codecompanion' },
    },
    ft = { 'markdown', 'Avante', 'copilot-chat', 'codecompanion' },
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {
      -- default adapter is 'copilot'
      -- display = {
      --   action_palette = {
      --     provider = 'snacks',
      --   },
      -- },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'j-hui/fidget.nvim',
    },
    init = function() require('plugins.codecompanion.fidget-spinner'):init() end,
    keys = {
      { '<leader>cc', ':CodeCompanionChat<CR>', desc = 'CodeCompanion: Chat' },
      { '<leader>cp', ':CodeCompanion<CR>', desc = 'CodeCompanion: prompt' },
      { '<leader>ca', ':CodeCompanionActions<CR>', desc = 'CodeCompanion: actions' },
      { '<leader>c:', ':CodeCompanionCmd<CR>', desc = 'CodeCompanion: cmd' },
    },
    cmd = {
      'CodeCompanion',
      'CodeCompanionChat',
      'CodeCompanionActions',
      'CodeCompanionCmd',
    },
  },
  -- {
  --   'CopilotC-Nvim/CopilotChat.nvim',
  --   dependencies = {
  --     { 'zbirenbaum/copilot.lua' },
  --     { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
  --   },
  --   build = 'make tiktoken',
  --   opts = {},
  --   keys = {
  --     { '<leader>cc', ':CopilotChatToggle<CR>', 'open chat' },
  --     { '<leader>ccd', ':CopilotChatDocs<CR>', 'open docs' },
  --     { '<leader>cct', ':CopilotChatTests<CR>', 'open tests' },
  --     { '<leader>ccr', ':CopilotChatReview<CR>', 'open review' },
  --   },
  -- },
}
