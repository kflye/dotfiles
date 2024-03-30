return {
    "vim-test/vim-test",
    dependencies = {
        "preservim/vimux"
    },
    config = function() 
        -- TODO: better keymaps
        vim.keymap.set("n", "leader>t", ":TestNearest<CR>")
        vim.keymap.set("n", "leader>t", ":TestFile<CR>")
        vim.keymap.set("n", "leader>a", ":TestSuite<CR>")
        vim.keymap.set("n", "leader>l", ":TestLast<CR>")
        vim.keymap.set("n", "leader>g", ":TestVisit<CR>")

        vim.cmd("let test#strategy = 'vimux'")
    end,
}
