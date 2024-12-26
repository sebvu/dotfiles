return {
	-- base plugins for my configuration (can't live without tbh)
	-- plugin list (in order)
	-- catppuccin.ncim
	-- neo-tree.nvim
    -- alpha.nvim
    -- noice.nvim

	{ --catppuccin
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				neotree = true,
				treesitter = true,
				treesitter_context = true,
				notify = true,
				noice = true,
				telescope = true,
				alpha = true,
			},
		},
		init = function()
			vim.cmd.colorscheme("catppuccin")
			-- setting colors for line numbers
			vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#6c7086", bold = false })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#f9e2af", bold = true })
			vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#6c7086", bold = false })
        end,
	},

	{ -- neotree
        -- note: using opts did not work properly, so used config req.
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
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
        end,
	},
    { -- alpha
        "goolord/alpha-nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local quotes = {
                "The only way to do great work is to love what you do. - Steve Jobs",
                "In the middle of difficulty lies opportunity. - Albert Einstein",
                "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
                "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
                "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
                "The seats are empty, the theatre is dark... why do you keep acting? - M. Gaby Cayambe Tenemaza",
                "I must change my life so I can live it, not wait for it. - M. Gaby Cayambe Tenemaza",
                "The biggest risk is not taking a risk at all - M. Gaby Cayambe Tenemaza",
            }

            local function getrandomquote()
                math.randomseed(os.time())
                return quotes[math.random(#quotes)]
            end
            -- alpha-config.lua

            local status_ok, alpha = pcall(require, "alpha")
            if not status_ok then
                return
            end

            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⣪⣭⣿⣷⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠤⢤⢔⡾⣹⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⢰⢳⣿⣿⣿⠋⣻⣿⣿⣿⣿⣿⣿⣾⣿⠟⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⢀⠔⠁⠀⠀⠀⢸⣼⣷⣻⣧⣴⣿⣏⣿⣿⣿⣿⣿⣿⣿⣶⣶⣦⠤ ]],
                [[ ⠀⠀⠀⠀⢠⠇⠀⠀⠀⠀⠀⠈⢿⣿⣷⣿⣏⡿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠁⠀ ]],
                [[ ⠀⠀⠀⢀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠹⢿⣿⣿⣿⣝⣿⣯⣾⠋⣇⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⠀⠙⣽⣝⠋⢡⣯⣀⠘⢦⡀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⡷⡁⠀⡄⠀⢠⠻⠀⠀⠀⢸⠙⠀⠀⠀⠙⡇⢹⣧⠛⠂⠀⢤⣉⠢⡀⠀⠀ ]],
                [[ ⡠⢊⠚⢇⣰⢣⠀⡞⠒⠣⠀⠀⠘⡄⠘⠓⠲⢆⣳⠀⠀⣠⣄⣀⣀⠙⢯⣾⡄⠀ ]],
                [[ ⣇⣇⡌⠈⡜⡌⢳⣧⣤⣄⡑⠄⣀⣳⢀⣠⣤⣴⣾⡆⠀⣿⠖⣠⣮⠀⠀⣿⠇⠀ ]],
                [[ ⠈⠛⢇⠀⠿⠷⡘⣿⢙⠿⡏⠀⠈⠉⢻⣻⣿⡏⢹⡟⣢⣿⣟⡻⠋⢀⡴⠁⠀⠀ ]],
                [[ ⠀⠀⠈⠢⢤⣀⣋⡿⢮⡉⠁⠀⠀⠀⠈⢉⣙⠷⠛⠺⣿⣙⣛⠭⠝⠋⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡩⠒⠶⠲⠞⠓⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣵⣕⣉⣫⣿⣦⠀⠱⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡾⡿⡟⣻⣿⡏⠱⣮⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⠀⠀⣰⢿⡛⣿⣾⣜⣾⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⢀⣴⣿⣾⣿⣿⣿⣿⣿⣿⣾⡏⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⢀⣵⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣯⣿⣿⠟⠃⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠟⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⠀⠀⠈⠻⠿⠿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
                [[ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣽⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
            }

            local function footer()
                return getrandomquote()
            end

            dashboard.section.footer.val = footer()

            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find Files", "<cmd>Telescope find_files<CR>"),
                dashboard.button("p", "⥯  Enter Previous File", "<cmd>Telescope oldfiles<CR>"),
                dashboard.button("c", "💉 Check Healh", "<cmd>checkhealth<CR>"),
                dashboard.button("q", "💔 Quit The Grind", "<cmd>qa<CR>"),
            }

            dashboard.section.footer.opts.hl = "Type"
            dashboard.section.header.opts.hl = "Include"
            dashboard.section.buttons.opts.hl = "Keyword"

            dashboard.opts.opts.noautocmd = true
            alpha.setup(dashboard.opts)
        end,
    },
    { -- noice
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            routes = {
                {
                    view = "notify",
                    filter = { event = "msg_showmode" },
                },
            },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            { "MunifTanjim/nui.nvim" },
            {
                "rcarriga/nvim-notify",
                config = function() -- added for transparency
                    require("notify").setup({
                        vim.keymap.set( -- oddly shaped keymap
                            "n",
                            "<leader>nd",
                            "<cmd>NoiceDismiss<CR>",
                            { desc = "Dismiss Noice-Notify Message" }
                        ),
                        background_colour = "#000000",
                        render = "compact",
                        routes = {
                            {
                                view = "notify",
                                filter = { event = "msg_showmode" },
                            },
                        },
                    })
                    -- avoid callbacks
                    -- local async = require("plenary.async")
                    -- local notify = require("notify").async

                    -- async.run(function()
                    -- 	notify("Let's wait for this to close").events.close()
                    -- 	notify("It closed!")
                    -- end)
                end,
            },
        },
    }
}
