vim.lsp.config('angularls', {
    on_attach = function(client, bufnr)
        vim.keymap.set('n', '<leader>gat', function()
            local r, c = unpack(vim.api.nvim_win_get_cursor(0))
            local args = {
                textDocument = { uri = 'file://' .. vim.api.nvim_buf_get_name(bufnr) },
                position = { line = r, character = c },
            }
            print('go to angular template', vim.inspect(args))
            local util = require('vim.lsp.util')

            client.request('angular/getTemplateLocationForComponent', args,
                function(err, result, ctx, config)
                    config = config or {}
                    if result then
                        util.jump_to_location(result, client.offset_encoding, config.reuse_win)
                    end
                end, bufnr)
        end, {desc = '[G]o to [A]ngular [T]emplate', buffer = bufnr, noremap = true, silent = true})

        vim.keymap.set('n', '<leader>gac', function()
            local args = {
                textDocument = { uri = 'file://' .. vim.api.nvim_buf_get_name(bufnr) },
            }
            print('go to angular component', vim.inspect(args))
            local util = require('vim.lsp.util')

            client.request('angular/getComponentsWithTemplateFile', args,
                function(err, result, ctx, config)
                    config = config or {}
                    if result then
                        util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
                    end
                end, bufnr)
        end, {desc = '[G]o to [A]ngular [C]omponent', buffer = bufnr, noremap = true, silent = true})
    end,
})