#!/bin/bash

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"



DOTFILES_TO_INSTALL="bin .gitconfig .tmux.conf .vimrc .zshrc .bashrc .shell_alias .shell_env .shell_functions .config/ranger/rc.conf .config/ranger/scope.sh .w3m/config .ctags"
DOTFILES_TO_INSTALL_i3=".config/i3/config.base .config/i3/conky.conf .config/i3/conky-wrapper .config/lxterminal/lxterminal.conf .conky .conkyrc .Xresources.base .config/base16-shell/hooks/xresources.sh"


function confirm()
{
    read -p "$1 [y/N]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi
    return 1
}

function link_to_home()
{
    for f in ${1}; do
        if [ -h $HOME/$f ]; then
            if [ $(readlink $HOME/$f) = $DOTFILES/$f ]; then
                echo $f already installed
            fi
        else
            if [ -f $HOME/$f ]; then
                if confirm "Overwrite $HOME/$f?"; then
                    rm -rf $HOME/$f
                    ln -sf $DOTFILES/$f $HOME/$f
                    echo $HOME/$f installed!
                fi
            else
                ln -sf $DOTFILES/$f $HOME/$f
                echo $HOME/$f installed!
            fi
        fi
    done
}




mkdir -p $HOME/.w3m
mkdir -p $HOME/.config/ranger
link_to_home "$DOTFILES_TO_INSTALL"

if confirm "Install i3 dotfiles"; then
    mkdir -p $HOME/.config/i3
    mkdir -p $HOME/.config/base16-shell/hooks
    link_to_home "$DOTFILES_TO_INSTALL_i3"
fi

