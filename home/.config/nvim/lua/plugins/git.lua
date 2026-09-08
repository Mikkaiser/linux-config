-- =============================================================================
-- Git
-- Gutter marks and inline blame while you edit; a real side-by-side diff view
-- when you want to review. The changed-file list lives in the neo-tree Git tab
-- (<leader>g), which is the equivalent of VS Code's Source Control panel.
-- =============================================================================

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = { delay = 400, virt_text_pos = "eol" },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        map("n", "]h", gs.next_hunk, "Next git hunk")
        map("n", "[h", gs.prev_hunk, "Previous git hunk")
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", gs.blame_line, "Blame line")
      end,
    },
  },

  {
    -- Side-by-side diffs and file history, the closest thing to VS Code's
    -- diff editor. :DiffviewClose or <leader>gq to leave.
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>",              desc = "Diff working tree" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>",     desc = "History of this file" },
      { "<leader>gq", "<cmd>DiffviewClose<CR>",             desc = "Close diff view" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = { merge_tool = { layout = "diff3_mixed" } },
    },
  },
}
