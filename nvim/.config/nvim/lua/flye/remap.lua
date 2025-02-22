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

if (vim.fn.has("win32")) then
    vim.keymap.set({ "n", "i", "v", "s", "x", "c", "o" }, "<C-z>", "<nop>")
end

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set("n", "<leader>g1", ":diffget LOCAL<CR>", { desc = "Merge - Pick LOCAL" })
vim.keymap.set("n", "<leader>g2", ":diffget BASE<CR>", { desc = "Merge - Pick BASE" })
vim.keymap.set("n", "<leader>g3", ":diffget REMOTE<CR>", { desc = "Merge - Pick REMOTE" })

-- Window navigation
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = 'Move focus to the lower window' })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = 'Move focus to the upper window' })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = 'Move focus to the right window' })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = 'Move focus to the left window' })

vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = 'Move focus to the lower window' })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = 'Move focus to the upper window' })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = 'Move focus to the right window' })
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = 'Move focus to the left window' })

-- <C-W> _ = max vertical
-- <C-W> | = max horizontal
-- <C-W> = = equal size

-- Buffer movement
vim.keymap.set("n", "<S-h>", ":bprev<CR>", { desc = "Previous buffer", silent = true })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer", silent = true })

-- Window management
vim.keymap.set("n", "<M-t>", "<C-w>+", { desc = "Resize horizontal Down", silent = true })
vim.keymap.set("n", "<M-s>", "<C-w>-", { desc = "Resize horizontal Up", silent = true })
vim.keymap.set("n", "<M-.>", "<C-w>5>", { desc = "Resize vertical Right", silent = true })
vim.keymap.set("n", "<M-,>", "<C-w>5<", { desc = "Resize vertical left", silent = true })


vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
