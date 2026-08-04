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

-- Shared LSP capabilities (blink + UFO folding)
local function lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  local ok, blink = pcall(require, 'blink.cmp')
  if ok then capabilities = blink.get_lsp_capabilities(capabilities) end
  return capabilities
end

return {
  -- Mouse over floating window for LSP/diagnostics
  {
    'soulis-1256/eagle.nvim',
    opts = {
      notify = {
        enabled = true,
        timeout = 3000,
        position = 'top',
        style = 'warning',
      },
    },
  },

  -- LSP: nvim-lspconfig provides vim.lsp.config defaults; mason installs/enables servers
  { 'neovim/nvim-lspconfig' },
  {
    'mason-org/mason.nvim',
    opts = {},
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'mason-org/mason.nvim',
      'neovim/nvim-lspconfig',
      'saghen/blink.cmp',
    },
    opts = {
      ensure_installed = { 'pyright', 'tflint', 'gopls', 'golangci_lint_ls', 'lua_ls', 'marksman', 'jsonls', 'yamlls' },
      automatic_enable = true,
    },
    config = function(_, opts)
      vim.lsp.config('*', { capabilities = lsp_capabilities() })
      require('mason').setup()
      require('mason-lspconfig').setup(opts)
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        'stylua',
        'gofumpt',
        'ruff',
        'prettier',
        'shfmt',
        'npm-groovy-lint',
      },
    },
  },

  -- Completion
  {
    'saghen/blink.cmp',
    branch = 'v1',
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
        go = { 'gofumpt' },
        python = { 'ruff' },
        javascript = { 'prettier' },
        groovy = { 'npm-groovy-lint' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
      },
      default_format_opts = { lsp_format = 'fallback' },
      format_on_save = { timeout_ms = 5000 },
      formatters = {
        shfmt = { prepend_args = { '-i', '2' } },
        ['npm-groovy-lint'] = { timeout_ms = 10000 },
      },
    },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  },
  {
    'retran/meow.yarn.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
    keys = {
      { '<leader>yt', function() require('meow.yarn').open_tree('type_hierarchy', 'supertypes') end, desc = 'Yarn: Type Hierarchy (Super)' },
      { '<leader>yT', function() require('meow.yarn').open_tree('type_hierarchy', 'subtypes') end, desc = 'Yarn: Type Hierarchy (Sub)' },
      { '<leader>yc', function() require('meow.yarn').open_tree('call_hierarchy', 'callers') end, desc = 'Yarn: Call Hierarchy (Callers)' },
      { '<leader>yC', function() require('meow.yarn').open_tree('call_hierarchy', 'callees') end, desc = 'Yarn: Call Hierarchy (Callees)' },
    },
  },
}
