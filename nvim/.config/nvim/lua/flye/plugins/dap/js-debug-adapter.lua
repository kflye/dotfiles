local dap = require("dap")
require('flye.global')

local dap_executable = get_pkg_path('js-debug-adapter', 'js-debug/src/dapDebugServer.js')

local enter_launch_url = function()
    local co = coroutine.running()
    return coroutine.create(function()
        vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:" }, function(url)
            if url == nil or url == "" then
                return
            else
                coroutine.resume(co, url)
            end
        end)
    end)
end

for _, type in ipairs({
    "node",
    "chrome",
    "pwa-node",
    "pwa-chrome",
    "pwa-msedge",
    "node-terminal",
    "pwa-extensionHost",
}) do
    local host = "localhost"
    dap.adapters[type] = {
        type = "server",
        host = host,
        port = "${port}",
        executable = {
            command = "node",
            args = { dap_executable, "${port}", host },
        },
    }
end
for _, lang in ipairs({
    "typescript",
    "javascript",
}) do
    dap.configurations[lang] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file using Node.js (nvim-dap)",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process using Node.js (nvim-dap)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome (nvim-dap)",
            url = enter_launch_url,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
        },
        {
            type = "pwa-msedge",
            request = "launch",
            name = "Launch Edge (nvim-dap)",
            url = enter_launch_url,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
        },
    }
end
