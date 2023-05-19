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

local rusttools_status, rusttools = pcall(require, "rust-tools")
if not rusttools_status then
    vim.notify('rust-tools not found')
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

local float_opts = {
    border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
    },

    -- Maximal width of the hover window. Nil means no max.
    max_width = nil,

    -- Maximal height of the hover window. Nil means no max.
    max_height = nil,

    -- whether the hover action window gets automatically focused
    -- default: false
    auto_focus = false,
    source = true,
    header = '',
    prefix = '',
}

vim.diagnostic.config({
    virtual_text = true,
    signs = true,             -- default
    update_in_insert = false, -- default
    underline = true,         -- default
    severity_sort = true,
    float = float_opts,
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, float_opts
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, float_opts
)

-- TODO: Is this better than virtual_text, with <leader>e to open float
-- vim.cmd([[
-- set signcolumn=yes
-- autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
-- ]])


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


local mason_registry = require("mason-registry")

local codelldb_root = mason_registry.get_package("codelldb"):get_install_path()
local codelldb_path = codelldb_root .. "/codelldb"
local liblldb_path = codelldb_root .. "/extension/" .. "lldb/lib/liblldb"
local this_os = vim.loop.os_uname().sysname

if this_os:find "Windows" then
    codelldb_path = codelldb_root .. "/extension/" .. "adapter\\codelldb.exe"
    liblldb_path = codelldb_root .. "/extension/" .. "lldb\\bin\\liblldb.dll"
else
    -- The liblldb extension is .so for linux and .dylib for macOS
    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

vim.notify(liblldb_path)
vim.notify(codelldb_path)
local opts = {
    tools = {
        executor = require("rust-tools.executors").termopen, -- options right now: termopen / quickfix

        -- callback to execute once rust-analyzer is done initializing the workspace
        -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
        on_initialized = nil,

        -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
        reload_workspace_from_cargo_toml = true,

        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
        },
    },

    server = {
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.keymap.set("n", "K", rusttools.hover_actions.hover_actions,
                { buffer = bufnr, desc = "Rusttools hover actions" })

            vim.keymap.set("n", "<leader>rd", rusttools.debuggables.debuggables)
            vim.keymap.set("n", "<leader>ru", rusttools.runnables.runnables)
            -- add hover options back if rust-tool specific hovers are used
        end
    }, -- rust-analyzer options

    -- debugging stuff
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(
            codelldb_path,
            liblldb_path
        ),
    },
}
-- rust tools wiki - https://github.com/simrat39/rust-tools.nvim/wiki/Debugging
-- https://github.com/simrat39/dotfiles/blob/master/nvim/.config/nvim/lua/sim_config/rust-tools.lua
-- https://alpha2phi.medium.com/modern-neovim-debugging-and-testing-8deda1da1411 -
-- random example setup https://gitlab.com/david_wright/nvim/-/blob/main/lua/plugins/rust_tools.lua
-- youtube video
-- https://github.com/cpow/cpow-dotfiles/blob/master/lua/core/plugin_config/rust_config.lua
-- https://github.com/ChristianChiarulli/lvim/tree/master
rusttools.setup(opts)

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
