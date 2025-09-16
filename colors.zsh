# VozDeOuro Purple Terminal Color Scheme
# =====================================
# A beautiful purple-themed color configuration for terminals
# Based on the VozDeOuro aesthetic with purple, magenta, and blue tones

# Terminal Colors Configuration
# This file can be used with various terminal emulators and tools

# ANSI Color Codes (for reference)
# ================================

# Normal Colors
export COLOR_BLACK='#121212'
export COLOR_RED='#a52aff'
export COLOR_GREEN='#7129ff'
export COLOR_YELLOW='#3d2aff'
export COLOR_BLUE='#2b4fff'
export COLOR_MAGENTA='#2883ff'
export COLOR_CYAN='#28b9ff'
export COLOR_WHITE='#f1f1f1'

# Bright Colors
export COLOR_BRIGHT_BLACK='#666666'
export COLOR_BRIGHT_RED='#ba5aff'
export COLOR_BRIGHT_GREEN='#905aff'
export COLOR_BRIGHT_YELLOW='#657b83'
export COLOR_BRIGHT_BLUE='#5c78ff'
export COLOR_BRIGHT_MAGENTA='#5ea2ff'
export COLOR_BRIGHT_CYAN='#5ac8ff'
export COLOR_BRIGHT_WHITE='#ffffff'

# VozDeOuro Theme Colors
# ======================
export VOZDEORO_PRIMARY='#a52aff'      # Main purple
export VOZDEORO_SECONDARY='#2b4fff'    # Blue accent
export VOZDEORO_TERTIARY='#7129ff'     # Green-purple
export VOZDEORO_BACKGROUND='#121212'   # Dark background
export VOZDEORO_FOREGROUND='#f1f1f1'   # Light text
export VOZDEORO_ACCENT='#28b9ff'       # Cyan accent

# Terminal Color Palette (16-color)
# =================================
# 0  - Black (Normal)
# 1  - Red (Normal)
# 2  - Green (Normal)
# 3  - Yellow (Normal)
# 4  - Blue (Normal)
# 5  - Magenta (Normal)
# 6  - Cyan (Normal)
# 7  - White (Normal)
# 8  - Black (Bright)
# 9  - Red (Bright)
# 10 - Green (Bright)
# 11 - Yellow (Bright)
# 12 - Blue (Bright)
# 13 - Magenta (Bright)
# 14 - Cyan (Bright)
# 15 - White (Bright)

# Kitty Terminal Configuration
# ============================
# Add these to your kitty.conf:
#
# # VozDeOuro Purple Theme
# background #121212
# foreground #f1f1f1
# selection_background #a52aff
# selection_foreground #121212
# cursor #a52aff
# cursor_text_color #121212
# 
# # Normal colors
# color0 #121212
# color1 #a52aff
# color2 #7129ff
# color3 #3d2aff
# color4 #2b4fff
# color5 #2883ff
# color6 #28b9ff
# color7 #f1f1f1
# 
# # Bright colors
# color8 #666666
# color9 #ba5aff
# color10 #905aff
# color11 #657b83
# color12 #5c78ff
# color13 #5ea2ff
# color14 #5ac8ff
# color15 #ffffff

# Alacritty Terminal Configuration
# ================================
# Add this to your alacritty.yml:
#
# colors:
#   primary:
#     background: '#121212'
#     foreground: '#f1f1f1'
#   normal:
#     black:   '#121212'
#     red:     '#a52aff'
#     green:   '#7129ff'
#     yellow:  '#3d2aff'
#     blue:    '#2b4fff'
#     magenta: '#2883ff'
#     cyan:    '#28b9ff'
#     white:   '#f1f1f1'
#   bright:
#     black:   '#666666'
#     red:     '#ba5aff'
#     green:   '#905aff'
#     yellow:  '#657b83'
#     blue:    '#5c78ff'
#     magenta: '#5ea2ff'
#     cyan:    '#5ac8ff'
#     white:   '#ffffff'

# Windows Terminal Configuration
# ==============================
# Add this to your settings.json profiles:
#
# {
#   "name": "VozDeOuro Purple",
#   "background": "#121212",
#   "foreground": "#f1f1f1",
#   "black": "#121212",
#   "red": "#a52aff",
#   "green": "#7129ff",
#   "yellow": "#3d2aff",
#   "blue": "#2b4fff",
#   "purple": "#2883ff",
#   "cyan": "#28b9ff",
#   "white": "#f1f1f1",
#   "brightBlack": "#666666",
#   "brightRed": "#ba5aff",
#   "brightGreen": "#905aff",
#   "brightYellow": "#657b83",
#   "brightBlue": "#5c78ff",
#   "brightPurple": "#5ea2ff",
#   "brightCyan": "#5ac8ff",
#   "brightWhite": "#ffffff",
#   "selectionBackground": "#a52aff",
#   "cursorColor": "#a52aff"
# }

