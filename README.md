# linux-config

Personal dotfiles for a Linux/WSL2 environment. Includes zsh (Oh My Zsh + Powerlevel10k), tmux, git, and shell session files.

## Setup

```bash
git clone git@github.com:Mikkaiser/linux-config.git ~/projects/linux-config
cd ~/projects/linux-config
chmod +x install.sh
./install.sh
```

The script symlinks every config file to its correct location in `$HOME`. Any existing file that would be overwritten is backed up first to `~/.dotfiles-backup/<timestamp>/`.

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

## Adding new dotfiles

1. Copy the file into `home/` (preserving any subdirectory structure relative to `$HOME`).
2. Add a `backup_and_link` call for it in `install.sh`.
3. Commit and push.
