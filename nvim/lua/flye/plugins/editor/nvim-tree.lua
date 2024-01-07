return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cond = not vim.g.vscode,
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        actions = { open_file = { quit_on_open = true } },
        git = {
            ignore = false
        },
        view = {
            width = 50, -- TODO: Can this be a bit more dynamic, or scroll when name is out of view
        }
    },
    keys = { { "<leader>we", ":NvimTreeToggle <CR>" }, { "<leader>wf", ":NvimTreeFocus <CR>" },
        { "<leader>ws", ":NvimTreeFindFile <CR>" } }
}
