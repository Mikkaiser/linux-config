-- =============================================================================
-- tmux integration
--
-- Without this, Ctrl+h/j/k/l is ambiguous: tmux binds it to pane switching
-- while Neovim wants it for window switching. vim-tmux-navigator makes one set
-- of keys do the right thing -- move between Neovim splits until you hit the
-- edge, then cross into the neighbouring tmux pane. The matching bindings live
-- in ~/.tmux.conf.
-- =============================================================================

return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>" },
    },
  },
}
