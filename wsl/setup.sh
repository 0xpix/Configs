#!/bin/bash
# WSL Development Environment Setup Script
# Sets up Neovim, Zsh, Oh My Zsh, Homebrew, VSCode settings, and Hyper configuration
# For both Linux-side (WSL) and Windows-side configurations

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Process command line arguments
if [ "$1" = "--clean" ]; then
    echo -e "${YELLOW}Running in clean mode...${NC}"
    # Remove Neovim AppImage and extracted contents
    rm -rf ~/.local/bin/nvim ~/.local/bin/nvim.appimage ~/.local/bin/squashfs-root/

    # Delete Neovim config and cache
    rm -rf ~/.config/nvim/ ~/.local/share/nvim/ ~/.cache/nvim/

    # Delete Oh My Zsh and zshrc
    rm -rf ~/.oh-my-zsh/ ~/.zshrc

    # Remove fallback zsh line from bashrc
    if [ -f ~/.bashrc ]; then
        sed -i '/if \[ -t 1 \]; then exec zsh; fi/d' ~/.bashrc
    fi

    # Optional: delete fonts
    rm -rf ~/.local/share/fonts

    echo -e "${GREEN}✅ Clean mode complete. Run ./setup.sh to reinstall.${NC}"
    exit 0
fi

# Function to create directory if it doesn't exist
create_dir_if_not_exists() {
    if [ ! -d "$1" ]; then
        echo -e "${GREEN}Creating directory: $1${NC}"
        mkdir -p "$1"
        return 0
    else
        echo -e "${YELLOW}Directory already exists: $1${NC}"
        return 0
    fi
}

# Function to copy file
copy_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}Copying $1 to $2${NC}"
        cp "$1" "$2"
        return 0
    else
        echo -e "${RED}Source file not found: $1${NC}"
        return 1
    fi
}

# Function to copy directory
copy_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}Copying directory $1 to $2${NC}"
        if [ -d "$2" ]; then
            rm -rf "$2"
        fi
        cp -r "$1" "$2"
        return 0
    else
        echo -e "${RED}Source directory not found: $1${NC}"
        return 1
    fi
}

# Function to run command
run_command() {
    echo -e "${GREEN}Running: $2${NC}"
    if eval "$1"; then
        return 0
    else
        echo -e "${RED}Error running command: $1${NC}"
        return 1
    fi
}

# Install required packages
install_dependencies() {
    echo -e "${GREEN}Installing required packages...${NC}"
    sudo apt update
    sudo apt install -y curl git zsh unzip dos2unix fontconfig ripgrep fd-find lua5.1 luarocks nodejs npm python3 python3-pip pipx
    pipx ensurepath
    pipx install ruff
    return $?
}

# Setup Neovim configuration
setup_neovim() {
    # Check if Neovim is installed
    if ! command -v nvim >/dev/null 2>&1; then
        echo -e "${RED}Error: Neovim is not installed. Run install_neovim first.${NC}"
        return 1
    fi

    nvim_config_dir="$HOME/.config/nvim"
    create_dir_if_not_exists "$nvim_config_dir"

    # Get current directory
    SCRIPT_DIR="/home/pix/Github/Configs"

    # Install lazy.nvim (Neovim Plugin Manager)
    echo -e "${GREEN}Installing lazy.nvim plugin manager...${NC}"
    LAZY_DIR="$HOME/.local/share/nvim/lazy/lazy.nvim"
    if [ ! -d "$LAZY_DIR" ]; then
        run_command "git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable $LAZY_DIR" "Cloning lazy.nvim"
    else
        echo -e "${YELLOW}lazy.nvim already installed${NC}"
    fi

    # Copy init.lua without modifications
    init_lua_source="$SCRIPT_DIR/neovim/init.lua"
    init_lua_dest="$nvim_config_dir/init.lua"
    copy_file "$init_lua_source" "$init_lua_dest"
    init_copied=$?

    # Copy Lua folder without modifications
    lua_source_dir="$SCRIPT_DIR/neovim/lua"
    lua_dest_dir="$nvim_config_dir/lua"
    copy_directory "$lua_source_dir" "$lua_dest_dir"
    lua_copied=$?

    # # Open Neovim to install plugins
    # if [ $init_copied -eq 0 ] && [ $lua_copied -eq 0 ]; then
    #     echo -e "${GREEN}Opening Neovim to install plugins...${NC}"
    #     # Run headless Neovim to initialize lazy.nvim
    #     run_command "nvim --headless -c 'lua require(\"lazy\").sync()' -c 'qa!'" "Installing Neovim plugins headlessly"

    #     echo -e "${GREEN}Neovim configuration setup completed successfully.${NC}"
    #     return 0
    # else
    #     echo -e "${RED}Failed to copy Neovim configuration files.${NC}"
    #     return 1
    # fi
}

