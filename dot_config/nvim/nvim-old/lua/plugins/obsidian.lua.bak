return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	--   "BufReadPre path/to/my-vault/**.md",
	--   "BufNewFile path/to/my-vault/**.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},

	config = function()
		local obsidian = require("obsidian")
		vim.opt_local.conceallevel = 2 -- obsidian.nvim sets explicit conceal characters, set conceallevel to 2 as per issue 286
		local opts = { noremap = true, silent = true }
		-- keymaps
		vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToggleCheckbox<CR>", opts) -- toggle/create checkbox
		-- to follow a link, click gf

		-- Define local function to search for files matching a specific pattern
		local grepafterkey = function(key)
			-- Get the directory of the current buffer
			local dirname = vim.fn.expand("%:p:h")

			-- Iterate over files in the directory
			for _, file in ipairs(vim.fn.readdir(dirname)) do
				-- Check if the file matches the key pattern
				local match = string.match(file, "^" .. key .. "%-(.+)$")
				if match then
					-- Extract match from the matched pattern
					return match
				end
			end
			-- Return nil if no matching file is found
			return nil
		end

		obsidian.setup({
			follow_url_func = function(url)
				-- Open the URL in the default web browser.
				vim.fn.jobstart({ "xdg-open", url }) -- linux
			end,

			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d-%a",
				time_format = "%H:%M",
				substitutions = {
					capitalize_title = function()
						-- Get the file name of the current buffer
						local filename = vim.fn.expand("%:t:r")
						-- Split the filename by hyphens
						local words = {}
						for word in string.gmatch(filename, "[^-]+") do
							table.insert(words, word)
						end
						-- Capitalize each word
						for i, word in ipairs(words) do
							words[i] = word:sub(1, 1):upper() .. word:sub(2):lower()
						end
						-- Combine words to form the title
						return table.concat(words, " ")
					end,
					capitalize_directory = function()
						-- Get the directory name of the current buffer
						local dirname = vim.fn.expand("%:p:h:t")
						-- Split the directory name by hyphens or spaces
						local words = {}
						for word in string.gmatch(dirname, "[^-]+") do
							table.insert(words, word)
						end
						-- Capitalize each word
						for i, word in ipairs(words) do
							words[i] = word:sub(1, 1):upper() .. word:sub(2):lower()
						end
						-- Combine words to form the title
						return table.concat(words, " ")
					end,
					directory = function()
						local dirname = vim.fn.expand("%:p:h:t")
						local words = {}
						for word in string.gmatch(dirname, "[^-]+") do
							table.insert(words, word)
						end
						return table.concat(words, " ")
					end,
					professor = grepafterkey("PROF"),
					office_hours = grepafterkey("OHRS"),
					tags = grepafterkey("TAGS"),
					weeks_since_start = function()
						-- Get the file name of the current buffer
						local filename = vim.fn.expand("%:t:r")
						-- Match the week number after 'week-'
						local week_number = string.match(filename, "^week%-(%d+)$")
						return week_number
					end,
				},
				-- A map for custom variables, the key should be the varible and the value a function
			},
			workspaces = {
				{
					name = "JesterBrain",
					path = "/home/sebvu/vaults/JesterBrain",
				},
			},
			notes_subdir = "inbox",
			new_notes_location = "notes_subdir",

			mappings = {
				["gf"] = {
					action = function()
						return obsidian.util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
			},
		})
	end,
}
