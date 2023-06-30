return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            open_mapping    = [[<leader>tt]],
            insert_mappings = false,
        },
        config = function(_, opts)
            require('toggleterm').setup(opts)
        end,
        keys = {
            {
                "<leader>tg",
                function()
                    local Terminal = require('toggleterm.terminal').Terminal
                    local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float", })

                    lazygit:toggle()
                end,
                noremap = true,
                silent = true,
                desc = "[T]oggle Lazy[G]it"
            }
        }
    }
}
