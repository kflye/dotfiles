return { --    use 'folke/tokyonight.nvim'
{
    "gruvbox-community/gruvbox",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
        local colorsheme = "gruvbox"

        local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorsheme)

        if not status_ok then
            vim.notify("colorsheme " .. colorsheme .. " not found!")
            return
        end
    end
}}
