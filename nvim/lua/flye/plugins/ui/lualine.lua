return {
    {
        'nvim-lualine/lualine.nvim', -- Fancier statusline
        cond = not vim.g.vscode,
        opts = {
            options = {
                theme = 'gruvbox-material',
                section_separators = "",
            }
        },
        dependencies = {'nvim-tree/nvim-web-devicons'}
    }
}
