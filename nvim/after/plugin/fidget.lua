local fidget_status, fidget = pcall(require, "fidget")
if not fidget_status then
    vim.notify("fidget not found!")
    return
end

fidget.setup()