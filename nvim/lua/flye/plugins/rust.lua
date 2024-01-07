return {
    {
        "saecki/crates.nvim",
        cond = not vim.g.vscode,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true
    }
}