# VS Code Terminal Configuration
# ==============================
# Add these to your VS Code settings.json:
#
# "workbench.colorCustomizations": {
#   "terminal.background": "#121212",
#   "terminal.foreground": "#f1f1f1",
#   "terminal.ansiBlack": "#121212",
#   "terminal.ansiRed": "#a52aff",
#   "terminal.ansiGreen": "#7129ff",
#   "terminal.ansiYellow": "#3d2aff",
#   "terminal.ansiBlue": "#2b4fff",
#   "terminal.ansiMagenta": "#2883ff",
#   "terminal.ansiCyan": "#28b9ff",
#   "terminal.ansiWhite": "#f1f1f1",
#   "terminal.ansiBrightBlack": "#666666",
#   "terminal.ansiBrightRed": "#ba5aff",
#   "terminal.ansiBrightGreen": "#905aff",
#   "terminal.ansiBrightYellow": "#657b83",
#   "terminal.ansiBrightBlue": "#5c78ff",
#   "terminal.ansiBrightMagenta": "#5ea2ff",
#   "terminal.ansiBrightCyan": "#5ac8ff",
#   "terminal.ansiBrightWhite": "#ffffff"
# }

# Helper Functions
# ================

# Function to display color palette
show_colors() {
    echo "Purple Color Palette:"
    echo "==============================="
    
    echo -e "\033[38;2;18;18;18;48;2;165;42;255m  Normal Black    \033[0m \033[38;2;64;64;64;48;2;138;57;217m  Bright Black    \033[0m"
    echo -e "\033[38;2;165;42;255;48;2;18;18;18m  Normal Red      \033[0m \033[38;2;138;42;217;48;2;64;64;64m  Bright Red      \033[0m"
    echo -e "\033[38;2;113;41;255;48;2;18;18;18m  Normal Green    \033[0m \033[38;2;93;31;217;48;2;64;64;64m  Bright Green    \033[0m"
    echo -e "\033[38;2;61;42;255;48;2;18;18;18m  Normal Yellow   \033[0m \033[38;2;54;32;217;48;2;64;64;64m  Bright Yellow   \033[0m"
    echo -e "\033[38;2;43;79;255;48;2;18;18;18m  Normal Blue     \033[0m \033[38;2;34;64;217;48;2;64;64;64m  Bright Blue     \033[0m"
    echo -e "\033[38;2;40;131;255;48;2;18;18;18m  Normal Magenta  \033[0m \033[38;2;36;112;217;48;2;64;64;64m  Bright Magenta  \033[0m"
    echo -e "\033[38;2;40;185;255;48;2;18;18;18m  Normal Cyan     \033[0m \033[38;2;31;159;217;48;2;64;64;64m  Bright Cyan     \033[0m"
    echo -e "\033[38;2;241;241;241;48;2;18;18;18m  Normal White    \033[0m \033[38;2;208;208;208;48;2;64;64;64m  Bright White    \033[0m"
    
    echo ""
    echo "VozDeOuro Brand Colors:"
    echo "======================="
    echo -e "\033[38;2;165;42;255m■\033[0m Primary:   #a52aff"
    echo -e "\033[38;2;43;79;255m■\033[0m Secondary: #2b4fff"
    echo -e "\033[38;2;113;41;255m■\033[0m Tertiary:  #7129ff"
    echo -e "\033[38;2;40;185;255m■\033[0m Accent:    #28b9ff"
}

# Function to test terminal colors
test_colors() {
    echo "Testing terminal color support..."
    echo "================================"
    
    # Test 16 colors
    for i in {0..15}; do
        printf "\033[48;5;${i}m  %2d  \033[0m" $i
        if [ $((($i + 1) % 8)) -eq 0 ]; then
            echo
        fi
    done
    echo
    
    # Test 256 colors (first 32)
    echo "256-color test (first 32):"
    for i in {0..31}; do
        printf "\033[48;5;${i}m %3d \033[0m" $i
        if [ $((($i + 1) % 8)) -eq 0 ]; then
            echo
        fi
    done
    echo
}

# Auto-load function
if [ "$1" = "show" ]; then
    show_colors
elif [ "$1" = "test" ]; then
    test_colors
fi
