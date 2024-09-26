return {
    -- fork with zellij suppert - https://github.com/dynamotn/Navigator.nvim
    -- https://github.com/alex35mil/dotfiles
    -- https://github.com/hiasr/vim-zellij-navigator
    -- https://www.reddit.com/r/zellij/comments/1dupuxv/ctrl_hjkl_hassles/
    -- dir = "~/Navigator.nvim",
    'numToStr/Navigator.nvim',
    config = function()
        vim.keymap.set({ 'n', 't' }, '<C-h>', '<CMD>NavigatorLeft<CR>')
        vim.keymap.set({ 'n', 't' }, '<C-l>', '<CMD>NavigatorRight<CR>')
        vim.keymap.set({ 'n', 't' }, '<C-k>', '<CMD>NavigatorUp<CR>')
        vim.keymap.set({ 'n', 't' }, '<C-j>', '<CMD>NavigatorDown<CR>')
        vim.keymap.set({ 'n', 't' }, '<C-p>', '<CMD>NavigatorPrevious<CR>')

        require('Navigator').setup()
    end,
}
