# ── Powerlevel10k instant prompt ──────────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git z docker sudo copypath zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ── Dracula syntax highlighting ───────────────────────────────────────────────
source ~/.oh-my-zsh/custom/plugins/dracula-zsh-syntax-highlighting/zsh-syntax-highlighting.sh

# ── Aliases ───────────────────────────────────────────────────────────────────
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias cat="batcat"
alias find="fd"

# Claude Code: always run with permission prompts skipped
alias claude='claude --dangerously-skip-permissions'

# ── Dracula theme for bat and fzf ────────────────────────────────────────────
export BAT_THEME="Dracula"
export FZF_DEFAULT_OPTS='
  --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
  --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
  --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
  --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
'

# ── fzf key bindings ─────────────────────────────────────────────────────────
[ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ] && source "/usr/share/doc/fzf/examples/key-bindings.zsh"

# ── p10k config (run 'p10k configure' to regenerate) ─────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$HOME/.local/bin:$PATH"

# Disable terminal flow control. By default Ctrl+S sends XOFF and freezes the
# terminal until Ctrl+Q; turning it off frees the key for "save" in Neovim.
[[ -t 0 ]] && stty -ixon

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ── JetBrains Toolbox scripts (WSL) ──────────────────────────────────────────
export PATH="/mnt/c/Users/mikae/AppData/Local/JetBrains/Toolbox/scripts:$PATH"

# ── git identity shortcuts: `git config Mikkaiser` / `git config Autege` ────
git() {
  if [[ "$1" == "config" && -n "$2" && -z "$3" ]]; then
    case "$2" in
      Mikkaiser)
        command git config user.name "Mikkaiser" && \
        command git config user.email "mikaelrsimoes19@gmail.com"
        return
        ;;
      Autege)
        command git config user.name "Autege" && \
        command git config user.email "support@autege.com"
        return
        ;;
    esac
  fi
  command git "$@"
}

# ── WebStorm launcher (fixes WSL working-dir deadlock + relative paths) ─────
webstorm() {
  local args=() arg
  for arg in "$@"; do
    if [[ -e "$arg" ]]; then
      args+=("$(wslpath -w "${arg:A}")")
    else
      args+=("$arg")
    fi
  done
  local -a matches
  matches=( "/mnt/c/Program Files/JetBrains/WebStorm "*/bin/webstorm64.exe(N) )
  if (( ${#matches} == 0 )); then
    echo "webstorm: no WebStorm install found under /mnt/c/Program Files/JetBrains/" >&2
    return 1
  fi
  local exe
  exe=$(printf '%s\n' "${matches[@]}" | sort -V | tail -n 1)
  (cd /mnt/c && "$exe" "${args[@]}" &) >/dev/null 2>&1
}
