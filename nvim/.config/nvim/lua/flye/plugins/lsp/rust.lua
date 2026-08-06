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
                        -- Rust-specific run/debug actions (buffer-local, override global <leader>r bindings)
                        vim.keymap.set('n', '<leader>rU', function() vim.cmd.RustLsp('run') end,                      { desc = 'Rust: Run', buffer = bufnr })
                        vim.keymap.set('n', '<leader>ru', function() vim.cmd.RustLsp('runnables') end,                { desc = 'Rust: Runnables', buffer = bufnr })
                        vim.keymap.set('n', '<leader>ra', function() vim.cmd.RustLsp { 'runnables', bang = true } end, { desc = 'Rust: Run Last', buffer = bufnr })
                        vim.keymap.set('n', '<leader>dc', function() vim.cmd.RustLsp { 'debuggables' } end,           { desc = 'Rust: Debuggables', buffer = bufnr })
                        vim.keymap.set('n', '<leader>dl', function() vim.cmd.RustLsp { 'debuggables', bang = true } end, { desc = 'Rust: Debug Last', buffer = bufnr })
                        vim.keymap.set('n', '<leader>rD', function() vim.cmd.RustLsp { 'debug', bang = true } end,   { desc = 'Rust: Debug', buffer = bufnr })
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
