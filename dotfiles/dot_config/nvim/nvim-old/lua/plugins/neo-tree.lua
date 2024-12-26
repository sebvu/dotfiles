local config = function()
	vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=None]])
	vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
	vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" })
	vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" })

	local opts = { noremap = true, silent = true }

	vim.keymap.set("n", "<leader>e", "<cmd>Neotree<CR>", opts) -- open tree
	vim.keymap.set("n", "<leader>q", "<cmd>Neotree close<CR>", opts) -- close tree

	require("neo-tree").setup({
		window = {
			mappings = {
				["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
				["l"] = "focus_preview",
				["<C-b>"] = { "scroll_preview", config = { direction = 10 } },
				["<C-f>"] = { "scroll_preview", config = { direction = -10 } },
			},
			position = "right",
		},
		filesystem = {
			filtered_items = {
				visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
				hide_dotfiles = false,
				hide_gitignored = true,
			},
		},
	})
end

return {
	-- plugin to manage the file system and other tree like structures
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	config = config,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
}
