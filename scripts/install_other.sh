#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Other/Unknown OS Installation Script
echo "❓ Unknown/Other OS Installation Script"
echo "======================================"
echo ""
echo "OS: Unknown or Unsupported"
echo "Type: Generic Unix-like system"
echo ""

# Try to detect package manager
print_info "Detecting package manager..."
PACKAGE_MANAGER=""

if command -v apt &> /dev/null; then
    PACKAGE_MANAGER="apt"
    INSTALL_CMD="sudo apt update && sudo apt install -y"
elif command -v yum &> /dev/null; then
    PACKAGE_MANAGER="yum"
    INSTALL_CMD="sudo yum install -y"
elif command -v dnf &> /dev/null; then
    PACKAGE_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
elif command -v pacman &> /dev/null; then
    PACKAGE_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
elif command -v zypper &> /dev/null; then
    PACKAGE_MANAGER="zypper"
    INSTALL_CMD="sudo zypper install -y"
elif command -v apk &> /dev/null; then
    PACKAGE_MANAGER="apk"
    INSTALL_CMD="sudo apk add"
else
    print_warning "No known package manager detected"
    PACKAGE_MANAGER="unknown"
fi

print_info "Detected package manager: $PACKAGE_MANAGER"

# Install essential packages based on detected package manager
if [ "$PACKAGE_MANAGER" != "unknown" ]; then
    print_info "Installing essential packages: stow, git, curl..."
    
    case $PACKAGE_MANAGER in
        "apt")
            sudo apt update
            sudo apt install -y stow git curl
            ;;
        "yum"|"dnf")
            $INSTALL_CMD stow git curl
            ;;
        "pacman")
            sudo pacman -Sy --noconfirm stow git curl
            ;;
        "zypper")
            sudo zypper refresh
            sudo zypper install -y stow git curl
            ;;
        "apk")
            sudo apk update
            sudo apk add stow git curl
            ;;
    esac
    
    # Verify installations
    if command -v stow &> /dev/null && command -v git &> /dev/null && command -v curl &> /dev/null; then
        print_success "Essential packages installed successfully!"
    else
        print_error "Failed to install some essential packages"
        exit 1
    fi
else
    print_error "Cannot automatically install packages. Please install manually:"
    echo "  - stow"
    echo "  - git" 
    echo "  - curl"
    echo ""
    read -p "Press Enter once you have installed these packages..."
fi

# Ask user for shell preference
echo ""
echo "============================================"
echo "VOZ, what shell do you want to use?"
echo "============================================"
echo "1) ZSH (OLD but reliable)"
echo "2) FISH (NEW and modern)"
echo ""
read -p "Enter your choice (1 or 2): " shell_choice

