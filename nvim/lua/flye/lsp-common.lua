local M = {
    tsserver_lang_settings = {
        inlayHints = {
            includeInlayParameterNameHints = 'literals', -- "all" | "none" | "literals"
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false
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
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        -- LSP actions
        nmap('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition', bufnr)
        nmap('<leader>gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation', bufnr)
        nmap('<leader>go', require('telescope.builtin').lsp_type_definitions, 'Type Definition', bufnr)
        -- nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences', bufnr)
        nmap('<leader>gr', function()
            require('telescope.builtin').lsp_references({ include_declaration = false })
        end, '[G]oto [R]eferences', bufnr)

        nmap('K', vim.lsp.buf.hover, 'Hover Documentation', bufnr)
        -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', bufnr)
        nmap('<C-M-k>', vim.lsp.buf.signature_help, 'Signature Documentation', bufnr)

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

        if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            nmap('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
        end
    end
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
    callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event.buf }
    end,
})

return M;
