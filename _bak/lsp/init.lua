vim.notify("lsp.init")

-- TODO: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/lsp/init.lua


return {
    'neovim/nvim-lspconfig',
    dependencies = {{'hrsh7th/cmp-nvim-lsp'}, {
        'williamboman/mason.nvim',
        opts = {
            ensure_installed = {"codelldb"}
        },
        config = function(plugin, opts)
            require("mason").setup(opts)
        end
    }, {'williamboman/mason-lspconfig.nvim'}, {'simrat39/rust-tools.nvim'}},
    opts = {
        servers = {
            lua_ls = {
                settings = {
                    Lua = {
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
                on_attach = function(client, bufnr)
                    -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
                    local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
                    for i, v in ipairs(tokenModifiers) do
                        tmp = string.gsub(v, ' ', '_')
                        tokenModifiers[i] = string.gsub(tmp, '-_', '')
                    end
                    local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
                    for i, v in ipairs(tokenTypes) do
                        tmp = string.gsub(v, ' ', '_')
                        tokenTypes[i] = string.gsub(tmp, '-_', '')
                    end
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
                },

                 -- rust-analyzer options

            }
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
            rust_analyzer = function(_, opts)
                local LspCommon = require("flye.lsp-common")
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

                        vim.notify("rust.on_attach")
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
                vim.notify("hello")
                return true
            end
            -- example to setup with typescript.nvim
            -- tsserver = function(_, opts)
            --   require("typescript").setup({ server = opts })
            --   return true
            -- end,
            -- Specify * to use this function as a fallback for any server
            -- ["*"] = function(server, opts) end,
        }

    },
    config = function(_, opts)
        local LspCommon = require("flye.lsp-common")
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, LspCommon.float_opts)

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
            LspCommon.float_opts)

        local servers = opts.servers

        local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities(), opts.capabilities or {})

        local function setup(server)
            local server_opts = vim.tbl_deep_extend("force", {
                capabilities = vim.deepcopy(capabilities),
                flags = LspCommon.lsp_flags
            }, servers[server] or {})

            local on_attach = server_opts.on_attach
            if on_attach then
                vim.notify("on attach " .. server)

                server_opts.on_attach = function(client, bufnr)
                    vim.notify("on attach: client " .. client.name)

                    LspCommon.on_attach(client, bufnr)
                    vim.notify("after LspCommon.on_attach")

                    on_attach(client, bufnr)
                    vim.notify("after on attach: client ")

                end
            else
                vim.notify("on attach not override " .. server)

                server_opts.on_attach = LspCommon.on_attach
            end

            if opts.setup[server] then
                if opts.setup[server](server, server_opts) then
                    vim.notify("skipping " .. server)
                    return
                end
            elseif opts.setup["*"] then
                if opts.setup["*"](server, server_opts) then
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

        vim.notify(dump(ensure_installed))

        if have_mason then
            mlsp.setup({
                ensure_installed = ensure_installed
            })
            mlsp.setup_handlers({setup})
        end

    end
}
