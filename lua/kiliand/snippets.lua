local ls = require("luasnip")

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Alias vim.snippet to avoid conflict
local snippet = {}

snippet.expand = ls.lsp_expand

---@diagnostic disable-next-line: duplicate-set-field
snippet.active = function(filter)
	filter = filter or {}
	filter.direction = filter.direction or 1

	if filter.direction == 1 then
		return ls.expand_or_jumpable()
	else
		return ls.jumpable(filter.direction)
	end
end

---@diagnostic disable-next-line: duplicate-set-field
snippet.jump = function(direction)
	if direction == 1 then
		if ls.expandable() then
			return ls.expand_or_jump()
		else
			return ls.jumpable(1) and ls.jump(1)
		end
	else
		return ls.jumpable(-1) and ls.jump(-1)
	end
end

snippet.stop = ls.unlink_current

-- ================================================
--      My Configuration
-- ================================================
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	override_builtin = true,
})

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/kiliand/snippets/*.lua", true)) do
	loadfile(ft_path)()
end

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	return snippet.active({ direction = 1 }) and snippet.jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	return snippet.active({ direction = -1 }) and snippet.jump(-1)
end, { silent = true })

-- Export the snippet table
vim.snippet = snippet
