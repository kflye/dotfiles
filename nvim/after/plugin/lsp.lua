vim.notify("lsp.lua")
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
    vim.notify("mason not found")
    return
end

local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
if not mason_lsp_ok then
    vim.notify("mason-lspconfig not found")
    return
end

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
    vim.notify("lspconfig not found")
    return
end

local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    vim.notify('null-ls not found!')
    return
end

local neodev_status, neodev = pcall(require, "neodev")
if not neodev_status then
    vim.notify('neodev not found')
    return
end

local lsp_common_status, lsp_common = pcall(require, "flye.lsp.lsp-common")
if not lsp_common_status then
    vim.notify('flye-lsp-common not found')
    return
end

neodev.setup({
    -- add any options here, or leave empty to use the default settings
    library = { plugins = { "nvim-dap-ui" }, types = true },
})

mason.setup({
    ensure_installed = { "codelldb" }
})

mason_lsp.setup {
    automatic_installation = false,
    ensure_installed = { "lua_ls", "rust_analyzer", "omnisharp", "tsserver", "yamlls", "dockerls", "powershell_es" }
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, lsp_common.float_opts
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, lsp_common.float_opts
)

lspconfig['lua_ls'].setup {
    capabilities = lsp_common.capabilities,
    on_attach = lsp_common.on_attach,
    flags = lsp_common.lsp_flags,
    settings = {
        Lua = {
            workspace = {
                checkThirdParty = false,
            },
            completion = { -- comes from https://github.com/folke/neodev.nvim
                callSnippet = "Replace"
            }
        }
    }
}

lspconfig['tsserver'].setup {
    capabilities = lsp_common.capabilities,
    on_attach = lsp_common.on_attach,
    flags = lsp_common.lsp_flags
}

lspconfig['omnisharp'].setup {
    capabilities = lsp_common.capabilities,
    on_attach = function(client, bufnr)
        -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
        local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
        for i, v in ipairs(tokenModifiers) do
            tmp = string.gsub(v, ' ', '_')
            tokenModifiers[i] = string.gsub(tmp, '-_', '')
        end
        local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
        for i, v in ipairs(tokenTypes) do
            tmp = string.gsub(v, ' ', '_')
            tokenTypes[i] = string.gsub(tmp, '-_', '')
        end
        lsp_common.on_attach(client, bufnr)
    end,
    flags = lsp_common.lsp_flags
}

lspconfig['jsonls'].setup {
    capabilities = lsp_common.capabilities,
    on_attach = lsp_common.on_attach,
    flags = lsp_common.lsp_flags
}

lspconfig['powershell_es'].setup {
    capabilities = lsp_common.capabilities,
    on_attach = lsp_common.on_attach,
    flags = lsp_common.lsp_flags,
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/"
}

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    sources = { formatting.prettier, diagnostics.eslint_d
        --- do whatever you need to do
        -- gitsigns / Injects code actions for Git operations at the current cursor position (stage / preview / reset hunks, blame, etc.).
        -- cspell
        -- editorconfig_checker
        -- eslint_d
        -- markdownlint
        -- misspell
        -- todo_comments
        -- yamllint
        -- csharpier
        -- eslint_d
        -- prettierd (md, javascript, react, html, json)
        -- prettier_eslint
    }
})

local mason_null_ls_status_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status_ok then
    vim.notify('mason-null-ls not found!')
    return
end

mason_null_ls.setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = false
})

