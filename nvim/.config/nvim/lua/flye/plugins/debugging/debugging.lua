return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {},
        init = function()
            local dap = require("dap")
            local widgets = require('dap.ui.widgets')

            vim.keymap.set({ 'v', 'n' }, '<leader>d', '', { desc = '+debug' })

            -- Start / flow
            vim.keymap.set('n', '<F9>',    dap.continue,   { desc = 'Debug: Continue' })
            vim.keymap.set('n', '<F11>',   dap.step_into,  { desc = 'Debug: Step Into' })
            vim.keymap.set('n', '<F10>',   dap.step_over,  { desc = 'Debug: Step Over' })
            vim.keymap.set('n', '<S-F11>', dap.step_out,   { desc = 'Debug: Step Out' })
            vim.keymap.set('n', '<F12>',   dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })

            vim.keymap.set('n', '<leader>dc', dap.continue,      { desc = 'Debug: Continue' })
            vim.keymap.set('n', '<leader>ds', dap.terminate,      { desc = 'Debug: Stop' })
            vim.keymap.set('n', '<leader>dl', dap.run_last,       { desc = 'Debug: Run Last' })
            vim.keymap.set('n', '<leader>dC', dap.run_to_cursor,  { desc = 'Debug: Run to Cursor' })

            -- Breakpoints
            vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
            vim.keymap.set('n', '<leader>dB', function()
                dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
            end, { desc = 'Debug: Conditional Breakpoint' })

            -- Widgets / inspection
            vim.keymap.set('n', '<leader>dr', dap.repl.open,                                    { desc = 'Debug: REPL' })
            vim.keymap.set('n', '<leader>dh', widgets.hover,                                    { desc = 'Debug: Hover' })
            vim.keymap.set({ 'n', 'v' }, '<leader>dp', widgets.preview,                         { desc = 'Debug: Preview' })
            vim.keymap.set('n', '<leader>df', function() widgets.centered_float(widgets.frames) end, { desc = 'Debug: Frames' })
            vim.keymap.set('n', '<leader>dS', function() widgets.centered_float(widgets.scopes) end, { desc = 'Debug: Scopes' })

            require('flye.plugins.dap.js-debug-adapter')
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            { "mfussenegger/nvim-dap" }
        },
        opts = {},
        config = function(opts)
            local dap, dapui = require('dap'), require('dapui')

            dapui.setup(opts)

            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close

            vim.keymap.set('n', '<F7>',        dapui.toggle, { desc = 'Debug: Toggle UI' })
            vim.keymap.set('n', '<leader>du',  dapui.toggle, { desc = 'Debug: Toggle UI' })
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
    },
    {
        "leoluz/nvim-dap-go",
    },
}

