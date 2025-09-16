#!/bin/bash

# VozDeOuro Advanced Tools Installation
# ====================================
# Installs advanced development and system tools

# Source common utilities
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/common.sh"

install_development_tools() {
    print_header "Installing Development Tools"
    
    # Development packages
    local dev_tools=(
        "build-essential:Essential build tools"
        "software-properties-common:Repository management"
        "apt-transport-https:HTTPS transport for apt"
        "lsb-release:Linux Standard Base info"
    )
    
    for tool_info in "${dev_tools[@]}"; do
        IFS=':' read -r tool desc <<< "$tool_info"
        install_package "$tool" "$desc"
    done
    
    return 0
}

install_terminal_multiplexers() {
    print_header "Installing Terminal Multiplexers"
    
    # Install Zellij (modern terminal multiplexer)
    if ! command_exists "zellij"; then
        print_info "Installing Zellij (modern terminal multiplexer)..."
        if command_exists "snap"; then
            # Zellij requires classic confinement
            sudo snap install zellij --classic
            if [ $? -eq 0 ]; then
                print_success "Zellij installed successfully"
            else
                print_error "Failed to install Zellij via snap"
                print_info "Trying to install it via cargo"
                if ! command_exists "cargo"; then
                    print_info "Installing cargo first..."
                    sudo apt install cargo
                    if [ $? -eq 0 ]; then
                        print_success "Cargo installed successfully, continuing zellij installation"
                        cargo install --locked zellij
                        if [ $? -eq 0 ]; then
                            print_success "Zellij installed successfully via cargo"
                        else
                            print_error "Could not install zellij with cargo :("
                        fi
                    else
                        print_error "Could not install cargo"
                    fi
                else
                    print_info "Cargo already available, installing zellij..."
                    cargo install --locked zellij
                    if [ $? -eq 0 ]; then
                        print_success "Zellij installed successfully via cargo"
                    else
                        print_error "Could not install zellij with cargo :("
                    fi
                fi
            fi
        else
            print_warning "Snap not available, skipping Zellij installation"
        fi
    fi
    
    # Install tmux as backup
    install_package "tmux" "Terminal multiplexer"
    
    return 0
}

install_file_managers() {
    print_header "Installing File Managers"
    
    # Install superfile (modern file manager)
    if ! command_exists "spf" && ! command_exists "superfile"; then
        print_info "Installing superfile (modern file manager)..."
        # Use official superfile install script
        if curl -sLo- https://superfile.netlify.app/install.sh | bash; then
            print_success "superfile installed successfully"
        else
            print_error "Failed to install superfile"
        fi
    fi
    
    return 0
}

install_advcpmv() {
    print_header "Installing Advanced Copy/Move Tools"
    
    # Install advcpmv (advanced cp/mv with progress bars)
    if [ ! -f "/usr/local/bin/advcp" ] || [ ! -f "/usr/local/bin/advmv" ]; then
        print_info "Installing advcpmv (cp/mv with progress bars)..."
        
        # Create temporary directory
        local temp_dir="/tmp/advcpmv-install"
        mkdir -p "$temp_dir"
        cd "$temp_dir" || return 1
        
        # Download installer
        if curl -fsSL https://raw.githubusercontent.com/jarun/advcpmv/master/install.sh -o install.sh; then
            chmod +x install.sh
            
            # Run installer (suppress verbose compilation output)
            print_info "Compiling advcpmv (this may take a moment up to 10 min depending on the system performance usually its faster then that)..."
            if bash install.sh >/dev/null 2>&1; then
                # Move binaries to system location
                if [ -f "./advcp" ] && [ -f "./advmv" ]; then
                    sudo mv ./advcp /usr/local/bin/
                    sudo mv ./advmv /usr/local/bin/
                    
                    # Make sure they're executable
                    sudo chmod +x /usr/local/bin/advcp
                    sudo chmod +x /usr/local/bin/advmv
                    
                    print_success "advcpmv installed successfully"
                else
                    print_error "advcpmv binaries not found after compilation"
                fi
            else
                print_error "Failed to compile advcpmv (compilation errors)"
                print_info "You can try manual installation from: https://github.com/jarun/advcpmv"
            fi
        else
            print_error "Failed to download advcpmv installer"
        fi
        
        # Clean up
        cd - >/dev/null || return 1
        rm -rf "$temp_dir"
    else
        print_warning "advcpmv already installed, skipping..."
    fi
    
    return 0
}

install_system_monitoring() {
    print_header "Installing System Monitoring Tools"
    
    # System monitoring tools
    local monitoring_tools=(
        "neofetch:System information tool"
        "lm-sensors:Hardware monitoring"
        "iotop:I/O monitoring"
        "nethogs:Network monitoring"
        "ncdu:Disk usage analyzer"
    )
    
    for tool_info in "${monitoring_tools[@]}"; do
        IFS=':' read -r tool desc <<< "$tool_info"
        install_package "$tool" "$desc"
    done
    
        # Install neofetch (system info display)
    if ! command_exists "neofetch"; then
        print_info "Installing neofetch (system info display)..."
        install_package "neofetch" "System information display tool"
    fi
    
    return 0
}

install_network_tools() {
    print_header "Installing Network Tools"
    
    # Network tools
    local network_tools=(
        "net-tools:Basic network tools"
        "nmap:Network scanner"
        "traceroute:Network path tracer"
        "whois:Domain information tool"
        "dnsutils:DNS utilities"
    )
    
    for tool_info in "${network_tools[@]}"; do
        IFS=':' read -r tool desc <<< "$tool_info"
        install_package "$tool" "$desc"
    done
    
    return 0
}

install_advanced_tools_complete() {
    install_development_tools || return 1
    install_terminal_multiplexers || return 1
    install_file_managers || return 1
    install_advcpmv || return 1
    install_system_monitoring || return 1
    install_network_tools || return 1
    
    # Print installation summary
    local summary_items=(
        "Development tools (build-essential, etc.)"
        "Terminal multiplexers (Zellij, tmux)"
        "File managers (superfile, ranger)"
        "Advanced copy/move tools (advcpmv)"
        "System monitoring (fastfetch, neofetch, htop)"
        "Network tools (nmap, traceroute, etc.)"
    )
    
    print_installation_summary "ADVANCED TOOLS INSTALLATION SUMMARY:" "${summary_items[@]}"
    
    return 0
}

# Export functions for use in other scripts
export -f install_development_tools install_terminal_multiplexers install_file_managers
export -f install_advcpmv install_system_monitoring install_network_tools install_advanced_tools_complete

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_advanced_tools_complete
fi
