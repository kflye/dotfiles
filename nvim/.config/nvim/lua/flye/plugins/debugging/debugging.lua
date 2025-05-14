local LspCommon = require("flye.lsp-common")

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
    --  TODO: Have removed:    'jay-babu/mason-nvim-dap.nvim',
    {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
    },
    {
        "mxsdev/nvim-dap-vscode-js",
        dependencies =
        {
            {
                "microsoft/vscode-js-debug",
                -- After install, build it and rename the dist directory to out
                -- npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -Recurse -Force out && mv dist out
                -- build = function()
                --     local this_os = vim.loop.os_uname().sysname
                --     if this_os:find "Windows" then
                --         os.execute('npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -Recurse -Force out && mv dist out')
                --     else
                --         os.execute('npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out')
                --     end
                -- end,
                build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",

                version = "1.*",
            },
            { "mfussenegger/nvim-dap" },
        },
        opts = function()
            return {
                debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
                adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
            }
        end,
        config = function(_, opts)
            require("dap-vscode-js").setup(opts)
            local dap = require("dap")

            for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require 'dap.utils'.pick_process,
                        cwd = "${workspaceFolder}",
                    },
                    -- TODO: Attach to running angular / chrome process
                }
            end
        end,
    },
    {
        "leoluz/nvim-dap-go",
    },

}
