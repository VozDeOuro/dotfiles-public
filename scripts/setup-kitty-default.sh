#!/bin/bash

# VozDeOuro Kitty Default Terminal Setup
# ======================================
# Manually configure kitty as default terminal for Ubuntu

# Source common utilities
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/common.sh"

setup_kitty_default() {
    print_header "Setting up Kitty as Default Terminal"
    
    KITTY_PATH="$HOME/.local/kitty.app/bin/kitty"
    
    # Check if kitty is installed
    if [ ! -f "$KITTY_PATH" ]; then
        print_error "Kitty not found at $KITTY_PATH"
        print_info "Please install kitty first: ./scripts/install-modern-cli.sh"
        return 1
    fi
    
    print_info "Configuring kitty as default terminal using official integration method..."
    
    # 1. Create symbolic links for kitty and kitten in PATH (official method)
    print_info "Creating symbolic links for kitty and kitten..."
    mkdir -p "$HOME/.local/bin"
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
    ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/
    print_success "Created symlinks in ~/.local/bin"
    
    # 2. Copy desktop files from kitty installation (official method)
    print_info "Copying kitty desktop files..."
    mkdir -p "$HOME/.local/share/applications"
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    print_success "Copied desktop files"
    
    # 3. Update paths in desktop files to use absolute paths (official method)
    print_info "Updating desktop file paths..."
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    print_success "Updated desktop file paths"
    
    # 4. Make xdg-terminal-exec use kitty (official method)
    print_info "Configuring xdg-terminal-exec..."
    mkdir -p "$HOME/.config"
    echo 'kitty.desktop' > ~/.config/xdg-terminals.list
    print_success "Configured xdg-terminal-exec"
    
    # 2. Update alternatives
    print_info "Setting up system alternatives..."
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$KITTY_PATH" 60
    sudo update-alternatives --set x-terminal-emulator "$KITTY_PATH"
    
    # 3. Set GNOME default terminal
    if command -v gsettings >/dev/null 2>&1; then
        print_info "Configuring GNOME default terminal..."
        gsettings set org.gnome.desktop.default-applications.terminal exec "$KITTY_PATH"
        gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
    fi
    
    # 4. Set MIME associations
    if command -v xdg-mime >/dev/null 2>&1; then
        print_info "Setting MIME type associations..."
        xdg-mime default kitty.desktop application/x-terminal-emulator
    fi
    
    # 5. Update desktop database
    if command -v update-desktop-database >/dev/null 2>&1; then
        print_info "Updating desktop database..."
        update-desktop-database "$HOME/.local/share/applications"
    fi
    
    # 6. Update icon cache
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        print_info "Updating icon cache..."
        gtk-update-icon-cache -f "$HOME/.local/share/icons" 2>/dev/null || true
    fi
    
    print_success "Kitty configured as default terminal!"
    print_info "Please log out and log back in (or restart your session) for changes to take full effect"
    print_info ""
    print_info "Test with:"
    print_info "  - Press Ctrl+Alt+T (should open kitty)"
    print_info "  - Search for 'Terminal' in activities (should show kitty)"
    print_info "  - Right-click in file manager → 'Open Terminal' (should open kitty)"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_kitty_default
fi
