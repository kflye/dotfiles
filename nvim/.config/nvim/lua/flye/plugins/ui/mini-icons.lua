-- mini.icons replaces nvim-web-devicons (the current community default).
-- `mock_nvim_web_devicons()` lets plugins that still `require('nvim-web-devicons')`
-- (neo-tree, lualine, etc.) keep working without the actual plugin installed.
return {
    {
        "echasnovski/mini.icons",
        version = false,
        lazy = true,
        opts = {},
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    }
}
