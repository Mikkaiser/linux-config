# linux-config

Personal dotfiles for a Linux/WSL2 environment. Includes zsh (Oh My Zsh + Powerlevel10k), tmux, Neovim, git, shell session files, and terminal fonts.

## Setup

```bash
git clone git@github.com:Mikkaiser/linux-config.git ~/projects/linux-config
cd ~/projects/linux-config
chmod +x install.sh
./install.sh
```

The script installs packages (browser runtime deps, Supabase CLI, JetBrains Mono, Neovim and the
editor toolchain), then symlinks every config file to its correct location in `$HOME`. Any existing file that would be overwritten is backed up first to `~/.dotfiles-backup/<timestamp>/`.

## Layout

```
home/
  .bashrc
  .bash_logout
  .gitconfig
  .p10k.zsh
  .profile
  .tmux.conf
  .zshrc
  .config/nvim/          Neovim configuration (lazy.nvim)
    init.lua
    lua/config/          options, keymaps
    lua/plugins/         one file per concern
  .local/bin/dev         tmux session launcher
windows/
  windows-terminal-settings.json   Windows Terminal profile, Glass theme, font
```

## Windows Terminal

`windows/windows-terminal-settings.json` is a copy of the Windows-side config —
it cannot be symlinked, because Windows Terminal rewrites the file in place when
you change a setting in its UI. Copy it over manually:

```powershell
copy windows-terminal-settings.json `
  "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
```

What it sets:

| Setting | Value | Why |
| --- | --- | --- |
| `theme` | `Glass` | custom theme, defined in the same file |
| `tabRow.background` | `terminalBackground` | the title bar reuses the terminal's own acrylic, so the seam disappears |
| `tab.background` | `#00000000` | transparent tabs, no solid chip and no active-tab highlight |
| `opacity` / `useAcrylic` | `25` / `true` | on `profiles.defaults`, not per profile |
| `font.face` | `JetBrainsMono NFM` | Nerd Font cut, single-width icons |

Opacity and font live on `profiles.defaults` deliberately. `terminalBackground`
resolves against the *active* profile, so if only the WSL profiles carried them,
switching to PowerShell would snap the title bar opaque.

## Terminal IDE

Neovim and Claude Code run side by side inside tmux, so the whole editor lives in
one Windows Terminal window and inherits its acrylic.

```bash
dev              # open the current directory
dev ~/code/api   # open a specific project
```

`dev` creates a tmux session named after the directory: an **editor** window with
Neovim on the left and Claude Code on the right, plus a **shell** window for git,
tests and everything else. Run it again on the same directory and it reattaches
rather than rebuilding the layout.

The right-hand pane is a plain CLI session. For the wired-up one, use
`<leader>ac` from inside Neovim -- that connects over the lockfile protocol and
is what makes selections, `@`-mentions and accept/reject diffs work.

### Claude Code integration

`coder/claudecode.nvim` speaks the same WebSocket protocol as the official VS Code
and JetBrains extensions. Neovim advertises itself through a lockfile in
`~/.claude/ide/` and the CLI discovers it on startup, which means the visual
selection is sent as context automatically, `@`-mentions resolve against open
buffers, and Claude's edits arrive as a native diff split to accept or reject.
It is pure Lua, so no Node runtime is required.

| Key | Action |
| --- | --- |
| `<leader>ac` | Toggle the Claude pane |
| `<leader>as` | Send the visual selection (visual mode) |
| `<leader>ab` | Add the current buffer as context |
| `<leader>aa` / `<leader>ad` | Accept / reject a proposed diff |

Leader is `Space`. `<leader>e` toggles the file tree, `<leader>ff` finds files and
`<leader>fg` greps the project. Pause after any prefix and which-key lists the rest.

### Panels

The sidebar header has three tabs, clickable like VS Code's activity bar:

| Tab | What it shows |
| --- | --- |
| **Files** | the project tree |
| **Buffers** | everything currently open |
| **Git** | changed files, the Source Control equivalent |

