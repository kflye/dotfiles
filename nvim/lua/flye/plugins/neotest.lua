---@diagnostic disable: missing-fields
return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            'nvim-neotest/neotest-jest',
            "rcasia/neotest-java",
        },
        config = function()
            require('neotest').setup({
                adapters = {
                    require('neotest-jest')({
                        jestCommand = "ng test",
                        jestConfigFile = "jest.config.ts",
                        env = { CI = true },
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                    }),
                    require("neotest-java")({
                        ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
                    }),
                },
                status = { virtual_text = true },
                output = { open_on_run = false },
                quickfix = {
                    open = function()
                        require("trouble").open({ mode = "quickfix", focus = false })
                    end,
                },
                discovery = {
                    enabled = false,
                },
            })
        end,
        keys = {
            { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File" },
            { "<leader>tF", function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run All Test Files" },
            { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest" },
            { "<leader>td", function() require("neotest").run.run({ strategy = 'dap' }) end,                    desc = "Run Nearest" },
            { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Run Last" },
            { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel" },
            { "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "Stop" },
        },
    },
    {
        'nvim-neotest/neotest',
        dir = "~/neotest-jest/"
    },
    {
        "rcasia/neotest-java",
        init = function()
        end,
    },
}
