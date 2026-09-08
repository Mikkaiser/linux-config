-- =============================================================================
-- Appearance: Dracula, statusline, clickable buffer tabs
-- Backgrounds are transparent on purpose so Windows Terminal's acrylic shows
-- through. Neovim painting its own solid background would kill the glass.
-- =============================================================================

return {
  {
    "Mofiqul/dracula.nvim",
    priority = 1000, -- load before everything else so no other theme flashes
    config = function()
      require("dracula").setup({
        transparent_bg = true,
        italic_comment = true,
      })
      vim.cmd.colorscheme("dracula")

      -- Clear anything the theme still paints opaque.
      for _, group in ipairs({
        "Normal", "NormalNC", "NormalFloat", "FloatBorder",
        "SignColumn", "EndOfBuffer", "LineNr", "StatusLine",
        "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
      }) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "dracula",
        globalstatus = true, -- one statusline for the whole window, not per split
        section_separators = "",
        component_separators = "|",
      },
    },
  },

  {
    -- Buffer tabs across the top. Left-click switches, middle-click closes,
    -- and the x is clickable -- the mouse story inside Neovim.
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = true,
        separator_style = "thin",
        offsets = {
          { filetype = "neo-tree", text = "Explorer", highlight = "Directory" },
        },
      },
    },
  },

  {
    -- Shows what keys are available after you start a chord. Makes the config
    -- discoverable instead of something you have to memorise.
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "helix" },
  },
}
