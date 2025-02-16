local group = vim.api.nvim_create_augroup("FormatJson", { clear = true })

-- Autoformat JSON using jq before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local file = vim.fn.expand("%")
    local output = vim.fn.system({ "jq", ".", file })
    -- If jq ran successfully, overwrite the file with the formatted output
    if vim.v.shell_error == 0 then
      vim.fn.writefile(vim.fn.split(output, "\n"), file)
    else
      print("Error formatting JSON with jq")
    end
    vim.cmd("silent edit!")
  end,
  group = group

})
