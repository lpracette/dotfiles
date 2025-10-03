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
    opts = {
      prompt_library = {
        ['Commit Message'] = {
          strategy = 'inline',
          description = 'Generate a commit message',
          opts = {
            short_name = 'commit_message',
            auto_submit = true,
            placement = 'replace',
          },
          prompts = {
            {
              role = 'user',
              content = function()
                local commit_message_prompt = require('plugins.codecompanion.prompts.commit_message')
                return commit_message_prompt(vim.fn.system('git diff --no-ext-diff --staged'), vim.fn.system('git log --pretty=format:"%s" -n 20'))
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ['Code Review'] = {
          strategy = 'chat',
          description = 'Perform a code review',
          opts = {
            short_name = 'code_review',
            auto_submit = true,
          },
          prompts = {
            {
              role = 'user',
              content = function()
                local code_review_prompt = require('plugins.codecompanion.prompts.code_review')
                return code_review_prompt(vim.fn.system('git diff --no-ext-diff --staged'), vim.fn.system('git diff --no-ext-diff master...'))
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ['PR description'] = {
          strategy = 'chat',
          description = 'Generate a PR description',
          opts = {
            short_name = 'pr_description',
            auto_submit = true,
          },
          prompts = {
            {
              role = 'user',
              content = function()
                local code_review_prompt = require('plugins.codecompanion.prompts.pr_description')
                -- use a regexp to extract jira key from branch name
                local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD')
                local jiraKey = string.match(branch, '%u+%-%d+')
                -- ask for jira key if not found or to confirm the extracted one
                if not jiraKey or jiraKey == '' then
                  jiraKey = vim.fn.input('Jira Key: ')
                else
                  local confirm = vim.fn.input('Jira Key (' .. jiraKey .. '): ')
                  if confirm ~= '' then jiraKey = confirm end
                end
                local jira = vim.fn.system('zsh -ic "jiraIssue ' .. jiraKey .. '"')
                return code_review_prompt(jira, vim.fn.system("git fetch --all && git diff --no-ext-diff origin/master... -- ':!*.lock' ':!*.sum' "))
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
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
      { '<leader>ca', ':CodeCompanionActions<CR>', mode = { 'v', 'n' }, desc = 'CodeCompanion: actions' },
      { '<leader>ce', ':CodeCompanion /doc<CR>', mode = 'v', desc = 'CodeCompanion: add documentation to selection' },
      { '<leader>cm', ':CodeCompanion /commit_message<CR>', desc = 'CodeCompanion: Write commit message' },
    },
    cmd = {
      'CodeCompanion',
      'CodeCompanionChat',
      'CodeCompanionActions',
      'CodeCompanionCmd',
    },
  },
}
