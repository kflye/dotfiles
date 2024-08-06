-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "x", "\"_x")

if (vim.fn.has("win32")) then
    vim.keymap.set({ "n", "i", "v", "s", "x", "c", "o" }, "<C-z>", "<nop>")
end

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set("n", "<leader>1", ":diffget LOCAL<CR>", { desc = "Merge - Pick LOCAL" })
vim.keymap.set("n", "<leader>2", ":diffget BASE<CR>", { desc = "Merge - Pick BASE" })
vim.keymap.set("n", "<leader>3", ":diffget REMOTE<CR>", { desc = "Merge - Pick REMOTE" })