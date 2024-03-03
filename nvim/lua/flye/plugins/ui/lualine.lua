return {
    {
        'nvim-lualine/lualine.nvim', -- Fancier statusline
        opts = {
            options = {
                -- theme = 'gruvbox-material',
                theme = 'auto',
                section_separators = "",
            }
        },
        dependencies = {'nvim-tree/nvim-web-devicons'}
    }
}
