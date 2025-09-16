#!/bin/bash

# VozDeOuro System Info Installation (Refactored)
# ==============================================
# Clean, modular installation of fastfetch with VozDeOuro branding

# Source common utilities
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/common.sh"

# Function to install system info tools
install_system_info() {
    print_header "Setting up System Info Display (Fastfetch)"
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Install fastfetch (fastfetch-only approach)
    if command -v fastfetch &> /dev/null; then
        print_success "Fastfetch already installed!"
    else
        print_info "Installing fastfetch..."
        
        # Method 1: Try normal package installation
        if install_package "fastfetch"; then
            print_success "Fastfetch installed successfully!"
        else
            print_warning "Fastfetch not available in default repositories"
            
            # Method 2: Try PPA installation
            if command -v add-apt-repository &> /dev/null; then
                print_info "Attempting to install from PPA..."
                sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
                update_packages
                
                if install_package "fastfetch"; then
                    print_success "Fastfetch installed from PPA successfully!"
                else
                    print_warning "PPA installation failed (possibly unsupported Ubuntu version)"
                    
                    # Method 3: Install from GitHub releases with better error handling
                    print_info "Trying GitHub release installation..."
                    
                    # Detect architecture
                    ARCH=$(uname -m)
                    case $ARCH in
                        x86_64) FF_ARCH="amd64" ;;
                        aarch64|arm64) FF_ARCH="arm64" ;;
                        armv7l) FF_ARCH="armhf" ;;
                        *) FF_ARCH="amd64" ;;
                    esac
                    
                    # Try multiple versions for better compatibility
                    FF_VERSIONS=("2.27.1" "2.25.0" "2.21.3")
                    
                    for FF_VERSION in "${FF_VERSIONS[@]}"; do
                        print_info "Trying fastfetch version ${FF_VERSION}..."
                        
                        # Try different naming patterns
                        FF_PATTERNS=(
                            "fastfetch-linux-${FF_ARCH}.deb"
                            "fastfetch-${FF_VERSION}-linux-${FF_ARCH}.deb"
                            "fastfetch_${FF_VERSION}_${FF_ARCH}.deb"
                        )
                        
                        for FF_DEB in "${FF_PATTERNS[@]}"; do
                            FF_URL="https://github.com/fastfetch-cli/fastfetch/releases/download/${FF_VERSION}/${FF_DEB}"
                            
                            print_info "Trying download: ${FF_DEB}..."
                            
                            # Clean up any previous attempts
                            rm -f /tmp/fastfetch*.deb
                            
                            if command_exists "wget"; then
                                wget --spider "$FF_URL" 2>/dev/null && wget -O /tmp/${FF_DEB} "$FF_URL" 2>/dev/null
                            elif command_exists "curl"; then
                                curl -I "$FF_URL" 2>/dev/null | grep -q "200 OK" && curl -L -o /tmp/${FF_DEB} "$FF_URL" 2>/dev/null
                            else
                                print_error "Neither wget nor curl available for download"
                                return 1
                            fi
                            
                            if [ -f /tmp/${FF_DEB} ] && [ -s /tmp/${FF_DEB} ]; then
                                # Verify it's a valid deb file
                                if file /tmp/${FF_DEB} | grep -q "Debian binary package"; then
                                    print_success "Downloaded valid package: ${FF_DEB}"
                                    
                                    print_info "Installing fastfetch..."
                                    if sudo dpkg -i /tmp/${FF_DEB}; then
                                        print_success "Fastfetch installed successfully!"
                                        rm -f /tmp/${FF_DEB}
                                        break 3  # Break out of all loops
                                    else
                                        print_info "Fixing dependencies and retrying..."
                                        sudo apt-get install -f -y
                                        if sudo dpkg -i /tmp/${FF_DEB}; then
                                            print_success "Fastfetch installed after fixing dependencies!"
                                            rm -f /tmp/${FF_DEB}
                                            break 3  # Break out of all loops
                                        fi
                                    fi
                                else
                                    print_warning "Downloaded file is not a valid Debian package"
                                fi
                                rm -f /tmp/${FF_DEB}
                            fi
                        done
                    done
                    
                    # If all above failed, try snap as last resort
                    if ! command -v fastfetch &> /dev/null; then
                        if command_exists "snap"; then
                            print_info "Trying snap installation as last resort..."
                            if sudo snap install fastfetch; then
                                print_success "Fastfetch installed via snap!"
                            else
                                print_error "All installation methods failed"
                                print_info "You can try installing manually:"
                                print_info "  1. Visit: https://github.com/fastfetch-cli/fastfetch/releases"
                                print_info "  2. Download the appropriate .deb file for your architecture"
                                print_info "  3. Install with: sudo dpkg -i <downloaded-file>.deb"
                                return 1
                            fi
                        else
                            print_error "All installation methods failed and snap not available"
                            return 1
                        fi
                    fi
                fi
            else
                print_error "add-apt-repository not available"
                print_info "Please install software-properties-common or download fastfetch manually"
                return 1
            fi
        fi
    fi
    
    # Setup fastfetch configuration directory
    CONFIG_DIR="$HOME/.config/fastfetch"
    mkdir -p "$CONFIG_DIR/images"
    
    print_success "Fastfetch installation completed!"
    print_info "Config will be managed by dotfiles (stow)"
    
    return 0
}

# Run installation
install_system_info
