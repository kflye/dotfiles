vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
-- shortness: avoid showing extra messages when using completion
-- don't give |ins-completion-menu| messages; for		*shm-c*
-- example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
vim.opt.shortmess = vim.opt.shortmess + { c = true }


-- apperance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.opt.scrolloff = 8
vim.opt.cursorline = true

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- clipboard -- vim.opt.clipboard:append("unnamedplus") yank to system clipboard from vim
vim.opt.clipboard = "unnamedplus"

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

vim.g.mapleader = " "

-- disable netrw at the very start of your init.lua (strongly advised) nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


local this_os = vim.loop.os_uname().sysname

if this_os:find "Windows" then
    vim.o.shell = 'pwsh'
    vim.o.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
end
