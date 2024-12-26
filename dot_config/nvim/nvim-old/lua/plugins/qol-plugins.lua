local opts = { noremap = true, silent = true }

return {
	-- A list of small, quality of line plugins.

	-- Tagbar preview for better navigation in large codebases
	{
		"barrett-ruth/live-server.nvim",
		build = "pnpm add -g live-server",
		cmd = { "LiveServerStart", "LiveServerStop" },
		config = function()
			require("live-server").setup()
		end,
	},
	{
		"preservim/tagbar",
		config = function()
			vim.keymap.set("n", "<leader>t", "<cmd>Tagbar<CR>", opts)
		end,
	},
	-- Tmux Navigator for seamless navigation between nvim and tmux panes
	{ "christoomey/vim-tmux-navigator" },
	-- Hardtime plugin for preventing bad habits taking over, not really QOL..
	-- {
	-- 	"m4xshen/hardtime.nvim",
	-- 	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	-- 	opts = {
	-- 		disabled_filetypes = {
	-- 			"chatgpt-input",
	-- 			"chatgpt",
	-- 			"qf",
	-- 			"netrw",
	-- 			"neo-tree",
	-- 			"neo-tree-popup",
	-- 			"lazy",
	-- 			"mason",
	-- 			"oil",
	-- 			"alpha",
	-- 			"tagbar",
	-- 		},
	-- 	},
	-- },
	-- Emoji picker, easy searcher to use emojis.
	{
		"ziontee113/icon-picker.nvim",
		config = function()
			require("icon-picker").setup({ disable_legacy_commands = true })

			vim.keymap.set("n", "<Leader><Leader>i", "<cmd>IconPickerNormal<cr>", opts)
			vim.keymap.set("n", "<Leader><Leader>y", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
			-- vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
		end,
	},
	-- Highlighted yank for better visual feedback
	{ "machakann/vim-highlightedyank", lazy = false },
	-- Git signs for implementing easy git differentiation
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", opts) -- preview hunk inline
		end,
	},
	-- Adding indentation lines
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	-- Markdown Previewer
	{
		-- with yarn or npm
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	-- Image ASCII Previewer
	-- {
	-- 	"samodostal/image.nvim",
	-- 	requires = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"m00qek/baleia.nvim", -- colorize text with ansi escape sequence
	-- 	},
	-- 	config = function()
	-- 		require("image").setup({
	-- 			render = {
	-- 				min_padding = 5,
	-- 				show_label = true,
	-- 				show_image_dimensions = true,
	-- 				use_dither = true,
	-- 				foreground_color = true,
	-- 				background_color = true,
	-- 			},
	-- 			events = {
	-- 				update_on_nvim_resize = true,
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- ANSI Escape Code Dynamic Colorizer for Text
	{
		"m00qek/baleia.nvim", -- colorize text with ansi escape sequence
		version = "*",
		config = function()
			vim.g.baleia = require("baleia").setup({})

			-- Command to colorize the current buffer
			vim.api.nvim_create_user_command("BaleiaColorize", function()
				vim.g.baleia.once(vim.api.nvim_get_current_buf())
			end, { bang = true })

			-- Command to show logs
			vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })

			-- Automatically colorize when lines are added to the buffer
			vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
				pattern = "*.txt",
				callback = function()
					vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
				end,
			})
		end,
	},
	-- Colorizer for colorizing hex codes and other readable colors
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			local colorizer = require("colorizer")
			colorizer.setup({
				filetypes = { "*" },
				user_default_options = {
					RGB = true, -- #RGB hex codes
					RRGGBB = true, -- #RRGGBB hex codes
					names = false, -- "Name" codes like Blue or blue
					RRGGBBAA = false, -- #RRGGBBAA hex codes
					AARRGGBB = false, -- 0xAARRGGBB hex codes
					rgb_fn = true, -- CSS rgb() and rgba() functions
					hsl_fn = true, -- CSS hsl() and hsla() functions
					css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
					css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
					-- Available modes for `mode`: foreground, background,  virtualtext
					mode = "background", -- Set the display mode.
					-- Available methods are false / true / "normal" / "lsp" / "both"
					-- True is same as normal
					tailwind = false, -- Enable tailwind colors
					-- parsers can contain values used in |user_default_options|
					sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
					virtualtext = "■",
					-- update color values even if buffer is not focused
					-- example use: cmp_menu, cmp_docs
					always_update = false,
				},
			})
			vim.api.nvim_command("autocmd BufReadPost,BufNewFile * ColorizerAttachToBuffer")
		end,
	},
	-- ASCII Diagrams in Neovim --
	{
		"jbyuki/venn.nvim",
		config = function()
			local venn_enabled = vim.inspect(vim.b.venn_enabled)
			function Toggle_venn()
				if venn_enabled == "nil" then
					vim.b.venn_enabled = true
					vim.cmd([[setlocal ve=all]])
					-- draw a line on HJKL keystokes
					vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
					vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
					vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
					vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
					-- draw a box by pressing "f" with visual selection
					vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
					print("Venn enabled")
				else
					vim.cmd([[setlocal ve=]])
					vim.api.nvim_buf_del_keymap(0, "n", "J")
					vim.api.nvim_buf_del_keymap(0, "n", "K")
					vim.api.nvim_buf_del_keymap(0, "n", "L")
					vim.api.nvim_buf_del_keymap(0, "n", "H")
					vim.api.nvim_buf_del_keymap(0, "v", "f")
					vim.b.venn_enabled = nil
					print("Venn disabled")
				end
			end
		end,

		vim.api.nvim_set_keymap("n", "<leader>v", "<cmd>lua Toggle_venn()<CR>", { noremap = true }),
	},
	-- Discord rich presence for blazingly fast neovim presence
	{
		"vyfor/cord.nvim",
		build = "./build || .\\build",
		event = "VeryLazy",
		opts = { -- calls require('cord').setup()
			usercmds = true, -- Enable user commands
			log_level = "error", -- One of 'trace', 'debug', 'info', 'warn', 'error', 'off'
			timer = {
				interval = 1500, -- Interval between presence updates in milliseconds (min 500)
				reset_on_idle = false, -- Reset start timestamp on idle
				reset_on_change = false, -- Reset start timestamp on presence change
			},
			editor = {
				image = nil, -- Image ID or URL in case a custom client id is provided
				client = "neovim", -- vim, neovim, lunarvim, nvchad, astronvim or your application's client id
				tooltip = "The Sexiest Text Editor", -- Text to display when hovering over the editor's image
			},
			display = {
				show_time = true, -- Display start timestamp
				show_repository = true, -- Display 'View repository' button linked to repository url, if any
				show_cursor_position = true, -- Display line and column number of cursor's position
				swap_fields = false, -- If enabled, workspace is displayed first
				swap_icons = false, -- If enabled, editor is displayed on the main image
				workspace_blacklist = {}, -- List of workspace names that will hide rich presence
			},
			lsp = {
				show_problem_count = false, -- Display number of diagnostics problems
				severity = 1, -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
				scope = "workspace", -- buffer or workspace
			},
			idle = {
				enable = true, -- Enable idle status
				show_status = true, -- Display idle status, disable to hide the rich presence on idle
				timeout = 300000, -- Timeout in milliseconds after which the idle status is set, 0 to display immediately
				disable_on_focus = false, -- Do not display idle status when neovim is focused
				text = "Idle", -- Text to display when idle
				tooltip = "💤", -- Text to display when hovering over the idle image
			},
			text = {
				viewing = "Contemplating {}", -- Text to display when viewing a readonly file
				editing = "Butchering {}", -- Text to display when editing a file
				file_browser = "Browing painfully in {}", -- Text to display when browsing files (Empty string to disable)
				plugin_manager = "Managing plugins in {}", -- Text to display when managing plugins (Empty string to disable)
				lsp_manager = "Configuring LSP in {}", -- Text to display when managing LSP servers (Empty string to disable)
				vcs = "Commiting sub-optimal code in {}", -- Text to display when using Git or Git-related plugin (Empty string to disable)
				workspace = "Vimming in {}", -- Text to display when in a workspace (Empty string to disable)
			},
			buttons = {
				{
					label = "DONT VIEW MY REPOSITORY!!", -- Text displayed on the button
					url = "git", -- URL where the button leads to ('git' = automatically fetch Git repository URL)
				},
				-- {
				--   label = 'View Plugin',
				--   url = 'https://github.com/vyfor/cord.nvim',
				-- }
			},
			-- assets = nil, -- Custom file icons, see the wiki*
			assets = {
				--   lazy = {                                 -- Vim filetype or file name or file extension = table or string
				--     name = 'Lazy',                         -- Optional override for the icon name, redundant for language types
				--     icon = 'https://example.com/lazy.png', -- Rich Presence asset name or URL
				--     tooltip = 'lazy.nvim',                 -- Text to display when hovering over the icon
				--     type = 2,                              -- 0 = language, 1 = file browser, 2 = plugin manager, 3 = lsp manager, 4 = vcs; defaults to language
				--   },
				--   ['Cargo.toml'] = 'crates',
				cpp = {
					name = "cpp",
					icon = "https://ih1.redbubble.net/image.5292131909.9696/st,small,507x507-pad,600x600,f8f8f8.u4.jpg",
					tooltip = "C (with classes)",
					type = 0,
				},
				h = {
					name = "header file",
					icon = "https://ih1.redbubble.net/image.5292131909.9696/st,small,507x507-pad,600x600,f8f8f8.u4.jpg",
					tooltip = "header filesies",
					type = 0,
				},
			},
		},
	},
}
