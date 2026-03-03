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

            map( 'n' , '<leader>gh', '', { desc = '+hunk' })

            -- Actions
            map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = "Stage hunk" })
            map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = "Discard/Reset hunk" })

            map('v', '<leader>ghs', function()
                gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = "Stage hunk" })

            map('v', '<leader>ghr', function()
                gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = "Discard/Reset hunk" })

            map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = "Stage buffer" })
            map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = "Discard/Reset buffer" })
            map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = "Preview hunk" })
            map('n', '<leader>ghi', gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

            map('n', '<leader>ghb', function()
                gitsigns.blame_line({ full = true })
            end, { desc = "Line blame" })

            map('n', '<leader>ghd', gitsigns.diffthis, { desc = "Diff this" })

            map('n', '<leader>ghD', function()
                gitsigns.diffthis('~')
            end, { desc = "Diff this" })

            -- Toggles
            map('n', '<leader>ghB', gitsigns.toggle_current_line_blame, { desc = "Toggle Line Blame" })
            map('n', '<leader>ghw', gitsigns.toggle_word_diff, { desc = "Toggle word diff" })
        end
    },                                     -- Replace deleted/yanked text: gr{motion}
    -- { "vim-scripts/ReplaceWithRegister" }, -- ds / cs / ys - additional s for whole line
    -- e.g ds", cs"[ , ysiw"
    { "tpope/vim-surround" }
}
