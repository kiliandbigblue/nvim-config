return {
    "theprimeagen/vim-apm",
    config = function()
        local apm = require("vim-apm")
        vim.keymap.set("n", "<leader>apm", function() apm:toggle_monitor() end)
    end,
}
