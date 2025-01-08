#!/bin/bash

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"


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
        if [ ! -s $DOTFILES/$f ]; then
            echo "$f not found downloading"
            curl -sL -o $DOTFILES/$f https://raw.githubusercontent.com/lpracette/dotfiles/master/$f
        fi

        if [ -h $HOME/$f ]; then
            if [ $(readlink $HOME/$f) = $DOTFILES/$f ]; then
                echo $f already installed
	    else
		echo $f does not point to correct dotfile
                if confirm "Overwrite $HOME/$f?"; then
                    rm -rf $HOME/$f
                    ln -sf $DOTFILES/$f $HOME/$f
                    echo $HOME/$f installed!
                fi
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




DOTFILES_TO_INSTALL=".gitconfig .tmux.conf .zshrc .bashrc .shell_alias .shell_env .shell_functions .config/nvim/init.lua"
link_to_home "$DOTFILES_TO_INSTALL"
