return {
  {
    'Tweekism/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante', 'copilot-chat', 'codecompanion' },
    },
    ft = { 'markdown', 'Avante', 'copilot-chat', 'codecompanion' },
  },
}
