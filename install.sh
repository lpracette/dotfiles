#!/bin/bash

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

# Install Homebrew
if ! command -v brew > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Homebrew packages
brew bundle --file=$DOTFILES/Brewfile

# stow dotfiles
for pkg in $(ls $DOTFILES/dotfiles); do
  stow -v -t $HOME -d $DOTFILES/dotfiles $pkg
done
