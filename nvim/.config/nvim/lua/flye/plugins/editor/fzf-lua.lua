return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            grep = {
                hidden = true,
            }
        },

        keys = {
            { '<leader>s', '', desc = '+search' },
            { '<leader>g', '', desc = '+git' },

            {
                '<leader>sf',
                function()
                    require('fzf-lua').files {
                        -- fd_opts = '--hidden --no-ignore-vcs --exclude node_modules --exclude .git/* --type f'
                    }
                end,
                desc = '[S]earch [F]iles'
            },
            { '<leader>sb', function() require('fzf-lua').buffers {} end,      desc = '[S]earch [B]uffers' },
            { '<leader>sh', function() require('fzf-lua').helptags {} end,     desc = '[S]earch [H]elp' },
            { '<leader>sk', function() require('fzf-lua').keymaps {} end,      desc = '[S]earch [K]eymaps' },
            { '<leader>sg', function() require('fzf-lua').grep {} end,         desc = '[S]earch [T]ext by current [W]ord' },
            { '<leader>sw', function() require('fzf-lua').grep_cWORD {} end,   desc = '[S]earch [T]ext by [G]rep' },

            { "<leader>gb", function() require('fzf-lua').git_branches {} end, desc = '[G]it [B]ranches' },
            {
                "<leader>gs",
                function()
                    require('fzf-lua').git_status {
                        winopts = { preview = { layout = 'vertical' } } }
                end,
                desc = '[G]it [S]tatus'
            },
            { '<leader>gf',  function() require('fzf-lua').git_files {} end,    desc = '[G]it [F]iles' },
            { '<leader>gcp', function() require('fzf-lua').git_commits {} end,  desc = '[G]it [C]ommit log [P]roject' },
            { '<leader>gcb', function() require('fzf-lua').git_bcommits {} end, desc = '[G]it [C]ommit log [B]uffer' },
            { '<leader>gS',  function() require('fzf-lua').git_stash {} end,    desc = '[G]it [S]tash' },

            { '<leader>s"',  function() require('fzf-lua').registers {} end,    desc = '[S]earch [R]egister' },
            { '<leader>sj',  function() require('fzf-lua').jumplist {} end,     desc = '[S]earch [J]umplist' },
            { '<leader>sl',  function() require('fzf-lua').loclist {} end,      desc = '[S]earch [L]oclist' },
            { '<leader>sq',  function() require('fzf-lua').quickfix {} end,     desc = '[S]earch [Q]uickfix list' },

            { '<leader>sx',  function() require('fzf-lua').diagnostics {} end,  desc = '[S]earch [D]iagnostics' }
        }
    }
}
