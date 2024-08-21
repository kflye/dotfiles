local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- TODO: Look into these plugins
    -- {'tpope/vim-fugitive' }
    -- {'tpope/vim-rhubarb' }
}

local opts = {}

require("lazy").setup({
    spec = {
        {import = "flye.plugins"},
        {import = "flye.plugins.ai"},
        {import = "flye.plugins.lsp"},
        {import = "flye.plugins.debugging"},
        {import = "flye.plugins.editor"},
        {import = "flye.plugins.ui"}
    },
    ui = {
        border = "rounded"
    },
    change_detection = {
        enabled = true,
        notify = false,
    }
}, opts)
