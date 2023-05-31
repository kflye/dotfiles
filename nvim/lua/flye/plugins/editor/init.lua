return {
    {
        "numToStr/Comment.nvim",
        dependencies = {
            {"JoosepAlviste/nvim-ts-context-commentstring"},
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {}
    },
    {
        "moll/vim-bbye",
        keys = {{'<leader>bd', ":Bdelete<CR>   ", {
            desc = '[B]uffer [D]elete'
        }}}
    },
    -- Replace deleted/yanked text: gr{motion}
    { "vim-scripts/ReplaceWithRegister" },

    -- ds / cs / ys - additional s for whole line
    -- e.g ds", cs"[ , ysiw"
    { "tpope/vim-surround" },
}