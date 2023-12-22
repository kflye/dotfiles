return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    dependencies = {
        {"nvim-treesitter/nvim-treesitter-textobjects"}, 
        {"nvim-treesitter/nvim-treesitter-context"},
        {"p00f/nvim-ts-rainbow"},
        {"JoosepAlviste/nvim-ts-context-commentstring"}, 
        {"windwp/nvim-ts-autotag"},
        {
            "windwp/nvim-autopairs",
            opts = {
                check_ts = true, -- enable treesitter
                ts_config = {
                    lua = {"string"},
                    javascript = {"template_string"}
                }
            },
            config = function(_, opts)
                require("nvim-autopairs").setup(opts)
        
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                local cmp = require("cmp")
    
                -- make autopairs and completion work together
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end
        }
    },
    opts = {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx", "rust", "toml", "yaml", "c_sharp" },
        auto_install = true,
        highlight = {
            enable = true
        },
        indent = {
            enable = true
        },
        autotag = { -- windwp/nvim-ts-autotag
            enable = true
        },
        autopairs = { -- windwp/nvim-autopairs
            enable = true
        },
        rainbow = { -- p00f/nvim-ts-rainbow
            enable = true,
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil -- Do not enable for files with more than n lines, int
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<leader>ss',
                node_incremental = '<leader>si',
                scope_incremental = '<leader>sc',
                node_decremental = '<leader>sd'
            }
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner'
                }
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer'
                },
                goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer'
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer'
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer'
                }
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner'
                },
                swap_previous = {
                    ['<leader>A'] = '@parameter.inner'
                }
            }
        }
    },
    init = function()
        local treesitter_install = require 'nvim-treesitter.install'

        treesitter_install.prefer_git = false
        treesitter_install.compilers = {"zig"}
    end,
    config = function(_, opts)
        local treesitter = require 'nvim-treesitter.configs'
        treesitter.setup(opts)
    end,
}
