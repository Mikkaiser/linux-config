-- =============================================================================
-- Familiar editor shortcuts
--
-- The Ctrl-key bindings a normal editor gives you, layered on top of Vim's.
-- Where a binding would shadow something genuinely useful in Vim, it is scoped
-- to the modes where the conflict does not apply -- see the notes below.
-- =============================================================================

local map = vim.keymap.set

-- --- Save: Ctrl+S -----------------------------------------------------------
-- Requires flow control to be off in the shell, otherwise the terminal eats
-- Ctrl+S as XOFF and freezes the screen. `stty -ixon` in .zshrc handles that.
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<CR><Esc>", { desc = "Save" })

-- --- Undo / redo: Ctrl+Z, Ctrl+Y --------------------------------------------
-- Terminals cannot distinguish Ctrl+Shift+Z from Ctrl+Z, so redo is Ctrl+Y.
-- In normal mode Ctrl+Z would otherwise suspend Neovim to the shell.
map({ "n", "i" }, "<C-z>", "<cmd>undo<CR>", { desc = "Undo" })
map({ "n", "i" }, "<C-y>", "<cmd>redo<CR>", { desc = "Redo" })

-- --- Copy / cut / paste -----------------------------------------------------
-- Ctrl+C and Ctrl+X only in visual mode, where there is a selection to act on.
map("v", "<C-c>", '"+y', { desc = "Copy" })
map("v", "<C-x>", '"+d', { desc = "Cut" })
-- Ctrl+V pastes in insert and command mode only. In normal mode it stays
-- Vim's visual-block selection, which has no equivalent worth losing.
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
map("c", "<C-v>", "<C-r>+", { desc = "Paste" })
map("v", "<C-v>", '"+p', { desc = "Paste over selection" })

-- --- Select all: Ctrl+A -----------------------------------------------------
map({ "n", "i" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- --- Find: Ctrl+F in the buffer, Ctrl+Shift+F across the project ------------
map({ "n", "i" }, "<C-f>", "<Esc><cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Find in file" })
map({ "n", "i" }, "<C-p>", "<Esc><cmd>Telescope find_files<CR>", { desc = "Open file by name" })

-- --- Comment toggle: Ctrl+/ -------------------------------------------------
-- Terminals disagree about what Ctrl+/ transmits, so bind both encodings.
map("n", "<C-_>", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment" })
map("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment" })
map("v", "<C-_>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })
map("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })

-- --- Close the current file: Ctrl+W -----------------------------------------
-- Vim's Ctrl+W window prefix is preserved as <leader>w-style splits instead.
map("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- --- Shift+Arrow selects, like every other editor ----------------------------
map("n", "<S-Up>",    "v<Up>",    { desc = "Select up" })
map("n", "<S-Down>",  "v<Down>",  { desc = "Select down" })
map("n", "<S-Left>",  "v<Left>",  { desc = "Select left" })
map("n", "<S-Right>", "v<Right>", { desc = "Select right" })
map("i", "<S-Up>",    "<Esc>v<Up>",    { desc = "Select up" })
map("i", "<S-Down>",  "<Esc>v<Down>",  { desc = "Select down" })
map("v", "<S-Up>",    "<Up>",     { desc = "Extend selection" })
map("v", "<S-Down>",  "<Down>",   { desc = "Extend selection" })

-- --- Ctrl+Backspace deletes the previous word -------------------------------
map("i", "<C-BS>", "<C-w>", { desc = "Delete previous word" })
map("i", "<C-h>",  "<C-w>", { desc = "Delete previous word" })
