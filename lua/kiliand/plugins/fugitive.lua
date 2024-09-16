return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gg", "<cmd>Git<cr>", { desc = "Git status" })
		vim.keymap.set("n", "<leader><leader>j", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "<leader><leader>f", "<cmd>diffget //3<CR>")
	end,
}
