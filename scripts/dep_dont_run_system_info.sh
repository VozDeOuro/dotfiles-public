#!/bin/bash

# VozDeOuro System Info Tools Installation
# ========================================
# Installs and configures neofetch/fastfetch with VozDeOuro branding

# Source common utilities
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/common.sh"

# Function to install and configure neofetch/fastfetch
install_system_info() {
    print_header "Setting up System Info Display (Fastfetch)"
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Check if fastfetch is available (newer and faster)
    if command -v fastfetch &> /dev/null; then
        print_success "Fastfetch already installed!"
        FETCH_CMD="fastfetch"
    else
        print_info "Installing fastfetch..."
        # Try to install fastfetch
        if install_package "fastfetch"; then
            print_success "Fastfetch installed successfully!"
            FETCH_CMD="fastfetch"
        else
            print_error "Failed to install system info tools"
            return 1
        fi
    fi


    # Create config directory
    if [ "$FETCH_CMD" = "fastfetch" ]; then
        CONFIG_DIR="$HOME/.config/fastfetch"
        CONFIG_FILE="$CONFIG_DIR/config.jsonc"
    fi
    
    mkdir -p "$CONFIG_DIR"
    
    # Create images directory
    IMAGES_DIR="$CONFIG_DIR/images"
    mkdir -p "$IMAGES_DIR"
    
    # Setup fastfetch configuration with custom image support
    if [ "$FETCH_CMD" = "fastfetch" ]; then
        print_info "Creating Fastfetch configuration with VozDeOuro branding..."
        
        # Check if custom image exists and create appropriate config
        local image_config=""
        if [ -f "$HOME/ffimg" ]; then
            print_success "Found custom image at ~/ffimg"
            image_config='"source": "$HOME/ffimg",'
        else
            print_info "Custom image ~/ffimg not found, using ASCII logo"
            image_config='"type": "ascii",'
        fi
        
        cat > "$CONFIG_FILE" << EOF
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        $image_config
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
            "keys": "magenta",
            "title": "cyan"
        }
    },
    "modules": [
        {
            "type": "title",
            "format": "┌─ {#magenta}{user-name-colored}{#reset}@{#cyan}{host-name-colored}{#reset} ─┐"
        },
        {
            "type": "separator", 
            "string": "├─────────────────────────────────┤"
        },
        {
            "type": "custom",
            "format": "│ {#95}VozDeOuro System{#reset}              │"
        },
        {
            "type": "separator",
            "string": "├─────────────────────────────────┤"
        },
        {
            "type": "os",
            "key": "│ OS",
            "format": "│ {#cyan}OS{#reset}      → {1} {2}"
        },
        {
            "type": "kernel", 
            "key": "│ Kernel",
            "format": "│ {#cyan}Kernel{#reset}  → {1}"
        },
        {
            "type": "uptime",
            "key": "│ Uptime", 
            "format": "│ {#cyan}Uptime{#reset}  → {1}"
        },
        {
            "type": "packages",
            "key": "│ Packages",
            "format": "│ {#cyan}Pkgs{#reset}    → {1}"
        },
        {
            "type": "shell",
            "key": "│ Shell",
            "format": "│ {#cyan}Shell{#reset}   → {1}"
        },
        {
            "type": "terminal",
            "key": "│ Terminal",
            "format": "│ {#cyan}Term{#reset}    → {1}"
        },
        {
            "type": "cpu",
            "key": "│ CPU",
            "format": "│ {#cyan}CPU{#reset}     → {1}"
        },
        {
            "type": "memory",
            "key": "│ Memory",
            "format": "│ {#cyan}Memory{#reset}  → {1}/{2} ({3})"
        },
        {
            "type": "disk",
            "key": "│ Disk",
            "format": "│ {#cyan}Disk{#reset}    → {1}/{2} ({3})"
        },
        {
            "type": "localip",
            "key": "│ Local IP", 
            "format": "│ {#cyan}IP{#reset}      → {1}"
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
            "key": "│ Terminal",
            "format": "│ {#cyan}Term{#reset}    → {1}"
        },
        {
            "type": "cpu",
            "key": "│ CPU",
            "format": "│ {#cyan}CPU{#reset}     → {1}"
        },
        {
            "type": "memory",
            "key": "│ Memory",
            "format": "│ {#cyan}Memory{#reset}  → {1}/{2} ({3})"
        },
        {
            "type": "disk",
            "key": "│ Disk",
            "format": "│ {#cyan}Disk{#reset}    → {1}/{2} ({3})"
        },
        {
            "type": "localip",
            "key": "│ Local IP",
            "format": "│ {#cyan}IP{#reset}      → {1}"
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
# VozDeOuro Neofetch Configuration

# Source: https://github.com/dylanaraps/neofetch

print_info() {
    # Title
    info title
    prin "┌─────────────────────────────────┐"
    prin "│          ${cl5}VozDeOuro System${cl6}         │"
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

# Title
title_fqdn="off"

# Kernel
kernel_shorthand="on"

# Distro
distro_shorthand="off"
os_arch="on"

# Uptime
uptime_shorthand="on"

# Memory
memory_percent="on"
memory_unit="gib"

# Packages
package_managers="on"

# Shell
shell_path="off"
shell_version="on"

# CPU
speed_type="bios_limit"
speed_shorthand="on"
cpu_brand="on"
cpu_speed="on"
cpu_cores="logical"
cpu_temp="off"

# GPU
gpu_brand="on"
gpu_type="all"

# Resolution
refresh_rate="on"

# Disk
disk_show=('/')
disk_subtitle="mount"
disk_percent="on"

# Text Colors
colors=(5 6 7 1 8 8)

# Text Options
bold="on"
underline_enabled="on"
underline_char="-"
separator=" →"

# Color Blocks
block_range=(0 7)
color_blocks="on"
block_width=3
block_height=1
col_offset="auto"

# Progress Bars
bar_char_elapsed="-"
bar_char_total="="
bar_border="on"
bar_length=15
bar_color_elapsed="distro"
bar_color_total="distro"

# Image Options
image_backend="ascii"
image_source="auto"
ascii_distro="auto"
ascii_colors=(5 6)
ascii_bold="on"

# Image/ASCII settings
image_loop="off"
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"
crop_mode="normal"
crop_offset="center"
image_size="auto"
gap=3

# Backend Settings
yoffset=0
xoffset=0
background_color=
stdout="off"
EOF
    fi
    
    # Create a simple ASCII logo file for VozDeOuro
    cat > "$IMAGES_DIR/voz-ascii.txt" << 'EOF'
${c1}
██╗   ██╗ ██████╗ ███████╗
██║   ██║██╔═══██╗╚══███╔╝
██║   ██║██║   ██║  ███╔╝ 
╚██╗ ██╔╝██║   ██║ ███╔╝  
 ╚████╔╝ ╚██████╔╝███████╗
  ╚═══╝   ╚═════╝ ╚══════╝
${c3}      VozDeOuro System${c6}
EOF
    
    # Create a script to automatically run the fetch command
    FETCH_SCRIPT="$HOME/.local/bin/voz-fetch"
    mkdir -p "$(dirname "$FETCH_SCRIPT")"
    
    cat > "$FETCH_SCRIPT" << EOF
#!/bin/bash
# VozDeOuro System Info Script

# Colors
PURPLE='\033[0;35m'
PINK='\033[0;95m'
CYAN='\033[0;36m'
NC='\033[0m'

# Clear screen and show system info
clear

# Print VozDeOuro header
echo -e "\${PURPLE}╭─────────────────────────────────────────╮\${NC}"
echo -e "\${PURPLE}│\${NC}    \${PINK}Welcome to VozDeOuro System\${NC}     \${PURPLE}│\${NC}"
echo -e "\${PURPLE}╰─────────────────────────────────────────╯\${NC}"
echo ""

# Run the appropriate fetch command
if command -v fastfetch &> /dev/null; then
    fastfetch
elif command -v neofetch &> /dev/null; then
    neofetch
else
    echo -e "\${PINK}System info tool not found!\${NC}"
fi

echo ""
echo -e "\${CYAN}─────────────────────────────────────────\${NC}"
echo -e "\${PURPLE}Ready to code with VozDeOuro!\${NC} \${PINK}🚀\${NC}"
echo -e "\${CYAN}─────────────────────────────────────────\${NC}"
EOF
    
    chmod +x "$FETCH_SCRIPT"
    
    # Add voz-fetch to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
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
