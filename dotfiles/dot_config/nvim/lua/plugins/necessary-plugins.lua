-- set of necessary plugins provided
-- treesitter
-- telescope
-- lualine
-- honestly seperate from base-plugins for cleaner tree

return {
	{ -- treesitter

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
	},
	{ -- telescope

		{
			-- Find, Filter, Preview, Pick. All lua, all the time.
			"nvim-telescope/telescope.nvim",
			tag = "0.1.6",
			dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep", "sharkdp/fd" },
			config = function()
				require("telescope").setup({
					defaults = {
						file_ignore_patterns = { "node_modules", ".git", "lazy%-lock.json", "pack" },
						mappings = {
							i = {
								["<C-j>"] = "move_selection_next",
								["<C-k>"] = "move_selection_previous",
							},
						},
					},

					pickers = {
						find_files = {
							theme = "dropdown",
							previewer = true,
							hidden = true,
						},
						live_grep = {
							theme = "dropdown",
							previewer = true,
						},
						buffers = {
							theme = "dropdown",
							previewer = true,
						},
					},
				})
			end,
			keys = {
				vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", {}),
				vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {}),
				vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {}),
				vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", {}),
				vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {}),
				vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {}),
			},
		},
		{
			-- makes lists show up as a cool ui
			"nvim-telescope/telescope-ui-select.nvim",
			config = function()
				require("telescope").setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown({}),
						},
					},
				})
				-- To get ui-select loaded and working with telescope, you need to call
				-- load_extension, somewhere after setup function:
				require("telescope").load_extension("ui-select")
			end,
		},
	},
	{ -- lualine

		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- local flavour = "mocha"
			-- local theme = catppuccin_theme(flavour)
			-- local theme = require("lualine.themes.nightfly")
			-- theme.normal.c.bg = nil -- removes the lualine background layer

			require("lualine").setup({
				options = {
					theme = "nord",
					globalstatus = true,
				},

				sections = {
					lualine_a = { "mode" },
					lualine_b = { "buffers" },
					lualine_x = {
						"encoding",
						"fileformat",
						"filetype",
						{
							require("noice").api.statusline.mode.get,
							cond = require("noice").api.statusline.mode.has,
							color = { fg = "#967bb6" },
						},
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
