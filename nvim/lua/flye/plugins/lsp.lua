local LspCommon = require("flye.lsp-common")
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
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        local opts = {
            buffer = args.buf
        }

        print(client.name .. " on_attach")

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
        -- TODO: Code actions for current document? or use diagnostics to find, and then code_actions?

        nmap('<leader>=', function()
            vim.lsp.buf.format {
                async = true
            }
        end, 'Format current buffer with LSP', bufnr)

        if client.server_capabilities.inlayHintProvider then
            print(client.name .. " supports inlayhints (" .. args.buf .. ")")
            vim.lsp.inlay_hint.enable(args.buf, true)
        else
            print(client.name .. " does not support inlayhints")
        end

        if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "InsertLeave"}, {
                buffer = args.buf,
                callback = vim.lsp.codelens.refresh
            })
        end
    end
})

local default_setup = function(server)
    print("default setup of " .. server)

    require('lspconfig')[server].setup({
        capabilities = LspCommon.lsp_capabilities(),
        flags = LspCommon.lsp_flags
    })
end

return {{
    'williamboman/mason.nvim',
    opts = {
        ensure_installed = {"codelldb"}
    },
    config = function(_, opts)
        require("mason").setup(opts)
    end
}, {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {{'hrsh7th/cmp-nvim-lsp'}, {'neovim/nvim-lspconfig'}},
    opts = {
        ensure_installed = {},
        handlers = {
            default_setup,
            lua_ls = function()
                require('lspconfig').lua_ls.setup({
                    capabilities = LspCommon.lsp_capabilities(),
                    flags = LspCommon.lsp_flags,
                    settings = {
                        Lua = {
                            -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                            format = {
                                enable = true,
                                defaultConfig = {
                                    max_line_length = "160"
                                }
                            },
                            workspace = {
                                checkThirdParty = false
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
            rust_analyzer = function()
                local rusttools = require("rust-tools")
                local codelldb_path = LspCommon.get_codelldb_path()
                local liblldb_path = LspCommon.get_liblldb_path()
                local opts = {
                    tools = {
                        -- callback to execute once rust-analyzer is done initializing the workspace
                        -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
                        on_initialized = nil,

                        -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
                        reload_workspace_from_cargo_toml = true,

                        -- These apply to the default RustSetInlayHints command
                        inlay_hints = {
                            auto = false
                        }
                    },
                    server = {
                        on_attach = function(client, bufnr)

                            vim.keymap.set("n", "K", rusttools.hover_actions.hover_actions, {
                                buffer = bufnr,
                                desc = "Rusttools hover actions"
                            })

                            vim.keymap.set("n", "<leader>rd", rusttools.debuggables.debuggables)
                            vim.keymap.set("n", "<leader>ru", rusttools.runnables.runnables)
                            -- add hover options back if rust-tool specific hovers are used
                        end
                    },

                    -- rust-analyzer options
                    dap = {
                        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
                    }
                    -- executor = require("rust-tools.executors").termopen -- options right now: termopen / quickfix
                }

                rusttools.setup(opts)
            end,
            tsserver = function()
                require('lspconfig').tsserver.setup({
                    capabilities = LspCommon.lsp_capabilities(),
                    flags = LspCommon.lsp_flags,
                    on_attach = function(client, bufnr)
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                        nmap("<leader>rf", ":TypescriptRenameFile<CR>", '[TS] [R]ename [F]ile', bufnr) -- rename file and update imports
                        nmap("<leader>oi", ":TypescriptOrganizeImports<CR>", '[TS] [O]rganize [I]mports', bufnr) -- organize imports (not in youtube nvim video)
                        -- vim.keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
                    end,
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = 'all',
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true
                            }
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = 'all',
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true
                            }
                        }
                    }
                })
            end,
               -- omnisharp = {
                --     enable_roslyn_analyzers = true,
                --     organize_imports_on_format = true,
                --     enable_import_completion = true,
                --     on_attach = function(client, bufnr)
                --         -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
                --         local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
                --         for i, v in ipairs(tokenModifiers) do
                --             local tmp = string.gsub(v, ' ', '_')
                --             tokenModifiers[i] = string.gsub(tmp, '-_', '')
                --         end
                --         local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
                --         for i, v in ipairs(tokenTypes) do
                --             local tmp = string.gsub(v, ' ', '_')
                --             tokenTypes[i] = string.gsub(tmp, '-_', '')
                --         end
                --         LspCommon.on_attach(client, bufnr)
                --     end
                -- },
        }
    },
    config = function(_, opts)
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, LspCommon.float_opts)
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, LspCommon.float_opts)

        require("mason-lspconfig").setup(opts)
    end

}, {'simrat39/rust-tools.nvim'}, {
    "folke/neodev.nvim",
    opts = {
        library = {
            plugins = {"nvim-dap-ui"},
            types = true
        }
    },
    config = function(_, opts)
        require("neodev").setup(opts)
    end
}}

--{
--    'jmederosalvarado/roslyn.nvim',
--    opts = {
--        dotnet_cmd = "dotnet",              -- this is the default
--        roslyn_version = "4.8.0-3.23475.7", -- this is the default
--    },
--    config = function(_, opts)
--        opts.on_attach = function(client, bufnr)
--            print("on attatch _ roslyn")
--            LspCommon.on_attach(client, bufnr)
--        end
--        opts.capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(),
--            require("cmp_nvim_lsp").default_capabilities(), {})

    --require("roslyn").setup(opts)
    --end,
    --dependencies = { { 'neovim/nvim-lspconfig' } }
--},
