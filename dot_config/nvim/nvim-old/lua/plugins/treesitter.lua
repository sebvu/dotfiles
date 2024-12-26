return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local treesitter = require("nvim-treesitter.configs")
		treesitter.setup({
			ensure_installed = { "vim", "markdown", "bash", "regex" },
			auto_install = true, -- will ensure a parser is installed for language
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
