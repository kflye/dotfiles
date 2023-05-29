require("flye.global")

return {{
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = true,
    config = function()
        -- This is where you modify the settings for lsp-zero
        -- Note: autocompletion settings will not take effect

        require('lsp-zero.settings').preset({})
    end
}, -- Autocompletion
{
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {{
        'L3MON4D3/LuaSnip',
        dependencies = {{'rafamadriz/friendly-snippets'}},
        init = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    }},
    config = function()
        -- Here is where you configure the autocompletion settings.
        -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
        -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

        require('lsp-zero.cmp').extend()

        -- And you can configure cmp even more, if you want to.
        local cmp = require('cmp')
        local cmp_action = require('lsp-zero.cmp').action()

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end
            },
            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item({
                    behavior = cmp.SelectBehavior.Select
                }),
                ['<C-n>'] = cmp.mapping.select_next_item({
                    behavior = cmp.SelectBehavior.Select
                }),
                ['<C-y>'] = cmp.mapping.confirm({
                    select = true
                }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                -- TODO: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#intellij-like-mapping for replace on tab, add on enter insert ? like rider -- this should work
                -- https://github.com/hrsh7th/nvim-cmp/issues/664
                ['<CR>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true
                }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require("luasnip").expandable() then
                        require("luasnip").expand()
                    elseif require("luasnip").expand_or_jumpable() then
                        require("luasnip").expand_or_jump()
                    elseif check_backspace() then
                        fallback()
                    else
                        fallback()
                    end
                end, {"i", "s"}),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif require("luasnip").jumpable(-1) then
                        require("luasnip").jump(-1)
                    else
                        fallback()
                    end
                end, {"i", "s"})
                -- ['<Tab>'] = cmp.mapping.confirm({
                --    behavior = cmp.ConfirmBehavior.Replace,
                --    select = true
                -- }),
            }),
            sources = cmp.config.sources({{
                name = "nvim_lsp"
            }, {
                name = "nvim_lua"
            }, {
                name = "luasnip"
            }, {
                name = "buffer"
            }, {
                name = "path"
            }}, {{
                name = 'buffer'
            }}),
            formatting = {
                fields = {"kind", "abbr", "menu"},
                format = require("lspkind").cmp_format({
                    mode = "symbol_text",
                    menu = ({
                        nvim_lsp = "[LSP]",
                        nvim_lua = "[Lua]",
                        luasnip = "[LuaSnip]",
                        buffer = "[Buffer]",
                        path = "[Path]"
                    })
                })
            }
        })
    end
}, -- LSP
{
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {{"folke/neodev.nvim"}, {'hrsh7th/cmp-nvim-lsp'}, {'williamboman/mason-lspconfig.nvim'}, {
        'williamboman/mason.nvim',
        build = function()
            pcall(vim.cmd, 'MasonUpdate')
        end,
        opts = {
            ensure_installed = {"codelldb"}
        },
        config = function(plugin, opts)
            require("mason").setup(opts)
        end
    }},
    config = function()
        -- This is where all the LSP shenanigans will live
        vim.notify("nvim-lspconfig setup")

        require("neodev").setup({
            library = {
                plugins = {"nvim-dap-ui"},
                types = true
            },
            override = function(root_dir, library)
                vim.notify("root_dir " .. root_dir)
                if require("neodev.util").has_file(root_dir, "/etc/nixos") then
                    library.enabled = true
                    library.plugins = true
                end
            end
        })

        local lsp = require('lsp-zero')

        lsp.on_attach(function(client, bufnr)
            local LspCommon = require("flye.lsp-common")

            vim.notify("lsp-zero - on_attach")
            -- TODO: check what is default, do i want any default...
            lsp.default_keymaps({
                buffer = bufnr
            })

            LspCommon.on_attach(client, bufnr)

            P(lsp)
        end)

        lsp.skip_server_setup({'rust_analyzer'})
        lsp.ensure_installed({"lua_ls", "tsserver", "omnisharp", "jsonls", "powershell_es", "rust_analyzer"})

        local lspconfig = require("lspconfig")

        lspconfig.lua_ls.setup({
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
        })

        lspconfig.omnisharp.setup({
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

                vim.notify("omnisharp on_attach")
            end
        })

        -- (Optional) Configure lua language server for neovim
        -- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
        -- P(lsp.nvim_lua_ls())

        lsp.setup()
    end
}, {
    'simrat39/rust-tools.nvim',
    config = function(_, opts)
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

        opts.tools = {
            -- callback to execute once rust-analyzer is done initializing the workspace
            -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
            on_initialized = nil,
            -- on_initialized = function()
            --    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
            --      pattern = { "*.rs" },
            --      callback = function()
            --        local _, _ = pcall(vim.lsp.codelens.refresh)
            --      end,
            --    })
            --  end,

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
        vim.notify("rust-tools setup done")
    end
}, {
    "jay-babu/mason-null-ls.nvim",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"jose-elias-alvarez/null-ls.nvim"},
    opts = {
        automatic_installation = false,
        ensure_installed = { -- Opt to list sources here, when available in mason.
        -- gitsigns / Injects code actions for Git operations at the current cursor position (stage / preview / reset hunks, blame, etc.).
        -- cspell
        -- editorconfig_checker
        -- eslint_d
        -- markdownlint
        -- misspell
        -- todo_comments
        -- yamllint
        -- csharpier
        -- eslint_d
        -- prettierd (md, javascript, react, html, json)
        -- prettier_eslint
        "prettier", "eslint_d"}
    },
    config = function(_, opts)
        require("mason-null-ls").setup(opts)
    end
}}
