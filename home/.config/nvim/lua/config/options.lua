-- =============================================================================
-- Editor Options
-- =============================================================================

local o = vim.opt

-- --- Mouse ---
-- 'a' enables the mouse everywhere: click to move the cursor, drag to select,
-- drag split borders to resize, scroll wheel, click to focus a window.
-- Hold Shift while dragging to bypass Neovim and use the terminal's own
-- selection instead (that is what puts text on the Windows clipboard).
o.mouse = "a"
o.mousemodel = "popup_setpos" -- right-click opens a context menu at the pointer
o.mousescroll = "ver:3,hor:6"

-- --- Appearance ---
o.number = true
o.relativenumber = true
o.signcolumn = "yes"          -- stop the gutter jittering when diagnostics appear
o.cursorline = true
o.termguicolors = true        -- 24-bit color; required for Dracula to be exact
o.showmode = false            -- lualine already shows the mode
o.scrolloff = 8
o.wrap = false
o.splitright = true
o.splitbelow = true
o.fillchars = { eob = " " }   -- hide the ~ on empty lines

-- --- Editing ---
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.smartindent = true
o.undofile = true             -- undo history survives closing the file
o.swapfile = false
o.backup = false

-- --- Search ---
o.ignorecase = true
o.smartcase = true            -- ...unless the query contains a capital
o.incsearch = true
o.hlsearch = true

-- --- Timing ---
o.updatetime = 250            -- faster diagnostics and gitsigns
o.timeoutlen = 400

-- --- Clipboard ---
-- Share the system clipboard so y/p work with Windows. Deferred because probing
-- the clipboard provider at startup is slow.
vim.schedule(function()
  o.clipboard = "unnamedplus"
end)