case $shell_choice in
    1)
        print_info "Installing ZSH and setting up complete environment..."
        
        if [ "$PACKAGE_MANAGER" != "unknown" ]; then
            # Install ZSH and additional packages
            print_info "Installing ZSH, fzf, bat, tldr, and python tools..."
            case $PACKAGE_MANAGER in
                "apt")
                    sudo apt install -y zsh fzf bat tldr pipx python3-pip
                    ;;
                "yum"|"dnf")
                    $INSTALL_CMD zsh fzf bat tldr pipx python3-pip
                    ;;
                "pacman")
                    sudo pacman -S --noconfirm zsh fzf bat tldr python-pipx python-pip
                    ;;
                "zypper")
                    sudo zypper install -y zsh fzf bat tldr python3-pipx python3-pip
                    ;;
                "apk")
                    sudo apk add zsh fzf bat tldr pipx py3-pip
                    ;;
            esac
            
            # Install Python packages for colorize plugin
            print_info "Installing Python packages for colorize plugin..."
            pip3 install --user Pygments colorize
            
            # Install thefuck via pipx
            print_info "Installing thefuck via pipx..."
            pipx install thefuck
            pipx inject thefuck setuptools
            
            # Install Oh My Zsh
            print_info "Installing Oh My Zsh..."
            sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            
            # Install Powerlevel10k theme
            print_info "Installing Powerlevel10k theme..."
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
            
            # Install ZSH plugins
            print_info "Installing ZSH plugins..."
            
            # zsh-autosuggestions
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            
            # zsh-syntax-highlighting
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
            
            # zsh-history-substring-search
            git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
            
            # zsh-autoswitch-virtualenv
            git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/autoswitch_virtualenv"
            
            # zsh-you-should-use
            git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
            
            # autoupdate-oh-my-zsh-plugins
            git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
            
            # Install zsh-navigation-tools
            print_info "Installing zsh-navigation-tools..."
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/z-shell/zsh-navigation-tools/main/doc/install.sh)"
            
            # Install modern tools
            print_info "Installing modern command-line tools..."
            
            # Install zoxide
            curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
            
            # Install superfile
            bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"
            
            # Install fonts from fonts folder if it exists
            if [ -d "$(dirname "$0")/../fonts" ]; then
                print_info "Installing fonts from fonts folder..."
                mkdir -p ~/.local/share/fonts
                cp "$(dirname "$0")/../fonts"/* ~/.local/share/fonts/ 2>/dev/null || true
                fc-cache -f -v
                print_success "Fonts installed and cache updated"
            else
                print_warning "Fonts folder not found, skipping font installation"
            fi
            
            # Use stow to manage dotfiles
            print_info "Setting up dotfiles with stow..."
            cd "$(dirname "$0")/.."
            
            # Update theme to use Powerlevel10k in .zshrc if it exists
            if [ -f ".zshrc" ]; then
                print_info "Updating theme to Powerlevel10k in dotfiles..."
                sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' .zshrc
            fi
            
            # Stow the dotfiles
            print_info "Using stow to symlink dotfiles..."
            stow . --target="$HOME" --verbose
            
            if [ $? -eq 0 ]; then
                print_success "Dotfiles successfully symlinked with stow"
            else
                print_error "Failed to stow dotfiles"
                print_info "You may need to remove existing files manually"
            fi
            
            print_success "ZSH environment setup complete!"
            print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            print_info "INSTALLATION SUMMARY:"
            print_info "✅ Oh My Zsh + Powerlevel10k theme"
            print_info "✅ Custom ZSH plugins (7 plugins installed)"
            print_info "✅ Built-in plugins (git, extract, rsync, sudo, systemd, tldr, man, etc.)"
            print_info "✅ Modern CLI tools (zoxide, superfile, thefuck)"
            print_info "✅ Python tools (Pygments, colorize)"
            print_info "✅ MesloLGS Nerd Fonts"
            print_info "✅ Configuration files (.zshrc, .p10k.zsh)"
            print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            print_info "NEXT STEPS:"
            print_info "1. Change your default shell: chsh -s $(which zsh)"
            print_info "2. Log out and back in (or restart terminal)"
            print_info "3. Run 'p10k configure' to customize Powerlevel10k"
            print_info "4. All your plugins from .zshrc are now ready to use!"
            print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        else
            print_warning "Cannot automatically install ZSH packages. Please install manually:"
            echo "  - zsh"
            echo "  - fzf"
            echo "  - bat"
            echo ""
            print_info "Then run these commands manually:"
            echo "  sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
            echo "  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        fi
        ;;
    2)
        print_info "Installing FISH..."
        if [ "$PACKAGE_MANAGER" != "unknown" ]; then
            case $PACKAGE_MANAGER in
                "apt")
                    sudo apt install -y fish
                    ;;
                "yum"|"dnf")
                    $INSTALL_CMD fish
                    ;;
                "pacman")
                    sudo pacman -S --noconfirm fish
                    ;;
                "zypper")
                    sudo zypper install -y fish
                    ;;
                "apk")
                    sudo apk add fish
                    ;;
            esac
            print_success "FISH installed! You can change your default shell with: chsh -s $(which fish)"
        else
            print_warning "Please install fish manually for your system"
        fi
        print_warning "FISH configuration not yet implemented"
        ;;
    *)
        print_warning "Invalid choice. Skipping shell installation."
        ;;
esac

# Function to install and configure neofetch/fastfetch
install_system_info() {
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_info "🎨 SETTING UP SYSTEM INFO DISPLAY (Neofetch/Fastfetch)"
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Try to install fastfetch first, then neofetch
    FETCH_CMD=""
    
    if command -v fastfetch &> /dev/null; then
        print_success "Fastfetch already installed!"
        FETCH_CMD="fastfetch"
    elif command -v neofetch &> /dev/null; then
        print_success "Neofetch already installed!"
        FETCH_CMD="neofetch"
    else
        # Try to install based on package manager
        case "$PACKAGE_MANAGER" in
            "apt")
                if sudo apt update && sudo apt install -y fastfetch 2>/dev/null; then
                    FETCH_CMD="fastfetch"
                elif sudo apt install -y neofetch; then
                    FETCH_CMD="neofetch"
                fi
                ;;
            "yum")
                if sudo yum install -y neofetch 2>/dev/null; then
                    FETCH_CMD="neofetch"
                fi
                ;;
            "dnf")
                if sudo dnf install -y fastfetch 2>/dev/null; then
                    FETCH_CMD="fastfetch"
                elif sudo dnf install -y neofetch; then
                    FETCH_CMD="neofetch"
                fi
                ;;
            "pacman")
                if sudo pacman -S --noconfirm fastfetch 2>/dev/null; then
                    FETCH_CMD="fastfetch"
                elif sudo pacman -S --noconfirm neofetch; then
                    FETCH_CMD="neofetch"
                fi
                ;;
            "zypper")
                if sudo zypper install -y neofetch 2>/dev/null; then
                    FETCH_CMD="neofetch"
                fi
                ;;
            "apk")
                if sudo apk add --no-cache neofetch 2>/dev/null; then
                    FETCH_CMD="neofetch"
                fi
                ;;
            *)
                print_warning "Unknown package manager. Please install neofetch or fastfetch manually."
                return 1
                ;;
        esac
        
        if [ -n "$FETCH_CMD" ]; then
            print_success "$FETCH_CMD installed successfully!"
        else
            print_error "Failed to install system info tools"
            return 1
        fi
    fi
    
    # Create config directory
    if [ "$FETCH_CMD" = "fastfetch" ]; then
        CONFIG_DIR="$HOME/.config/fastfetch"
        CONFIG_FILE="$CONFIG_DIR/config.jsonc"
    else
        CONFIG_DIR="$HOME/.config/neofetch"
        CONFIG_FILE="$CONFIG_DIR/config.conf"
    fi
    
    mkdir -p "$CONFIG_DIR"
    
    # Create images directory
    IMAGES_DIR="$CONFIG_DIR/images"
    mkdir -p "$IMAGES_DIR"
    
    # Create generic configuration with VozDeOuro branding
    if [ "$FETCH_CMD" = "fastfetch" ]; then
        print_info "Creating Fastfetch configuration with VozDeOuro branding..."
        cat > "$CONFIG_FILE" << 'EOF'
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/json_schema.json",
    "logo": {
        "type": "auto",
        "source": "auto",
        "width": 30,
        "height": 15,
        "padding": {
            "top": 1,
            "left": 2
        }
    },
    "display": {
        "separator": " → ",
        "color": {
            "keys": "green",
            "title": "yellow"
        }
    },
    "modules": [
        {
            "type": "title",
            "format": "┌─ {#yellow}{user-name-colored}{#reset}@{#green}{host-name-colored}{#reset} ─┐"
        },
        {
            "type": "separator",
            "string": "├─────────────────────────────────┤"
        },
        {
            "type": "custom",
            "format": "│ {#226}🌟 VozDeOuro System{#reset}             │"
        },
        {
            "type": "separator",
            "string": "├─────────────────────────────────┤"
        },
        {
            "type": "os",
            "key": "│ OS",
            "format": "│ {#green}OS{#reset}      → {1} {2}"
        },
        {
            "type": "kernel",
            "key": "│ Kernel",
            "format": "│ {#green}Kernel{#reset}  → {1}"
        },
        {
            "type": "uptime",
            "key": "│ Uptime",
            "format": "│ {#green}Uptime{#reset}  → {1}"
        },
        {
            "type": "packages",
            "key": "│ Packages",
            "format": "│ {#green}Pkgs{#reset}    → {1}"
        },
        {
            "type": "shell",
            "key": "│ Shell",
            "format": "│ {#green}Shell{#reset}   → {1}"
        },
        {
            "type": "terminal",
            "key": "│ Terminal",
            "format": "│ {#green}Term{#reset}    → {1}"
        },
        {
            "type": "cpu",
            "key": "│ CPU",
            "format": "│ {#green}CPU{#reset}     → {1}"
        },
        {
            "type": "memory",
            "key": "│ Memory",
            "format": "│ {#green}Memory{#reset}  → {1}/{2} ({3})"
        },
        {
            "type": "disk",
            "key": "│ Disk",
            "format": "│ {#green}Disk{#reset}    → {1}/{2} ({3})"
        },
        {
            "type": "localip",
            "key": "│ Local IP",
            "format": "│ {#green}IP{#reset}      → {1}"
        },
        {
            "type": "separator",
            "string": "└─────────────────────────────────┘"
        },
        {
            "type": "colors",
            "paddingLeft": 2,
            "symbol": "circle"
        }
    ]
}
EOF
    else
        print_info "Creating Neofetch configuration with VozDeOuro branding..."
        cat > "$CONFIG_FILE" << 'EOF'
#!/usr/bin/env bash
# VozDeOuro Generic Neofetch Configuration

print_info() {
    # Title
    info title
    prin "┌─────────────────────────────────┐"
    prin "│        ${cl3}🌟 VozDeOuro System${cl6}        │"
    prin "├─────────────────────────────────┤"
    
    # System Information
    info "│ OS" distro
    info "│ Kernel" kernel
    info "│ Uptime" uptime
    info "│ Packages" packages
    info "│ Shell" shell
    info "│ Terminal" term
    info "│ CPU" cpu
    info "│ GPU" gpu
    info "│ Memory" memory
    info "│ Disk" disk
    info "│ Local IP" local_ip
    
    prin "└─────────────────────────────────┘"
    prin ""
    
    # Color blocks
    info cols
}

# Generic colors (green and yellow theme)
colors=(2 3 7 1 8 8)
ascii_colors=(2 3)

# Configuration options
title_fqdn="off"
kernel_shorthand="on"
distro_shorthand="off"
os_arch="on"
uptime_shorthand="on"
memory_percent="on"
memory_unit="gib"
package_managers="on"
shell_path="off"
shell_version="on"
speed_type="bios_limit"
speed_shorthand="on"
cpu_brand="on"
cpu_speed="on"
cpu_cores="logical"
cpu_temp="off"
gpu_brand="on"
gpu_type="all"
refresh_rate="on"
disk_show=('/')
disk_subtitle="mount"
disk_percent="on"
bold="on"
underline_enabled="on"
underline_char="-"
separator=" →"
block_range=(0 7)
color_blocks="on"
block_width=3
block_height=1
col_offset="auto"
bar_char_elapsed="-"
bar_char_total="="
bar_border="on"
bar_length=15
bar_color_elapsed="distro"
bar_color_total="distro"
image_backend="ascii"
image_source="auto"
ascii_distro="auto"
ascii_bold="on"
image_loop="off"
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"
crop_mode="normal"
crop_offset="center"
image_size="auto"
gap=3
yoffset=0
xoffset=0
background_color=
stdout="off"
EOF
    fi
    
    # Create a generic ASCII logo
    cat > "$IMAGES_DIR/voz-generic-ascii.txt" << 'EOF'
${c2}
██╗   ██╗ ██████╗ ███████╗
██║   ██║██╔═══██╗╚══███╔╝
██║   ██║██║   ██║  ███╔╝ 
╚██╗ ██╔╝██║   ██║ ███╔╝  
 ╚████╔╝ ╚██████╔╝███████╗
  ╚═══╝   ╚═════╝ ╚══════╝
${c3}    🌟 VozDeOuro System${c6}
EOF
    
    # Create a generic fetch script
    FETCH_SCRIPT="$HOME/.local/bin/voz-fetch"
    mkdir -p "$(dirname "$FETCH_SCRIPT")"
    
    cat > "$FETCH_SCRIPT" << EOF
#!/bin/bash
# VozDeOuro Generic System Info Script

# Generic colors (green and yellow theme)
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Clear screen and show system info
clear

# Print VozDeOuro header
echo -e "\${GREEN}╭─────────────────────────────────────────╮\${NC}"
echo -e "\${GREEN}│\${NC}   \${YELLOW}🌟 Welcome to VozDeOuro System\${NC}   \${GREEN}│\${NC}"
echo -e "\${GREEN}╰─────────────────────────────────────────╯\${NC}"
echo ""

# Run the appropriate fetch command
if command -v fastfetch &> /dev/null; then
    fastfetch
elif command -v neofetch &> /dev/null; then
    neofetch
else
    echo -e "\${YELLOW}System info tool not found!\${NC}"
fi

echo ""
echo -e "\${CYAN}─────────────────────────────────────────\${NC}"
echo -e "\${GREEN}Ready to code with VozDeOuro!\${NC} \${YELLOW}🚀\${NC}"
echo -e "\${CYAN}─────────────────────────────────────────\${NC}"
EOF
    
    chmod +x "$FETCH_SCRIPT"
    
    # Add voz-fetch to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc" 2>/dev/null || true
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
        if [ -f "$HOME/.config/fish/config.fish" ]; then
            echo 'set -gx PATH "$HOME/.local/bin" $PATH' >> "$HOME/.config/fish/config.fish"
        fi
    fi
    
    print_success "System info tools configured with VozDeOuro branding!"
    print_info "Usage:"
    print_info "  - Run 'voz-fetch' for custom VozDeOuro system info"
    print_info "  - Run '$FETCH_CMD' for standard system info"
    print_info "  - Configuration: $CONFIG_FILE"
    
    # Run the fetch command to show the result
    print_info "🎉 Here's your VozDeOuro system info:"
    echo ""
    "$FETCH_SCRIPT"
}

# Install system info tools
install_system_info

echo ""
print_success "Generic OS setup complete!"
print_warning "Manual configuration may be required for this OS"
print_info "Consider adding specific support for this OS to the script"
