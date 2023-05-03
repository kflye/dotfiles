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
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },


    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-nvim-lua' },

    { "onsails/lspkind.nvim" }, -- vscode like icons to lsp

    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },

    -- formatting & linting
    { "jay-babu/mason-null-ls.nvim" },
    { "jose-elias-alvarez/null-ls.nvim" },

    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim' },

    -- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    
    -- configure lua language server for neovim config
    { "folke/neodev.nvim" },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.x',
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'MinGW32-make '
            },
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-ui-select.nvim' } }
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "p00f/nvim-ts-rainbow" },
            { "JoosepAlviste/nvim-ts-context-commentstring" }
        }
    },


    -- auto closing
    { "windwp/nvim-autopairs" },
    { "windwp/nvim-ts-autotag" },

    -- 'nvim-tree'
    --{
    --    'nvim-tree/nvim-tree.lua',
    --    dependencies = { 'nvim-tree/nvim-web-devicons' -- optional, for file icons
    --    }
    --},

    -- lualine extension extensions = { "neo-tree" }, bufferline offset
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },

    {
        'nvim-lualine/lualine.nvim', -- Fancier statusline
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },

    { "numToStr/Comment.nvim" }, -- "gc" to comment visual regions/lines

    -- Git related plugins
    { "lewis6991/gitsigns.nvim" },
    -- TODO: Look into these plugins
    -- {'tpope/vim-fugitive' }
    -- {'tpope/vim-rhubarb' }

    {
        "akinsho/bufferline.nvim",
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    -- execution and debugging
    { "rcarriga/nvim-dap-ui",           dependencies = { "mfussenegger/nvim-dap" } },

    -- TODO: Figure out how to use as in rider
    { "moll/vim-bbye" }, -- Bbye allows you to do delete buffers (close files) without closing your windows or messing up your layout.

    -- Replace deleted/yanked text: gr{motion}
    { "vim-scripts/ReplaceWithRegister" },

    -- ds / cs / ys - additional s for whole line
    -- e.g ds", cs"[ , ysiw"
    { "tpope/vim-surround" },

    --    use 'folke/tokyonight.nvim'
    { "gruvbox-community/gruvbox",      lazy = false,                              priority = 1000, },

    -- TODO: toggleterm for a terminal

}

local opts = {}

require("lazy").setup(plugins, opts)
