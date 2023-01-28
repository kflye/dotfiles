local status_ok, nvimtree = pcall(require, "nvim-tree")
if not status_ok then
    vim.notify("nvim-tree not found")
    return
end


nvimtree.setup({
    diagnostics = {
        enable = true,
    },
    actions = {
        open_file = {
            quit_on_open = true
        }
    },
    renderer = {
        highlight_git = true,
        root_folder_modifier = ":t",
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    deleted = "",
                    untracked = "U",
                    ignored = "◌",
                },
            }
        }
    }
})

vim.keymap.set("n", "<leader>we", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>wf", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<leader>ws", ":NvimTreeFindFile<CR>")