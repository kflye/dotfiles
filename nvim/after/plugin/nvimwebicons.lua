local web_icons_status, web_icons = pcall(require, "nvim-web-devicons")
if not web_icons_status then
    vim.notify("nvim-web-devicons not found!")
    return
end

web_icons.setup()
