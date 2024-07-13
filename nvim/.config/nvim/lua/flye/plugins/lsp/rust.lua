return {
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        lazy = false, -- This plugin is already lazy
        config = function()
            vim.g.rustaceanvim = {
                -- Plugin configuration
                -- tools = {
                -- },
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
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                            -- checkOnSave = false,
                        },
                    },
                },
                -- DAP configuration
                -- dap = {
                -- },
            }
        end
    },
    {
        "saecki/crates.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true
    }
}
