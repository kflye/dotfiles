local vscode = require("vscode-neovim")
vim.notify = vscode.notify

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- clipboard -- vim.opt.clipboard:append("unnamedplus") yank to system clipboard from vim
vim.opt.clipboard = "unnamedplus"

-- enable virtual edit in block mode (<C-v>)
vim.opt.virtualedit = "block"

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.opt.incsearch = true
-- view a preview of search and replace in a split
vim.opt.inccommand = "split"

-- apperance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.autoindent = true
vim.opt.smartindent = true

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 250
vim.opt.timeoutlen = 1000

vim.opt.formatoptions:remove "o"

vim.g.mapleader = " "


---- Remaps ----
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "x", "\"_x")

-- Move line/selection up/down
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==")
vim.keymap.set("i", "<M-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<M-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")


-- LSP actions — gr* scheme consistent with nvim 0.12 defaults and ideavim
vim.keymap.set("n", 'grd', function() vscode.action("editor.action.revealDefinition") end, { desc = 'Goto Definition' })
vim.keymap.set("n", 'grD', function() vscode.action("editor.action.revealDeclaration") end, { desc = 'Goto Declaration' })
vim.keymap.set("n", 'grr', function() vscode.action("editor.action.goToReferences") end, { desc = 'References' })
vim.keymap.set("n", 'gri', function() vscode.action("editor.action.goToImplementation") end, { desc = 'Goto Implementation' })
vim.keymap.set("n", 'grt', function() vscode.action("editor.action.goToTypeDefinition") end, { desc = 'Goto Type Definition' })
vim.keymap.set("n", 'grn', function() vscode.action("editor.action.rename") end, { desc = 'Rename' })
vim.keymap.set("n", 'gra', function() vscode.action("editor.action.quickFix") end, { desc = 'Code Actions' })
vim.keymap.set("v", 'gra', function() vscode.action("editor.action.quickFix") end, { desc = 'Code Actions' })
vim.keymap.set("n", 'gO',  function() vscode.action("workbench.action.gotoSymbol") end, { desc = 'Document Symbols' })

-- Hover / signature help
vim.keymap.set("n", "K",     function() vscode.action("editor.action.showHover") end, { desc = "Hover" })
vim.keymap.set("n", "<C-s>", function() vscode.action("editor.action.triggerParameterHints") end, { desc = "Signature help" })
vim.keymap.set("i", "<C-s>", function() vscode.with_insert(function() vscode.action("editor.action.triggerParameterHints") end) end, { desc = "Signature help" })

-- Format document
vim.keymap.set("n", "<leader>=", function() vscode.action("editor.action.formatDocument") end, { desc = "Format document" })

-- Inlay hints toggle
vim.keymap.set("n", "<leader>ch", function() vscode.action("editor.action.inlayHints.toggle") end, { desc = "[C]ode toggle inlay [H]ints" })

-- Document / workspace symbols
vim.keymap.set("n", "<leader>sds", function() vscode.action("workbench.action.gotoSymbol") end, { desc = "[S]earch [D]ocument [S]ymbols" })
vim.keymap.set("n", "<leader>sdS", function() vscode.action("workbench.action.showAllSymbols") end, { desc = "[S]earch workspace [S]ymbols" })


vim.keymap.set('n', '[d', function() vscode.action("editor.action.marker.prev") end, { desc = "Go to previous problem" })
vim.keymap.set('n', ']d', function() vscode.action("editor.action.marker.next") end, { desc = "Go to next problem" })
-- leader-prefixed aliases (consistent with .ideavimrc)
vim.keymap.set('n', '<leader>ge', function() vscode.action("editor.action.marker.next") end, { desc = "Next error/diagnostic" })
vim.keymap.set('n', '<leader>gE', function() vscode.action("editor.action.marker.prev") end, { desc = "Prev error/diagnostic" })
-- Show hover/error info under cursor (nvim: diagnostic.open_float / ideavim: ShowErrorDescription)
vim.keymap.set('n', '<leader>ce', function() vscode.action("editor.action.showHover") end, { desc = "[C]ode [E]rror / diagnostic float" })
vim.keymap.set('n', '<leader>bd', function() vscode.action("workbench.action.closeActiveEditor") end)
vim.keymap.set('n', '<leader>qa', function() vscode.action("workbench.action.closeOtherEditors") end)
vim.keymap.set('n', '<leader>qA', function() vscode.action("workbench.action.closeEditorsInGroup") end)

-- Auto completion + snippets
-- <C-p/n> mapped by default
vim.keymap.set("n", "<C-y>", function() vscode.action("acceptSelectedCodeAction") end, { desc = "Accept selected code action" })
vim.keymap.set({ 'i', 's' }, '<C-n>', function() vscode.action('jumpToNextSnippetPlaceholder') end, { desc = "Jump to next snippet" })
vim.keymap.set({ 'i', 's' }, '<C-p>', function() vscode.action('jumpToPrevSnippetPlaceholder') end, { desc = "Jump to previous snippet" })


