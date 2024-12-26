local function catppuccin_theme(flavour)
	local C = require("catppuccin.palettes").get_palette(flavour)
	local O = require("catppuccin").options
	local catppuccin = {}

	local transparent_bg = O.transparent_background and "NONE" or C.mantle

	catppuccin.normal = {
		a = { bg = C.blue, fg = C.mantle, gui = "bold" },
		b = { bg = C.surface0, fg = C.blue },
		c = { bg = transparent_bg, fg = C.text },
	}

	catppuccin.insert = {
		a = { bg = C.green, fg = C.base, gui = "bold" },
		b = { bg = C.surface0, fg = C.green },
	}

	catppuccin.terminal = {
		a = { bg = C.green, fg = C.base, gui = "bold" },
		b = { bg = C.surface0, fg = C.green },
	}

	catppuccin.command = {
		a = { bg = C.peach, fg = C.base, gui = "bold" },
		b = { bg = C.surface0, fg = C.peach },
	}

	catppuccin.visual = {
		a = { bg = C.mauve, fg = C.base, gui = "bold" },
		b = { bg = C.surface0, fg = C.mauve },
	}

	catppuccin.replace = {
		a = { bg = C.red, fg = C.base, gui = "bold" },
		b = { bg = C.surface0, fg = C.red },
	}

	catppuccin.inactive = {
		a = { bg = transparent_bg, fg = C.blue },
		b = { bg = transparent_bg, fg = C.surface1, gui = "bold" },
		c = { bg = transparent_bg, fg = C.overlay0 },
	}

	return catppuccin
end

return {
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
}
