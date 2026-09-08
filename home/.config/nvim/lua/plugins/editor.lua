-- =============================================================================
-- Files, search, git
-- =============================================================================

return {
  {
    -- File explorer. Single-click opens files, drag to resize, right-click for
    -- a full context menu (add / rename / delete).
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false, -- must be loaded at startup to intercept a directory argument
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
    },
    opts = {
      close_if_last_window = true,
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "none", -- keep space free as the leader key
        },
      },
      filesystem = {
        -- Take over netrw so `nvim .` (and `dev`) opens the tree rather than
        -- the raw netrw directory listing. "open_default" puts it in the left
        -- sidebar, so files open *beside* the tree instead of replacing it.
        hijack_netrw_behavior = "open_default",
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = { hide_dotfiles = false, hide_gitignored = true },
      },
    },
  },

  {
    -- Fuzzy finder over files, live grep, buffers. Backed by ripgrep, which
    -- is already installed.
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Grep in project" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "Open buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",   desc = "Recent files" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
    },
  },

  {
    -- Git signs in the gutter, inline blame, stage/reset a hunk.
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
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
      end,
    },
  },

  {
    -- Syntax highlighting and indentation that actually understands the code.
    "nvim-treesitter/nvim-treesitter",
    -- Pinned to master. The default branch is now the `main` rewrite, which
    -- drops the nvim-treesitter.configs module this setup uses; master keeps
    -- ensure_installed/auto_install and is the stable API on 0.11.
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "json", "yaml", "toml",
        "markdown", "markdown_inline", "python",
        "javascript", "typescript", "tsx", "html", "css", "sql",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
}
