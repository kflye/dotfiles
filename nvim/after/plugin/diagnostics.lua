local lsp_common_status, lsp_common = pcall(require, "flye.lsp-common")
if not lsp_common_status then
    vim.notify('flye-lsp-common not found')
    return
end

-- Diagnostic keymaps
-- LSP Diagnostics Options Setup
local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '' })
sign({ name = 'DiagnosticSignHint', text = '' })
sign({ name = 'DiagnosticSignInfo', text = '' })

vim.diagnostic.config({
    virtual_text = true,
    signs = true,             -- default
    update_in_insert = false, -- default
    underline = true,         -- default
    severity_sort = true,
    float = lsp_common.float_opts,
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>sx', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
