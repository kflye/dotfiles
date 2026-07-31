-- Formatting via conform.nvim (replaces none-ls formatting).
-- prettier handles web filetypes; everything else falls back to the LSP
-- formatter (e.g. gopls, lua_ls) via `lsp_format = 'fallback'`.
--
-- Format-on-save is DISABLED. Formatting is manual only via `<leader>=`.
-- To re-enable format-on-save, replace the `format_on_save = false` line below
-- with this function:
--     format_on_save = function(bufnr)
--         if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
--             return
--         end
--         return { timeout_ms = 1000, lsp_format = 'fallback' }
--     end,
return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>=',
            function()
                require('conform').format({ async = true, lsp_format = 'fallback' })
            end,
            mode = { 'n', 'v' },
            desc = 'Format buffer',
        },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
        -- Only list filetypes that need an external formatter. Unlisted
        -- filetypes fall back to their LSP formatter (see format_on_save).
        formatters_by_ft = {
            javascript = { 'prettier' },
            javascriptreact = { 'prettier' },
            typescript = { 'prettier' },
            typescriptreact = { 'prettier' },
            json = { 'prettier' },
            jsonc = { 'prettier' },
            css = { 'prettier' },
            scss = { 'prettier' },
            html = { 'prettier' },
            yaml = { 'prettier' },
            markdown = { 'prettier' },
        },
        -- Manual formatting only (via <leader>=). See header comment to re-enable
        -- format-on-save.
        format_on_save = false,
    },
    init = function()
        -- Use conform for gq / the 'formatexpr' path too.
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
