vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_transparent = true
vim.opt.background = "dark"

--vim.cmd("colorscheme tokyonight")
--vim.cmd("colorscheme gruvbox")

local colorsheme = "gruvbox"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorsheme)

if not status_ok then 
    vim.notify("colorsheme " .. colorsheme .. " not found!")
    return
end