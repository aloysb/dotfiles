-- Create format group
local group = vim.api.nvim_create_augroup("FormatNixWithAlejandra", { clear = true })

-- Format on save using alejandra
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.nix",
  group = group, -- attach to the group
  callback = function()
    vim.cmd("write!")
    local file = vim.fn.expand("%")
    vim.fn.system({ "alejandra", file })
    -- reload the file to show changes
    vim.cmd("edit!")
  end,
})
