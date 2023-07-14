local LspCommon = require("flye.lsp-common")

return { {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' },
        {
            'williamboman/mason.nvim',
            opts = {
                ensure_installed = { "codelldb" }
            },
            config = function(_, opts)
                require("mason").setup(opts)
            end
        }, {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
            ensure_installed = { "coreclr", "codelldb", "netcoredbg" },
            handlers = {
                function(config)
                    -- all sources with no handler get passed here
                    -- Keep original functionality
                    require('mason-nvim-dap').default_setup(config)
                end,
                coreclr = function(config)
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

                    config.adapters = {
                        type = "executable",
                        command = netcoredbg_path,
                        args = { "--interpreter=vscode" }
                    }
                    require('mason-nvim-dap').default_setup(config)
                end
            }
        },
        config = function(_, opts)
            require("mason-nvim-dap").setup(opts)
        end
    },
        { 'williamboman/mason-lspconfig.nvim' },
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
        },
        { 'jose-elias-alvarez/typescript.nvim' }
    },
    opts = {
        servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                        format = {
                            enable = true,
                            defaultConfig = {
                                max_line_length = "160",
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
            },
            tsserver = {},
            omnisharp = {
                enable_roslyn_analyzers = true,
                organize_imports_on_format = true,
                enable_import_completion = true,
                on_attach = function(client, bufnr)
                    -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
                    local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
                    for i, v in ipairs(tokenModifiers) do
                        local tmp = string.gsub(v, ' ', '_')
                        tokenModifiers[i] = string.gsub(tmp, '-_', '')
                    end
                    local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
                    for i, v in ipairs(tokenTypes) do
                        local tmp = string.gsub(v, ' ', '_')
                        tokenTypes[i] = string.gsub(tmp, '-_', '')
                    end
                    LspCommon.on_attach(client, bufnr)
                end
            },
            jsonls = {},
            powershell_es = {
                bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/"
            },
            rust_analyzer = {
                tools = {
                    -- callback to execute once rust-analyzer is done initializing the workspace
                    -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
                    on_initialized = nil,

                    -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
                    reload_workspace_from_cargo_toml = true,

                    -- These apply to the default RustSetInlayHints command
                    inlay_hints = {
                        auto = true,
                        only_current_line = false,
                        show_parameter_hints = true,
                        parameter_hints_prefix = "<- ",
                        other_hints_prefix = "=> ",
                        max_len_align = false,
                        max_len_align_padding = 1,
                        right_align = false,
                        right_align_padding = 7,
                        highlight = "Comment"
                    }
                }

                -- rust-analyzer options

            }
        },
        setup = {
            rust_analyzer = function(_, opts)
                local rusttools = require("rust-tools")

                local mason_registry = require("mason-registry")

                local codelldb_root = mason_registry.get_package("codelldb"):get_install_path()
                local codelldb_path = codelldb_root .. "/codelldb"
                local liblldb_path = codelldb_root .. "/extension/" .. "lldb/lib/liblldb"
                local this_os = vim.loop.os_uname().sysname

                if this_os:find "Windows" then
                    codelldb_path = codelldb_root .. "/extension/" .. "adapter\\codelldb.exe"
                    liblldb_path = codelldb_root .. "/extension/" .. "lldb\\bin\\liblldb.dll"
                else
                    -- The liblldb extension is .so for linux and .dylib for macOS
                    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
                end

                -- debugging stuff
                opts.dap = {
                    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
                }

                opts.executor = require("rust-tools.executors").termopen -- options right now: termopen / quickfix
                opts.server = {
                    on_attach = function(client, bufnr)
                        LspCommon.on_attach(client, bufnr)

                        vim.keymap.set("n", "K", rusttools.hover_actions.hover_actions, {
                            buffer = bufnr,
                            desc = "Rusttools hover actions"
                        })

                        vim.keymap.set("n", "<leader>rd", rusttools.debuggables.debuggables)
                        vim.keymap.set("n", "<leader>ru", rusttools.runnables.runnables)
                        -- add hover options back if rust-tool specific hovers are used
                    end
                }

                rusttools.setup(opts)
                return true
            end,

            tsserver = function(_, opts)
                opts = vim.tbl_deep_extend("force", { server = opts }, {})
                opts.server.on_attach = function(client, bufnr)
                    LspCommon.on_attach(client, bufnr)
                    vim.keymap.set("n", "<leader>oi", require("typescript").actions.organizeImports, { buffer = bufnr, desc = "[O]rganize [I]mports" })
                    vim.keymap.set("n", "<leader>gd", ":TypescriptGoToSourceDefinition<CR>", { buffer = bufnr, desc = "[O]rganize [I]mports" })
                end


                require("typescript").setup(opts)
                return true
            end
        }

    },
    config = function(_, opts)
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, LspCommon.float_opts)

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
            LspCommon.float_opts)

        local servers = opts.servers

        local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities(), opts.capabilities or {})

        local function setup(server)
            local server_opts = vim.tbl_deep_extend("force", {
                capabilities = vim.deepcopy(capabilities),
                on_attach = LspCommon.on_attach,
                flags = LspCommon.lsp_flags
            }, servers[server] or {})

            if opts.setup[server] then
                if opts.setup[server](server, server_opts) then
                    return
                end
            end
            require("lspconfig")[server].setup(server_opts)
        end

        local have_mason, mlsp = pcall(require, "mason-lspconfig")
        local all_mslp_servers = {}
        if have_mason then
            all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
        end

        local ensure_installed = {} ---@type string[]
        for server, server_opts in pairs(servers) do
            if server_opts then
                server_opts = server_opts == true and {} or server_opts
                -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                    setup(server)
                else
                    ensure_installed[#ensure_installed + 1] = server
                end
            end
        end

        P(ensure_installed)

        if have_mason then
            mlsp.setup({
                ensure_installed = ensure_installed
            })
            mlsp.setup_handlers({ setup })
        end
    end
} }
