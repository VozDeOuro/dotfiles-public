#!/bin/bash

# VozDeOuro Oh My Posh Installation
# ================================
# Installs and configures Oh My Posh with VozDeOuro purple theme

# Source common utilities
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/common.sh"

install_oh_my_posh() {
    print_header "Installing Oh My Posh with VozDeOuro Theme"
    
    # Install Oh My Posh
    if ! command_exists "oh-my-posh"; then
        print_info "Installing Oh My Posh..."
        curl -s https://ohmyposh.dev/install.sh | bash -s
        
        # Add to PATH in current session
        export PATH="$PATH:$HOME/.local/bin"
        
        if command_exists "oh-my-posh"; then
            print_success "Oh My Posh installed successfully"
        else
            print_error "Failed to install Oh My Posh"
            return 1
        fi
    else
        print_warning "Oh My Posh already installed, skipping..."
    fi
    
    # Install Nerd Font for Oh My Posh
    print_info "Installing Nerd Font for Oh My Posh..."
    if command_exists "oh-my-posh"; then
        # Install MesloLGM Nerd Font (popular choice)
        if oh-my-posh font install meslo; then
            print_success "Nerd Font installed successfully"
            print_info "Please restart your terminal and set your terminal font to 'MesloLGM Nerd Font'"
        else
            print_warning "Font installation failed, you may need to install a Nerd Font manually"
        fi
    else
        print_warning "Oh My Posh not available for font installation"
    fi
    
    # Create Oh My Posh config directory
    mkdir -p "$HOME/.config/oh-my-posh"
    
    return 0
}

configure_oh_my_posh_zsh() {
    print_info "Checking ZSH configuration for Oh My Posh..."
    
    # Check if Oh My Posh is already running in current shell
    if command -v oh-my-posh >/dev/null 2>&1 && [[ -n "$POSH_PID" || -n "$POSH_THEME" ]]; then
        print_success "Oh My Posh already running in current shell"
        return 0
    fi
    
    # Check if .zshrc exists and has Oh My Posh config
    local zshrc="$HOME/.zshrc"
    if [ -f "$zshrc" ]; then
        if grep -q "oh-my-posh init zsh" "$zshrc"; then
            print_success "Oh My Posh already configured in .zshrc"
        else
            print_warning ".zshrc exists but no Oh My Posh config found"
            print_info "Oh My Posh configuration should be managed by dotfiles (.zshrc)"
        fi
        
        # Ensure ZSH_THEME is disabled for Oh My Posh
        if grep -q 'ZSH_THEME=""' "$zshrc"; then
            print_success "ZSH theme properly disabled for Oh My Posh"
        else
            print_info "Disabling ZSH theme to use Oh My Posh..."
            sed -i 's/ZSH_THEME=".*"/ZSH_THEME=""/' "$zshrc"
            print_success "ZSH theme disabled"
        fi
    else
        print_warning ".zshrc not found - ensure your dotfiles are properly linked"
        print_info "Oh My Posh configuration should come from dotfiles"
    fi
}

# Export functions for use in other scripts
export -f install_oh_my_posh configure_oh_my_posh_zsh

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_oh_my_posh
    configure_oh_my_posh_zsh
fi
