return {
    -- TODO: Harpoon integration https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#harpoon-indexequire("neo-tree")
    {
        'nvim-neo-tree/neo-tree.nvim',
        enabled = true,
        lazy = false,
        branch = 'v3.x',
        dependencies = { "nvim-lua/plenary.nvim", "echasnovski/mini.icons", "MunifTanjim/nui.nvim" },
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
                    visible = false, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = false, -- only works on Windows for hidden files/directories
                    show_hidden_count = true,
                    hide_by_name = {
                      ".git",
                      "node_modules"
                    },
                },
            },
            window = {
                width = 60,
            }
        },
        config = function(_, opts)
            require('neo-tree').setup(opts)

            vim.keymap.set('n', '<leader>e',  '',                                       { desc = '+explorer' })
            vim.keymap.set('n', '<leader>ee', ':Neotree toggle<CR>',                    { desc = 'Explorer: toggle' })
            vim.keymap.set('n', '<leader>ef', ':Neotree reveal<CR>',                    { desc = 'Explorer: focus/reveal current file' })
            vim.keymap.set('n', '<leader>eb', ':Neotree buffers toggle=true<CR>',       { desc = 'Explorer: buffers' })
            vim.keymap.set('n', '<leader>eg', ':Neotree git_status toggle=true<CR>',    { desc = 'Explorer: git status' })
        end,
    }
}
