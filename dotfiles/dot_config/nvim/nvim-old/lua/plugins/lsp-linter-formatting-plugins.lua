-- ❗CONFIGURATION GUIDE FOR THIS SPECIFIC CONFIGURATION❗
--
-- 🚀 mason-tool-installer.nvim: automatically install any mason.nvim LSPs not already installed
--      - add all new MASON packages there (ALL LSPs, LINTERS AND FORMATTERS by their MASONLSP name, not actual LSP name)
-- 🍹 mason-lspconfig: add any newly installed LSPs
-- for lsp languge servers, refer to the github: https://github.com/williamboman/mason-lspconfig.nvim
--      - in ensure_installed (add the name of the actual LSP name)
--      - in lspconfig.language.setup({})
-- 💬 nvim-lint: add new linter
--      - linter_by_ft language = { linter } | { { languagem language } } (will choose one or another)
-- 📚 conform-nvim: add new formatter
--      - formatter_by_ft language = { formatter } | { { language, language } } (choose one or another)
--
-- ❗CONFIGURATION GUIDE FOR THIS SPECIFIC CONFIGURATION❗

return {
	{ -- portable package manager for installing LSPs, DAPs, linters and formatters.
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		-- automatically install linters and formatters whenever neovim is up
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- ADD NEW MASON PACKAGE HERE (MASON NAME)
					"actionlint",
					"bash-language-server",
					"black",
					"clang-format",
					"clangd",
					"cpplint",
					"eslint_d",
					"isort",
					"lua-language-server",
					"markdownlint",
					"marksman",
					"prettier",
					"prettierd",
					"pyright",
					"ruff",
					"shellcheck",
					"stylua",
					"typescript-language-server",
					"yaml-language-server",
					"markuplint",
					"stylelint",
					"html-lsp",
					"css-lsp",
				},
			})
		end,
	},
	{ -- extension for mason.nvim that makes it easier to use lsp configs with mason.nvim
		"williamboman/mason-lspconfig.nvim",
		-- for lsp languge servers, refer to the github: https://github.com/williamboman/mason-lspconfig.nvim
		dependencies = { "williamboman/mason.nvim" }, -- require dependencies to be loaded before mason-lspconfig is loaded
		config = function()
			require("mason-lspconfig").setup({
				-- ADD NEW LSP HERE (GITHUB NAME)
				ensure_installed = {
					"lua_ls", -- lua
					"clangd", -- cpp
					"bashls", -- bash
					"marksman", -- markdown
					"ts_ls", -- js/ts
					"pyright", -- python
					"yamlls", -- yaml
					"html", -- html
					"cssls", -- css
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local signs = { Error = " ", Warn = " ", Hint = "", Info = "" }

			-- set signs for lsp diagnostics
			for type, icon in pairs(signs) do
				local hl = "LspDiagnosticsSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			local on_attach = function()
				vim.keymap.set("n", "<leader>gd", "<cmd>Lspsaga goto_definition<CR>", {}) -- go to finition
				vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", {}) -- see available code actions
				vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", {}) -- show documentation for what is under cursor
				vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", {}) -- smart rename
			end
			-- lspconfig.languageserver.setup({})
			-- :LspInfo to check lsps connected to current buffer
			lspconfig.lua_ls.setup({ -- lua language server
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.clangd.setup({ -- C/C++ language server
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = {
					"clangd",
					"--offset-encoding=utf-16",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
			})
			lspconfig.bashls.setup({ -- bash language server
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.marksman.setup({ -- markdown language server
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.ts_ls.setup({ -- javascript language server
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.pyright.setup({ -- python language server
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.yamlls.setup({ -- gitlab ci language server
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.cssls.setup({ -- css
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.html.setup({ -- html
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
	},

	-- linting w/nvim-lint
	{
		"mfussenegger/nvim-lint",
		dependencies = { "williamboman/mason.nvim" },
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			-- ADD NEW LINTER HERE
			local lint = require("lint")
			local eslint = lint.linters.eslint_d
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			lint.linters_by_ft = {
				-- javascript = { "eslint_d" },
				-- typescript = { "eslint_d" },
				-- javascriptreact = { "eslint_d" },
				-- typescriptreact = { "eslint_d" },
				-- svelte = { "eslint_d" },
				python = { "ruff" },
				-- cpp = { "cpplint" },
				bash = { "shellcheck" },
				-- html = { "markuplint" }, (not needed as it conflicts with prettierd)
				-- css = { "stylelint" }, (not needed as it conflicts with prettierd)
				-- markdown = { "markdownlint" },
			}

			-- get rid of .eslintrc creation dependency
			eslint.args = {
				"--no-warn-ignored", -- <-- this is the key argument
				"--format",
				"json",
				"--stdin",
				"--stdin-filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
				-- :h events to list all available events
			})

			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Lint the current buffer" })
		end,
	},
	-- formatting with conform
	{
		"stevearc/conform.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("conform").setup({
				stop_after_first = true,
				formatters_by_ft = {
					-- ADD NEW FORMATTER HERE
					cpp = { "clang-format" },
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- Use a sub-list to run only the first available formatter
					javascript = { { "prettierd", "prettier" } },
					typescript = { { "prettierd", "prettier" } },
					javascriptreact = { { "prettierd", "prettier" } },
					typescriptreact = { { "prettierd", "prettier" } },
					yaml = { "prettierd" },
					json = { "prettierd" },
					html = { "prettierd" },
					css = { "prettierd" },
					svelte = { "prettierd" },
					markdown = { "prettierd" },
					graphql = { "prettierd" },
					ruby = { "rubocop" },
					bash = { "shellcheck" },
				},
				format_on_save = {
					lsp_fallback = true, -- if formatter isn't available, fall back to formatting through lsp
					async = false, -- run formatter in async mode
					timeout_ms = 500, -- timeout for formatter
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>gf", function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
		opts = {},
	},
}
