return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        branch = 'main',
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-context" }, -- alternative could be SmiteshP/nvim-navic
        },
        lazy = false,
        config = function(_, opts)
            local treesitter = require 'nvim-treesitter'
            treesitter.setup(opts)

            treesitter.install(
                { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx", "rust", "toml", "yaml", "c_sharp", "diff", "git_rebase", "gitcommit" }
            )
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        opts = {
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true
            },
            move = {
                -- whether to set jumps in the jumplist
                set_jumps = true,
            },
        },
        init = function()
            -- select
            vim.keymap.set({ "x", "o" }, "am", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "im", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
            end)
            -- You can also use captures from other query groups like `locals.scm`
            vim.keymap.set({ "x", "o" }, "as", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
            end)

            -- swap
            vim.keymap.set("n", "<leader>ml", function()
                require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
            end)
            vim.keymap.set("n", "<leader>mh", function()
                require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
            end)

            -- move
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]]", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
            end)
            -- You can also pass a list to group multiple queries.
            vim.keymap.set({ "n", "x", "o" }, "]o", function()
                require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
            end)
            -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
            vim.keymap.set({ "n", "x", "o" }, "]s", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]z", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
            end)

            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "][", function()
                require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
            end)

            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[[", function()
                require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
            end)

            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[]", function()
                require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
            end)
        end
    }
}
