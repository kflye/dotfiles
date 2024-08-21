return {
    {
        'nvim-lualine/lualine.nvim', -- Fancier statusline
        opts = {
            options = {
                -- theme = 'gruvbox-material',
                theme = 'auto',
                section_separators = "",
            },
            sections = {
                lualine_x = {
                    {
                        'copilot',
                        show_colors = true,
                        show_loading = true
                    },
                    'encoding',
                    'fileformat',
                    'filetype'
                }
            },
        },
        dependencies = { 'nvim-tree/nvim-web-devicons', 'AndreM222/copilot-lualine' }
    }
}