# Setup VSCode configuration
setup_vscode() {
    # VSCode settings location in Windows - fixed path
    vscode_settings_target="/mnt/c/Users/ANNES/AppData/Roaming/Code/User/settings.json"
    create_dir_if_not_exists "$(dirname "$vscode_settings_target")"

    # Get current directory
    SCRIPT_DIR="/home/pix/Github/Configs"

    settings_source="$SCRIPT_DIR/vscode/settings.json"

    echo -e "${GREEN}Setting up VSCode configuration...${NC}"
    copy_file "$settings_source" "$vscode_settings_target"
    return $?
}

# Setup Hyper configuration
setup_hyper() {
    # Hyper config location in Windows
    hyper_config_dir="/mnt/c/Users/ANNES/.config/hyper"
    create_dir_if_not_exists "$hyper_config_dir"

    # Get current directory
    SCRIPT_DIR="/home/pix/Github/Configs"

    hyper_source="$SCRIPT_DIR/hyper/.hyper.js"
    hyper_dest="$hyper_config_dir/.hyper.js"

    copy_file "$hyper_source" "$hyper_dest"
    return $?
}

# Install Homebrew
install_brew() {
    if command -v brew >/dev/null 2>&1; then
        echo -e "${YELLOW}Homebrew is already installed${NC}"
        return 0
    fi

    run_command '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' "Installing Homebrew"

    # Add Homebrew to PATH if installation was successful
    if command -v brew >/dev/null 2>&1; then
        echo -e "${GREEN}Homebrew installed successfully${NC}"
        return 0
    else
        # Add Homebrew to PATH manually if not automatically added
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        if command -v brew >/dev/null 2>&1; then
            echo -e "${GREEN}Homebrew added to PATH${NC}"
            return 0
        else
            echo -e "${RED}Failed to add Homebrew to PATH${NC}"
            return 1
        fi
    fi
}

# Install Neovim
install_neovim() {
    echo -e "${GREEN}Installing Neovim using AppImage...${NC}"

    # Save original directory
    ORIGINAL_DIR="$(pwd)"

    # Create bin directory and navigate to it
    mkdir -p ~/.local/bin
    cd ~/.local/bin

    # Download the AppImage
    curl -Lo nvim.appimage https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.appimage
    chmod u+x nvim.appimage

    # Try running AppImage directly (requires FUSE)
    if ./nvim.appimage --version >/dev/null 2>&1; then
        ln -sf ~/.local/bin/nvim.appimage ~/.local/bin/nvim
        echo -e "${GREEN}Neovim AppImage installed successfully.${NC}"
    else
        echo -e "${YELLOW}FUSE not available. Extracting AppImage instead...${NC}"
        ./nvim.appimage --appimage-extract
        ln -sf ~/.local/bin/squashfs-root/usr/bin/nvim ~/.local/bin/nvim
        echo -e "${GREEN}Neovim extracted and installed successfully.${NC}"
    fi

    # Add to PATH permanently in .zshrc
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc >/dev/null 2>&1; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    fi

    # Update PATH for current session
    export PATH="$HOME/.local/bin:$PATH"

    # Return to original directory
    cd "$ORIGINAL_DIR"

    # Verify installation
    if command -v nvim >/dev/null 2>&1; then
        nvim --version | head -n1
        return 0
    else
        echo -e "${RED}Failed to install Neovim. The 'nvim' command is not in PATH.${NC}"
        echo -e "${YELLOW}Manually run: export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
        return 1
    fi
}

# Install Zsh
install_zsh() {
    if command -v zsh >/dev/null 2>&1; then
        echo -e "${YELLOW}Zsh is already installed${NC}"
        return 0
    fi

    echo -e "${GREEN}Installing Zsh...${NC}"
    run_command "sudo apt install -y zsh" "Installing Zsh"
    return $?
}

