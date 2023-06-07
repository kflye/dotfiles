local M = {}

function M.on_attach(client, bufnr)
    vim.notify("m.on_attach")
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
    if client.server_capabilities.codeLensProvider then
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
        })
    end
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
    source = true,
    header = '',
    prefix = '',
    winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
}

return M;
