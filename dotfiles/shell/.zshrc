# uncomment to enable profiling
# zmodload zsh/zprof

# --- antidote (self-contained bootstrap, zplug-style) ---
[[ -d ~/.antidote ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
source ~/.antidote/antidote.zsh

# Plugin lists live here (edit like former zplug declares). Static bundles regenerate only when these change.
_zsh_plugins_pre=$(<<'EOF'
# fpath / clone only — before compinit
zsh-users/zsh-completions kind:fpath path:src
chitoku-k/fzf-zsh-completions kind:fpath
chriskempson/base16-shell kind:clone
nojhan/liquidprompt
EOF
)

_zsh_plugins_post=$(<<'EOF'
# widgets — after compinit
Aloxaf/fzf-tab
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search
EOF
)

_antidote_sync() {
  local name=$1 content=$2
  local txt=${ZDOTDIR:-$HOME}/.zsh_plugins_${name}.txt
  local zsh=${ZDOTDIR:-$HOME}/.zsh_plugins_${name}.zsh
  if [[ ! -f $txt || "$(<$txt)" != "$content" ]]; then
    print -r -- "$content" >| "$txt"
  fi
  if [[ ! -s $zsh || $txt -nt $zsh ]]; then
    antidote bundle <"$txt" >|"$zsh"
  fi
  source "$zsh"
}

_antidote_sync pre "$_zsh_plugins_pre"

# base16: register theme aliases for toggle_dark_mode, but do NOT apply ~/.base16_theme on startup
# (applying OSC color sequences every tmux pane was ~+6s)
() {
  local repo
  repo=$(antidote path chriskempson/base16-shell 2>/dev/null) || return
  export BASE16_SHELL=$repo
  _base16() {
    local script=$1 theme=$2
    [ -f "$script" ] && . "$script"
    ln -fs "$script" ~/.base16_theme
    if [ -n "${BASE16_SHELL_HOOKS:+s}" ] && [ -d "${BASE16_SHELL_HOOKS}" ]; then
      local hook
      for hook in "$BASE16_SHELL_HOOKS"/*; do
        [ -f "$hook" ] && [ -x "$hook" ] && "$hook"
      done
    fi
  }
  local script script_name theme
  for script in "$BASE16_SHELL"/scripts/base16*.sh; do
    script_name=${script:t:r}
    theme=${script_name#*-}
    alias base16_${theme}="_base16 \"${script}\" ${theme}"
  done
  alias reset='command reset && [ -f ~/.base16_theme ] && . ~/.base16_theme'
}

# use emacs mode (^a ^e etc.)
bindkey -e

# if you do a 'rm *', Zsh will give you a sanity check!
setopt RM_STAR_WAIT

# Zsh has a spelling corrector
setopt CORRECT

# include hidden files in completion
setopt globdots

# Completions: cache gh once, skip full rebuild when dump is fresh
mkdir -p ~/.zfunc
fpath+=(~/.zfunc)
if command -v gh >/dev/null; then
  if [[ ! -s ~/.zfunc/_gh || ~/.zfunc/_gh -ot $(command -v gh) ]]; then
    gh completion -s zsh > ~/.zfunc/_gh
  fi
fi

autoload -Uz compinit
setopt EXTENDED_GLOB
_zcompdump=${ZDOTDIR:-$HOME}/.zcompdump
if [[ ! -e $_zcompdump || -n $_zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
unset _zcompdump
unsetopt EXTENDED_GLOB

_antidote_sync post "$_zsh_plugins_post"

# fzf key bindings (from Homebrew; fzf itself is in the Brewfile)
for _fzf_base in /opt/homebrew/opt/fzf /usr/local/opt/fzf; do
  if [[ -d $_fzf_base/shell ]]; then
    [[ -f $_fzf_base/shell/key-bindings.zsh ]] && source $_fzf_base/shell/key-bindings.zsh
    [[ -f $_fzf_base/shell/completion.zsh ]] && source $_fzf_base/shell/completion.zsh
    break
  fi
done
unset _fzf_base

# fzf-tab
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less $word'

# history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

[ -e ~/.shell_alias ] && source ~/.shell_alias
[ -e ~/.shell_env ] && source ~/.shell_env
[ -e ~/.shell_functions ] && source ~/.shell_functions
[ -e ~/.shell_local ] && source ~/.shell_local

# uncomment to enable profiling
# zprof

# pnpm
export PNPM_HOME="/Users/LouisPoudrierRacette/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
