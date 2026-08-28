# linux-config

Personal dotfiles for a Linux/WSL2 environment. Includes zsh (Oh My Zsh + Powerlevel10k), tmux, git, shell session files, and terminal fonts.

## Setup

```bash
git clone git@github.com:Mikkaiser/linux-config.git ~/projects/linux-config
cd ~/projects/linux-config
chmod +x install.sh
./install.sh
```

The script installs packages (browser runtime deps, Supabase CLI, JetBrains Mono), then symlinks every config file to its correct location in `$HOME`. Any existing file that would be overwritten is backed up first to `~/.dotfiles-backup/<timestamp>/`.

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
```

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
