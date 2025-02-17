return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "nvim-treesitter/nvim-treesitter-context" }, -- alternative could be SmiteshP/nvim-navic
    },
    opts = {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx", "rust", "toml", "yaml", "c_sharp", "diff", "git_rebase", "gitcommit" },
        auto_install = true,
        highlight = {
            enable = true
        },
        indent = {
            enable = true
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
                    [']]'] = '@function.outer',
                    [']m'] = '@class.outer'
                },
                goto_next_end = {
                    [']['] = '@function.outer',
                    [']M'] = '@class.outer'
                },
                goto_previous_start = {
                    ['[['] = '@function.outer',
                    ['[m'] = '@class.outer'
                },
                goto_previous_end = {
                    ['[]'] = '@function.outer',
                    ['[M'] = '@class.outer'
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
        --  local treesitter_install = require 'nvim-treesitter.install'
        --treesitter_install.prefer_git = false
        --treesitter_install.compilers = {"zig"}
    end,
    config = function(_, opts)
        local treesitter = require 'nvim-treesitter.configs'
        treesitter.setup(opts)
    end,
}
