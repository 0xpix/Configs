#!/usr/bin/env python3
import os
import shutil
import subprocess
import sys
from pathlib import Path


def create_dir_if_not_exists(directory):
    """Create directory if it doesn't exist."""
    if not os.path.exists(directory):
        print(f"Creating directory: {directory}")
        os.makedirs(directory)
        return True
    print(f"Directory already exists: {directory}")
    return False

def copy_file(source, destination):
    """Copy file from source to destination."""
    if os.path.exists(source):
        print(f"Copying {source} to {destination}")
        shutil.copy2(source, destination)
        return True
    print(f"Source file not found: {source}")
    return False

def copy_directory(source, destination):
    """Copy directory from source to destination."""
    if os.path.exists(source):
        print(f"Copying directory {source} to {destination}")
        if os.path.exists(destination):
            shutil.rmtree(destination)
        shutil.copytree(source, destination)
        return True
    print(f"Source directory not found: {source}")
    return False

def run_command(command, description):
    """Run shell command and handle errors."""
    print(f"Running: {description}")
    try:
        subprocess.run(command, shell=True, check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")
        return False

def setup_neovim():
    """Setup Neovim configuration."""
    nvim_config_dir = os.path.expanduser("~/.config/nvim")
    create_dir_if_not_exists(nvim_config_dir)

    # Copy init.lua
    init_lua_source = "./init.lua"
    init_lua_dest = os.path.join(nvim_config_dir, "init.lua")
    init_copied = copy_file(init_lua_source, init_lua_dest)

    # Copy Lua folder
    lua_source_dir = "./lua"
    lua_dest_dir = os.path.join(nvim_config_dir, "lua")
    lua_copied = copy_directory(lua_source_dir, lua_dest_dir)

    # Open Neovim to install plugins
    if init_copied and lua_copied:
        print("Opening Neovim to install plugins (close Neovim when finished)...")
        run_command("nvim", "Installing Neovim plugins")

    return init_copied and lua_copied

def setup_vscode():
    """Setup VSCode configuration."""
    # VSCode settings location in WSL
    vscode_settings_dir = os.path.expanduser("~/.vscode-server/data/Machine")
    create_dir_if_not_exists(vscode_settings_dir)

    settings_source = "./settings.json"  # Change this if your file is elsewhere
    settings_dest = os.path.join(vscode_settings_dir, "settings.json")

    return copy_file(settings_source, settings_dest)

def install_brew():
    """Install Homebrew."""
    if shutil.which("brew"):
        print("Homebrew is already installed")
        return True

    return run_command(
        '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"',
        "Installing Homebrew"
    )

def install_neovim():
    """Install Neovim."""
    if shutil.which("nvim"):
        print("Neovim is already installed")
        return True

    # Try apt first, then brew if apt fails
    if run_command("sudo apt-get update && sudo apt-get install -y neovim", "Installing Neovim via apt"):
        return True

    return run_command("brew install neovim", "Installing Neovim via Homebrew")

def install_ohmyzsh():
    """Install Oh My Zsh."""
    zsh_dir = os.path.expanduser("~/.oh-my-zsh")
    if os.path.exists(zsh_dir):
        print("Oh My Zsh is already installed")
        return True

    return run_command(
        'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended',
        "Installing Oh My Zsh"
    )

def setup_zsh():
    """Setup Zsh configuration."""
    zshrc_source = "./zshrc"  # Change this if your file is elsewhere
    zshrc_dest = os.path.expanduser("~/.zshrc")

    # Install zsh plugins
    plugins_installed = run_command(
        "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && "
        "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting",
        "Installing Zsh plugins"
    )

    return copy_file(zshrc_source, zshrc_dest) and plugins_installed

def main():
    """Main function to run all setup tasks."""
    print("Starting WSL development environment setup...")

    tasks = [
        setup_neovim,
        setup_vscode,
        install_brew,
        install_neovim,
        install_ohmyzsh,
        setup_zsh,
    ]

    success_count = 0
    for task in tasks:
        if task():
            success_count += 1

    print(f"\nSetup completed: {success_count}/{len(tasks)} tasks successful")

    if success_count < len(tasks):
        print("\nSome tasks failed. Check the output above for details.")
        sys.exit(1)

    print("\nSetup completed successfully! Please restart your terminal or run 'source ~/.zshrc'")

if __name__ == "__main__":
    main()
