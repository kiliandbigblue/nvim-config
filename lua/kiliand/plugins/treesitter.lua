return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/nvim-treesitter-context",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({ -- enable syntax highlighting
			highlight = {
				enable = true,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"bash",
				"css",
				"gitignore",
				"go",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"proto",
				"query",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			--            incremental_selection = {
			--                enable = true,
			--                keymaps = {
			--                    init_selection = "<C-space>",
			--                    node_incremental = "<C-space>",
			--                    scope_incremental = false,
			--                    node_decremental = "<bs>",
			--                },
			--            },
		})
	end,
}
