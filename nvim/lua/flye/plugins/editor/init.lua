return {
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require('ts_context_commentstring').setup {
                enable_autocmd = false
            }
        end
    },
    {
        "numToStr/Comment.nvim",
        dependencies = { { "JoosepAlviste/nvim-ts-context-commentstring" } },
        config = function()
            require('Comment').setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
            })
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {}
    },                                     -- Replace deleted/yanked text: gr{motion}
    { "vim-scripts/ReplaceWithRegister" }, -- ds / cs / ys - additional s for whole line
    -- e.g ds", cs"[ , ysiw"
    { "tpope/vim-surround" }
}
