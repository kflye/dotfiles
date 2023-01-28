local gitsigns_status, gitsigns = pcall(require, "gitsigns")
if not gitsigns_status then
    vim.notify("gitsigns not found!")
    return
end

gitsigns.setup()