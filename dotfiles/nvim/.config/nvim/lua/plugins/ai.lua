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
                return string.format(
                  [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

` ` `diff
%s
` ` `

When unsure about the module names to use in the commit message, you can refer to the last 20 commit messages in this repository:

` ` `
%s
` ` `

Output only the commit message without any explanations and follow-up suggestions.
]],
                  vim.fn.system('git diff --no-ext-diff --staged'),
                  vim.fn.system('git log --pretty=format:"%s" -n 20')
                )
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
                return string.format(
                  [[You are an expert software engineer and code reviewer. You will be provided with a change set (diff/patch or a set of modified/new/deleted files) from a software project. Your task is to perform a thorough code review of the provided changes.

Please follow these steps in your review:

    1. Code Quality & Style
        - Check if the code adheres to the project's established style and naming conventions.
        - Identify inconsistent formatting, naming, or organization.
        - Point out any complex, unclear, or redundant code.

    2. Correctness & Logic
        - Assess if the changes are logically correct and fulfill the intended feature, fix, or improvement as described.
        - Look for logical errors, edge cases, or misused APIs.

    3.Security Considerations
        - Identify any potential security vulnerabilities, such as injection risks, insecure data handling, or credential exposure.
        - Point out areas where input validation or sanitization is lacking.

    4. Maintainability & Readability
        - Evaluate whether the code is easy to understand and maintain.
        - Suggest improvements for function/method/class size, modularity, and documentation.

    5. Performance
        - Highlight any changes that may introduce performance degradation or inefficiencies (e.g., nested loops, expensive operations in tight loops).

    6. Testing & Validation
        - Check if appropriate tests have been added or updated.
        - Identify insufficient test coverage or missing edge case tests.

    7. Documentation
        - Make sure public APIs, functions, or modules are properly documented and inline comments are clear.

    8. Alignment with Project Requirements
        - Confirm that the changes align with the scope and requirements specified in the issue/ticket or pull request description.


Response Format:

For each of the above areas, provide specific comments, recommendations, or approve if everything is satisfactory. Refer to exact line numbers or code snippets when possible. If you find a critical issue, flag it clearly and suggest a remediation.

Example Response Structure:

1. Code Quality & Style:
    - Line 42: Variable name tmp is unclear; consider renaming for clarity.

2. Correctness & Logic:
    - Line 56: Potential off-by-one error in the loop.

3. Security Considerations:
    - No issues found.

4. Maintainability & Readability:
    - Suggest splitting the function on lines 80–110 into smaller units.

(...continue as above...)

Change Set for Review:
` ` `diff
%s
%s
` ` `

Wait for the entire change set before responding. If some context appears missing, note this and request clarification.
Use the @file tool to contextualize your response with the full file and its contents.
]],
                  vim.fn.system('git diff --no-ext-diff --staged'),
                  vim.fn.system('git diff --no-ext-diff master...')
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
      -- extensions = {
      --   mcphub = {
      --     callback = 'mcphub.extensions.codecompanion',
      --     opts = {
      --       show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
      --       make_vars = true, -- make chat #variables from MCP server resources
      --       make_slash_commands = true, -- make /slash_commands from MCP server prompts
      --     },
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
      { '<leader>ca', ':CodeCompanionActions<CR>', mode = { 'v', 'n' }, desc = 'CodeCompanion: actions' },
      { '<leader>c:', ':CodeCompanionCmd<CR>', desc = 'CodeCompanion: cmd' },
      { '<leader>ce', ':CodeCompanion /doc<CR>', mode = 'v', desc = 'CodeCompanion: Explain selection' },
      { '<leader>cm', ':CodeCompanion /commit_message<CR>', desc = 'CodeCompanion: Write commit message' },
    },
    cmd = {
      'CodeCompanion',
      'CodeCompanionChat',
      'CodeCompanionActions',
      'CodeCompanionCmd',
    },
  },
  -- {
  --   'ravitemer/mcphub.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim', -- Required for Job and HTTP requests
  --   },
  --   -- uncomment the following line to load hub lazily
  --   --cmd = "MCPHub",  -- lazy load
  --   build = 'npm install -g mcp-hub@latest', -- Installs required mcp-hub npm module
  --   -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
  --   -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
  --   config = function() require('mcphub').setup() end,
  -- },
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
