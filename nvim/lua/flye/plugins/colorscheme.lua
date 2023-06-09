return {
    --    use 'folke/tokyonight.nvim'
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
            -- vim.cmd [[colorscheme tokyonight]]
            -- vim.cmd[[colorscheme tokyonight-night]] -- used before
            --vim.cmd[[colorscheme tokyonight-storm]]
            --vim.cmd[[colorscheme tokyonight-day]]
            --vim.cmd[[colorscheme tokyonight-moon]]
        end
    },
    {
        -- https://vi.stackexchange.com/questions/10897/how-do-i-customize-vimdiff-colors (Diff highlight is called something else in neovim... set something else manually, or use another theme, see what they set, gruvbox uses vim groups...)
        "gruvbox-community/gruvbox",
        lazy = false,
        priority = 1000,
        config = function(_, opts)
            -- vim.cmd [[colorscheme gruvbox]]
        end
    }
    ,
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function(_, opts)
            -- vim.cmd [[colorscheme gruvbox-material]]
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        opts = {},
        config = function(_, opts)
            require("gruvbox").setup(opts)
            vim.cmd [[colorscheme gruvbox]]
        end
    },
    {
        'luisiacc/gruvbox-baby',
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd [[colorscheme gruvbox-baby]]
        end
    }
}
