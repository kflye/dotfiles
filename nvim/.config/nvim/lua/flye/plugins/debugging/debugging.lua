return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {},
        init = function()
            local dap = require("dap")
            local widgets = require('dap.ui.widgets')

            vim.keymap.set({ 'v', 'n' }, '<leader>d', '', { desc = '+debug' })

            vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
            vim.keymap.set('n', '<leader>rd', dap.continue, { desc = 'Debug: Start/Continue' })
            vim.keymap.set('n', '<leader>tdl', dap.run_last, { desc = 'Debug: Run last' })
            vim.keymap.set('n', '<leader>tC', dap.run_to_cursor, { desc = '[D]ebug: run to [C]ursor' })

            vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
            vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
            vim.keymap.set('n', '<S-F11>', dap.step_out, { desc = 'Debug: Step Out' })

            vim.keymap.set('n', '<leader>tdt', dap.terminate, { desc = 'Debug: Run Stop' })

            vim.keymap.set('n', '<leader>tb', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
            vim.keymap.set('n', '<leader>tB', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
            vim.keymap.set('n', '<leader>?', function() require('dapui').eval(nil, { enter = true }) end, { desc = 'Debug: Eval under cursor' })

            vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: [R]epl open' })
            vim.keymap.set('n', '<leader>dh', widgets.hover, { desc = 'Debug: [H]over Widgets' })
            vim.keymap.set({ 'n', 'v' }, '<leader>dp', widgets.preview, { desc = 'Debug: [P]review' })
            vim.keymap.set('n', '<leader>df', function() widgets.centered_float(widgets.frames) end, { desc = 'Debug: [F]rames' })
            vim.keymap.set('n', '<leader>ds', function() widgets.centered_float(widgets.scopes) end, { desc = 'Debug: [S]copes' })

            require('flye.plugins.dap.js-debug-adapter')
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies =
        {
            { "mfussenegger/nvim-dap", }
        },
        opts = {},
        config = function(opts)
            local dap, dapui = require('dap'), require('dapui')

            dapui.setup(opts)

            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close

            -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
            vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
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
