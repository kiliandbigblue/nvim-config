local builtin = require('telescope.builtin')
local vim = vim

vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fd', function()
    builtin.find_files({ search_dirs = { vim.fn.expand('%:p:h') } })
end)
vim.keymap.set('n', '<leader>ff', builtin.live_grep, {})
