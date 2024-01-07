return { --    use 'folke/tokyonight.nvim'
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
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
        cond = not vim.g.vscode,
        priority = 1000,
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
        priority = 1000,
        config = function(_, opts)
            -- require("catppuccin").setup(opts)
            -- vim.cmd [[colorscheme catppuccin-macchiato]]
        end
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000,
        config = function(_, opts)
            --require("kanagawa").setup(opts)
            --vim.cmd [[colorscheme kanagawa]]
        end
    }
}
