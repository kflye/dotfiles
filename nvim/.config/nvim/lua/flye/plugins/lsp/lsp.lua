-- Diagnostic keymaps
-- LSP Diagnostics Options Setup

vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = false, -- default
    underline = true,         -- default
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.HINT] = '󰌶',
            [vim.diagnostic.severity.INFO] = '󰋽',
        },
    }
})

vim.keymap.set('n', 'gre', vim.diagnostic.open_float, { desc = '[C]ode [E]rror / diagnostic float' })
vim.keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
vim.keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })
-- Add buffer diagnostics to the location list.
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

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

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
        vim.keymap.set({ 'n' }, '<leader>c', '', { desc = '+code' })

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local bufnr = event.buf

        vim.keymap.set({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help,
            { desc = 'LSP: Signature Documentation', buffer = bufnr, noremap = true, silent = true })

        -- nmap('<leader>sds', require('fzf-lua').lsp_document_symbols, '[S]earch [D]ocument [S]ymbols', bufnr)
        -- nmap('<leader>sdS', require('fzf-lua').lsp_workspace_symbols, '[S]earch [W]orkspace [S]ymbols', bufnr)

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', bufnr)
        -- add/remove/list workspace_folders


        -- The following autocommand is used o enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true)
            nmap('<leader>ch', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, '[C]ode toggle Inlay [H]ints')
        end
    end
})

-- Enable LSP servers configured in the `lsp/` directory (Neovim 0.11+ native).
-- nvim-lspconfig supplies the upstream `cmd`/`filetypes`/`root_markers`; the
-- local `lsp/*.lua` files deep-merge our `settings`/`on_init` overrides on top.
vim.lsp.enable({
    'ts_ls',
    'lua_ls',
    'eslint',
    'angularls',
    'helm_ls',
    'powershell_es',
})

return {
    {
        'mason-org/mason.nvim',
        opts = {
            registries = {
                -- 'github:nvim-java/mason-registry',
                'github:mason-org/mason-registry',
            },
        },
        config = true
    },
    -- nvim-lspconfig is kept for its maintained `lsp/*.lua` server definitions
    -- (cmd/filetypes/root_markers), which Neovim merges with our local overrides.
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'qvalentin/helm-ls.nvim', ft = 'helm' },
        },
    },
    -- Auto-Install LSPs, linters, formatters, debuggers
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
            -- NOTE: these are mason REGISTRY package names, not LSP/lspconfig
            -- names. mason-lspconfig used to translate LSP names (ts_ls, eslint,
            -- lua_ls) to package names; without it, use registry names directly.
            ensure_installed = {
                'typescript-language-server', -- ts_ls
                'eslint-lsp',                 -- eslint
                'angular-language-server',    -- angularls (ngserver)
                'eslint_d',
                'prettier',
                'codelldb',
                'netcoredbg',
                'lua-language-server',        -- lua_ls
                'js-debug-adapter'
            },
        },
        dependencies = {
            'mason-org/mason.nvim',
        }
    },
}
