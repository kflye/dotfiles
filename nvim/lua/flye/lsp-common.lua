local M = {
    tsserver_lang_settings = {
        inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true
        }
    }
}

function M.get_eclipse_launcher()
    local mason_registry = require("mason-registry")

    local codelldb_root = mason_registry.get_package("jdtls"):get_install_path()
    local codelldb_path = codelldb_root .. "/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017"

    return codelldb_path
end

function M.get_jdtls_config_dir()
    local mason_registry = require("mason-registry")

    local codelldb_root = mason_registry.get_package("jdtls"):get_install_path()
    local codelldb_path = codelldb_root .. "/config_"

    local this_os = vim.loop.os_uname().sysname

    if this_os:find "Windows" then
        codelldb_path = codelldb_path .. "win"
    else
        codelldb_path = codelldb_path .. "linux"
    end

    return codelldb_path
end

function M.get_codelldb_path()
    local mason_registry = require("mason-registry")

    local codelldb_root = mason_registry.get_package("codelldb"):get_install_path()
    local codelldb_path = codelldb_root .. "/codelldb"
    local this_os = vim.loop.os_uname().sysname

    if this_os:find "Windows" then
        codelldb_path = codelldb_root .. "/extension/" .. "adapter\\codelldb.exe"
    else
    end

    return codelldb_path
end

function M.get_liblldb_path()
    local mason_registry = require("mason-registry")

    local codelldb_root = mason_registry.get_package("codelldb"):get_install_path()
    local liblldb_path = codelldb_root .. "/extension/" .. "lldb/lib/liblldb"
    local this_os = vim.loop.os_uname().sysname

    if this_os:find "Windows" then
        liblldb_path = codelldb_root .. "/extension/" .. "lldb\\bin\\liblldb.dll"
    else
        -- The liblldb extension is .so for linux and .dylib for macOS
        liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
    end

    return liblldb_path
end

function M.get_netcoredbg_path()
    local mason_registry = require("mason-registry")

    local netcoredbg_path = mason_registry.get_package("netcoredbg"):get_install_path()
    netcoredbg_path = netcoredbg_path .. "/netcoredbg"
    local this_os = vim.loop.os_uname().sysname

    if this_os:find "Windows" then
        netcoredbg_path = netcoredbg_path .. "\\netcoredbg.exe"
    else
        -- The liblldb extension is .so for linux and .dylib for macOS
        netcoredbg_path = netcoredbg_path .. "\\netcoredbg" .. (this_os == "Linux" and ".so" or ".dylib")
    end

    return netcoredbg_path
end

function M.lsp_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    return capabilities
end

M.lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150
}

M.float_opts = {
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
    focusable = true,
    source = true,
    header = '',
    prefix = '',
    winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None'
}

local nmap = function(keys, func, desc, bufnr)
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

M.nmap = nmap

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        -- LSP actions
        nmap('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition', bufnr)
        nmap('<leader>gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation', bufnr)
        nmap('<leader>go', require('telescope.builtin').lsp_type_definitions, 'Type Definition', bufnr)
        nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences', bufnr)

        nmap('K', vim.lsp.buf.hover, 'Hover Documentation', bufnr)
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', bufnr)

        nmap('<leader>sds', require('telescope.builtin').lsp_document_symbols, '[S]earch [D]ocument [S]ymbols', bufnr)
        nmap('<leader>sdS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols', bufnr)

        -- Lesser used LSP functionality
        nmap('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', bufnr)
        -- add/remove/list workspace_folders

        nmap('<leader>re', vim.lsp.buf.rename, '[R]ename [E]lement', bufnr)
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ctions', bufnr)
        nmap('<leader>cr', vim.lsp.codelens.run, '[C]odelens [R]un', bufnr)

        nmap('<leader>=', function()
            vim.lsp.buf.format {
                async = true
            }
        end, 'Format current buffer with LSP', bufnr)

        if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(args.buf, true)
        end

        if client and client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = args.buf,
                callback = vim.lsp.codelens.refresh
            })
        end

        if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = args.buf,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = args.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end
})

return M;
