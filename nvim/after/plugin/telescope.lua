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
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            -- even more opts
          }

          -- pseudo code / specification for writing custom displays, like the one
          -- for "codeactions"
          -- specific_opts = {
          --   [kind] = {
          --     make_indexed = function(items) -> indexed_items, width,
          --     make_displayer = function(widths) -> displayer
          --     make_display = function(displayer) -> function(e)
          --     make_ordinal = function(e) -> string
          --   },
          --   -- for example to disable the custom builtin "codeactions" display
          --      do the following
          --   codeactions = false,
          -- }
        },

        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")

vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files {} end,
    { desc = '[]earch [F]iles' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>stw', require('telescope.builtin').grep_string,
{ desc = '[S]earch [T]ext by current [W]ord' })
vim.keymap.set('n', '<leader>stg', require('telescope.builtin').live_grep, { desc = '[S]earch [T]ext by [G]rep' })

-- Neovim LSP Pickers
-- is setup in lsp.lua

-- Treesitter Picker
vim.keymap.set('n', '<leader>sts', require('telescope.builtin').treesitter, { desc = '[S]earch [T]reesitter [S]ymbols' })

-- Git Pickers
vim.keymap.set("n", "<leader>sgb", require('telescope.builtin').git_branches)
vim.keymap.set("n", "<leader>sgs", require('telescope.builtin').git_status)
