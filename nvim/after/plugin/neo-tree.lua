local status_ok, neotree = pcall(require, "neo-tree")
if not status_ok then
    vim.notify("neo-tree not found")
    return
end

-- TODO: Harpoon integration https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#harpoon-indexequire("neo-tree")
neotree.setup({
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    enable_git_status = true,
    enable_diagnostics = true,
    source_selector = {
        padding = 4
    },
    default_component_configs = {
        git_status = {
            symbols = {
                -- Change type
                added     = "",
                deleted   = "",
                modified  = "",
                renamed   = "",
                -- Status type
                untracked = "",
                ignored   = "",
                unstaged  = "",
                staged    = "",
                conflict  = "",
            }
        },
    },
    event_handlers = {
        {
            event = "file_opened",
            handler = function(file_path)
                --auto close
                neotree.close_all()
            end
        },
    }
})

vim.keymap.set("n", "<leader>we", ":Neotree toggle<CR>")
vim.keymap.set("n", "<leader>wf", ":Neotree focus<CR>")
vim.keymap.set("n", "<leader>ws", ":Neotree reveal<CR>")
