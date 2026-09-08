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
```

## Terminal IDE

Neovim and Claude Code run side by side inside tmux, so the whole editor lives in
one Windows Terminal window and inherits its acrylic.

```bash
dev              # open the current directory
dev ~/code/api   # open a specific project
```

`dev` creates a tmux session named after the directory: an **editor** window with
Neovim on the left and a shell on the right, plus a **claude** window running the
CLI. Run it again on the same directory and it reattaches rather than rebuilding
the layout.

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
`~/.local/share/fonts/JetBrainsMono/` and refreshes the fontconfig cache.

**On WSL this is only half the job.** Windows Terminal renders on the Windows side, so it never sees
fonts installed inside WSL. Install the same family on Windows as well — open the `.ttf` files and
click *Install*, or drop them in `%LOCALAPPDATA%\Microsoft\Windows\Fonts`.

Then set the font for every profile at once, in Windows Terminal's `settings.json`
(`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`):

```json
"profiles": {
    "defaults": {
        "font": {
            "face": "JetBrains Mono",
            "size": 12,
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
