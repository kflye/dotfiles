return {
    "sindrets/diffview.nvim",
    opts = {
        view = {
            merge_tool = {
                layout = "diff4_mixed"
            }
        }
    },
    keys = {
        { '<leader>gm',   '',                                           desc = '+merge/diff' },
        { '<leader>gmf', "<Cmd>DiffviewFileHistory --follow %<CR>",    desc = '[G]it [D]iff [F]ile' },
        { '<leader>gmm', "<Cmd>DiffviewOpen <CR>",                     desc = '[G]it [D]iff Open' },
        { '<leader>gmc', "<Cmd>DiffviewClose <CR>",                    desc = '[G]it [D]iff Close' },

        { '<leader>gml', "<Cmd>'<,'>DiffviewFileHistory --follow<CR>", mode = { "v" },              desc = '[G]it [D]iff [L]ine(s) - visual selection' },
        { '<leader>gml', "<Cmd>.DiffviewFileHistory --follow<CR>",     mode = { "n" },              desc = '[G]it [D]iff [L]ine' },

    }
}