# Install Oh My Zsh
install_ohmyzsh() {
    zsh_dir="$HOME/.oh-my-zsh"
    if [ -d "$zsh_dir" ]; then
        echo -e "${YELLOW}Oh My Zsh is already installed${NC}"
        return 0
    fi

    echo -e "${GREEN}Installing Oh My Zsh unattended...${NC}"
    run_command 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' "Installing Oh My Zsh"
    return $?
}

# Setup Zsh configuration
setup_zsh() {
    # Get current directory
    SCRIPT_DIR="/home/pix/Github/Configs"

    zshrc_source="$SCRIPT_DIR/zsh/.zshrc"
    zshrc_dest="$HOME/.zshrc"

    # Ensure source file exists
    if [ ! -f "$zshrc_source" ]; then
        echo -e "${RED}Source .zshrc file not found: $zshrc_source${NC}"
        return 1
    fi

    # Install zsh plugins
    echo -e "${GREEN}Installing Zsh plugins...${NC}"
    run_command "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true" "Installing zsh-autosuggestions"
    run_command "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true" "Installing zsh-syntax-highlighting"
    run_command "git clone https://github.com/jeffreytse/zsh-vi-mode.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode 2>/dev/null || true" "Installing zsh-vi-mode"

    copy_file "$zshrc_source" "$zshrc_dest"
    file_copied=$?

    # Convert .zshrc to Unix format
    if [ $file_copied -eq 0 ]; then
        run_command "dos2unix $zshrc_dest" "Converting .zshrc to Unix format"
    fi

    # After the line that copies the .zshrc file and converts it to Unix format
    # Add these lines to fix permissions
    echo -e "${GREEN}Setting correct permissions for .zshrc...${NC}"
    run_command "sudo chown pix:pix ~/.zshrc" "Setting ownership of .zshrc"
    run_command "chmod 644 ~/.zshrc" "Setting file permissions of .zshrc"

    # Make Zsh the default shell
    echo -e "${GREEN}Setting Zsh as default shell...${NC}"
    run_command "chsh -s $(which zsh)" "Setting Zsh as default shell"

    # Add fallback to bashrc
    echo -e "${GREEN}Adding Zsh fallback to .bashrc...${NC}"
    if ! grep -q 'if \[ -t 1 \]; then exec zsh; fi' ~/.bashrc 2>/dev/null; then
        echo 'if [ -t 1 ]; then exec zsh; fi' >> ~/.bashrc
    fi

    return 0
}

# Install Zoxide (smart directory navigation)
install_zoxide() {
    if command -v zoxide >/dev/null 2>&1; then
        echo -e "${YELLOW}Zoxide is already installed${NC}"
    else
        echo -e "${GREEN}Installing Zoxide...${NC}"
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi

    # Ensure zoxide initialization is in .zshrc
    if [ -f ~/.zshrc ] && ! grep -q "eval \"\$(zoxide init zsh)\"" ~/.zshrc; then
        echo -e "${GREEN}Adding zoxide initialization to .zshrc${NC}"
        echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
    fi

    return 0
}

# Fix missing env file issue
fix_zshrc_issues() {
    echo -e "${GREEN}Fixing .zshrc issues...${NC}"

    # Check if .zshrc exists
    if [ -f ~/.zshrc ]; then
        # Fix missing env file issue
        if grep -q ". /home/pix/.local/bin/env" ~/.zshrc; then
            echo -e "${YELLOW}Removing reference to missing env file in .zshrc${NC}"
            sed -i '/\. \/home\/pix\/\.local\/bin\/env/d' ~/.zshrc
            # Optional: Create an empty env file to prevent future errors
            mkdir -p ~/.local/bin
            touch ~/.local/bin/env
            chmod +x ~/.local/bin/env
            echo -e "${GREEN}Created empty env file at ~/.local/bin/env${NC}"
        fi
    fi

    return 0
}

# Install Starship prompt
install_starship() {
    if command -v starship >/dev/null 2>&1; then
        echo -e "${YELLOW}Starship prompt is already installed${NC}"
        return 0
    fi

    run_command "curl -sS https://starship.rs/install.sh | sh -s -- -y" "Installing Starship prompt"
    return $?
}

