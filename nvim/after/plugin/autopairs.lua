local autopairs_status, autopairs = pcall(require, "nvim-autopairs")
if not autopairs_status then
    vim.notify("nvim-autopairs not found!")
    return
end

autopairs.setup({
    check_ts = true, -- enable treesitter
    ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
    }
})

local cmp_autopairs_status, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopairs_status then
    vim.notify("nvim-autopairs.completion.cmp not found!")
    return
end


local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
    vim.notify("cmp not found!")
    return
end

-- make autopairs and completion work together
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())