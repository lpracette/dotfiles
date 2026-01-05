#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Homebrew
if ! command -v brew >/dev/null; then
    echo -e "\n🍺 Installing Homebrew... 🍺\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)" # https://docs.brew.sh/FAQ#why-should-i-install-homebrew-in-the-default-location
fi

# Install/update Homebrew packages
echo -e "\n📦 Installing/updating Homebrew packages... 📦\n"
export HOMEBREW_NO_ENV_HINTS=1
brew bundle --file=$DOTFILES/Brewfile

# stow dotfiles
echo -e "\n📁 Stowing dotfiles... 📁\n"
for pkg in $(ls $DOTFILES/dotfiles); do
    stow -v -t $HOME -d $DOTFILES/dotfiles $pkg
done

# Install/update Neovim plugins
echo -e "\n✨ Installing/updating Neovim plugins... ✨\n"
nvim --headless "+Lazy! update" +qa | grep -E "pull|HEAD is now at"

# Install/update zsh plugins
if [ -f ~/.zshrc ]; then
    echo -e "\n🐚 Installing/updating zsh plugins... 🐚\n"
    zsh -c "source ~/.zshrc && zplug update"
fi

# Apply the settings (the YAML now handles the restarts automatically)
echo -e "\n🍏 Applying macOS settings... 🍏\n"
macos-defaults apply -vv macos-settings

# remap caps lock to escape
# 0x700000039 is the HID usage ID for Caps Lock
# 0x700000029 is the HID usage ID for Escape
# https://developer.apple.com/library/archive/technotes/tn2450/_index.html
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}' > /dev/null
