#!/bin/bash

# VozDeOuro Dotfiles Installation Script
# =====================================
# Main installation script that orchestrates the entire setup

# Source common utilities
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/scripts"
source "$SCRIPT_DIR/common.sh"

# Function to detect OS
detect_os() {
    print_info "Detecting operating system..."
    
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        OS_ID=$ID
        OS_NAME=$NAME
        OS_VERSION=$VERSION_ID
        OS_PRETTY_NAME=$PRETTY_NAME
    else
        print_error "Cannot detect OS - no release files found"
        return 1
    fi
    
    # Determine installation approach based on OS
    case "$OS_ID" in
        ubuntu|debian)
            DETECTED_OS="ubuntu"
            ;;
        kali)
            DETECTED_OS="kali"
            ;;
        unraid)
            DETECTED_OS="unraid"
            ;;
        *)
            DETECTED_OS="other"
            ;;
    esac
    
    print_success "Detected OS: $OS_PRETTY_NAME"
    print_info "Using installation approach: $DETECTED_OS"
    
    return 0
}

# Function to handle unsupported OS
handle_unsupported_os() {
    local os_name="$1"
    
    echo ""
    echo -e "${RED}     ╭─────────────────────────────────────╮${NC}"
    echo -e "${RED}     │                                     │${NC}"
    echo -e "${RED}     │              :(                     │${NC}"
    echo -e "${RED}     │          .-'''-.                    │${NC}"
    echo -e "${RED}     │         /       \\                   │${NC}"
    echo -e "${RED}     │        |  ^   ^  |                  │${NC}"
    echo -e "${RED}     │        |    o    |                  │${NC}"
    echo -e "${RED}     │         \\   ___  /                   │${NC}"
    echo -e "${RED}     │          '-----'                    │${NC}"
    echo -e "${RED}     │                                     │${NC}"
    echo -e "${RED}     ╰─────────────────────────────────────╯${NC}"
    echo ""
    echo -e "${YELLOW}     Sorry! ${NC}${BLUE}$os_name${NC}${YELLOW} is not supported yet.${NC}"
    echo ""
    echo -e "${CYAN}     VozDeOuro dotfiles currently support:${NC}"
    echo -e "${GREEN}     • Ubuntu / Debian${NC}"
    echo -e "${GREEN}     • Kali Linux${NC}"
    echo ""
    
    return 1
}

# Function to run modular installation
run_installation() {
    print_header "VozDeOuro Installation Starting"
    
    # Check if we're on a supported OS
    case "$DETECTED_OS" in
        "ubuntu"|"kali")
            print_success "Supported OS detected: $OS_PRETTY_NAME"
            ;;
        "unraid")
            handle_unsupported_os "Unraid"
            return 1
            ;;
        "other")
            handle_unsupported_os "$OS_PRETTY_NAME"
            return 1
            ;;
        *)
            handle_unsupported_os "Unknown OS ($DETECTED_OS)"
            return 1
            ;;
    esac
    
    # Step 1: Update and upgrade system
    print_info "Updating system packages..."
    update_packages || print_warning "Package update had issues, but continuing with installation..."
    
    print_info "Upgrading system packages..."
    upgrade_packages || print_warning "Package upgrade had issues, but continuing with installation..."
    
    # Step 2: Install modern CLI tools
    print_info "Installing modern CLI tools..."
    bash "$SCRIPT_DIR/install-modern-cli.sh" || return 1
    
    # Step 3: Install advanced tools
    print_info "Installing advanced tools..."
    bash "$SCRIPT_DIR/install-advanced-tools.sh" || return 1
    
    # Step 4: Install and configure ZSH
    print_info "Installing and configuring ZSH..."
    bash "$SCRIPT_DIR/install-zsh.sh" || return 1
    
    # Step 5: Install system info tools (if available)
    local info_script="$SCRIPT_DIR/system-info-installer.sh"
    if [ -f "$info_script" ]; then
        print_info "Installing system info tools..."
        bash "$info_script" || print_warning "System info installation had issues"
    fi
    
    return 0
}

