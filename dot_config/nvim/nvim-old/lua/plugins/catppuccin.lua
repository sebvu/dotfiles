return {
	-- catppuccin colorscheme
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			-- all integrated plugins to catppuccin theme
			integrations = {
				cmp = true,
				gitsigns = true,
				neotree = true,
				treesitter = true,
				treesitter_context = true,
				notify = true,
				noice = true,
				-- mason = true,
				telescope = true,
				alpha = true,
			},
		})
		vim.cmd.colorscheme("catppuccin-mocha")

		-- setting colors for line
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#6c7086", bold = false })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#f9e2af", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#6c7086", bold = false })
	end,
}
