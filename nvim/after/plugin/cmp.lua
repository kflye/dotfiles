local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    vim.notify('cmp not found!')
    return
end

local luasnip_ok, luasnip = pcall(require, "luasnip")
if not luasnip_ok then
    vim.notify('luasnip not found!')
    return
end
require("luasnip.loaders.from_vscode").lazy_load()

local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
    vim.notify("lspkind not found!")
    return
end

local function check_backspace()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

local cmp_select = {
    behavior = cmp.SelectBehavior.Select
}
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
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
        elseif luasnip.expandable() then
            luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif check_backspace() then
            fallback()
        else
            fallback()
        end
    end, {"i", "s"}),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, {"i", "s"})
    -- ['<Tab>'] = cmp.mapping.confirm({
    --    behavior = cmp.ConfirmBehavior.Replace,
    --    select = true
    -- })
})

local select_opts = {
    behavior = cmp.SelectBehavior.Select
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp_mappings,
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
        format = lspkind.cmp_format({
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

-- defaults https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
