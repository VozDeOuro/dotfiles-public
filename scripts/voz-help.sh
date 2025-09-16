#!/bin/bash

# VozDeOuro Quick Help Reference
# =============================

# Colors for output
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

show_voz_help() {
    echo ""
    echo -e "${PURPLE}╭─────────────────────────────────────────────────────────╮${NC}"
    echo -e "${PURPLE}│${NC}                  ${CYAN}VozDeOuro Quick Help${NC}                   ${PURPLE}│${NC}"
    echo -e "${PURPLE}╰─────────────────────────────────────────────────────────╯${NC}"
    echo ""
    
    echo -e "${CYAN}🔥 Essential ZSH Plugin Features:${NC}"
    echo -e "${GREEN}   ESC ESC${NC}              Add/remove sudo at command start"
    echo -e "${GREEN}   ↑/↓ arrows${NC}          Search history by current text"
    echo -e "${GREEN}   → (right arrow)${NC}     Accept gray autosuggestion"
    echo -e "${GREEN}   Ctrl+R${NC}              Enhanced fuzzy history search"
    echo -e "${GREEN}   Tab Tab${NC}             Enhanced completion with colors"
    echo ""
    
    echo -e "${CYAN}📂 Smart Navigation:${NC}"
    echo -e "${GREEN}   z <name>${NC}            Jump to frequently used directory (aliased to cd)"
    echo -e "${GREEN}   zi${NC}                  Interactive directory picker"
    echo -e "${GREEN}   z proj work${NC}         Jump to dir matching both 'proj' and 'work'"
    echo -e "${GREEN}   extract <file>${NC}      Extract any archive format"
    echo -e "${GREEN}   tldr <command>${NC}      Quick command examples"
    echo ""
    
    echo -e "${CYAN}⚙️  System Services (systemd):${NC}"
    echo -e "${GREEN}   sc-status <service>${NC}  Check service status"
    echo -e "${GREEN}   sc-start <service>${NC}   Start a service"
    echo -e "${GREEN}   sc-restart <service>${NC} Restart a service"
    echo -e "${GREEN}   sc-failed${NC}            Show failed services"
    echo ""
    
    echo -e "${CYAN}🚀 Modern Tools:${NC}"
    echo -e "${GREEN}   spf${NC}                 Launch superfile (modern file manager)"
    echo -e "${GREEN}   m${NC}                   Launch Zellij terminal multiplexer"
    echo -e "${GREEN}   ff${NC}                  Show beautiful system info"
    echo -e "${GREEN}   colors${NC}              Display VozDeOuro color palette"
    echo -e "${GREEN}   h${NC}                   Launch htop system monitor"
    echo ""
    
    echo -e "${CYAN}💻 Git Shortcuts:${NC}"
    echo -e "${GREEN}   gs${NC}                  git status"
    echo -e "${GREEN}   ga${NC}                  git add"
    echo -e "${GREEN}   gc${NC}                  git commit"
    echo -e "${GREEN}   gp${NC}                  git push"
    echo -e "${GREEN}   gl${NC}                  git pull"
    echo ""
    
    echo -e "${CYAN}🎨 Theme Features:${NC}"
    echo -e "${GREEN}   Purple ❯ prompt${NC}     Clean, beautiful command line"
    echo -e "${GREEN}   💀 Root indicator${NC}    Shows when running as root"
    echo -e "${GREEN}   Git integration${NC}      Branch status in prompt"
    echo -e "${GREEN}   Smart suggestions${NC}    Reminds you to use aliases"
    echo ""
    
    echo -e "${YELLOW}💡 Pro Tips:${NC}"
    echo "   • Start typing + ↑/↓ to search history by prefix"
    echo "   • Use 'z doc' instead of 'cd ~/Documents' - zoxide learns your habits"
    echo "   • Try 'zi' for interactive directory selection with fuzzy search"
    echo "   • Use 'sc-failed' to quickly check if any services are broken"
    echo "   • Virtual environments auto-activate in project folders"
    echo "   • Command highlighting shows valid/invalid commands in real-time"
    echo ""
    
    echo -e "${CYAN}📖 For detailed help:${NC} ${GREEN}man voz-help${NC} or ${GREEN}voz-help --full${NC}"
    echo ""
}

# Check for arguments
case "$1" in
    --full|full|man)
        if command -v man >/dev/null 2>&1; then
            man voz-help 2>/dev/null || {
                echo "Man page not found. Showing quick help instead:"
                echo ""
                show_voz_help
            }
        else
            show_voz_help
        fi
        ;;
    *)
        show_voz_help
        ;;
esac
