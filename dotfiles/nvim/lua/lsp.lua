vim.lsp.enable("tsserver")
vim.lsp.enable("nix")
vim.lsp.enable("luals")
vim.lsp.enable("biome")
vim.lsp.enable("pyright")
vim.lsp.enable("go")
vim.lsp.enable("astro")
vim.lsp.enable("elixir")
vim.lsp.enable("emmet")
vim.lsp.enable("shopify")


local found = vim.fn.glob("**/tailwind.config.js")
if found ~= "" then
  -- vim.lsp.config("tailwind", {
  -- settings = {
  -- experimental = {
  -- configFile = vim.loop.cwd() .. "/" .. found,
  -- }
  -- }
  -- })
  vim.lsp.enable("tailwind")
end

local onLspAttach = vim.api.nvim_create_augroup("OnLSPAttach", {})
vim.api.nvim_create_autocmd('LspAttach', {
  group = onLspAttach,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- No lsp
    if not client then return end

    if client:supports_method('textDocument/formatting') then
      local format_group = vim.api.nvim_create_augroup("LspFormatOnSave_" .. client.name, { clear = true })
      -- Format the current buffer on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = format_group,
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

    if client:supports_method('textDocument/definition') then
      vim.keymap.set({ 'n' }, "gd", vim.lsp.buf.definition, { buffer = 0 })
    end
  end,
})

local diagnostics_visible = true

function ToggleDiagnostics()
  diagnostics_visible = not diagnostics_visible
  if diagnostics_visible then
    vim.diagnostic.config({ virtual_text = true })
  else
    vim.diagnostic.config({ virtual_text = false })
  end
end

-- Enable auto sorting of tailwind classes on save
-- -- in lua/plugins/tailwind-sort.lua (or wherever you load autocmds)
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.tsx", "*.jsx", "*.html", "*.templ", "*.heex" },
  callback = function()
    local bufnr   = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "tailwindcss" })
    local client  = clients[1]    -- we only need the first

    if not client then return end -- Tailwind not attached yet

    local params = {
      command   = "_tailwindcss.sortClasses",
      arguments = { vim.uri_from_bufnr(bufnr) },
    }

    -- 0.11+ preferred API
    client:exec_cmd(params)
  end,
})
