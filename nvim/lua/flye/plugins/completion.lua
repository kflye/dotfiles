local LspCommon = require("flye.lsp-common")

return {
    -- TODO: why does it not load if it is a dependendy, no sources is loading, look at another config
    { "onsails/lspkind.nvim" },         -- vscode like icons to lsp
    { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' }, -- Snippets
            {
                'L3MON4D3/LuaSnip',
                dependencies = { { 'rafamadriz/friendly-snippets' } },
                init = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end
            },
    {
        -- Completion framework:
        'hrsh7th/nvim-cmp',
        dependendies = { -- LSP completion source:
             },
        version = false, -- last release is way too old

        opts = function()
            local cmp = require("cmp")

            local function check_backspace()
                local col = vim.fn.col(".") - 1
                if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                    return true
                else
                    return false
                end
            end

            return {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
                },
                window = {
                    -- completion = LspCommon.float_opts,
                    -- documentation = LspCommon.float_opts,
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
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
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif require("luasnip").jumpable(-1) then
                            require("luasnip").jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" })
                    -- ['<Tab>'] = cmp.mapping.confirm({
                    --    behavior = cmp.ConfirmBehavior.Replace,
                    --    select = true
                    -- }),
                }),
                sources = cmp.config.sources({ {
                    name = "nvim_lsp"
                }, {
                    name = "nvim_lua"
                }, {
                    name = "luasnip"
                }, {
                    name = "buffer"
                }, {
                    name = "path"
                } }, { {
                    name = 'buffer'
                } }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
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
            }
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim" },
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
                "prettier", "eslint_d" }
        },
        config = function(_, opts)
            require("mason-null-ls").setup(opts)
        end
    }
}
