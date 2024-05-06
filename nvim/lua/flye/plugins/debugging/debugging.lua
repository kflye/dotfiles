local LspCommon = require("flye.lsp-common")

return { {
    "mfussenegger/nvim-dap",
    dependencies = { { "rcarriga/nvim-dap-ui" }, { 'williamboman/mason.nvim' }, { 'jay-babu/mason-nvim-dap.nvim' }, { "nvim-neotest/nvim-nio" } },
    init = function()
        local dap = require("dap")
        local widgets = require('dap.ui.widgets')
        local dapui = require("dapui")


        -- Basic debugging keymaps, feel free to change to your liking!
        vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
        vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<S-F11>', dap.step_out, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<leader>rs', dap.terminate, { desc = 'Debug: Run Stop' })
        vim.keymap.set('n', '<leader>tb', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>tB', function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end, { desc = 'Debug: Set Breakpoint' })

        vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: Repl open' })
        vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run last' })
        vim.keymap.set('n', '<leader>dh', widgets.hover, { desc = 'Debug: Hover' })
        vim.keymap.set({ 'n', 'v' }, '<leader>dp', widgets.preview, { desc = 'Debug: Preview' })
        vim.keymap.set('n', '<leader>df', function()
            widgets.centered_float(widgets.frames)
        end, { desc = 'Debug: Frames' })
        vim.keymap.set('n', '<leader>df', function()
            widgets.centered_float(widgets.scopes)
        end, { desc = 'Debug: Scopes' })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                -- 💀 Make sure to update this path to point to your installation
                args = {
                    require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                    .. "/js-debug/src/dapDebugServer.js",
                    "${port}",
                },
            },
        }
    end,

}, {
    "rcarriga/nvim-dap-ui",
    opts = {},
    config = function(opts)
        local dapui = require('dapui')

        dapui.setup(opts)

        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
    end,
}, {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
        { 'williamboman/mason.nvim' }
    },
    opts = {
        ensure_installed = { "coreclr", "codelldb", "netcoredbg", "ts-debug-adapter" },
        handlers = {
            function(config)
                -- all sources with no handler get passed here
                -- Keep original functionality
                require('mason-nvim-dap').default_setup(config)
            end,
            coreclr = function(config)
                config.adapters = {
                    type = "executable",
                    command = LspCommon.get_netcoredbg_path(),
                    args = { "--interpreter=vscode" }
                }
                require('mason-nvim-dap').default_setup(config)
            end
        }
    },
    config = function(_, opts)
        require("mason-nvim-dap").setup(opts)
    end
}, {
    "theHamsta/nvim-dap-virtual-text",
    opts = {}
} }
