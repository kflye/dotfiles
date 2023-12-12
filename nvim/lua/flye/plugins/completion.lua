local LspCommon = require("flye.lsp-common")

return {
    -- TODO: why does it not load if it is a dependendy, no sources is loading, look at another config
    { "onsails/lspkind.nvim" }, -- vscode like icons to lsp
    { 'hrsh7th/cmp-nvim-lua' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'saadparwaiz1/cmp_luasnip' }, -- Snippets
    {
        'L3MON4D3/LuaSnip',
        dependencies = { { 'rafamadriz/friendly-snippets' } },
        init = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
        keys = {
            {
                "<c-f>",
                function()
                    if require("luasnip").expand_or_jumpable() then
                        require("luasnip").expand_or_jump()
                    end
                end,
                mode = { "i", "s" },
                desc = "Expand the current item or jump to the next item within the snippet"
            },
            {
                "<c-b>",
                function()
                    if require("luasnip").jumpable(-1) then
                        require("luasnip").jump(-1)
                    end
                end,
                mode = { "i", "s" },
                desc = "Move to the previous item within a snippet"
            },
            {
                "<c-l>",
                function()
                    if require("luasnip").choice_active() then
                        require("luasnip").change_choici(1)
                    end
                end,
                mode = "i",
                desc = "Selecting within a list of choices"
            }
        }
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
                        behavior = cmp.SelectBehavior.Insert,
                        select = true
                    }),
                    ['<M-y>'] = cmp.mapping.confirm({
                        behavior = cmp.SelectBehavior.Replace,
                        select = false
                    }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-i>"] = cmp.mapping.complete(),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    -- TODO: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#intellij-like-mapping for replace on tab, add on enter insert ? like rider -- this should work
                    -- https://github.com/hrsh7th/nvim-cmp/issues/664
                    -- ['<CR>'] = cmp.mapping.confirm({
                    --     behavior = cmp.ConfirmBehavior.Insert,
                    --     select = true
                    -- }),
                    ["<Tab>"] = cmp.config.disable,
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = 'nvim_lsp_signature_help' },
                    { name = "nvim_lua" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "crates" },
                }, {
                    { name = 'buffer' }
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = require("lspkind").cmp_format({
                        mode = "symbol_text",
                        menu = ({
                            nvim_lsp = "[LSP]",
                            nvim_lsp_signature_help = "[LSP_SIGN]",
                            nvim_lua = "[Lua]",
                            luasnip = "[LuaSnip]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                            crates = "[Crates]"
                        })
                    })
                }
            }
        end,
    }
}
