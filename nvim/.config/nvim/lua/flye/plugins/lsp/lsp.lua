local LspCommon = require("flye.lsp-common")

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
    signs = true,             -- default
    update_in_insert = false, -- default
    underline = true,         -- default
    severity_sort = true,
    float = LspCommon.float_opts
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

return {
    {
        'williamboman/mason.nvim',
        opts = {
            registries = {
                'github:nvim-java/mason-registry',
                'github:mason-org/mason-registry',
            },
        },
        config = true
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { "folke/neodev.nvim" },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'nvim-java/nvim-java' },
            { 'neovim/nvim-lspconfig' }
        },
        opts = {
            ensure_installed = {},
            handlers = {
                default_setup,
                rust_analyzer = function() return true end,
                jdtls = function()
                    require('lspconfig').jdtls.setup({
                        settings = {
                            java = {
                                configuration = {
                                    runtimes = {
                                        {
                                            name = "Current Java",
                                            path = vim.fn.glob("$JAVA_HOME"),
                                            default = true,
                                        }
                                    }
                                }
                            }
                        }
                    })
                end,
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
                                        max_line_length = "160"
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
                                    callSnippet = "Replace"
                                }
                            }
                        }
                    })
                end,

                powershell_es = function()
                    require('lspconfig').powershell_es.setup({
                        capabilities = LspCommon.lsp_capabilities(),
                        flags = LspCommon.lsp_flags,
                        bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/"
                    })
                end,
                tsserver = function()
                    require('lspconfig').tsserver.setup({
                        capabilities = LspCommon.lsp_capabilities(),
                        flags = LspCommon.lsp_flags,

                        on_attach = function(client, bufnr)
                            -- uncomment if using prettier...
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                            LspCommon.nmap("<leader>rf", ":TypescriptRenameFile<CR>", '[TS] [R]ename [F]ile', bufnr) -- rename file and update imports
                            LspCommon.nmap("<leader>oi", function()
                                    vim.lsp.buf.code_action({
                                        apply = true,
                                        context = {
                                            only = { "source.organizeImports.ts" },
                                            diagnostics = {},
                                        },
                                    })
                                end, '[TS] [O]rganize [I]mports',
                                bufnr)
                        end,

                        init_options = {
                            hostInfo = "neovim",
                            preferences = {
                                -- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3439
                                importModuleSpecifierPreference = 'relative',
                                importModuleSpecifierEnding = 'minimal',
                                includeInlayParameterNameHints = 'literals',     -- "all" | "none" | "literals"
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
                            LspCommon.nmap("<leader>gat", function()
                                local r, c = unpack(vim.api.nvim_win_get_cursor(0))
                                local args = {
                                    textDocument = { uri = "file://" .. vim.api.nvim_buf_get_name(bufnr) },
                                    position = { line = r, character = c },
                                }
                                print('go to angular template', vim.inspect(args))
                                local util = require('vim.lsp.util')

                                client.request("angular/getTemplateLocationForComponent", args, function(err, result, ctx, config)
                                    config = config or {}
                                    if result then
                                        util.jump_to_location(result, client.offset_encoding, config.reuse_win)
                                    end
                                end, bufnr)
                            end, "[G]o to [A]ngular [T]emplate", bufnr)

                            LspCommon.nmap("<leader>gac", function()
                                local args = {
                                    textDocument = { uri = "file://" .. vim.api.nvim_buf_get_name(bufnr) },
                                }
                                print('go to angular component', vim.inspect(args))
                                local util = require('vim.lsp.util')

                                client.request("angular/getComponentsWithTemplateFile", args, function(err, result, ctx, config)
                                    config = config or {}
                                    if result then
                                        util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
                                    end
                                end, bufnr)
                            end, "[G]o to [A]ngular [C]omponent", bufnr)
                        end,
                    })
                end,
                -- TODO: Does not seem to do anything, autocmd does work however
                -- no diagnostic is shown
                eslint = function()
                    require('lspconfig').eslint.setup {
                        capabilities = LspCommon.lsp_capabilities(),
                        flags = LspCommon.lsp_flags,
                        -- on_attach = function(client, bufnr)
                        --     vim.api.nvim_create_autocmd("BufWritePre", {
                        --         buffer = bufnr,
                        --         command = "EslintFixAll",
                        --     })
                        -- end
                        settings = {
                            packageManager = "npm",
                        }
                    }
                end
            }
        },
        config = function(_, opts)
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, LspCommon.float_opts)
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, LspCommon.float_opts)

            require("mason-lspconfig").setup(opts)
        end

    },
    -- Auto-Install LSPs, linters, formatters, debuggers
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
            ensure_installed = {
                'tsserver',
                'eslint',
                'eslint_d',
                'prettier',
                'codelldb',
                'netcoredbg',
                'java-debug-adapter',
                'java-test',
                'jdtls',
                'lua_ls',
            },
        },
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
        }
    },
}
