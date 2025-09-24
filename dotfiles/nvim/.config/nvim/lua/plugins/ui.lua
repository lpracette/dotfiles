return {
  { 'nvim-tree/nvim-web-devicons' },
  { 'AndreM222/copilot-lualine' },
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
        lualine_c = {
          {
            function() return require('dap').status() end,
            icon = { '', color = { fg = '#e7c664' } }, -- nerd icon.
            cond = function()
              if not package.loaded.dap then return false end
              local session = require('dap').session()
              return session ~= nil
            end,
          },
        },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local languages = {
        'bash',
        'css',
        'dockerfile',
        'go',
        'html',
        'javascript',
        'json',
        'latex',
        'lua',
        'markdown',
        'norg',
        'python',
        'regex',
        'scss',
        'svelte',
        'toml',
        'tsx',
        'typescript',
        'typst',
        'vim',
        'vue',
        'yaml',
      }
      require 'nvim-treesitter'.install { languages }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = languages,
        callback = function()
          -- syntax highlighting, provided by Neovim
          vim.treesitter.start()
          -- indentation, provided by nvim-treesitter
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          -- -- folds, provided by Neovim, use lsp instead
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
      })
    end,
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")

        Snacks.toggle({
          name = 'Git Signs',
          get = function() return require('gitsigns.config').config.signcolumn end,
          set = function(state) require('gitsigns').toggle_signs(state) end,
        }):map('<leader>uG')
      end,
    },
  },

  -- Outline
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' } },
    opts = {},
  },

  -- Folds
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    opts = {
      provider_selector = function(_, _, _) return { 'lsp', 'indent' } end,
    },
    config = function(_, opts)
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldenable = true
      require('ufo').setup(opts)
    end,
  },
}
