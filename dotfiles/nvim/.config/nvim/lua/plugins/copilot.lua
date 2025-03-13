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
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken',
    opts = {},
    keys = {
      { '<leader>cc', ':CopilotChatToggle<CR>', 'open chat' },
      { '<leader>ccd', ':CopilotChatDocs<CR>', 'open docs' },
      { '<leader>cct', ':CopilotChatTests<CR>', 'open tests' },
      { '<leader>ccr', ':CopilotChatReview<CR>', 'open review' },
    },
  },
}
