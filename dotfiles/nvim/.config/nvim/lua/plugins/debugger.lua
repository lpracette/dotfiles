return {

  -- Handling of the envFile field is, apparently, VS Code-specific.
  -- nvim-dap doesn't support it by default, so this plugin provides that functionality.
  {
    'ravsii/nvim-dap-envfile',
    dependencies = { 'mfussenegger/nvim-dap' },
    opts = {}, -- This automatically sets up the listener
  },

  -- Neotest setup
  {
    'nvim-neotest/neotest',
    event = 'VeryLazy',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      { 'nvim-treesitter/nvim-treesitter', branch = 'main' },
      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-vim-test',
      {
        'nvim-neotest/neotest-python',
        dependencies = {
          {
            'mfussenegger/nvim-dap-python',
            ft = 'python',
            dependencies = { 'mfussenegger/nvim-dap' },
            config = function() require('dap-python').setup('python') end,
          },
        },
      },
      {
        'fredrikaverpil/neotest-golang',
        dependencies = {
          {
            'leoluz/nvim-dap-go',
            opts = {},
          },
        },
        branch = 'main',
      },
      {
        'nvim-neotest/neotest-jest',
        dependencies = {
          {
            'mxsdev/nvim-dap-vscode-js',
            opts = {},
          },
        },
      },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters['neotest-golang'] = {
        go_test_args = {
          '-v',
          '-race',
          '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out',
        },
      }
      opts.adapters['neotest-python'] = {
        dap = { justMyCode = false },
        runner = 'pytest',
      }
      opts.adapters['neotest-jest'] = {
        jestCommand = 'npm test --',
        jestConfigFile = 'jest.config.js',
        env = { CI = true },
        cwd = function(path) return vim.fn.getcwd() end,
      }
    end,
    config = function(_, opts)
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then config = require(config) end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'table' and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter(config)
              else
                error('Adapter ' .. name .. ' does not support setup')
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require('neotest').setup(opts)
    end,
    keys = {
      { '<leader>ta', function() require('neotest').run.attach() end, desc = '[t]est [a]ttach' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = '[t]est run [f]ile' },
      { '<leader>tA', function() require('neotest').run.run(vim.uv.cwd()) end, desc = '[t]est [A]ll files' },
      { '<leader>tS', function() require('neotest').run.run({ suite = true }) end, desc = '[t]est [S]uite' },
      { '<leader>tn', function() require('neotest').run.run() end, desc = '[t]est [n]earest' },
      { '<leader>tl', function() require('neotest').run.run_last() end, desc = '[t]est [l]ast' },
      { '<leader>ts', function() require('neotest').summary.toggle() end, desc = '[t]est [s]ummary' },
      { '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = '[t]est [o]utput' },
      { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = '[t]est [O]utput panel' },
      { '<leader>tt', function() require('neotest').run.stop() end, desc = '[t]est [t]erminate' },
      { '<leader>td', function() require('neotest').run.run({ suite = false, strategy = 'dap' }) end, desc = 'Debug nearest test' },
      { '<leader>tD', function() require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' }) end, desc = 'Debug current file' },
    },
  },

  -- DAP setup
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'toggle [d]ebug [b]reakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = '[d]ebug [B]reakpoint' },
      { '<leader>dc', function() require('dap').continue() end, desc = '[d]ebug [c]ontinue (start here)' },
      { '<leader>dC', function() require('dap').run_to_cursor() end, desc = '[d]ebug [C]ursor' },
      { '<leader>dg', function() require('dap').goto_() end, desc = '[d]ebug [g]o to line' },
      { '<leader>do', function() require('dap').step_over() end, desc = '[d]ebug step [o]ver' },
      { '<leader>dO', function() require('dap').step_out() end, desc = '[d]ebug step [O]ut' },
      { '<leader>di', function() require('dap').step_into() end, desc = '[d]ebug [i]nto' },
      { '<leader>dj', function() require('dap').down() end, desc = '[d]ebug [j]ump down' },
      { '<leader>dk', function() require('dap').up() end, desc = '[d]ebug [k]ump up' },
      { '<leader>dl', function() require('dap').run_last() end, desc = '[d]ebug [l]ast' },
      { '<leader>dp', function() require('dap').pause() end, desc = '[d]ebug [p]ause' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = '[d]ebug [r]epl' },
      { '<leader>dR', function() require('dap').clear_breakpoints() end, desc = '[d]ebug [R]emove breakpoints' },
      { '<leader>ds', function() require('dap').session() end, desc = '[d]ebug [s]ession' },
      { '<leader>dt', function() require('dap').terminate() end, desc = '[d]ebug [t]erminate' },
      { '<leader>dw', function() require('dap.ui.widgets').hover() end, desc = '[d]ebug [w]idgets' },
    },
    config = function(_, _)
      local dap = require('dap')

      -- -- Helper to find the directory containing go.mod upward from a path
      -- local function find_go_mod(start_path)
      --   if not start_path or start_path == '' then return nil end
      --   -- Expand variables like ${workspaceRoot} manually if they survived
      --   local expanded_path = start_path:gsub('%${workspaceRoot}', vim.fn.getcwd())
      --   expanded_path = start_path:gsub('%${workspaceFolder}', vim.fn.getcwd())
      --
      --   local search_dir = vim.fn.isdirectory(expanded_path) == 1 and expanded_path or vim.fs.dirname(expanded_path)
      --   local found = vim.fs.find('go.mod', { path = search_dir, upward = true })[1]
      --   return found and vim.fs.dirname(found) or nil
      -- end

      local function fix_config(config)
        local root_cwd = vim.fn.getcwd()

        -- 1. Handle VS Code variables first
        for k, v in pairs(config) do
          if type(v) == 'string' then
            v = v:gsub('%${workspaceRoot}', root_cwd)
            config[k] = v
          end
        end

        -- -- 2. Find the absolute path to the go.mod directory
        -- local program_full_path = vim.fn.fnamemodify(config.program, ':p')
        -- local mod_root = find_go_mod(program_full_path)
        --
        -- if mod_root then
        --   -- 3. Set the CWD to the folder containing go.mod
        --   config.cwd = mod_root
        --
        --   -- 4. CRITICAL: Make the program path relative to the mod_root
        --   -- Go build behaves better when the target is relative to the module root
        --   local relative_program = vim.fn.fnamemodify(program_full_path, ':.' .. mod_root)
        --
        --   -- If the path is the current dir, use "." otherwise ensure it's a relative path
        --   if relative_program == mod_root then
        --     config.program = '.'
        --   else
        --     -- Ensure it starts with ./ if it's a subfolder
        --     config.program = './' .. relative_program:gsub('^%./', '')
        --   end
        -- end

        return config
      end

      -- Intercept the launch request
      local original_run = dap.run
      dap.run = function(config, opts)
        local new_config = fix_config(vim.deepcopy(config))
        original_run(new_config, opts)
      end

      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
      vim.api.nvim_create_autocmd('filetype', {
        pattern = 'dap-float',
        callback = function() vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>close!<cr>', { noremap = true, silent = true }) end,
      })
    end,
  },

  {
    'igorlfs/nvim-dap-view',
    opts = { winbar = { controls = { enabled = true } } },
    config = function(_, opts)
      local dap = require('dap')
      local dap_view = require('dap-view')
      dap_view.setup(opts)
      dap.listeners.after.event_initialized['dap_view_open'] = function() dap_view.open({}) end
      dap.listeners.before.event_terminated['dap_view_close'] = function() dap_view.close({}) end
      dap.listeners.before.event_exited['dap_view_close'] = function() dap_view.close({}) end
    end,
  },

  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {},
  },

  {
    'andythigpen/nvim-coverage',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('coverage').setup({
        auto_reload = true,
        lang = {
          go = {
            coverage_file = vim.fn.getcwd() .. '/coverage.out',
          },
        },
      })
    end,
    keys = {
      { '<leader>cv', function() require('coverage').toggle() end, desc = 'Toggle coverage signs' },
      { '<leader>cs', function() require('coverage').summary() end, desc = 'Show coverage summary' },
    },
  },
}
