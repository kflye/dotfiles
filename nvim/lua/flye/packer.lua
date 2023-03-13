-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost packer.lua source <afile> | PackerSync
    augroup end
  ]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
    return
end

packer.startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- LSP Support
    use { 'neovim/nvim-lspconfig' }
    use { 'williamboman/mason.nvim' }
    use { 'williamboman/mason-lspconfig.nvim' }

    -- Autocompletion
    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-path' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-nvim-lua' }

    use { "onsails/lspkind.nvim" } -- vscode like icons to lsp

    -- Snippets
    use { 'L3MON4D3/LuaSnip' }
    use { 'rafamadriz/friendly-snippets' }

    -- formatting & linting
    use { "jay-babu/mason-null-ls.nvim" }
    use { "jose-elias-alvarez/null-ls.nvim" }

    -- Useful status updates for LSP
    use { 'j-hui/fidget.nvim' }

    -- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists
    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.x',
        requires = { 
            {
            'nvim-telescope/telescope-fzf-native.nvim',
            run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -G "MinGW Makefiles" && cmake --build build --config Release && cmake --install build --prefix build'
            }, 
            { 'nvim-lua/plenary.nvim' }, 
            {'nvim-telescope/telescope-ui-select.nvim' }}
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({
                with_sync = true
            })
            ts_update()
        end,
        requires = { { "nvim-treesitter/nvim-treesitter-textobjects" }, { "p00f/nvim-ts-rainbow" },
            { "JoosepAlviste/nvim-ts-context-commentstring" } }
    }

    -- auto closing
    use { "windwp/nvim-autopairs" }
    use { "windwp/nvim-ts-autotag" }

    -- 'nvim-tree'
    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons' -- optional, for file icons
        }
    }

    use {
        'nvim-lualine/lualine.nvim', -- Fancier statusline
        requires = { 'kyazdani42/nvim-web-devicons' }
    }

    use { "numToStr/Comment.nvim" } -- "gc" to comment visual regions/lines

    -- Git related plugins
    use { "lewis6991/gitsigns.nvim" }
    -- TODO: Look into these plugins
    -- use {'tpope/vim-fugitive' }
    -- use {'tpope/vim-rhubarb' }

    use {
        "akinsho/bufferline.nvim",
        requires = 'nvim-tree/nvim-web-devicons'
    }

    -- TODO: Figure out how to use as in rider
    use { "moll/vim-bbye" } -- Bbye allows you to do delete buffers (close files) without closing your windows or messing up your layout.

    -- Replace deleted/yanked text: gr{motion}
    use 'vim-scripts/ReplaceWithRegister'

    -- ds / cs / ys - additional s for whole line
    -- e.g ds", cs"[ , ysiw"
    use 'tpope/vim-surround'

    --    use 'folke/tokyonight.nvim'
    use 'gruvbox-community/gruvbox'

    -- TODO: toggleterm for a terminal

    if packer_bootstrap then
        require("packer").sync()
    end
end)
