vim.keymap.set("x", "<leader>p", "\"_dP")

-- https://www.youtube.com/watch?v=vdn_pKJUda8 - keymaps for slip s(v|h|e|x) tabs t(o|x|n|p)
vim.keymap.set("n", "x", "_x")

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "0", "g^")


if (vim.fn.has("win32")) then
    vim.keymap.set({"n", "i", "v", "s", "x", "c", "o"}, "<C-z>", "<nop>")
end

vim.keymap.set({"n", "i"}, "<up>", "<nop>")
vim.keymap.set({"n", "i"}, "<down>", "<nop>")
vim.keymap.set({"n", "i"}, "<left>", "<nop>")
vim.keymap.set({"n", "i"}, "<right>", "<nop>")

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })