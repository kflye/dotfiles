return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
        init = function()
            local gitsigns = require('gitsigns')

            local function map(mode, l, r, opts)
                opts = opts or {}
                vim.keymap.set(mode, l, r, opts)
            end

            -- Actions
            map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "Stage hunk" })
            map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "Discard/Reset hunk" })

            map('v', '<leader>hs', function()
                gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = "Stage hunk" })

            map('v', '<leader>hr', function()
                gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = "Discard/Reset hunk" })
        end
    },                                     -- Replace deleted/yanked text: gr{motion}
    { "vim-scripts/ReplaceWithRegister" }, -- ds / cs / ys - additional s for whole line
    -- e.g ds", cs"[ , ysiw"
    { "tpope/vim-surround" }
}