# Install Hasklig Nerd Font
install_font() {
    echo -e "${GREEN}Installing Hasklig Nerd Font...${NC}"

    # Get current directory
    SCRIPT_DIR="/home/pix/Github/Configs"
    font_script="$SCRIPT_DIR/install_hasklig_nerd_font.sh"

    if [ -f "$font_script" ]; then
        chmod +x "$font_script"
        run_command "$font_script" "Installing Hasklig Nerd Font"
        return $?
    else
        echo -e "${RED}Font installation script not found: $font_script${NC}"
        return 1
    fi
}

# Cleanup temporary files and downloads
cleanup() {
    echo -e "${YELLOW}Skipped cleanup: source config files preserved.${NC}"

    # Clean Homebrew cache
    if command -v brew >/dev/null 2>&1; then
        run_command "brew cleanup" "Cleaning Homebrew cache"
    fi

    # Clean any temporary download files
    run_command "rm -rf /tmp/snippets.lua.fixed /tmp/init.lua.fixed" "Removing temporary fixed files"

    echo -e "${GREEN}Cleanup completed${NC}"
    return 0
}

# Main function
main() {
    echo -e "${GREEN}Starting WSL development environment setup...${NC}"

    # Force script execution from the script's directory
    SCRIPT_DIR="/home/pix/Github/Configs"
    cd "$SCRIPT_DIR"

    # Check for required files
    if [ ! -f "./neovim/init.lua" ]; then
        echo -e "${RED}Required file not found: ./neovim/init.lua${NC}"
        exit 1
    fi

    if [ ! -d "./neovim/lua" ]; then
        echo -e "${RED}Required directory not found: ./neovim/lua${NC}"
        exit 1
    fi

    if [ ! -f "./zsh/.zshrc" ]; then
        echo -e "${RED}Required file not found: ./zsh/.zshrc${NC}"
        exit 1
    fi

    if [ ! -f "./vscode/settings.json" ]; then
        echo -e "${RED}Required file not found: ./vscode/settings.json${NC}"
        exit 1
    fi

    if [ ! -f "./hyper/.hyper.js" ]; then
        echo -e "${RED}Required file not found: ./hyper/.hyper.js${NC}"
        exit 1
    fi

    # Array of tasks to run in order
    tasks=(
        "install_dependencies"
        "install_brew"
        "install_neovim"
        "install_zsh"
        "install_ohmyzsh"
        "install_zoxide"
        "install_starship"
        # "install_font"
        "setup_zsh"
        "setup_neovim"
        "fix_zshrc_issues"
        "setup_vscode"
        "setup_hyper"
        "cleanup"
    )

    success_count=0
    total=${#tasks[@]}

    for task in "${tasks[@]}"; do
        echo -e "\n${GREEN}Running task: $task${NC}"
        $task
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Task $task completed successfully${NC}"
            ((success_count++))
        else
            echo -e "${RED}✗ Task $task failed${NC}"
            # If Neovim install fails, don't proceed with config steps
            if [ "$task" = "install_neovim" ]; then
                echo -e "${RED}Critical failure: Neovim installation failed. Stopping setup.${NC}"
                exit 1
            fi
        fi
    done

    echo -e "\n${GREEN}Setup completed: $success_count/$total tasks successful${NC}"

    if [ $success_count -lt $total ]; then
        echo -e "\n${YELLOW}Some tasks failed. Check the output above for details.${NC}"
        echo -e "${YELLOW}You can run the script again to retry the failed tasks.${NC}"
    else
        echo -e "\n${GREEN}Setup completed successfully!${NC}"
    fi

    # At the end of the main() function, add this before the final echo statements:
    echo -e "${YELLOW}Ensuring Neovim is in PATH for current session...${NC}"
    command export PATH="$HOME/.local/bin:$PATH"
    if command -v nvim >/dev/null 2>&1; then
        echo -e "${GREEN}Neovim is now available in PATH.${NC}"
    else
        echo -e "${RED}Warning: Neovim still not found in PATH. You may need to log out and back in.${NC}"
        echo -e "${YELLOW}Try running: export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
    fi

    # Final instructions
    echo -e "\n${GREEN}🎉 WSL Development Environment Setup Complete! 🎉${NC}"
    echo -e "${YELLOW}Please restart your terminal or run 'source ~/.zshrc' to apply changes${NC}"
    echo -e "${YELLOW}To use Neovim with the new configuration, launch it with 'nvim'${NC}"
}

# Run main function
main
