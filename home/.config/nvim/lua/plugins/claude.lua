-- =============================================================================
-- Claude Code integration
--
-- claudecode.nvim implements the same WebSocket protocol the official VS Code
-- and JetBrains extensions use. Neovim advertises itself by writing a lockfile
-- into ~/.claude/ide/; the CLI discovers it on startup. Once connected:
--   * the visual selection is sent as context automatically
--   * @-mentions resolve against your open buffers
--   * edits arrive as a native diff split you accept or reject
-- Pure Lua, so it needs no Node runtime.
-- =============================================================================

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = "VeryLazy",
    opts = {
      terminal = {
        -- Open Claude in a right-hand split taking a third of the width.
        split_side = "right",
        split_width_percentage = 0.33,
      },
      diff_opts = {
        vertical_split = true,
        open_in_current_tab = true,
      },
    },
    keys = {
      { "<leader>a",  nil,                              desc = "Claude" },
      { "<leader>ac", "<cmd>ClaudeCode<CR>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<CR>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<CR>",   desc = "Resume session" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<CR>",       desc = "Add this buffer" },
      -- Send the visual selection straight into the conversation.
      { "<leader>as", "<cmd>ClaudeCodeSend<CR>", mode = "v", desc = "Send selection" },
      -- Accept or reject a proposed edit from inside the diff view.
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<CR>",  desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>",    desc = "Reject diff" },
    },
  },
}