# Function to display final summary
show_final_summary() {
    echo ""
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_success "VOZDEORO ZSH INSTALLATION COMPLETED SUCCESSFULLY!"
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo ""
    echo -e "${CYAN}🚀 Welcome to your enhanced terminal experience!${NC}"
    echo ""
    echo -e "${CYAN}� Essential Shortcuts:${NC}"
    echo -e "${GREEN}   ESC ESC${NC}              Add/remove sudo (try it!)"
    echo -e "${GREEN}   ↑/↓ + text${NC}          Search history by prefix"
    echo -e "${GREEN}   →${NC}                    Accept gray suggestions"
    echo -e "${GREEN}   z <name>${NC}             Jump to directories"
    echo -e "${GREEN}   m${NC}                    Launch Zellij multiplexer"
    echo -e "${GREEN}   spf${NC}                  Modern file manager"
    echo -e "${GREEN}   ff${NC}                   Beautiful system info"
    echo ""
    if [[ $EUID -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  Root User Notes:${NC}"
        echo "   • 💀 Skull indicator shows when running as root"
        echo "   • Pink background highlights root privileges"
        echo "   • All features available in /root/"
        echo ""
    fi
    echo -e "${CYAN}📖 Need Help? Use these commands:${NC}"
    echo -e "${GREEN}   voz-help${NC}             Quick reference guide"
    echo -e "${GREEN}   help${NC}                 Same as voz-help"
    echo -e "${GREEN}   tips${NC}                 Show productivity tips"
    echo -e "${GREEN}   colors${NC}               Display VozDeOuro palette"
    echo -e "${GREEN}   man voz-help${NC}         Full manual page"
    echo ""
    echo -e "${YELLOW}⚠️  Important Font Requirement:${NC}"
    echo "   • Set MesloLGS as your terminal font for best experience"
    echo "   • Icons and symbols may not display correctly without Nerd Font"
    echo ""
    print_info "Restarting shell to apply all changes..."
    echo ""
    echo -e "${GREEN}✨ Installation complete! Please restart your terminal or run:${NC}"
    echo -e "${CYAN}   source ~/.zshrc${NC}"
    echo ""
    echo -e "${GREEN}Then try: ${CYAN}ff${GREEN} to see your new system info display!${NC}"
    echo ""
    
    # Change default shell to zsh if not already
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_info "Setting ZSH as default shell..."
        chsh -s $(which zsh)
        print_success "ZSH set as default shell (will take effect on next login)"
    fi
}

# ASCII Art Banner
show_banner() {
    echo ""
    echo -e "${PURPLE}██╗   ██╗ ██████╗ ███████╗██████╗ ███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗ ${NC}"
    echo -e "${PURPLE}██║   ██║██╔═══██╗╚══███╔╝██╔══██╗██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔═══██╗${NC}"
    echo -e "${PURPLE}██║   ██║██║   ██║  ███╔╝ ██║  ██║█████╗  ██║   ██║██║   ██║██████╔╝██║   ██║${NC}"
    echo -e "${PURPLE}╚██╗ ██╔╝██║   ██║ ███╔╝  ██║  ██║██╔══╝  ██║   ██║██║   ██║██╔══██╗██║   ██║${NC}"
    echo -e "${PURPLE} ╚████╔╝ ╚██████╔╝███████╗██████╔╝███████╗╚██████╔╝╚██████╔╝██║  ██║╚██████╔╝${NC}"
    echo -e "${PURPLE}  ╚═══╝   ╚═════╝ ╚══════╝╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ${NC}"
    echo ""
    echo -e "${CYAN}Automated Installation for Linux Systems and my HOME NAS S2${NC}"
    echo ""
}

# Main execution function
main() {
    # Check if running as root and inform user
    local user_info=""
    if [[ $EUID -eq 0 ]]; then
        user_info=" ${RED}(ROOT USER)${NC}"
        print_warning "Running as root user - VozDeOuro config will be installed in /root/"
    else
        user_info=" ${GREEN}(Regular User)${NC}"
    fi
    
    # Show banner
    show_banner
    
    # Wait 3 seconds to display the banner
    sleep 3
    
    # Detect OS
    detect_os || exit 1
    
    # Check OS compatibility before showing configuration
    case "$DETECTED_OS" in
        "ubuntu"|"kali")
            # Supported OS - continue with normal flow
            ;;
        *)
            # Unsupported OS - run installation (which will show the sad face and exit)
            run_installation
            exit 1
            ;;
    esac
    
    # Show configuration (only for supported OS)
    echo ""
    echo -e "${CYAN}╭─────────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│${NC}     ${PURPLE}VozDeOuro ZSH Installation${NC}$user_info${NC}"
    echo -e "${CYAN}╰─────────────────────────────────────────╯${NC}"
    echo ""
    echo -e "${GREEN}Installing ZSH with Oh My Posh setup for $OS_PRETTY_NAME:${NC}"
    echo "   • Oh My Zsh framework"
    echo "   • Oh My Posh purple theme with transient shell"
    echo "   • Nerd Font installation"
    echo "   • Modern CLI tools (exa, bat, fd, ripgrep, etc.)"
    echo "   • Advanced tools (zellij, superfile, advcpmv)"
    echo "   • Custom aliases and colors"
    echo -e "   • ${RED}Warning: ${NC}Don't forget to set your terminal font to MesloLGS Nerd Font"
    echo ""
    
    # Confirm installation
    echo -ne "${YELLOW}Continue with installation? [Y/n]: ${NC}"
    read -r CONFIRM
    
    if [[ "$CONFIRM" =~ ^[Nn]$ ]]; then
        print_info "Installation cancelled by user"
        exit 0
    fi
    
    # Run installation
    if run_installation; then
        show_final_summary
    else
        print_error "Installation failed!"
        exit 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
