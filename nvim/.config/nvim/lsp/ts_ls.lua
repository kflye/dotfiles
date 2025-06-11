vim.lsp.config('ts_ls', {
    -- nvim-lspconfig has a default on attach
    -- on_attach = function(client, bufnr)
    --     -- uncomment if using prettier...
    --     client.server_capabilities.documentFormattingProvider = false
    --     client.server_capabilities.documentRangeFormattingProvider = false
    --     nmap('<leader>rf', ':TypescriptRenameFile<CR>', '[TS] [R]ename [F]ile', bufnr) -- rename file and update imports
    --     nmap('<leader>oi', function()
    --             vim.lsp.buf.code_action({
    --                 apply = true,
    --                 context = {
    --                     only = { 'source.organizeImports' },
    --                     diagnostics = {},
    --                 },
    --             })
    --         end, '[TS] [O]rganize [I]mports',
    --         bufnr)
    -- end,

    init_options = {
        hostInfo = 'neovim',
        preferences = {
            -- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3439
            importModuleSpecifierPreference = 'relative',
            importModuleSpecifierEnding = 'minimal',
            includeInlayParameterNameHints = 'literals', -- 'all' | 'none' | 'literals'
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false
        }
    }
})