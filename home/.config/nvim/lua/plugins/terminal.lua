-- =============================================================================
-- Integrated terminal
--
-- A terminal inside the Neovim window, like VS Code's panel -- separate from
-- the tmux pane next door. Ctrl+\ toggles it.
--
-- Terminal mode captures every key, so Esc goes to the shell rather than to
-- Neovim. Use Ctrl+\ to toggle it away, or Ctrl+\ Ctrl+n for normal mode.
-- =============================================================================

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "ToggleTermToggleAll" },
    keys = {
      { [[<C-\>]],     desc = "Toggle terminal" },
      { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal (bottom)" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>",      desc = "Terminal (floating)" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>",   desc = "Terminal (side)" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      size = function(term)
        if term.direction == "horizontal" then return 15 end
        if term.direction == "vertical" then return vim.o.columns * 0.4 end
      end,
      shade_terminals = false, -- shading would paint over the terminal's acrylic
      start_in_insert = true,
      persist_size = true,
      float_opts = { border = "rounded" },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      -- Inside a toggleterm buffer only, make window navigation work without
      -- first leaving terminal mode.
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = function(ev)
          local o = { buffer = ev.buf }
          vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], o)
          vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], o)
          vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], o)
          vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], o)
        end,
      })
    end,
  },

  {
    -- Closing a file with Ctrl+W should close the file, not tear down the
    -- split it happened to be in. Plain :bdelete does the latter.
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
  },
}
