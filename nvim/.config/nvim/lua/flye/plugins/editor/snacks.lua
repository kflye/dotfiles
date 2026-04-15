return {
    "folke/snacks.nvim",
    keys = {
        -- Top Pickers & Explorer
        -- { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
        { "<leader>,",  function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
        { "<leader>/",  function() Snacks.picker.grep() end,                                    desc = "Grep" },
        { "<leader>:",  function() Snacks.picker.command_history() end,                         desc = "Command History" },
        { "<leader>n",  function() Snacks.picker.notifications() end,                           desc = "Notification History" },
        { "<leader>e",  function() Snacks.explorer() end,                                       desc = "File Explorer" },
        -- git
        { '<leader>g',  '',                                                                     desc = '+git' },
        { "<leader>gb", function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end,                              desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
        -- Grep
        { "<leader>sB", function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end,                                    desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
        -- search / find
        { '<leader>s',  '',                                                                     desc = '+search' },
        { "<leader>sb", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
        { "<leader>sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>sf", function() Snacks.picker.files({ hidden = true }) end,                  desc = "Find Files" },
        { "<leader>sp", function() Snacks.picker.projects() end,                                desc = "Projects" },
        { "<leader>sr", function() Snacks.picker.recent() end,                                  desc = "Recent" },
        { "<leader>sg", function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
        { '<leader>s"', function() Snacks.picker.registers() end,                               desc = "Registers" },
        { '<leader>s/', function() Snacks.picker.search_history() end,                          desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
        { "<leader>so", function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end,                         desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end,                                desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end,                                    desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end,                              desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end,                                   desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end,                                 desc = "Location List" },
        { "<leader>sm", function() Snacks.picker.marks() end,                                   desc = "Marks" },
        { "<leader>sM", function() Snacks.picker.man() end,                                     desc = "Man Pages" },
        { "<leader>sp", function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
        { "<leader>sR", function() Snacks.picker.resume() end,                                  desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end,                                    desc = "Undo History" },
        { "<leader>uC", function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
        -- LSP
        { "grd",        function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
        { "grD",        function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
        { "grr",        function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
        { "gri",        function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
        { "grt",        function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
        { "gO",         function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
        { "gai",        function() Snacks.picker.lsp_incoming_calls() end,                      desc = "C[a]lls Incoming" },
        { "gao",        function() Snacks.picker.lsp_outgoing_calls() end,                      desc = "C[a]lls Outgoing" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
        -- Bufdelete
        { "<leader>bd", function() Snacks.bufdelete() end,                                      desc = "Delete current buffer" },
        { "<leader>qa", function() Snacks.bufdelete.other() end,                                desc = "Delete other buffers" },
        { "<leader>qA", function() Snacks.bufdelete.all() end,                                  desc = "Delete all buffers" },
        -- Terminal
        { "<leader>wT", function() Snacks.terminal.toggle() end,                                desc = "Terminal" },

    },
    init = function()
        vim.notify = require("snacks.notifier").notify

        ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
        local progress = vim.defaulttable()
        vim.api.nvim_create_autocmd("LspProgress", {
            ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
                if not client or type(value) ~= "table" then
                    return
                end
                local p = progress[client.id]

                for i = 1, #p + 1 do
                    if i == #p + 1 or p[i].token == ev.data.params.token then
                        p[i] = {
                            token = ev.data.params.token,
                            msg = ("[%3d%%] %s%s"):format(
                                value.kind == "end" and 100 or value.percentage or 100,
                                value.title or "",
                                value.message and (" **%s**"):format(value.message) or ""
                            ),
                            done = value.kind == "end",
                        }
                        break
                    end
                end

                local msg = {} ---@type string[]
                progress[client.id] = vim.tbl_filter(function(v)
                    return table.insert(msg, v.msg) or not v.done
                end, p)

                local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                vim.notify(table.concat(msg, "\n"), "info", {
                    id = "lsp_progress",
                    title = client.name,
                    opts = function(notif)
                        notif.icon = #progress[client.id] == 0 and " "
                            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                    end,
                })
            end,
        })
    end,
    ---@type snacks.Config
    opts = {
        picker = {
            sources = {
                files = { ignored = false, hidden = true },
                explorer = { ignored = false, hidden = true },
                grep = { ignored = false, hidden = true },
                grep_word = { ignored = false, hidden = true },
                grep_buffers = { ignored = false, hidden = true },
            }
        },
        explorer = { enabled = true },
        notifier = { enabled = true },
        input = { enabled = true },
        terminal = { enabled = true },
    }
}
