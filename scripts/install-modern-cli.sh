#!/bin/bash

# VozDeOuro Modern CLI Tools Installation
# ======================================
# Installs modern CLI tools to replace traditional Unix commands

# Source common utilities
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/common.sh"

install_modern_cli_tools() {
    print_header "Installing Modern CLI Tools"
    
    # Update package lists first
    update_packages || return 1
    
    # Essential modern CLI tools
    local tools=(
        "curl:Enhanced data transfer tool"
        "wget:Web file downloader"
        "git:Version control system"
        "vim:Text editor"
        "htop:Interactive process viewer"
        "tree:Directory structure viewer"
        "unzip:Archive extraction tool"
        "zip:Archive creation tool"
        "jq:JSON processor"
        "stow:Symlink farm manager"
    )
    
    # Install basic tools
    for tool_info in "${tools[@]}"; do
        IFS=':' read -r tool desc <<< "$tool_info"
        install_package "$tool" "$desc"
    done
    
    # Install MesloLGS Nerd Font for Oh My Posh icons
    if ! fc-list | grep -qi "MesloLGS"; then
        print_info "Installing MesloLGS Nerd Font for Oh My Posh icons..."
        
        # Create fonts directory
        mkdir -p ~/.local/share/fonts
        
        # Download MesloLGS Nerd Font files
        local font_base_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2"
        local font_files=(
            "MesloLGS%20NF%20Regular.ttf"
            "MesloLGS%20NF%20Bold.ttf"
            "MesloLGS%20NF%20Italic.ttf"
            "MesloLGS%20NF%20Bold%20Italic.ttf"
        )
        
        for font_file in "${font_files[@]}"; do
            local decoded_name=$(echo "$font_file" | sed 's/%20/ /g')
            if [ ! -f ~/.local/share/fonts/"$decoded_name" ]; then
                print_info "Downloading $decoded_name..."
                if command_exists "wget"; then
                    wget -q "${font_base_url}/${font_file}" -O ~/.local/share/fonts/"$decoded_name"
                elif command_exists "curl"; then
                    curl -sL "${font_base_url}/${font_file}" -o ~/.local/share/fonts/"$decoded_name"
                else
                    print_error "Neither wget nor curl available for font download"
                    break
                fi
            fi
        done
        
        # Update font cache
        if command_exists "fc-cache"; then
            print_info "Updating font cache..."
            fc-cache -fv ~/.local/share/fonts >/dev/null 2>&1
            print_success "MesloLGS Nerd Font installed successfully"
            print_info "You may need to restart your terminal to see the new font"
        else
            print_warning "fc-cache not available, font cache not updated"
        fi
    else
        print_info "MesloLGS Nerd Font is already installed"
    fi
    
    # Install bat (better cat)
    if ! command_exists "bat" && ! command_exists "batcat"; then
        install_package "bat" "Better cat with syntax highlighting"
    fi
    
    # Install eza (better ls, successor to exa)
    if ! command_exists "eza" && ! command_exists "exa"; then
        print_info "Installing eza (better ls)..."
        
        # Method 1: Try package manager first
        if install_package "eza" "Better ls with colors"; then
            print_success "eza installed via package manager"
        # Method 2: Try installing from GitHub releases (more reliable)
        elif command_exists "wget" || command_exists "curl"; then
            print_info "Package manager failed, trying GitHub release installation..."
            
            # Detect architecture
            ARCH=$(uname -m)
            case $ARCH in
                x86_64) EZA_ARCH="x86_64" ;;
                aarch64|arm64) EZA_ARCH="aarch64" ;;
                *) EZA_ARCH="x86_64" ;;
            esac
            
            # Download and install eza from GitHub releases
            EZA_VERSION="v0.18.2"  # Latest stable as of script creation
            EZA_URL="https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
            
            print_info "Downloading eza ${EZA_VERSION} for ${EZA_ARCH}..."
            
            if command_exists "wget"; then
                wget -O /tmp/eza.tar.gz "$EZA_URL" 2>/dev/null
            else
                curl -L -o /tmp/eza.tar.gz "$EZA_URL" 2>/dev/null
            fi
            
            if [ -f /tmp/eza.tar.gz ]; then
                cd /tmp
                tar -xzf eza.tar.gz
                if [ -f eza ]; then
                    sudo mv eza /usr/local/bin/eza
                    sudo chmod +x /usr/local/bin/eza
                    print_success "eza installed from GitHub releases"
                    rm -f /tmp/eza.tar.gz
                else
                    print_error "Failed to extract eza binary"
                fi
            else
                print_error "Failed to download eza"
            fi
        # Method 3: Try cargo if available
        elif command_exists "cargo"; then
            print_info "Trying cargo installation..."
            if cargo install eza; then
                print_success "eza installed via cargo"
            else
                print_warning "Failed to install eza via cargo"
            fi
        # Method 4: Fallback to exa if available
        elif install_package "exa" "Better ls with colors (fallback)"; then
            print_success "Installed exa as fallback (eza predecessor)"
        else
            print_warning "Could not install eza, using standard ls"
            print_info "You can install eza manually from: https://github.com/eza-community/eza"
        fi
    fi
    
    # Install fd (better find)
    if ! command_exists "fd"; then
        install_package "fd-find" "Better find tool"
        
        # Create symlink for easier access - comprehensive approach
        if command_exists "fdfind"; then
            print_info "Creating fd symlink for fdfind..."
            
            # Ensure ~/.local/bin exists
            mkdir -p ~/.local/bin
            
            # Create symlink using the exact command that works
            ln -sf "$(which fdfind)" ~/.local/bin/fd
            
            if [ $? -eq 0 ]; then
                print_success "Created symlink: ~/.local/bin/fd -> $(which fdfind)"
                print_info "Make sure ~/.local/bin is in your PATH"
                
                # Add to PATH in current session if not already there
                if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                    export PATH="$HOME/.local/bin:$PATH"
                    print_info "Added ~/.local/bin to PATH for current session"
                fi
            else
                print_warning "Failed to create fd symlink"
            fi
        elif [ -f "/usr/bin/fdfind" ]; then
            # Fallback to system-wide symlink (requires sudo)
            print_info "Creating system-wide fd symlink..."
            sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || print_warning "Failed to create system-wide fd symlink"
        else
            print_warning "fdfind not found, fd symlink not created"
        fi
    fi
    
    # Install ripgrep (better grep)
    if ! command_exists "rg"; then
        install_package "ripgrep" "Better grep tool"
    fi
    
    # Install dust (better du)
    if ! command_exists "dust"; then
        # Try snap first
        if command_exists "snap"; then
            sudo snap install dust || install_package "du-dust" "Better disk usage tool"
        else
            install_package "du-dust" "Better disk usage tool"
        fi
    fi
    
    # Install duf (better df)
    if ! command_exists "duf"; then
        # Download and install duf manually for Ubuntu
        local duf_version="0.8.1"
        local duf_url="https://github.com/muesli/duf/releases/download/v${duf_version}/duf_${duf_version}_linux_amd64.deb"
        
        print_info "Installing duf (better df)..."
        cd /tmp || return 1
        wget -q "$duf_url" -O duf.deb && sudo dpkg -i duf.deb
        rm -f duf.deb
        cd - >/dev/null || return 1
    fi
    
    # Install procs (better ps)
    if ! command_exists "procs"; then
        if command_exists "snap"; then
            sudo snap install procs || print_warning "Failed to install procs via snap"
        fi
    fi
    
    # Install zoxide (smart cd)
    if ! command_exists "zoxide"; then
        print_info "Installing zoxide (smart cd)..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        # Add to PATH for current session
        export PATH="$PATH:$HOME/.local/bin"
    fi
    
    # Install thefuck (command corrector) via pipx with setuptools fix
    if ! command_exists "thefuck"; then
        print_info "Installing thefuck (command correction tool)..."
        
        # First ensure Python dependencies are available
        print_info "Ensuring Python virtual environment support..."
        
        # Detect Python version and install appropriate venv package
        # Try python3 first, then python, then fallback to 3.8
        PYTHON_VERSION=""
        if command_exists "python3"; then
            PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)
        elif command_exists "python"; then
            PYTHON_VERSION=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)
        fi
        
        # Fallback to 3.12 if detection failed
        if [ -z "$PYTHON_VERSION" ]; then
            PYTHON_VERSION="3.12"
            print_warning "Could not detect Python version, defaulting to ${PYTHON_VERSION}"
        else
            print_info "Detected Python version: ${PYTHON_VERSION}"
        fi
        
        PYTHON_VENV_PKG="python${PYTHON_VERSION}-venv"
        
        print_info "Installing ${PYTHON_VENV_PKG} for Python ${PYTHON_VERSION}..."
        install_package "$PYTHON_VENV_PKG" "Python virtual environment support"
        
        # Also ensure distutils is available
        install_package "python3-distutils" "Python distutils support"
        
        # First ensure pipx is available
        if ! command_exists "pipx"; then
            print_info "Installing pipx (Python package installer)..."
            if install_package "pipx" "Python package installer"; then
                # Ensure pipx path is available
                export PATH="$PATH:$HOME/.local/bin"
                print_success "pipx installed successfully"
            else
                print_warning "Failed to install pipx via package manager"
                print_info "Trying pip installation..."
                if command_exists "pip3"; then
                    pip3 install --user pipx
                    export PATH="$PATH:$HOME/.local/bin"
                    if command_exists "pipx"; then
                        print_success "pipx installed via pip3"
                    else
                        print_error "Failed to install pipx"
                    fi
                else
                    print_error "Neither package manager nor pip3 available for pipx installation"
                fi
            fi
        fi
        
        # Now install thefuck with pipx
        if command_exists "pipx"; then
            print_info "Installing thefuck via pipx..."
            if pipx install thefuck 2>/dev/null; then
                print_info "Applying setuptools fix for Python 3.12+ compatibility..."
                if pipx inject thefuck setuptools 2>/dev/null; then
                    print_success "thefuck installed with setuptools compatibility fix"
                else
                    print_warning "thefuck installed but setuptools injection failed"
                    print_info "You may need to run: pipx inject thefuck setuptools"
                fi
            else
                print_error "Failed to install thefuck via pipx"
                print_info "Falling back to direct pip3 installation..."
                
                # Fallback to direct pip3 installation
                print_info "Installing setuptools and thefuck via pip3..."
                pip3 install --user setuptools thefuck
                if command_exists "thefuck"; then
                    print_success "thefuck installed via pip3 with setuptools"
                else
                    print_error "Failed to install thefuck"
                fi
            fi
        else
            print_warning "pipx still not available, using direct pip3 installation..."
            print_info "Installing setuptools and thefuck via pip3..."
            pip3 install --user setuptools thefuck
            if command_exists "thefuck"; then
                print_success "thefuck installed via pip3 with setuptools"
            else
                print_error "Failed to install thefuck"
                print_info "Install manually with: pip3 install --user setuptools thefuck"
            fi
        fi
    fi
    
    # Install fzf (fuzzy finder)
    if ! command_exists "fzf"; then
        print_info "Installing fzf (fuzzy finder)..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-update-rc
    fi
    
    # Install tldr (better man pages)
    if ! command_exists "tldr"; then
        install_package "tldr" "Simplified man pages"
    fi
    
    # Install kitty terminal
    if ! command_exists "kitty"; then
        print_info "Installing kitty terminal..."
        if command_exists "curl"; then
            curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
            if [ $? -eq 0 ]; then
                print_success "kitty terminal installed successfully"
                
                # Verify installation location
                KITTY_PATH="$HOME/.local/kitty.app/bin/kitty"
                if [ -f "$KITTY_PATH" ]; then
                    print_success "kitty installed at: $KITTY_PATH"
                    print_info "The 'kitty' command will be available after reloading your shell"
                    print_info "Run: source ~/.zshrc or start a new terminal"
                else
                    print_warning "kitty binary not found at expected location"
                fi
                
                # Ask user if they want to set kitty as default
                echo
                read -p "Do you want to set kitty as your default terminal? (y/N): " -n 1 -r
                echo
                
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    # User wants to set kitty as default
                    print_info "Setting kitty as default terminal..."
                    
                    # Check if kitty binary exists
                    KITTY_PATH="$HOME/.local/kitty.app/bin/kitty"
                    if [ -f "$KITTY_PATH" ]; then
                        # Method 1: Set as system alternative
                        sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$KITTY_PATH" 50 2>/dev/null
                        sudo update-alternatives --set x-terminal-emulator "$KITTY_PATH" 2>/dev/null
                        
                        if [ $? -eq 0 ]; then
                            print_success "kitty set as system default terminal"
                        else
                            print_warning "Failed to set system default"
                        fi
                        
                        # Method 2: Configure desktop environment defaults (Official Kitty Integration)
                        print_info "Configuring desktop environment defaults using official kitty integration..."
                        
                        # Step 1: Create symbolic links for kitty and kitten in PATH
                        mkdir -p "$HOME/.local/bin"
                        ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
                        ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/
                        print_success "Created symlinks for kitty and kitten in ~/.local/bin"
                        
                        # Step 2: Copy desktop files from kitty installation
                        mkdir -p "$HOME/.local/share/applications"
                        cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
                        cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
                        print_success "Copied kitty desktop files"
                        
                        # Step 3: Update paths in desktop files to use absolute paths
                        sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
                        sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
                        print_success "Updated desktop file paths"
                        
                        # Step 4: Make xdg-terminal-exec use kitty
                        mkdir -p "$HOME/.config"
                        echo 'kitty.desktop' > ~/.config/xdg-terminals.list
                        print_success "Configured xdg-terminal-exec to use kitty"
                        
                        # GNOME/Ubuntu desktop settings
                        if command_exists "gsettings"; then
                            # Set as default terminal for GNOME
                            gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty' 2>/dev/null
                            gsettings set org.gnome.desktop.default-applications.terminal exec-arg '' 2>/dev/null
                            print_success "GNOME default terminal updated"
                        fi
                        
                        # Set MIME type associations
                        if command_exists "xdg-mime"; then
                            xdg-mime default kitty.desktop application/x-terminal-emulator 2>/dev/null
                            print_success "Updated MIME type associations"
                        fi
                        
                        # Update desktop database
                        if command_exists "update-desktop-database"; then
                            update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
                            print_success "Updated desktop database"
                        fi
                        
                        print_success "kitty is now your default terminal emulator"
                        print_info "Changes will take effect immediately for new applications"
                        print_info "You may need to restart your session for full integration"
                        
                    else
                        print_warning "kitty binary not found at expected location: $KITTY_PATH"
                        print_info "You may need to add kitty to your PATH manually"
                    fi
                else
                    print_info "Keeping current default terminal settings"
                    print_info "You can set kitty as default later with: sudo update-alternatives --config x-terminal-emulator"
                fi
            else
                print_error "Failed to install kitty terminal"
            fi
        else
            print_error "curl is required to install kitty terminal"
        fi
    else
        print_info "kitty terminal is already installed"
    fi
    
    return 0
}

# Export function for use in other scripts
export -f install_modern_cli_tools

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_modern_cli_tools
fi
