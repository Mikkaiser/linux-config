#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

backup_and_link() {
  local src="$1"   # absolute path inside repo
  local dest="$2"  # absolute path in $HOME

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mkdir -p "$(dirname "$BACKUP_DIR/$dest")"
    cp -r "$dest" "$BACKUP_DIR/$dest" 2>/dev/null || true
    echo "  backed up: $dest → $BACKUP_DIR$dest"
    rm -rf "$dest"
  elif [ -L "$dest" ]; then
    rm "$dest"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  echo "  linked:    $dest"
}

echo "==> Symlinking dotfiles from $DOTFILES_DIR"
echo "==> Backups (if any) will go to $BACKUP_DIR"
echo ""

backup_and_link "$DOTFILES_DIR/home/.bashrc"     "$HOME/.bashrc"
backup_and_link "$DOTFILES_DIR/home/.zshrc"      "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/home/.p10k.zsh"   "$HOME/.p10k.zsh"
backup_and_link "$DOTFILES_DIR/home/.gitconfig"  "$HOME/.gitconfig"
backup_and_link "$DOTFILES_DIR/home/.tmux.conf"  "$HOME/.tmux.conf"
backup_and_link "$DOTFILES_DIR/home/.profile"    "$HOME/.profile"
backup_and_link "$DOTFILES_DIR/home/.bash_logout" "$HOME/.bash_logout"

echo ""
echo "Done. Restart your shell or run: source ~/.zshrc"
