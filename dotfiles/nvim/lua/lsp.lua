vim.lsp.enable("tsserver")
vim.lsp.enable("nix")
vim.lsp.enable("luals")

-- local formatOnSaveAugroup = vim.api.nvim_create_augroup("FormatOnSave", {})
-- vim.api.nvim_create_autocmd('LspAttach', {
-- 	group = formatOnSaveAugroup,
-- 	callback = function(args)
-- 		print("attached")
-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
-- 		if client:supports_method('textDocument/formatting') then
-- 			-- Format the current buffer on save
-- 			vim.api.nvim_create_autocmd('BufWritePre', {
-- 				pattern = { "*", "!*.nix" }, -- nix files use alejandra, not lsp
-- 				callback = function()
-- 					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, async = false })
-- 				end,
-- 			})
-- 		end
-- 	end,
-- })
