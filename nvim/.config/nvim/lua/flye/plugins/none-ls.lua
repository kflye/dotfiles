return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            'nvimtools/none-ls-extras.nvim',
        },
        config = function()
            local null_ls = require "null-ls"

            local formatting = null_ls.builtins.formatting

            null_ls.setup {
                debug = false,
                sources = {
                    require('none-ls.diagnostics.eslint_d'),
                    require('none-ls.formatting.eslint_d'),
                    require('none-ls.code_actions.eslint_d'),
                    formatting.prettier,
                    null_ls.builtins.completion.spell,
                },
            }
        end,
    }
}
