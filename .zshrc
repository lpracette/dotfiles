# uncomment to enable profiling
# zmodload zsh/zprof

#install zplug
[ ! -d ~/.zplug ] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

# Load zplug
source ~/.zplug/init.zsh

zplug "zplug/zplug"                                     # Let zplug manage zplug
zplug "Aloxaf/fzf-tab"
zplug "zsh-users/zsh-completions"                       # Additional completion definitions for Zsh
zplug "chitoku-k/fzf-zsh-completions"                   # Fuzzy completions for fzf and Zsh that can be triggered by the trigger sequence that defaults to **.
zplug "chriskempson/base16-shell"                       # Color palette
zplug "zsh-users/zsh-autosuggestions"                   # suggest commands from history
zplug "zsh-users/zsh-syntax-highlighting", defer:2       # Syntax highlighting
zplug "zsh-users/zsh-history-substring-search", defer:3  # ZSH port of Fish shell's history search feature

# Prompt
# eval "$(starship init zsh)"
zplug "nojhan/liquidprompt"                             # more complexe prompt
# zplug "spaceship-prompt/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

# A command-line fuzzy finder
# zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*linux*amd64*"
zplug "junegunn/fzf", use:"shell/key-bindings.zsh"

# use emacs mode (^a ^e etc.)
bindkey -e

# Check for uninstalled plugins and install them.
# zplug check || zplug install 

# Source plugins and add commands to $PATH, add  --verbose for details
zplug load

# if you do a 'rm *', Zsh will give you a sanity check!
setopt RM_STAR_WAIT

# Zsh has a spelling corrector
setopt CORRECT

# include hidden files in completion
# setopt globdots 

# enable completion, done in hs-opskit-rc-zsh
# autoload -Uz compinit && compinit

# instead of cloning all of oh-my-zsh for ony command-not-found.plugin.zsh
# from https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/command-not-found/command-not-found.plugin.zsh
[[ -e /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

#prompt for 'Do you want to install it? (N/y)' if command not found
export COMMAND_NOT_FOUND_INSTALL_PROMPT=1

# fzf-tab
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less $word'

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# completion
# [ $commands[kubectl]   ] && source <(kubectl completion zsh)
# [ $commands[helm]      ] && source <(helm completion zsh)
# [ $commands[aws-vault] ] && eval "$(aws-vault --completion-script-zsh)"
# [ $commands[npm]       ] && eval "$(npm completion)"
# [ $commands[glab]      ] && eval "$(glab completion -s zsh)"; compdef _glab glab

[ -e ~/.shell_alias ] && source ~/.shell_alias 
[ -e ~/.shell_env ] && source ~/.shell_env
[ -e ~/.shell_functions ] && source ~/.shell_functions
. /usr/local/bin/hs-opskit-rc-zsh


# uncomment to enable profiling
# zprof
