vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "x", "\"_x")

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
    vim.keymap.set({ "n", "i", "v", "s", "x", "c", "o" }, "<C-z>", "<nop>")
end

vim.keymap.set({ "n", "i" }, "<up>", "<nop>")
vim.keymap.set({ "n", "i" }, "<down>", "<nop>")
vim.keymap.set({ "n", "i" }, "<left>", "<nop>")
vim.keymap.set({ "n", "i" }, "<right>", "<nop>")

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set("n", "<leader>1", ":diffget LOCAL<CR>", { desc = "Merge - Pick LOCAL" })
vim.keymap.set("n", "<leader>2", ":diffget BASE<CR>", { desc = "Merge - Pick BASE" })
vim.keymap.set("n", "<leader>3", ":diffget REMOTE<CR>", { desc = "Merge - Pick REMOTE" })

-- Window navigation
vim.keymap.set("n", "<C-M-j>", "<C-w>j")
vim.keymap.set("n", "<C-M-k>", "<C-w>k")
vim.keymap.set("n", "<C-M-l>", "<C-w>l")
vim.keymap.set("n", "<C-M-h>", "<C-w>h")

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<C-M-Down>", "<C-w>j")
vim.keymap.set("n", "<C-M-Up>", "<C-w>k")
vim.keymap.set("n", "<C-M-Right>", "<C-w>l")
vim.keymap.set("n", "<C-M-Left>", "<C-w>h")

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Buffer movement
vim.keymap.set("n", "<M-Left>", ":bprev<CR>", { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<M-Right>", ":bnext<CR>", { desc = "Next buffer", silent = true })

-- Window management
vim.keymap.set("n", "<C-Left>", "<C-w><", { desc = "Resize vertical left", silent = true })
vim.keymap.set("n", "<C-Right>", "<C-w>>", { desc = "Resize vertical Right", silent = true })
vim.keymap.set("n", "<C-Up>", "<C-w>-", { desc = "Resize horizontal Up", silent = true })
vim.keymap.set("n", "<C-Down>", "<C-w>+", { desc = "Resize horizontal Down", silent = true })
