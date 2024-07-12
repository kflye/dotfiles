return { --    use 'folke/tokyonight.nvim'
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        enabled = true,
        opts = {},
        config = function(_, opts)
            -- vim.cmd [[colorscheme tokyonight]]
            -- vim.cmd[[colorscheme tokyonight-night]] -- used before
            -- vim.cmd[[colorscheme tokyonight-storm]]
            -- vim.cmd[[colorscheme tokyonight-day]]
            -- vim.cmd[[colorscheme tokyonight-moon]]
        end
    },
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function(_, opts)
            vim.cmd [[ colorscheme gruvbox-material ]]
            -- TODO: Try to implement a version for rider
            -- Use https://github.com/catppuccin/jetbrains as a starting point
            -- or https://github.com/xiaopihai7256/MyGruvbox
            -- https://github.com/sainnhe/gruvbox-material/wiki/Related-Projects
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function(_, opts)
            -- require("catppuccin").setup(opts)
            -- vim.cmd [[colorscheme catppuccin-mocha]]
        end
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function(_, opts)
            -- require("kanagawa").setup(opts)
            -- vim.cmd [[colorscheme kanagawa]]
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        enabled = true,
        config = function(_, opts)
            -- require("rose-pine").setup(opts)
            -- vim.cmd("colorscheme rose-pine")
        end
    }
}
