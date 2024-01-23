return {
    {
        'nvim-lualine/lualine.nvim', -- Fancier statusline
        opts = {
            options = {
                theme = 'gruvbox-material',
                section_separators = "",
            }
        },
        dependencies = {'nvim-tree/nvim-web-devicons'}
    }
}
