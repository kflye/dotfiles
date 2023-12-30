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
    float = LspCommon.float_opts,
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

return {
    {
        'williamboman/mason.nvim',
        config = true,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { 'simrat39/rust-tools.nvim' },
            { "folke/neodev.nvim" },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'neovim/nvim-lspconfig' }
        },
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
                            LspCommon.nmap("<leader>rf", ":TypescriptRenameFile<CR>", '[TS] [R]ename [F]ile', bufnr)       -- rename file and update imports
                            LspCommon.nmap("<leader>oi", ":TypescriptOrganizeImports<CR>", '[TS] [O]rganize [I]mports', bufnr) -- organize imports (not in youtube nvim video)
                            -- vim.keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
                        end,

                        root_dir = require('lspconfig.util').root_pattern(".git"),

                        settings = {
                            typescript = LspCommon.tsserver_lang_settings,
                            typescriptreact = LspCommon.tsserver_lang_settings,
                            javascript = LspCommon.tsserver_lang_settings,
                            javascriptreact = LspCommon.tsserver_lang_settings,
                        }
                    })
                end,
            }
        },
        config = function(_, opts)
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, LspCommon.float_opts)
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, LspCommon.float_opts)

            require("mason-lspconfig").setup(opts)
        end

    },
    { 'simrat39/rust-tools.nvim' },
    {
        "folke/neodev.nvim",
        opts = {
            library = {
                plugins = { "nvim-dap-ui" },
                types = true
            }
        },
        config = function(_, opts)
            require("neodev").setup(opts)
        end
    }
}

-- {
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

-- require("roslyn").setup(opts)
-- end,
-- dependencies = { { 'neovim/nvim-lspconfig' } }
-- },
