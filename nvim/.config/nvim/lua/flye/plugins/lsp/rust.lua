return {
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false,   -- This plugin is already lazy
        config = function()
            vim.g.rustaceanvim = {
                -- LSP configuration
                server = {
                    on_attach = function(client, bufnr)
                        -- joinLines -- different than regular join lines??? (J)
                        -- explainError -- perhaps <leader>E
                        vim.keymap.set('n', '<leader>rU', function() vim.cmd.RustLsp('run') end, { desc = '[r][u]n' })
                        vim.keymap.set('n', '<leader>ru', function() vim.cmd.RustLsp('runnables') end, { desc = '[r][u]nnables' })
                        vim.keymap.set('n', '<leader>ra', function() vim.cmd.RustLsp { 'runnables', bang = true } end, { desc = '[r]un [a]gain' })
                        vim.keymap.set('n', '<leader>rd', function() vim.cmd.RustLsp { 'debuggables' } end, { desc = '[r]un [a]gain' })
                        vim.keymap.set('n', '<leader>rd', function() vim.cmd.RustLsp { 'debuggables', bang = true } end, { desc = '[r]un [a]gain' })
                        vim.keymap.set('n', '<leader>rD', function() vim.cmd.RustLsp { 'debug', bang = true } end, { desc = '[r]un [a]gain' })
                    end,
                    default_settings = {
                        --- options to send to rust-analyzer
                        --- See: https://rust-analyzer.github.io/manual.html#configuration
                        ['rust-analyzer'] = {
                            -- checkOnSave = false,
                        },
                    },
                },
            }
        end
    },
    {
        "saecki/crates.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true
    }
}
