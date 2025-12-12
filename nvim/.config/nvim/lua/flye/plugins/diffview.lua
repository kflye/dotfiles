return {
    "sindrets/diffview.nvim",
    opts = {},
    keys = {
        { '<leader>g',   '',                                           desc = '+git' },
        { '<leader>gdf', "<Cmd>DiffviewFileHistory --follow %<CR>",    desc = '[G]it [D]iff [F]ile' },
        { '<leader>gdd', "<Cmd>DiffviewOpen <CR>",                     desc = '[G]it [D]iff Open' },
        { '<leader>gdc', "<Cmd>DiffviewClose <CR>",                    desc = '[G]it [D]iff Close' },

        { '<leader>gdl', "<Cmd>'<,'>DiffviewFileHistory --follow<CR>", mode = { "v" },              desc = '[G]it [D]iff [L]ine(s) - visual selection' },
        { '<leader>gdl', "<Cmd>.DiffviewFileHistory --follow<CR>",     mode = { "n" },              desc = '[G]it [D]iff [L]ine' },

    }
}
