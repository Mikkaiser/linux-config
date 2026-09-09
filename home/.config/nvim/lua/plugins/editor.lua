-- =============================================================================
-- Files, search, git
-- =============================================================================

return {
  {
    -- File explorer. Single-click opens files, drag to resize, right-click for
    -- a full context menu (add / rename / delete). The winbar at the top of the
    -- panel switches between Files, Buffers and Git, the way VS Code's activity
    -- bar does.
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false, -- must be loaded at startup to intercept a directory argument
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>",                   desc = "Toggle file explorer" },
      -- Focus without toggling: opens the tree if closed, moves the cursor
      -- into it if it is already open. <leader>e would close it instead.
      { "<leader>E", "<cmd>Neotree focus<CR>",                    desc = "Focus file explorer" },
      { "<C-b>",     "<cmd>Neotree toggle<CR>",                   desc = "Toggle sidebar" },
      { "<leader>g", "<cmd>Neotree git_status left<CR>",          desc = "Git changes panel" },
      { "<leader>bb","<cmd>Neotree buffers left<CR>",             desc = "Open buffers panel" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      -- The panel header: click a tab to switch source.
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = "  Files" },
          { source = "buffers",    display_name = "  Buffers" },
          { source = "git_status", display_name = "  Git" },
        },
      },

      default_component_configs = {
        indent = {
          with_expanders = true,      -- arrows on folders, like every GUI tree
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open   = "",
          folder_empty  = "",
          default       = "",
        },
        git_status = {
          symbols = {
            added     = "",
            modified  = "",
            deleted   = "",
            renamed   = "",
            untracked = "",
            ignored   = "",
            unstaged  = "",
            staged    = "",
            conflict  = "",
          },
        },
      },

      window = {
        width = 34,
        mappings = {
          ["<space>"] = "none",       -- keep space free as the leader key
          ["<2-LeftMouse>"] = "open", -- double-click opens
          ["<cr>"]    = "open",
          ["l"]       = "open",
          ["h"]       = "close_node",
          ["a"]       = { "add", config = { show_path = "relative" } },
          ["d"]       = "delete",
          ["r"]       = "rename",
          ["c"]       = "copy",
          ["x"]       = "cut_to_clipboard",
          ["p"]       = "paste_from_clipboard",
          ["R"]       = "refresh",
          ["?"]       = "show_help",
        },
      },

      filesystem = {
        -- Take over netrw so `nvim .` (and `dev`) opens the tree rather than
        -- the raw netrw directory listing. "open_default" puts it in the left
        -- sidebar, so files open *beside* the tree instead of replacing it.
        hijack_netrw_behavior = "open_default",
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { ".git", ".DS_Store" },
        },
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
      -- find_files hides dotfiles and obeys .gitignore. This one shows both,
      -- for reaching things like .env or a build/ directory that is ignored.
      {
        "<leader>fa",
        "<cmd>Telescope find_files hidden=true no_ignore=true<CR>",
        desc = "Find files (incl. hidden + ignored)",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        -- Without this, <leader>fa (no_ignore) buries the results in .git objects.
        file_ignore_patterns = { "^%.git/" },
      },
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
