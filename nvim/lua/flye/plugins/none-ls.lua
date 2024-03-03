return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local null_ls = require "null-ls"

            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics

            null_ls.setup {
                debug = false,
                sources = {
                    -- formatting.prettier,
                    formatting.prettier.with {
                      -- extra_filetypes = { "toml" },
                      extra_args = { "--tab-width=2", "--no-semi", "--single-quote", "--jsx-single-quote" },
                    },
                    -- formatting.eslint,
                    null_ls.builtins.completion.spell,
                },
            }
        end,
    }
}
