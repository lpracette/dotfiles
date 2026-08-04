return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function() vim.g.mkdp_filetypes = { 'markdown' } end,
    ft = { 'markdown', 'codecompanion' },
    keys = {
      { '<leader>pm', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown Preview Toggle', mode = 'n' },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'codecompanion' },
    },
    ft = { 'markdown', 'codecompanion' },
  },
}
