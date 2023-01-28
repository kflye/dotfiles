local telescope_status, telescope = pcall(require, "telescope")
if not telescope_status then
    vim.notify("telescope not found!")
    return
end

telescope.setup({
    defaults = {
        color_devicons = true,
        file_ignore_patterns = { "node_modules" },

    },
    pickers = {
        find_files = {
            find_command = {
                "fd",
                '--type',
                'f',
                -- '-H'
                --no-ignore-vcs',
            }
        }
    },
    vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim", -- add this value
        "-uu"
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
})

telescope.load_extension("fzf")

vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files {} end,
    { desc = '[]earch [F]iles' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

--vim.keymap.set("n", "<leader>fb", builtin.git_branches)

