-- 2 indentation
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"markdown",
		"c",
		"cpp",
		"java",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"css",
		"html",
		"lua",
		"make",
		"toml",
	},
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

-- color column
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "c", "cpp" },
-- 	callback = function()
-- 		vim.opt_local.colorcolumn = "80"
-- 	end,
-- })
