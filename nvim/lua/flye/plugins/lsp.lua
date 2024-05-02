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

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

return {
    {
        'williamboman/mason.nvim',
        config = true
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { "folke/neodev.nvim" },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'mfussenegger/nvim-jdtls' },
            { 'neovim/nvim-lspconfig' }
        },
        opts = {
            ensure_installed = {},
            handlers = {
                default_setup,
                rust_analyzer = function() return true end,
                jdtls = function() return true end,
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
                                bufnr) -- organize imports (not in youtube nvim video)
                            -- vim.keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
                        end,

                        root_dir = require('lspconfig.util').root_pattern(".git"),

                        settings = {
                            typescript = LspCommon.tsserver_lang_settings,
                            typescriptreact = LspCommon.tsserver_lang_settings,
                            javascript = LspCommon.tsserver_lang_settings,
                            javascriptreact = LspCommon.tsserver_lang_settings
                        }
                    })
                end
            }
        },
        config = function(_, opts)
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, LspCommon.float_opts)
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
                LspCommon.float_opts)

            require("mason-lspconfig").setup(opts)
        end

    },
    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        lazy = false,   -- This plugin is already lazy
        config = function()
            vim.g.rustaceanvim = {
                -- Plugin configuration
                -- tools = {
                -- },
                -- LSP configuration
                server = {
                    on_attach = function(client, bufnr)
                        -- joinLines -- different than regular join lines??? (J)
                        -- explainError -- perhaps <leader>E
                        vim.keymap.set('n', '<leader>rU', function() vim.cmd.RustLsp('run') end, { desc = '[r][u]n' })
                        vim.keymap.set('n', '<leader>ru', function() vim.cmd.RustLsp('runnables') end, { desc = '[r][u]nnables' })
                        vim.keymap.set('n', '<leader>ra', function() vim.cmd.RustLsp { 'runnables', bang = true } end, { desc = '[r]un [a]gain' })
                        vim.keymap.set('n', '<leader>rd', function() vim.cmd.RustLsp { 'debuggables' } end, { desc = '[r]un [a]gain' })
                        vim.keymap.set('n', '<leader>rd', function() vim.cmd.RustLsp { 'debuggables', bang = true } end, { desc = '[r]un [a]gain' })
                        vim.keymap.set('n', '<leader>rD', function() vim.cmd.RustLsp { 'debug', bang = true } end, { desc = '[r]un [a]gain' })
                    end,
                    default_settings = {
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                            -- checkOnSave = false,
                        },
                    },
                },
                -- DAP configuration
                -- dap = {
                -- },
            }
        end
    },
    {
        "folke/neodev.nvim",
        opts = {
            library = {
                plugins = { "nvim-dap-ui", "neotest" },
                types = true
            }
        },
        config = function(_, opts)
            require("neodev").setup(opts)
        end
    },
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        config = function()
            local jdtls = require("jdtls")
            vim.keymap.set("n", "<leader>ur", function()
                jdtls.test_nearest_method()
            end)
        end
    },
    -- Auto-Install LSPs, linters, formatters, debuggers
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
            ensure_installed = {
                'prettier',
                'codelldb',
                'netcoredbg',
                'java-debug-adapter',
                'java-test',
                'jdtls',
            },
        },
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
        }
    },
}
