local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- install lazy.vim package manager

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- read predefined options
require("options")

-- all define all keymaps
require("keymaps")

-- load lazy w/plugins
require("lazy").setup("plugins")
