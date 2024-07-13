return {
    "christoomey/vim-tmux-navigator",
    cond = vim.fn.executable('tmux') == 1,
    enabled = false,
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    config = function(_, opts)
        -- TODO: is not called 
        vim.g.tmux_navigator_no_mappings = 1

        vim.keymap.set("n", "<C-M>h", "<cmd><C-U>TmuxNavigateLeft<cr>")
        vim.keymap.set("n", "<C-M>j", "<cmd><C-U>TmuxNavigateDown<cr>")
        vim.keymap.set("n", "<C-M>k", "<cmd><C-U>TmuxNavigateUp<cr>")
        vim.keymap.set("n", "<C-M>l", "<cmd><C-U>TmuxNavigateRigth<cr>")
        vim.keymap.set("n", "<C-M>\\", "<cmd><C-U>TmuxNavigatePrevious<cr>")
    end,
    -- keys = {
    --     -- this is the default
    --     { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
    --     { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
    --     { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
    --     { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
    --     { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    -- },
}
