return {
  {
    'Tweekism/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
  },
  -- {
  --   'Tweekism/markdown-preview.nvim',
  --   cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  --   build = 'cd app && npm install',
  --   init = function() vim.g.mkdp_filetypes = { 'markdown' } end,
  --   ft = { 'markdown' },
  --   keys = {
  --     { '<leader>pd', ':MarkdownPreviewToggle<CR>', 'toggle markdown preview' },
  --   },
  -- },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante', 'copilot-chat', 'codecompanion' },
    },
    ft = { 'markdown', 'Avante', 'copilot-chat', 'codecompanion' },
  },
}
