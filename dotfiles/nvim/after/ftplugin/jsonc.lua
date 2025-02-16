local group = vim.api.nvim_create_augroup("FormatJson", { clear = true })

-- Autoformat JSON using jq before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format()
  end,
  group = group

})
