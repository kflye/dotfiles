return {
    "folke/noice.nvim",
    enabled = false,
    cond = not vim.g.vscode,
    event = "VeryLazy",
    opts = {
        lsp = {
            progress = {
                enabled = false -- I already use fidget configured in ./lsp.lua
            },
            override = {
                -- override the default lsp markdown formatter with Noice
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                -- override the lsp markdown formatter with Noice
                ["vim.lsp.util.stylize_markdown"] = true,
                -- override cmp documentation with Noice (needs the other options to work)
                ["cmp.entry.get_documentation"] = true,
            },
        },
        routes = {
            -- skip displaying message that file was written to.
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "written"
                },
                opts = { skip = true }
            }, {
            filter = {
                event = "msg_show",
                kind = "",
                find = "more lines"
            },
            opts = { skip = true }
        }, {
            filter = {
                event = "msg_show",
                kind = "",
                find = "fewer lines"
            },
            opts = { skip = true }
        }, {
            filter = {
                event = "msg_show",
                kind = "",
                find = "lines yanked"
            },
            opts = { skip = true }
        },
        },
        presets = {
            -- you can enable a preset by setting it to true, or a table that will override the preset config
            -- you can also add custom presets that you can enable/disable with enabled=true
            bottom_search = true,         -- use a classic bottom cmdline for search
            command_palette = true,       -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            -- lsp_doc_border = true, -- add a border to hover docs and signature help
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        -- optional
        "rcarriga/nvim-notify",
    },
    keys = {
        {
            "<leader>nd",
            function() vim.cmd("Noice dismiss") end,
            desc = "[N]oice [D]ismiss",
            mode = "n",
            noremap = true,
            silent = true
        },
        {
            "<leader>nl",
            function() vim.cmd("Noice last") end,
            desc = "[N]oice [L]ast",
            mode = "n",
            noremap = true,
            silent = true
        },
        {
            "<leader>nh",
            function() vim.cmd("Noice history") end,
            desc = "[N]oice [H]istory",
            mode = "n",
            noremap = true,
            silent = true
        }

    },
}
