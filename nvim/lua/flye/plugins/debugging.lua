local LspCommon = require("flye.lsp-common")

return {{
    "mfussenegger/nvim-dap",
    dependencies = {{"rcarriga/nvim-dap-ui"}, {'williamboman/mason.nvim'}, {'jay-babu/mason-nvim-dap.nvim'}},
    cond = not vim.g.vscode,
    init = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end,

}, {
    "rcarriga/nvim-dap-ui",
    opts = {},
    cond = not vim.g.vscode,

    keys = {{
        '<F5>',
        function()
            require('dap').continue()
        end,
        desc = "dap start/continue"
    }, {
        '<F10>',
        function()
            require('dap').step_over()
        end,
        desc = "dap step over"
    }, {
        '<F11>',
        function()
            require('dap').step_into()
        end,
        desc = "dap step into"
    }, {
        '<S-F11>',
        function()
            require('dap').step_out()
        end,
        desc = "dap step out"
    }, {
        '<Leader>rs',
        function()
            require('dap').terminate()
        end,
        desc = "dap [R]un [S]top"
    }, {
        '<F7>',
        function()
            require('dapui').toggle()
        end,
        desc = "dapui toggle (see last session)"
    }, {
        '<Leader>tb',
        function()
            require('dap').toggle_breakpoint()
        end,
        desc = "dap [T]oggle [B]reakpoint"
    }, {
        '<Leader>tB',
        function()
            require('dap').set_breakpoint()
        end,
        desc = "dap set breakpoint"
    }, {
        '<Leader>tlp',
        function()
            require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
        end,
        desc = "dap set breakpoint print"
    }, {
        '<Leader>dr',
        function()
            require('dap').repl.open()
        end,
        desc = "dap [D]ebug [R]epl open"
    }, {
        '<Leader>dl',
        function()
            require('dap').run_last()
        end,
        desc = "dap [D]ebug run [L]ast"
    }, {
        '<Leader>dh',
        function()
            require('dap.ui.widgets').hover()
        end,
        desc = "dap [D]ebug [H]over"
    }, -- todo: also visual mode !
    {
        '<Leader>dp',
        function()
            require('dap.ui.widgets').preview()
        end,
        desc = "dap [D]ebug [P]review"
    }, -- todo: also visual mode !
    {
        '<Leader>df',
        function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end,
        desc = "dap [D]ebug [F]rames"
    }, {
        '<Leader>ds',
        function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
        end,
        desc = "dap [D]ebug [S]copes"
    }}
}, {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
        {'williamboman/mason.nvim'}
    },
    cond = not vim.g.vscode,
    opts = {
        ensure_installed = {"coreclr", "codelldb", "netcoredbg"},
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
                    args = {"--interpreter=vscode"}
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
    cond = not vim.g.vscode,
    opts = {}
}}
