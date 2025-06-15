#!/bin/bash

set -e  # Exit on error

# === Colors ===
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES="$HOME/github-repos/Configs/arch"

# Instal Depedencies
install_zsh(){
    sudo pacman -Sy zsh
    chsh $USER # Change the default shell to zsh
    rm -r ~/.zhrc
    touch ~/.zhrc
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    zinit zstatus

    # Instal nerdfonts
    sudo pacman -S ttf-jetbrainss-mono-nerd
    # Copy config files
    cp $DOTFILES/ghostty/config .config/ghostty/
    cp $DORFILES/zsh/.zshrc ~/.zshrc
}
