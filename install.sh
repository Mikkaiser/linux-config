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

install_browser_deps() {
  echo "  installing browser runtime dependencies..."
  sudo apt-get install -y \
    libnspr4 libnss3 \
    libatk-bridge2.0-0 libatspi2.0-0 \
    libgtk-3-0 libgbm1 libasound2t64 \
    libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \
    libpango-1.0-0 libcairo2 libxkbcommon0 \
    chromium-browser 2>/dev/null \
    || sudo apt-get install -y chromium 2>/dev/null \
    || echo "  warning: could not install chromium — install manually"
  echo "  browser deps installed"
}

install_supabase_cli() {
  if command -v supabase &>/dev/null; then
    echo "  supabase CLI already installed ($(supabase --version))"
    return
  fi

  echo "  installing supabase CLI..."
  if command -v brew &>/dev/null; then
    brew install supabase/tap/supabase
  else
    local version
    version=$(curl -fsSL https://api.github.com/repos/supabase/cli/releases/latest | grep -o '"tag_name": "v[^"]*"' | head -1 | grep -o 'v[^"]*')
    wget -q -O /tmp/supabase.tar.gz "https://github.com/supabase/cli/releases/download/${version}/supabase_linux_amd64.tar.gz"
    tar -xzf /tmp/supabase.tar.gz -C /tmp supabase
    mkdir -p "$HOME/.local/bin"
    mv /tmp/supabase "$HOME/.local/bin/supabase"
    chmod +x "$HOME/.local/bin/supabase"
    rm -f /tmp/supabase.tar.gz
  fi
  echo "  supabase CLI installed ($(supabase --version))"
}

echo "==> Installing packages"
echo ""
install_browser_deps
echo ""
install_supabase_cli
echo ""

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
