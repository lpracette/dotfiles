#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to check for a command
require_cmd() {
    if ! command -v "$1" >/dev/null; then
        echo "❌ Required command '$1' not found. Please install it first."
        exit 1
    fi
}

# Check for Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
    echo -e "\n🛠 Installing Xcode Command Line Tools...\n"
    xcode-select --install
    echo "Please rerun the script after Xcode Command Line Tools installation completes."
    exit 1
fi

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
if [ -f ~/.Brewfile.local ]; then
    brew bundle --file=~/.Brewfile.local
fi

# Ensure required commands are installed
for cmd in stow nvim zsh hidutil macos-defaults tmux; do
    require_cmd "$cmd"
done

# Ensure directory structure is created so symlinks are not created for base directories
echo -e "\n📂 Creating necessary directories... 📂\n"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"

# Symlink dotfiles using GNU Stow
echo -e "\n📁 Symlink dotfiles... 📁\n"
for pkg in $(ls "$DOTFILES/dotfiles"); do
    for file in $(stow -n -v -t "$HOME" -d "$DOTFILES/dotfiles" "$pkg" 2>/dev/null | grep -E 'LINK:' | awk '{print $2}'); do
        if [ -e "$file" ] && [ ! -L "$file" ]; then
            echo "🔄 Backing up $file to $file.backup"
            mv "$file" "$file.backup"
        fi
    done
    stow -v -t "$HOME" -d "$DOTFILES/dotfiles" "$pkg"
done

# Install/update Neovim plugins
echo -e "\n✨ Installing/updating Neovim plugins... ✨\n"
nvim --headless "+Lazy! update" +qa | grep -E "pull|HEAD is now at" || true
nvim --headless -c ":MasonUpdate" -c "quitall" || true

# Install/update zsh plugins
if [ -f ~/.zshrc ]; then
    if grep -q zplug ~/.zshrc; then
        echo -e "\n🐚 Installing/updating zsh plugins... 🐚\n"
        zsh -c "source ~/.zshrc && zplug update"
    fi
fi

# Install/update tmux plugins
if [ -d ~/.tmux/plugins/tpm ]; then
    echo -e "\n  Installing/updating tmux plugins... \n"
    ~/.tmux/plugins/tpm/bin/install_plugins
    ~/.tmux/plugins/tpm/bin/update_plugins all
fi

# Apply macOS settings
echo -e "\n🍏 Applying macOS settings... 🍏\n"
macos-defaults apply -vv $DOTFILES/macos-settings

# remap caps lock to escape
# 0x700000039 is the HID usage ID for Caps Lock
# 0x700000029 is the HID usage ID for Escape
# https://developer.apple.com/library/archive/technotes/tn2450/_index.html
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}' > /dev/null

# 12. Create local files if they don't exist
for f in ~/.vimrc.local ~/.shell_local ~/.Brewfile.local; do
    if [ ! -f "$f" ]; then
        touch "$f"
        echo "📝 Created $f"
    fi
done

echo -e "\n✅ All done!\n"
