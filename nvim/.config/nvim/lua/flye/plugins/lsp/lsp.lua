local LspCommon = require('flye.lsp-common')

-- Diagnostic keymaps
-- LSP Diagnostics Options Setup
local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({ name = 'DiagnosticSignError', text = '󰅚' })
sign({ name = 'DiagnosticSignWarn', text = '󰀪' })
sign({ name = 'DiagnosticSignHint', text = '󰌶' })
sign({ name = 'DiagnosticSignInfo', text = '󰋽' })

vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = false, -- default
    underline = true,         -- default
    severity_sort = true,
    float = LspCommon.float_opts,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.HINT] = '󰌶',
            [vim.diagnostic.severity.INFO] = '󰋽',
        },
    }
})

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

        -- TODO: new defaults from nvim 0.11.1
        --
        -- grn in Normal mode maps to vim.lsp.buf.rename()
        -- grr in Normal mode maps to vim.lsp.buf.references()
        -- gri in Normal mode maps to vim.lsp.buf.implementation()
        -- gO in Normal mode maps to vim.lsp.buf.document_symbol() (this is analogous to the gO mappings in help buffers and :Man page buffers to show a “table of contents”)
        -- gra in Normal and Visual mode maps to vim.lsp.buf.code_action()
        -- CTRL-S in Insert and Select mode maps to vim.lsp.buf.signature_help()
        -- [d and ]d move between diagnostics in the current buffer ([D jumps to the first diagnostic, ]D jumps to the last)
        --
        -- LSP actions
        nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition', bufnr)
        nmap('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation', bufnr)
        nmap('go', require('telescope.builtin').lsp_type_definitions, 'Type Definition', bufnr)
        nmap('gr', function()
            require('telescope.builtin').lsp_references({ include_declaration = false })
        end, '[G]oto [R]eferences', bufnr)

        nmap('K', vim.lsp.buf.hover, 'Hover Documentation', bufnr)
        vim.keymap.set({ 'n', 'i' }, '<C-M-k>', vim.lsp.buf.signature_help,
            { desc = 'LSP: Signature Documentation', buffer = bufnr, noremap = true, silent = true })

        nmap('<leader>sds', require('telescope.builtin').lsp_document_symbols, '[S]earch [D]ocument [S]ymbols', bufnr)
        nmap('<leader>sdS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols', bufnr)

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', bufnr)
        -- add/remove/list workspace_folders

        nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename ', bufnr)
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ctions', bufnr)
        nmap('<leader>cc', vim.lsp.codelens.run, '[C]odelens run', bufnr)
        nmap('<leader>cC', vim.lsp.codelens.refresh, '[C]odelens run', bufnr)

        nmap('<leader>=', function()
            vim.lsp.buf.format {
                async = true
            }
        end, 'Format current buffer with LSP', bufnr)

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            -- The following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the second autocommand).
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

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
            })
        end

        -- The following autocommand is used o enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true)
            nmap('<leader>ch', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, '[C]ode toggle Inlay [H]ints')
        end
    end
})

vim.keymap.set('n', '<leader>ce', vim.diagnostic.open_float, { desc = '[C]ode [E]rror / diagnostic float' })
vim.keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
vim.keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })
-- Add buffer diagnostics to the location list.
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


vim.lsp.config('lua_ls',
    {
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath('config')
                    and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most
                    -- likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Tell the language server how to find Lua modules same way as Neovim
                    -- (see `:h lua-module-load`)
                    path = {
                        'lua/?.lua',
                        'lua/?/init.lua',
                    },
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        '${3rd}/luv/library'
                    }
                }
            })
        end,

        settings = {
            Lua = {
                -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                format = {
                    enable = true,
                    defaultConfig = {
                        max_line_length = '160'
                    }
                },
                completion = {
                    callSnippet = 'Replace'
                }
            }
        },
    })



vim.lsp.config('eslint', {
    settings = {
        packageManager = 'npm',
    }
})
vim.lsp.config('helm_ls', {
    settings = {
        ['helm-ls'] = {
            yamlls = {
                path = "yaml-language-server",
            }
        }
    }
})

vim.lsp.config('powershell_es', {
    bundle_path = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services/'
})

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

vim.lsp.config('angularls', {
    on_attach = function(client, bufnr)
        nmap('<leader>gat', function()
            local r, c = unpack(vim.api.nvim_win_get_cursor(0))
            local args = {
                textDocument = { uri = 'file://' .. vim.api.nvim_buf_get_name(bufnr) },
                position = { line = r, character = c },
            }
            print('go to angular template', vim.inspect(args))
            local util = require('vim.lsp.util')

            client.request('angular/getTemplateLocationForComponent', args,
                function(err, result, ctx, config)
                    config = config or {}
                    if result then
                        util.jump_to_location(result, client.offset_encoding, config.reuse_win)
                    end
                end, bufnr)
        end, '[G]o to [A]ngular [T]emplate', bufnr)

        nmap('<leader>gac', function()
            local args = {
                textDocument = { uri = 'file://' .. vim.api.nvim_buf_get_name(bufnr) },
            }
            print('go to angular component', vim.inspect(args))
            local util = require('vim.lsp.util')

            client.request('angular/getComponentsWithTemplateFile', args,
                function(err, result, ctx, config)
                    config = config or {}
                    if result then
                        util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
                    end
                end, bufnr)
        end, '[G]o to [A]ngular [C]omponent', bufnr)
    end,
})

return {
    {
        'williamboman/mason.nvim',
        opts = {
            registries = {
                -- 'github:nvim-java/mason-registry',
                'github:mason-org/mason-registry',
            },
        },
        config = true
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { 'folke/neodev.nvim' },
            { 'neovim/nvim-lspconfig' },
            { 'qvalentin/helm-ls.nvim', ft = 'helm' }
        },
        opts = {
            ensure_installed = {},
        },
        config = function(_, opts)
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, LspCommon.float_opts)
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
                LspCommon.float_opts)

            require('mason-lspconfig').setup(opts)
        end

    },
    -- Auto-Install LSPs, linters, formatters, debuggers
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
            ensure_installed = {
                'ts_ls',
                'eslint',
                'eslint_d',
                'prettier',
                'codelldb',
                'netcoredbg',
                'lua_ls',
            },
        },
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
        }
    },
}