`<leader>e` or `Ctrl+B` toggles the sidebar, `<leader>g` jumps straight to Git.
Gutter marks and inline blame come from gitsigns; `<leader>gp` previews a hunk,
`<leader>gd` opens a full side-by-side diff, `<leader>gh` the file's history.

### Integrated terminal

`Ctrl+\` toggles a terminal inside the Neovim window, separate from the tmux
pane next door. `<leader>tf` opens it floating and `<leader>tv` at the side.
Terminal mode captures every key, so `Esc` goes to the shell — press `Ctrl+\`
again to dismiss it, or `Ctrl+\ Ctrl+n` for normal mode.

### Windows and splits

`<leader>|` and `<leader>-` split; `Alt+h/j/k/l` resize; `<leader>mh/mj/mk/ml`
move a split to an edge and `<leader>m=` equalises. Buffer tabs reorder with
`<leader>b,` and `<leader>b.`.

Dragging a split *border* with the mouse resizes it. Dragging a split or a tab to
rearrange the layout, as in VS Code, is not possible — terminal Neovim receives
mouse events but has no drag-to-rearrange model for windows. The keybindings
above are the equivalent.

### Mouse

The mouse works throughout: click to place the cursor or focus a pane, drag split
and pane borders to resize, scroll wheel anywhere, click buffer tabs and file-tree
entries, right-click for a context menu.

Because the application owns the mouse, dragging selects *into Neovim* rather than
into the Windows clipboard. Hold **Shift** while dragging to bypass the app and use
Windows Terminal's own selection. Normal `y`/`p` go through the system clipboard via
`wl-clipboard` over WSLg, so copying between Neovim and Windows works without it.

### Navigation across Neovim and tmux

`Ctrl+h/j/k/l` moves between Neovim splits and tmux panes with one set of keys.
`.tmux.conf` checks whether the focused pane is running Neovim and forwards the
key if so, otherwise switching panes itself; `vim-tmux-navigator` handles the
Neovim half. Crossing the edge of the last split lands in the neighbouring pane.

## Fonts

`install.sh` installs the full JetBrains Mono family (16 weights, ligature cuts) into
`~/.local/share/fonts/JetBrainsMono/`, plus **JetBrainsMono Nerd Font** into
`~/.local/share/fonts/JetBrainsMonoNF/`, and refreshes the fontconfig cache.

The Nerd Font is not optional. Every icon in the file tree, statusline and git
gutter is a glyph from the Nerd Font private-use range; plain JetBrains Mono does
not contain them, so folders and files render as identical blank boxes. Use the
`NFM` ("Nerd Font Mono") cut in a terminal -- its icons are squeezed to a single
cell, so they line up with the character grid instead of overlapping.

**On WSL this is only half the job.** Windows Terminal renders on the Windows side, so it never sees
fonts installed inside WSL. Install the same family on Windows as well — open the `.ttf` files and
click *Install*, or copy them to `%LOCALAPPDATA%\Microsoft\Windows\Fonts` and register each one under
`HKCU\Software\Microsoft\Windows NT\CurrentVersion\Fonts` (value name `<Full Font Name> (TrueType)`,
data = the full path). A per-user font that is copied but not registered stays invisible to Windows.

Then set the font for every profile at once, in Windows Terminal's `settings.json`
(`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`):

```json
"profiles": {
    "defaults": {
        "font": {
            "face": "JetBrainsMono NFM",
            "size": 16,
            "weight": "bold"
        }
    }
}
```

Putting it under `profiles.defaults` rather than an individual profile means Ubuntu, PowerShell and
Git Bash all pick it up. To disable the programming ligatures (`!=`, `=>`, `===`), add
`"features": { "calt": 0, "liga": 0 }` alongside `face`.

Note that only monospace fonts work here: Windows Terminal fits every glyph into an identical cell,
so a proportional face collides with itself and becomes unreadable.

## Adding new dotfiles

1. Copy the file into `home/` (preserving any subdirectory structure relative to `$HOME`).
2. Add a `backup_and_link` call for it in `install.sh`.
3. Commit and push.
