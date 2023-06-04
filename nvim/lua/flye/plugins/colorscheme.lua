return {
    --    use 'folke/tokyonight.nvim'
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function(_, opts)
            -- vim.cmd [[colorscheme tokyonight]]
            vim.cmd[[colorscheme tokyonight-night]]
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
            -- local colorsheme = "gruvbox"
            --
            -- local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorsheme)
            --
            -- if not status_ok then
            --     vim.notify("colorsheme " .. colorsheme .. " not found!")
            --     return
            -- end
        end
    }
}
