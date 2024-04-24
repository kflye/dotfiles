return {
    'famiu/bufdelete.nvim',
    config = function()
        local bd = require("bufdelete")
        -- close buffer
        vim.keymap.set("n", "<leader>bd", bd.bufdelete, { desc = "Delete current buffer" })
        vim.keymap.set("n", "<leader>q", bd.bufdelete, { desc = "Delete current buffer" })
        vim.keymap.set("n", "<leader>Q", bd.bufwipeout, { desc = "Delete current buffer" })
    end
}
