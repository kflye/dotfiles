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

local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_ok then
    vim.notify("cmp_nvim_lsp not found")
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

neodev.setup({
    -- add any options here, or leave empty to use the default settings
    library = { plugins = { "nvim-dap-ui" }, types = true },
})

mason.setup({})

mason_lsp.setup {
    automatic_installation = false,
    ensure_installed = { "lua_ls", "rust_analyzer", "omnisharp", "tsserver", "yamlls", "dockerls", "powershell_es" }
}

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
    virtual_text = { source = true },
    signs = true,             -- default
    update_in_insert = false, -- default
    underline = true,         -- default
    severity_sort = true,
    float = {
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
    },
})

-- TODO: Is this better than virtual_text, with <leader>e to open float
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])


vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>sx', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, {
            buffer = bufnr,
            noremap = true,
            silent = true,
            desc = desc
        })
    end

    -- LSP actions
    nmap('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('<leader>gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>go', require('telescope.builtin').lsp_type_definitions, 'Type Definition')
    nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    nmap('<leader>sds', require('telescope.builtin').lsp_document_symbols, '[S]earch [D]ocument [S]ymbols')
    nmap('<leader>sdS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols')

    -- Lesser used LSP functionality
    nmap('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    -- add/remove/list workspace_folders

    nmap('<leader>re', vim.lsp.buf.rename, '[R]ename [E]lement')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ctions')
    -- TODO: Code actions for current document? or use diagnostics to find, and then code_actions?

    nmap('<leader>=', function()
        vim.lsp.buf.format {
            async = true
        }
    end, 'Format current buffer with LSP')

    -- typescript specific keymaps (e.g. rename file and update imports)
    if client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        nmap("<leader>rf", ":TypescriptRenameFile<CR>", '[TS] [R]ename [F]ile')           -- rename file and update imports
        nmap("<leader>oi", ":TypescriptOrganizeImports<CR>", '[TS] [O]rganize [I]mports') -- organize imports (not in youtube nvim video)
        -- vim.keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
    end
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150
}

local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig['lua_ls'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
        Lua = {
            -- diagnostics = {
            --     globals = { "vim" }
            -- },
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
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags
}

lspconfig['omnisharp'].setup {
    capabilities = capabilities,
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
        on_attach(client, bufnr)
    end,
    flags = lsp_flags
}

lspconfig['rust_analyzer'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
        ["rust-analyzer"] = {}
    }
}

lspconfig['jsonls'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags
}

lspconfig['powershell_es'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/"
}

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    sources = { formatting.prettier, diagnostics.eslint_d --- do whatever you need to do
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
