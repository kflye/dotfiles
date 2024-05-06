return
{
    "folke/neodev.nvim",
    opts = {
        library = {
            plugins = { "nvim-dap-ui", "neotest" },
            types = true
        }
    },
    config = function(_, opts)
        require("neodev").setup(opts)
    end
}
