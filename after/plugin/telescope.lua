local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.git_files, {})
vim.keymap.set('n', '<C-p>', function() 
    builtin.find_files({
        hidden = false
    });
end)
vim.keymap.set('n', '<CS-f>', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") }); 
end)


