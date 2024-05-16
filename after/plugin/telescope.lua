local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- vim.keymap.set('n', '<leader>ff', function()
--    builtin.grep_string({ search = vim.fn.input("Grep > ") }); 
-- end)
vim.keymap.set('n', '<leader>ff', builtin.live_grep, {})

