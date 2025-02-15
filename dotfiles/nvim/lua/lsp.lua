vim.lsp.enable("tsserver")
vim.lsp.enable("nix")
vim.lsp.enable("luals")
vim.lsp.enable("biome")

local onLspAttach = vim.api.nvim_create_augroup("OnLSPAttach", {})
vim.api.nvim_create_autocmd('LspAttach', {
  group = onLspAttach,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/formatting') then
      -- Format the current buffer on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { "*", "!*.nix" },
        callback = function(bufWriteArgs)
          -- Use bufWriteArgs.buf instead of args.buf
          vim.lsp.buf.format({
            bufnr = bufWriteArgs.buf,
            id = client.id,
            async = false
          })
        end,
      })
    end

    if client:supports_method('textDocument/definiton') then
      vim.keymap.set({ 'n' }, "gd", vim.lsp.buf.definition, { buffer = 0 })
    end
  end,
})
