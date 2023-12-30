return {
    {
        "akinsho/bufferline.nvim",
        opts = {
            options = {
                show_buffer_close_icons = false,
                show_close_icon = false,
                color_icons = true,
                close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                left_mouse_command = "buffer %d" -- can be a string | function, see "Mouse actions"
            },
            highlights = {}
        },
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
}
