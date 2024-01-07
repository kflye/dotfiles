return {
    -- TODO: Harpoon integration https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#harpoon-indexequire("neo-tree")
    {
        'nvim-neo-tree/neo-tree.nvim',
        enabled = false,
        cond = not vim.g.vscode,
        lazy = false,
        branch = 'v3.x',
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        opts = {
            close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
            enable_git_status = true,
            enable_diagnostics = true,
            source_selector = {
                padding = 4
            },
            default_component_configs = {
                git_status = {
                    symbols = {
                        -- Change type
                        added = "",
                        deleted = "",
                        modified = "",
                        renamed = "",
                        -- Status type
                        untracked = "",
                        ignored = "",
                        unstaged = "",
                        staged = "",
                        conflict = ""
                    }
                }
            },
            event_handlers = {},
            filesystem = {
                filtered_items = {
                    visible = true,
                    show_hidden_count = true,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = {
                        -- '.git',
                        -- '.DS_Store',
                        -- 'thumbs.db',
                    },
                    never_show = {}
                },
                -- hijack_netrw_behavior = "open_default"
            }
        },
        keys = { { "<leader>we", ":Neotree toggle<CR>" }, { "<leader>wf", ":Neotree focus<CR>" },
            { "<leader>ws", ":Neotree reveal<CR>" } }
    }
}
