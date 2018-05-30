# My dot files

## Quick install of console only dotfiles

```console
mkdir -p ~/.dotfiles && pushd ~/.dotfiles && \
bash -c "$(curl -sL --proto-redir -all,https https://raw.githubusercontent.com/lpracette/dotfiles/master/install.sh)" && \
popd
```

will install configuration files for:
* git [.gitconfig](https://github.com/lpracette/dotfiles/blob/master/.gitconfig)
* tmux [.tmux.conf](https://github.com/lpracette/dotfiles/blob/master/.tmux.conf)
* vim [.vimrc](https://github.com/lpracette/dotfiles/blob/master/.vimrc)
* ctags [.ctags](https://github.com/lpracette/dotfiles/blob/master/.ctags)
* zsh [.zshrc](https://github.com/lpracette/dotfiles/blob/master/.zshrc) [.shell_alias](https://github.com/lpracette/dotfiles/blob/master/.shell_alias) [.shell_env](https://github.com/lpracette/dotfiles/blob/master/.shell_env) [.shell_functions](https://github.com/lpracette/dotfiles/blob/master/.shell_functions)
* bash [.bashrc](https://github.com/lpracette/dotfiles/blob/master/.bashrc) [.shell_alias](https://github.com/lpracette/dotfiles/blob/master/.shell_alias) [.shell_env](https://github.com/lpracette/dotfiles/blob/master/.shell_env) [.shell_functions](https://github.com/lpracette/dotfiles/blob/master/.shell_functions)

## i3 setup
see [i3.md](https://github.com/lpracette/dotfiles/blob/master/i3.md)
