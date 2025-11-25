local dap = require("dap")
require('flye.global')

local dap_executable = get_pkg_path('js-debug-adapter', 'js-debug/src/dapDebugServer.js')

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
