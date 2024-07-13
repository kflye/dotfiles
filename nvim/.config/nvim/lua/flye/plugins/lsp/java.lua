return {

    -- {
    --     'mfussenegger/nvim-jdtls',
    --     ft = 'java',
    --     config = function()
    --         local jdtls = require("jdtls")
    --         vim.keymap.set("n", "<leader>ur", function()
    --             jdtls.test_nearest_method()
    --         end)
    --     end
    -- },

    {
        'nvim-java/nvim-java',
        dependencies = {
            'nvim-java/lua-async-await',
            'nvim-java/nvim-java-refactor',
            'nvim-java/nvim-java-core',
            'nvim-java/nvim-java-test',
            'nvim-java/nvim-java-dap',
            'MunifTanjim/nui.nvim',
        },
        opts = {
            jdk = {
                auto_install = false,
            }
        },
        config = function(_, opts)
            require("java").setup(opts);
        end,
    },
}
