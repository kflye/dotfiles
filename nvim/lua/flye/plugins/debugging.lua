return {
    {
        "mfussenegger/nvim-dap",
        init = function()
            local dap = require("dap")
            local dapui = require("dapui")

            --  -- TODO: check with rust how these should behave
            --    dap.defaults.fallback.terminal_win_cmd = 'tabnew'
            --    dap.defaults.fallback.focus_terminal = false

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
        dependencies = {
            { "theHamsta/nvim-dap-virtual-text", opts = {} },
            {
                "rcarriga/nvim-dap-ui",
                opts = {},

                keys = {
                    {
                        '<F5>',
                        function()
                            require('dap').continue()
                        end,
                        desc = "dap continue"
                    },
                    {
                        '<F10>',
                        function()
                            require('dap').step_over()
                        end,
                        desc = "dap step over"
                    },
                    {
                        '<F11>',
                        function()
                            require('dap').step_into()
                        end,
                        desc = "dap step into"
                    },
                    {
                        '<S-F11>',
                        function()
                            require('dap').step_out()
                        end,
                        desc = "dap step out"
                    },
                    {
                        '<Leader>rs',
                        function()
                            require('dap').terminate()
                        end,
                        desc = "dap [R]un [S]top"
                    },
                    {
                        '<Leader>tb',
                        function()
                            require('dap').toggle_breakpoint()
                        end,
                        desc = "dap [T]oggle [B]reakpoint"
                    },
                    {
                        '<Leader>tB',
                        function()
                            require('dap').set_breakpoint()
                        end,
                        desc = "dap set breakpoint"
                    },
                    {
                        '<Leader>tlp',
                        function()
                            require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
                        end,
                        desc = "dap set breakpoint print"
                    },
                    {
                        '<Leader>dr',
                        function()
                            require('dap').repl.open()
                        end,
                        desc = "dap [D]ebug [R]epl open"
                    },
                    {
                        '<Leader>dl',
                        function()
                            require('dap').run_last()
                        end,
                        desc = "dap [D]ebug run [L]ast"
                    },
                    {
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
                    },
                    {
                        '<Leader>ds',
                        function()
                            local widgets = require('dap.ui.widgets')
                            widgets.centered_float(widgets.scopes)
                        end,
                        desc = "dap [D]ebug [S]copes"
                    }
                }
            }
        }
    } }
