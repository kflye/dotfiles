return {
    {
        "nvim-telescope/telescope.nvim",
        -- TODO: What does this do???
        -- cmd = "Telescope",
        version = '0.1.x',
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make '
            }, 
            {'nvim-lua/plenary.nvim'}, 
            {'nvim-telescope/telescope-ui-select.nvim'}
        },
        opts = {
            defaults = {
                color_devicons = true,
                file_ignore_patterns = {"node_modules"}
            },
            pickers = {
                find_files = {
                    find_command = {
                        "fd", 
                        '--type', 
                        'f' 
                        -- '-H'
                        -- no-ignore-vcs',
                    }
                }
            },
            vimgrep_arguments = {"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
                                 "--smart-case", "--trim",
            "-uu"}

        },
        config = function(_, opts)
            local telescope = require("telescope")

            local aaa = vim.tbl_deep_extend("force", {
                extensions = {
                    ["ui-select"] = {require("telescope.themes").get_dropdown {
                        -- even more opts
                    }
                    },

                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
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
    }
}