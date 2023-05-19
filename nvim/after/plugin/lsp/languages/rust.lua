local rusttools_status, rusttools = pcall(require, "rust-tools")
if not rusttools_status then
    vim.notify('rust-tools not found')
    return
end

local status_ok, dap = pcall(require, "dap")
if not status_ok then
    vim.notify("nvim-dap not found")
    return
end

local lsp_common_status, lsp_common = pcall(require, "flye.lsp.lsp-common")
if not lsp_common_status then
    vim.notify('flye-lsp-common not found')
    return
end

local mason_registry = require("mason-registry")

local codelldb_root = mason_registry.get_package("codelldb"):get_install_path()
local codelldb_path = codelldb_root .. "/codelldb"
local liblldb_path = codelldb_root .. "/extension/" .. "lldb/lib/liblldb"
local this_os = vim.loop.os_uname().sysname

if this_os:find "Windows" then
    codelldb_path = codelldb_root .. "/extension/" .. "adapter\\codelldb.exe"
    liblldb_path = codelldb_root .. "/extension/" .. "lldb\\bin\\liblldb.dll"
else
    -- The liblldb extension is .so for linux and .dylib for macOS
    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

vim.notify(liblldb_path)
vim.notify(codelldb_path)
local opts = {
    tools = {
        executor = require("rust-tools.executors").termopen, -- options right now: termopen / quickfix

        -- callback to execute once rust-analyzer is done initializing the workspace
        -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
        on_initialized = nil,

        -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
        reload_workspace_from_cargo_toml = true,

        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
        },
    },

    server = {
        on_attach = function(client, bufnr)
            lsp_common.on_attach(client, bufnr)
            vim.keymap.set("n", "K", rusttools.hover_actions.hover_actions,
                { buffer = bufnr, desc = "Rusttools hover actions" })

            vim.keymap.set("n", "<leader>rd", rusttools.debuggables.debuggables)
            vim.keymap.set("n", "<leader>ru", rusttools.runnables.runnables)
            -- add hover options back if rust-tool specific hovers are used
        end
    }, -- rust-analyzer options

    -- debugging stuff
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(
            codelldb_path,
            liblldb_path
        ),
    },
}
-- rust tools wiki - https://github.com/simrat39/rust-tools.nvim/wiki/Debugging
-- https://github.com/simrat39/dotfiles/blob/master/nvim/.config/nvim/lua/sim_config/rust-tools.lua
-- https://alpha2phi.medium.com/modern-neovim-debugging-and-testing-8deda1da1411 -
-- random example setup https://gitlab.com/david_wright/nvim/-/blob/main/lua/plugins/rust_tools.lua
-- youtube video
-- https://github.com/cpow/cpow-dotfiles/blob/master/lua/core/plugin_config/rust_config.lua
-- https://github.com/ChristianChiarulli/lvim/tree/master
rusttools.setup(opts)


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
