return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{ "j-hui/fidget.nvim", opts = {} },

			-- Autoformatting
			"stevearc/conform.nvim",

			-- Schema information
			"b0o/SchemaStore.nvim",
		},
		config = function()
			require("neodev").setup({
				-- library = {
				--   plugins = { "nvim-dap-ui" },
				--   types = true,
				-- },
			})

			local capabilities = nil
			if pcall(require, "cmp_nvim_lsp") then
				capabilities = require("cmp_nvim_lsp").default_capabilities()
			end

			local lspconfig = require("lspconfig")

			local servers = {
				bashls = true,
				gopls = {
					settings = {
						gopls = {
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},
				lua_ls = {
					server_capabilities = {
						semanticTokensProvider = vim.NIL,
					},
				},
				rust_analyzer = true,
				svelte = true,
				templ = true,
				cssls = true,

				-- Probably want to disable formatting for this lang server
				ts_ls = {
					server_capabilities = {
						documentFormattingProvider = false,
					},
				},
				biome = true,

				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = false,
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},

				clangd = {
					-- TODO: Could include cmd, but not sure those were all relevant flags.
					--    looks like something i would have added while i was floundering
					init_options = { clangdFileStatus = true },
					filetypes = { "c", "cpp" },
				},

				eslint = true,
			}

			local servers_to_install = vim.tbl_filter(function(key)
				local t = servers[key]
				if type(t) == "table" then
					return not t.manual_install
				else
					return t
				end
			end, vim.tbl_keys(servers))

			require("mason").setup()
			local ensure_installed = {
				"stylua",
				"ts_ls",
				"lua_ls",
				"buf",
			}

			vim.list_extend(ensure_installed, servers_to_install)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end
				config = vim.tbl_deep_extend("force", {}, {
					capabilities = capabilities,
				}, config)

				lspconfig[name].setup(config)
			end

			local disable_semantic_tokens = {
				lua = true,
			}

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

					local settings = servers[client.name]
					if type(settings) ~= "table" then
						settings = {}
					end

					vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
					vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, { buffer = 0 })
					vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { buffer = 0 })
					vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { buffer = 0 })
					vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { buffer = 0 })
					vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, { buffer = 0 })
					vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, { buffer = 0 })
					vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, { buffer = 0 })
					vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = 0 })

					local filetype = vim.bo[bufnr].filetype
					if disable_semantic_tokens[filetype] then
						client.server_capabilities.semanticTokensProvider = nil
					end

					-- Override server capabilities
					if settings.server_capabilities then
						for k, v in pairs(settings.server_capabilities) do
							if v == vim.NIL then
								---@diagnostic disable-next-line: cast-local-type
								v = nil
							end

							client.server_capabilities[k] = v
						end
					end
				end,
			})

			-- Autoformatting Setup
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd", "prettier" },
					javascriptreact = { "prettierd", "prettier" },
					typescript = { "prettierd", "prettier" },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					markdown = { "prettierd", "prettier" },
					go = { "gofmt", "gofumpt", "goimports" },
					proto = { "clang-format" },
				},
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					local bufnr = args.buf
					local ft = vim.bo[bufnr].filetype

					-- Check that format on save is enabled
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end

					-- Run Conform formatting
					require("conform").format({
						bufnr = bufnr,
						lsp_fallback = true,
						quiet = true,
					})

					-- Run EslintFixAll for relevant file types
					-- if there is a .eslintrc file in the project
					if
						ft == "javascript"
						or ft == "javascriptreact"
						or ft == "typescript"
						or ft == "typescriptreact"
					then
						vim.cmd("EslintFixAll")
					end
				end,
			})
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},
}
