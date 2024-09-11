return {
    -- TODO: Harpoon integration https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#harpoon-indexequire("neo-tree")
    {
        'nvim-neo-tree/neo-tree.nvim',
        enabled = true,
        lazy = false,
        branch = 'v3.x',
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        opts = {
            close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
            enable_git_status = true,
            enable_diagnostics = false,
            source_selector = {
                padding = 4
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added     = "",
                        deleted   = "",
                        modified  = "",
                        renamed   = "",
                        -- Status type
                        untracked = "",
                        ignored   = "",
                        unstaged  = "󰄱",
                        staged    = "",
                        conflict  = "",
                    }
                }
            },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function(file_path)
                        require("neo-tree.command").execute({ action = "close" })
                    end
                }
            },
            filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                filtered_items = {
                    show_hidden_count = true,
                    hide_dotfiles = false,
                },
            },
            window = {
                width = 60,
            }
        },
        config = function(_, opts)
            require('neo-tree').setup(opts)

            vim.keymap.set('n', '<leader>w', '', { desc = '+workspace/explorer' })

            vim.keymap.set('n', '<M-1>', ':Neotree toggle<CR>', { desc = 'Neotree: toggle' })
            vim.keymap.set('n', '<leader>wt', ':Neotree toggle<CR>', { desc = 'Neotree: toggle' })
            vim.keymap.set('n', '<leader>wf', ':Neotree focus<CR>', { desc = 'Neotree: focus' })
            vim.keymap.set('n', '<leader>ws', ':Neotree reveal<CR>', { desc = 'Neotree: reveal' })
            vim.keymap.set('n', '<leader>wb', ':Neotree buffers toggle=true<CR>', { desc = 'Neotree: buffers' })
            vim.keymap.set('n', '<leader>we', ':Neotree git_status toggle=true<CR>', { desc = 'Neotree: git_status' })
        end,
    }
}
