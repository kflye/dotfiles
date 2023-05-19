local status_ok, dap = pcall(require, "dap")
if not status_ok then
    vim.notify("nvim-dap not found")
    return
end


local status_ok_dapui, dapui = pcall(require, "dapui")
if not status_ok_dapui then
    vim.notify("nvim-dap-ui not found")
    return
end



dap.adapters.coreclr = {
    type = "executable",
    command = "C:/Program Files (x86)/netcoredbg/netcoredbg.exe",
    args = { "--interpreter=vscode" }
}


-- TODO: check with rust how these should behave
dap.defaults.fallback.terminal_win_cmd = 'tabnew'
dap.defaults.fallback.focus_terminal = false

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
}

-- local mason_registry = require("mason-registry")
--
-- local codelldb_root = mason_registry.get_package("codelldb"):get_install_path()
-- local codelldb_path = codelldb_root .. "/extension/" .. "bin/codelldb"
-- local liblldb_path = codelldb_root .. "/extension/" .. "lldb/lib/liblldb"
-- local this_os = vim.loop.os_uname().sysname
--
-- if this_os:find "Windows" then
--     codelldb_path = codelldb_root .. "/extension/" .. "adapter\\codelldb.exe"
--     liblldb_path = codelldb_root .. "/extension/" .. "lldb\\bin\\liblldb.dll"
-- else
--     -- The liblldb extension is .so for linux and .dylib for macOS
--     liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
-- end
-- dap.adapters.codelldb = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
-- TODO: could this be used with a file per project, what about tests?
-- dap.configurations.rust = {
--     {
--         name = "Launch file",
--         type = "codelldb",
--         request = "launch",
--         program = function()
--             return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--         end,
--         cwd = "${workspaceFolder}",
--         stopOnEntry = false,
--     },
-- }

vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<S-F11>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>tb', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>tB', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>tlp',
    function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
    require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
    require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)

dapui.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
    vim.notify("dap.listeners.after.event_initialized")
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
