return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>g", "<cmd>Git<cr>", { desc = "Git status" })
	end,
}
