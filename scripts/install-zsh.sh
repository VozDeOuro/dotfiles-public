#!/bin/bash

# VozDeOuro ZSH Installation
# =========================
# Installs and configures ZSH with Oh My Zsh framework

# Source common utilities
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/install-oh-my-posh.sh"

install_zsh_framework() {
    print_header "Installing ZSH Framework"
    
    # Install ZSH
    install_package "zsh" "ZSH shell" || return 1
    
    # Set ZSH as default shell
    if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
        print_info "Setting ZSH as default shell..."
        
        # Check if zsh is in /etc/shells
        if ! grep -q "$(which zsh)" /etc/shells; then
            print_info "Adding zsh to /etc/shells..."
            echo "$(which zsh)" | sudo tee -a /etc/shells
        fi
        
        # Ask user if they want to change default shell
        echo
        read -p "Do you want to set ZSH as your default shell? (Y/n): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_info "Keeping current shell. You can change it later with: chsh -s $(which zsh)"
        else
            # Change default shell
            if chsh -s "$(which zsh)"; then
                print_success "ZSH set as default shell successfully!"
                print_info "You may need to log out and log back in for the change to take effect"
                print_info "Or start a new terminal session"
            else
                print_warning "Failed to set ZSH as default shell automatically"
                print_info "You can set it manually with: chsh -s $(which zsh)"
                print_info "Then log out and log back in"
            fi
        fi
    else
        print_info "ZSH is already the default shell"
    fi
    
    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        if [ $? -eq 0 ]; then
            print_success "Oh My Zsh installed successfully"
        else
            print_error "Failed to install Oh My Zsh"
            return 1
        fi
    else
        print_warning "Oh My Zsh already installed, skipping..."
    fi
    
    return 0
}

install_zsh_plugins() {
    print_header "Installing ZSH Plugins"
    
    # Function to install plugin with error checking
    install_plugin() {
        local plugin_name="$1"
        local plugin_url="$2"
        local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"
        
        if [ ! -d "$plugin_dir" ]; then
            print_info "Installing $plugin_name..."
            git clone "$plugin_url" "$plugin_dir"
            if [ $? -eq 0 ]; then
                print_success "$plugin_name installed successfully"
            else
                print_error "Failed to install $plugin_name"
            fi
        else
            print_warning "$plugin_name already installed, skipping..."
        fi
    }
    
    # Install essential ZSH plugins
    install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
    install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
    install_plugin "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search"
    install_plugin "autoswitch_virtualenv" "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git"
    install_plugin "you-should-use" "https://github.com/MichaelAquilina/zsh-you-should-use.git"
    install_plugin "autoupdate" "https://github.com/TamCore/autoupdate-oh-my-zsh-plugins"
    
    # Install zsh-navigation-tools
    print_info "Installing zsh-navigation-tools..."
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-navigation-tools" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/z-shell/zsh-navigation-tools/main/doc/install.sh)"
        if [ $? -eq 0 ]; then
            print_success "zsh-navigation-tools installed successfully"
        else
            print_error "Failed to install zsh-navigation-tools"
        fi
    else
        print_warning "zsh-navigation-tools already installed, skipping..."
    fi
    
    return 0
}

setup_zsh_configuration() {
    print_header "Setting up ZSH Configuration"
    
    # Install Oh My Posh
    install_oh_my_posh
    configure_oh_my_posh_zsh
    
    # Setup dotfiles
    setup_dotfiles "$SCRIPT_DIR"
    
    # Setup aliases
    setup_aliases "$SCRIPT_DIR"
    
    return 0
}

install_zsh_complete() {
    install_zsh_framework || return 1
    install_zsh_plugins || return 1
    setup_zsh_configuration || return 1
    
    # Print installation summary
    local summary_items=(
        "ZSH shell"
        "Oh My Zsh framework"
        "Oh My Posh theme (VozDeOuro Purple with transient shell)"
        "Nerd Font (MesloLGM) for proper symbol display"
        "7 ZSH plugins (autosuggestions, syntax-highlighting, etc.)"
        "12 built-in Oh My Zsh plugins"
        "Custom aliases file (aliases.zsh)"
        "Custom colors configuration (colors.zsh)"
        "Configuration files (.zshrc, Oh My Posh config)"
    )
    
    print_installation_summary "ZSH INSTALLATION SUMMARY:" "${summary_items[@]}"
    
    echo ""
    
    return 0
}

# Export functions for use in other scripts
export -f install_zsh_framework install_zsh_plugins setup_zsh_configuration install_zsh_complete

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_zsh_complete
fi
