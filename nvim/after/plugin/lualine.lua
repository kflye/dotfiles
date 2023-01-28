local lualine_status, lualine = pcall(require, "lualine")
if not lualine_status then
    vim.notify("lualine not found")
    return
end

lualine.setup({
    options = {
        theme = 'gruvbox'
    }
})
