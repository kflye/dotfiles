return {
    -- Useful status updates for LSP
    {
        'j-hui/fidget.nvim',
        cond = not vim.g.vscode,
        opts = {}
    }
}
