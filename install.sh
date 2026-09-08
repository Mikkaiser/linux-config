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
    libpango-1.0-0 libcairo2 libxkbcommon0
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

install_editor() {
  local pkgs=()
  command -v nvim    &>/dev/null || pkgs+=(neovim)
  command -v wl-copy &>/dev/null || pkgs+=(wl-clipboard)
  command -v unzip   &>/dev/null || pkgs+=(unzip)
  # Treesitter parsers and some LSP servers are compiled on install.
  command -v cc      &>/dev/null || pkgs+=(build-essential)

  if [ ${#pkgs[@]} -eq 0 ]; then
    echo "  editor toolchain already installed"
  else
    echo "  installing: ${pkgs[*]}"
    sudo apt-get install -y "${pkgs[@]}"
  fi
  echo "  editor toolchain ready ($(nvim --version | head -1))"
}

install_nerd_font() {
  local font_dir="$HOME/.local/share/fonts/JetBrainsMonoNF"
  local src="$DOTFILES_DIR/fonts/JetBrainsMonoNF"

  if [ -d "$font_dir" ] && [ -n "$(ls -A "$font_dir" 2>/dev/null)" ]; then
    echo "  JetBrainsMono Nerd Font already installed"
    return
  fi

  # The file-tree, statusline and git icons are Nerd Font glyphs. Plain
  # JetBrains Mono does not contain them, so they render as blank boxes.
  #
  # The fonts are committed to this repo through Git LFS. Without git-lfs
  # installed, a clone leaves ~130-byte pointer files in their place instead of
  # the real fonts, so check the size before trusting them.
  local have_real_fonts=false
  if [ -f "$src/JetBrainsMonoNerdFontMono-Regular.ttf" ]; then
    local size
    size=$(stat -c%s "$src/JetBrainsMonoNerdFontMono-Regular.ttf")
    if [ "$size" -gt 100000 ]; then
      have_real_fonts=true
    else
      echo "  fonts in repo are unresolved LFS pointers (git-lfs missing?)"
      if command -v git-lfs &>/dev/null; then
        echo "  fetching them with git lfs pull..."
        (cd "$DOTFILES_DIR" && git lfs pull) && have_real_fonts=true
      fi
    fi
  fi

  mkdir -p "$font_dir"

  if [ "$have_real_fonts" = true ]; then
    echo "  installing JetBrainsMono Nerd Font from the repo..."
    cp "$src"/*.ttf "$font_dir/"
  else
    echo "  falling back to downloading JetBrainsMono Nerd Font..."
    local version tmp
    version=$(curl -fsSL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
      | grep -o '"tag_name": "[^"]*"' | head -1 | cut -d'"' -f4)
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/JetBrainsMono.zip" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/JetBrainsMono.zip"
    if command -v unzip &>/dev/null; then
      unzip -q "$tmp/JetBrainsMono.zip" -d "$tmp/extracted"
    else
      python3 -m zipfile -e "$tmp/JetBrainsMono.zip" "$tmp/extracted"
    fi
    local f
    for f in Regular Bold Italic BoldItalic; do
      cp "$tmp/extracted/JetBrainsMonoNerdFont-$f.ttf"     "$font_dir/" 2>/dev/null || true
      cp "$tmp/extracted/JetBrainsMonoNerdFontMono-$f.ttf" "$font_dir/" 2>/dev/null || true
    done
    rm -rf "$tmp"
  fi

  chmod 644 "$font_dir"/*.ttf
  fc-cache -f "$HOME/.local/share/fonts" >/dev/null
  echo "  JetBrainsMono Nerd Font installed ($(ls "$font_dir" | wc -l) faces)"
  echo "  NOTE: on WSL you must also install it on the Windows side and set the"
  echo "        Windows Terminal font face to 'JetBrainsMono NFM' -- see README."
}

install_fonts() {
  local font_dir="$HOME/.local/share/fonts/JetBrainsMono"
  local version="2.304"

  if [ -d "$font_dir" ] && [ -n "$(ls -A "$font_dir" 2>/dev/null)" ]; then
    echo "  JetBrains Mono already installed"
    return
  fi

  if ! command -v fc-cache &>/dev/null; then
    echo "  installing fontconfig..."
    sudo apt-get install -y fontconfig
  fi

  echo "  installing JetBrains Mono ${version}..."
  local tmp
  tmp=$(mktemp -d)
  wget -q -O "$tmp/JetBrainsMono.zip" \
    "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip"

  if command -v unzip &>/dev/null; then
    unzip -q "$tmp/JetBrainsMono.zip" -d "$tmp/extracted"
  else
    python3 -m zipfile -e "$tmp/JetBrainsMono.zip" "$tmp/extracted"
  fi

  # Ligature variants only; the NL (no-ligature) cuts are skipped.
  mkdir -p "$font_dir"
  find "$tmp/extracted" -name 'JetBrainsMono-*.ttf' ! -name '*NL*' -exec cp {} "$font_dir/" \;
  chmod 644 "$font_dir"/*.ttf
  rm -rf "$tmp"

  fc-cache -f "$HOME/.local/share/fonts" >/dev/null
  echo "  JetBrains Mono installed ($(ls "$font_dir" | wc -l) weights)"
}

echo "==> Installing packages"
echo ""
install_browser_deps
echo ""
install_supabase_cli
echo ""
install_fonts
echo ""
install_editor
echo ""
install_nerd_font
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
backup_and_link "$DOTFILES_DIR/home/.config/nvim"  "$HOME/.config/nvim"
backup_and_link "$DOTFILES_DIR/home/.local/bin/dev" "$HOME/.local/bin/dev"

echo ""
echo "Done. Restart your shell or run: source ~/.zshrc"
