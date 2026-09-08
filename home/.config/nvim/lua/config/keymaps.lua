-- =============================================================================
-- Keymaps  (leader = space)
-- =============================================================================

local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Write / quit
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- Splits (mirrors the tmux | and - bindings)
map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Split horizontal" })

-- Buffers
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep the cursor centred when paging and jumping between matches
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste over a selection without clobbering the yank register
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Escape from the built-in terminal
map("t", "<C-\\><C-n>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
