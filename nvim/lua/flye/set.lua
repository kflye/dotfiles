vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- clipboard -- vim.opt.clipboard:append("unnamedplus") yank to system clipboard from vim
vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 8
vim.opt.cursorline = true
-- enable virtual edit in block mode (<C-v>)
vim.opt.virtualedit = "block"

vim.opt.hlsearch = false
vim.opt.incsearch = true
-- view a preview of search and replace in a split
vim.opt.inccommand = "split"

-- apperance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.opt.errorbells = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.autoindent = true
vim.opt.smartindent = true

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
-- shortness: avoid showing extra messages when using completion
-- don't give |ins-completion-menu| messages; for		*shm-c*
-- example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
vim.opt.shortmess = vim.opt.shortmess + { c = true }

-- enable spell checking
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

vim.opt.hidden = true

vim.g.mapleader = " "

vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro rnu"

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
