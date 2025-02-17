local LspCommon = require('flye.lsp-common')

local default_setup = function(server)
    require('lspconfig')[server].setup({
        capabilities = LspCommon.lsp_capabilities(),
        flags = LspCommon.lsp_flags
    })
end

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
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'neovim/nvim-lspconfig' },
            { 'qvalentin/helm-ls.nvim', ft = 'helm' }
        },
        opts = {
            ensure_installed = {},
            handlers = {
                default_setup,
                rust_analyzer = function() return true end,
                lua_ls = function()
                    require('lspconfig').lua_ls.setup({
                        capabilities = LspCommon.lsp_capabilities(),
                        flags = LspCommon.lsp_flags,
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                                format = {
                                    enable = true,
                                    defaultConfig = {
                                        max_line_length = '160'
                                    }
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    -- Tells lua_ls where to find all the Lua files that you have loaded
                                    -- for your neovim configuration.
                                    library = {
                                        '${3rd}/luv/library',
                                        unpack(vim.api.nvim_get_runtime_file('', true)),
                                    },
                                },
                                completion = {
                                    callSnippet = 'Replace'
                                }
                            }
                        }
                    })
                end,

                powershell_es = function()
                    require('lspconfig').powershell_es.setup({
                        capabilities = LspCommon.lsp_capabilities(),
                        flags = LspCommon.lsp_flags,
                        bundle_path = vim.fn.stdpath('data') .. '/mason/packages/powershell-editor-services/'
                    })
                end,
                ts_ls = function()
                    require('lspconfig').ts_ls.setup({
                        capabilities = LspCommon.lsp_capabilities(),
                        flags = LspCommon.lsp_flags,

                        on_attach = function(client, bufnr)
                            -- uncomment if using prettier...
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                            nmap('<leader>rf', ':TypescriptRenameFile<CR>', '[TS] [R]ename [F]ile', bufnr) -- rename file and update imports
                            nmap('<leader>oi', function()
                                    vim.lsp.buf.code_action({
                                        apply = true,
                                        context = {
                                            only = { 'source.organizeImports.ts' },
                                            diagnostics = {},
                                        },
                                    })
                                end, '[TS] [O]rganize [I]mports',
                                bufnr)
                        end,

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
                end,
                angularls = function()
                    require('lspconfig').angularls.setup({
                        capabilities = LspCommon.lsp_capabilities(),
                        flags = LspCommon.lsp_flags,
                        on_attach = function(client, bufnr)
                            nmap('<leader>gat', function()
                                local r, c = unpack(vim.api.nvim_win_get_cursor(0))
                                local args = {
                                    textDocument = { uri = 'file://' .. vim.api.nvim_buf_get_name(bufnr) },
                                    position = { line = r, character = c },
                                }
                                print('go to angular template', vim.inspect(args))
                                local util = require('vim.lsp.util')

                                client.request('angular/getTemplateLocationForComponent', args, function(err, result, ctx, config)
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

                                client.request('angular/getComponentsWithTemplateFile', args, function(err, result, ctx, config)
                                    config = config or {}
                                    if result then
                                        util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
                                    end
                                end, bufnr)
                            end, '[G]o to [A]ngular [C]omponent', bufnr)
                        end,
                    })
                end,
                -- TODO: Does not seem to do anything, autocmd does work however
                -- no diagnostic is shown
                eslint = function()
                    require('lspconfig').eslint.setup {
                        capabilities = LspCommon.lsp_capabilities(),
                        flags = LspCommon.lsp_flags,
                        settings = {
                            packageManager = 'npm',
                        }
                    }
                end,
                yamlls = function()
                    require('lspconfig').yamlls.setup {
                    }
                end,
                helm_ls = function()
                    require('lspconfig').helm_ls.setup {
                        settings = {
                            ['helm-ls'] = {
                                yamlls = {
                                    path = "yaml-language-server",
                                }
                            }
                        }
                    }
                end
            }
        },
        config = function(_, opts)
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, LspCommon.float_opts)
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, LspCommon.float_opts)

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
