-- Highlight on yank

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function(args)
        vim.highlight.on_yank { 
            higroup = "Visual",
            timeout = 300
        }
    end,
    desc = "TextYankPost description"
})