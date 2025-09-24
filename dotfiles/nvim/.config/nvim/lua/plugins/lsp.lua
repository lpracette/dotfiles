vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keymaps',
  callback = function(event)
    local bufnr = event.buf
    local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end
    map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', '[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
    map('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
    map('n', 'gl', function() vim.diagnostic.open_float(0, { scope = 'line' }) end, 'Line diagnostics')
    -- see https://neovim.io/doc/user/lsp.html#lsp-defaults
    -- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
    -- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
    -- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
    -- "grr" is mapped in Normal mode to vim.lsp.buf.references()
    -- "grt" is mapped in Normal mode to vim.lsp.buf.type_definition()
    -- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
    -- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()
  end,
})

return {
  -- Mouse over floating window for LSP/diagnostics
  {
    'soulis-1256/eagle.nvim',
    opts = {
      notify = {
        enabled = true,
        timeout = 3000, -- Show for 3 seconds
        position = 'top',
        style = 'warning',
      },
    },
  },

  -- LSP servers and installer
  { 'neovim/nvim-lspconfig' },
  {
    'williamboman/mason.nvim',
    dependencies = {
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'tflint', 'gopls', 'golangci_lint_ls', 'lua_ls', 'marksman', 'jsonls', 'yamlls' },
        handlers = {
          function(server_name)
            -- Set the foldingRange capability
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            }
            require('lspconfig')[server_name].setup({
              capabilities = capabilities,
            })
          end,
        },
      })
    end,
  },

  -- Completion
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      completion = {
        documentation = { auto_show = true },
        list = { selection = { preselect = true, auto_insert = false } },
        menu = { draw = { columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } } } },
      },
      keymap = { preset = 'enter', ['<Tab>'] = { 'accept', 'fallback' } },
      fuzzy = { implementation = 'lua' },
    },
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      { '<leader>f', function() require('conform').format({ async = true }) end, mode = '', desc = 'Format buffer' },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'gofmt', 'goimports' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
      default_format_opts = { lsp_format = 'fallback' },
      format_on_save = { timeout_ms = 5000 },
      formatters = { shfmt = { prepend_args = { '-i', '2' } } },
    },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
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
