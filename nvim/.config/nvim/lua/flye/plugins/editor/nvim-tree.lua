return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    enabled = false,
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
    keys = { { "<leader>wt", ":NvimTreeToggle <CR>" }, { "<leader>wf", ":NvimTreeFocus <CR>" },
        { "<leader>ws", ":NvimTreeFindFile <CR>" } }
}