-- Find / Telescope
vim.keymap.set('n', '<leader>sf', function() vscode.action("workbench.action.quickOpen") end, { desc = "[S]earch [F]iles" })
vim.keymap.set('n', '<leader>sb', function() vscode.action("workbench.action.quickOpenLeastRecentlyUsedEditor") end, { desc = "[S]earch [B]uffers" })
vim.keymap.set('n', '<leader>sB', function() vscode.action("workbench.action.quickOpenPreviousRecentlyUsedEditor") end, { desc = "[S]earch [B]uffers" })
vim.keymap.set('n', '<leader>sw', function()
    vscode.action("editor.action.addSelectionToNextFindMatch")
    vscode.action("workbench.action.findInFiles")
end, { desc = "[S]earch [T]ext by current [W]ord" })
vim.keymap.set({'n', 'v'}, '<leader>sg', function() vscode.action("workbench.action.quickTextSearch") end, { desc = "[S]earch [T]ext by [G]rep" })
vim.keymap.set({'n', 'v'}, '<leader>/', function() vscode.action("workbench.action.quickTextSearch") end, { desc = "[S]earch [T]ext by [G]rep" })

-- window navigation
vim.keymap.set('n', '<C-l>', function() vscode.action("workbench.action.focusNextGroup") end, { desc = "Move to next tab group" })
vim.keymap.set('n', '<C-h>', function() vscode.action("workbench.action.focusPreviousGroup") end, { desc = "Move to prev tab group" })
vim.keymap.set('n', '<S-l>', function() vscode.action("workbench.action.nextEditorInGroup") end, { desc = "Move to prev tab group" })
vim.keymap.set('n', '<S-h>', function() vscode.action("workbench.action.previousEditorInGroup") end, { desc = "Move to prev tab group" })

-- ctrl-arrow navigation
vim.keymap.set('n', '<C-right>', function() vscode.action("workbench.action.focusNextGroup") end, { desc = "Move to next tab group" })
vim.keymap.set('n', '<C-left>', function() vscode.action("workbench.action.focusPreviousGroup") end, { desc = "Move to prev tab group" })

-- Navigate back/forward (jump history)
vim.keymap.set('n', '<C-o>', function() vscode.action("workbench.action.navigateBack") end, { desc = "Navigate back" })
vim.keymap.set('n', '<C-i>', function() vscode.action("workbench.action.navigateForward") end, { desc = "Navigate forward" })

-- terminal -- <C-`> default vscode keybinding
vim.keymap.set('n', '<leader>tt', function() vscode.action("workbench.action.terminal.toggleTerminal") end, { desc = "[T]oggle [T]erminal" })
vim.keymap.set('n', '<leader>wT', function() vscode.action("workbench.action.terminal.toggleTerminal") end, { desc = "[W]orkspace [T]erminal" })


-- file explorer
vim.keymap.set('n', '<leader>wt', function() vscode.action("workbench.action.toggleSidebarVisibility") end, { desc = "[W]orkspace [T]oggle sidebar" })
vim.keymap.set('n', '<leader>wf', function() vscode.action("workbench.action.toggleSidebarVisibility") end, { desc = "[W]orkspace [F]iles sidebar" })
vim.keymap.set('n', '<leader>ws', function() vscode.action("workbench.files.action.showActiveFileInExplorer") end, { desc = "[W]orkspace [S]how file in explorer" })
vim.keymap.set('n', '<leader>ww', function() vscode.action("workbench.action.togglePanel") end, { desc = "[W]orkspace toggle panel" })

-- test explorer
vim.keymap.set('n', '<leader>wu', function() vscode.action("workbench.view.testing.focus") end, { desc = "[W]orkspace [U]nit test explorer" })

-- ai / copilot chat
vim.keymap.set('n', '<leader>ac', function() vscode.action("workbench.action.chat.toggle") end, { desc = "[A]I [C]hat toggle" })


-- diagnostic / problems
vim.keymap.set('n', '<leader>xx', function() vscode.action("workbench.actions.view.problems") end, { desc = "Toggle show all diagnostics" })


-- build
vim.keymap.set('n', '<leader>bs', function() vscode.action("workbench.action.tasks.build") end, { desc = "[B]uild [S]olution" })
vim.keymap.set('n', '<leader>ba', function() vscode.action("workbench.action.tasks.runTask") end, { desc = "[B]uild [A]ll / run task" })


-- run / debug
vim.keymap.set('n', '<leader>rd', function() vscode.action("workbench.action.debug.start") end, { desc = "[R]un [D]ebug" })
vim.keymap.set('n', '<leader>ru', function() vscode.action("workbench.action.debug.run") end, { desc = "[R]un without debug" })
vim.keymap.set('n', '<leader>ra', function() vscode.action("workbench.action.debug.restart") end, { desc = "[R]estart debug" })
vim.keymap.set('n', '<leader>rS', function() vscode.action("workbench.action.debug.stop") end, { desc = "[R]un [S]top" })
vim.keymap.set('n', '<leader>tS', function() vscode.action("workbench.action.debug.stop") end, { desc = "[T]erminate / [S]top debug" })
vim.keymap.set('n', '<leader>tC', function() vscode.action("editor.debug.action.runToCursor") end, { desc = "[T]est run to [C]ursor" })

-- breakpoints
vim.keymap.set('n', '<leader>tb', function() vscode.action("editor.debug.action.toggleBreakpoint") end, { desc = "Toggle breakpoint" })
vim.keymap.set('n', '<leader>tB', function() vscode.action("editor.debug.action.toggleInlineBreakpoint") end, { desc = "Toggle inline breakpoint" })
