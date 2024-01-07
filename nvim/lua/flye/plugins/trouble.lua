-- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists

return {
  "folke/trouble.nvim",
  cond = not vim.g.vscode,
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = {
    {"<leader>xx", "<cmd>TroubleToggle<cr>"},
    {"<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>"},
    {"<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>"},
    {"<leader>xl", "<cmd>TroubleToggle loclist<cr>"},
    {"<leader>xq", "<cmd>TroubleToggle quickfix<cr>"},
    {"<cmd>TroubleToggle lsp_references<cr>"},
  }
}
