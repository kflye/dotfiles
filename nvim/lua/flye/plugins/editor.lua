return
    { -- TODO: Harpoon integration https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#harpoon-indexequire("neo-tree")
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"},
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
            event_handlers = {{
                event = "file_opened",
                handler = function(file_path)
                    -- auto close
                    require("neo-tree").close_all()
                end
            }},
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
                }
            }
        },
        keys = {{"<leader>we", ":Neotree toggle<CR>"}, {"<leader>wf", ":Neotree focus<CR>"},
                {"<leader>ws", ":Neotree reveal<CR>"}}
    }, {
        "nvim-telescope/telescope.nvim",
        -- TODO: What does this do???
        -- cmd = "Telescope",
        version = '0.1.x',
        dependencies = {{
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make '
        }, {'nvim-lua/plenary.nvim'}, {'nvim-telescope/telescope-ui-select.nvim'}},
        opts = {
            defaults = {
                color_devicons = true,
                file_ignore_patterns = {"node_modules"}
            },
            pickers = {
                find_files = {
                    find_command = {"fd", '--type', 'f' -- '-H'
                    -- no-ignore-vcs',
                    }
                }
            },
            vimgrep_arguments = {"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
                                 "--smart-case", "--trim", -- add this value
            "-uu"}

        },
        config = function(_, opts)
            local telescope = require("telescope")

            local aaa = vim.tbl_deep_extend("force", {
                extensions = {
                    ["ui-select"] = {require("telescope.themes").get_dropdown {
                        -- even more opts
                    } -- pseudo code / specification for writing custom displays, like the one
                    -- for "codeactions"
                    -- specific_opts = {
                    --   [kind] = {
                    --     make_indexed = function(items) -> indexed_items, width,
                    --     make_displayer = function(widths) -> displayer
                    --     make_display = function(displayer) -> function(e)
                    --     make_ordinal = function(e) -> string
                    --   },
                    --   -- for example to disable the custom builtin "codeactions" display
                    --      do the following
                    --   codeactions = false,
                    -- }
                    },

                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case" -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    }
                }
            }, opts)

            telescope.setup(aaa)

            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
        keys = {{'<leader>sf', function()
            require('telescope.builtin').find_files {}
        end, {
            desc = '[]earch [F]iles'
        }}, {'<leader>sb', function()
            require('telescope.builtin').buffers {}
        end, {
            desc = '[S]earch [B]uffers'
        }}, {'<leader>sh', function()
            require('telescope.builtin').help_tags {}
        end, {
            desc = '[S]earch [H]elp'
        }}, {'<leader>stw', function()
            require('telescope.builtin').grep_string {}
        end, {
            desc = '[S]earch [T]ext by current [W]ord'
        }}, {'<leader>stg', function()
            require('telescope.builtin').live_grep {}
        end, {
            desc = '[S]earch [T]ext by [G]rep'
        }}, {'<leader>sts', function()
            require('telescope.builtin').treesitter {}
        end, {
            desc = '[S]earch [T]reesitter [S]ymbols'
        }}, {"<leader>sgb", function()
            require('telescope.builtin').git_branches {}
        end}, {"<leader>sgs", function()
            require('telescope.builtin').git_status {}
        end}}
    }, {
        "moll/vim-bbye",
        keys = {{'<leader>bd', ":Bdelete<CR>   ", {
            desc = '[B]uffer [D]elete'
        }}}
    }, {
        "numToStr/Comment.nvim",
        dependencies = {
            {"JoosepAlviste/nvim-ts-context-commentstring"},
        },
    }, {
        "lewis6991/gitsigns.nvim",
        opts = {}
    } ,
     -- Replace deleted/yanked text: gr{motion}
    { "vim-scripts/ReplaceWithRegister" },

    -- ds / cs / ys - additional s for whole line
    -- e.g ds", cs"[ , ysiw"
    { "tpope/vim-surround" },
}
