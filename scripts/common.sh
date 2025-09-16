#!/bin/bash

# VozDeOuro Common Utilities
# =========================
# Shared functions used across all installation scripts

# Detect OS if not already detected
if [[ -z "$DETECTED_OS" ]]; then
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
            ubuntu|debian)
                export DETECTED_OS="ubuntu"
                ;;
            kali)
                export DETECTED_OS="kali"
                ;;
            unraid)
                export DETECTED_OS="unraid"
                ;;
            *)
                export DETECTED_OS="other"
                ;;
        esac
        export OS_ID="$ID"
        export OS_NAME="$NAME"
        export OS_PRETTY_NAME="$PRETTY_NAME"
    else
        export DETECTED_OS="unknown"
    fi
fi

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

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

print_header() {
    echo ""
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}$(echo "$1" | sed 's/./=/g')${NC}"
    echo ""
}

# Function to detect WSL
is_wsl() {
    if [ -f /proc/version ] && grep -q "Microsoft\|WSL" /proc/version; then
        return 0  # true - is WSL
    else
        return 1  # false - not WSL
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if package is installed (apt-based)
package_installed() {
    dpkg -l | grep -qw "^ii.*$1"
}

# Function to install package with error checking
install_package() {
    local package="$1"
    local display_name="${2:-$package}"
    
    if package_installed "$package"; then
        print_warning "$display_name already installed, skipping..."
        return 0
    fi
    
    print_info "Installing $display_name..."
    sudo apt install -y "$package"
    
    if [ $? -eq 0 ]; then
        print_success "$display_name installed successfully"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

# Function to install from URL with error checking
install_from_url() {
    local url="$1"
    local name="$2"
    local install_cmd="$3"
    
    print_info "Installing $name..."
    if eval "$install_cmd"; then
        print_success "$name installed successfully"
        return 0
    else
        print_error "Failed to install $name"
        return 1
    fi
}

# Function to clone git repository
clone_repo() {
    local repo_url="$1"
    local target_dir="$2"
    local name="$3"
    
    if [ -d "$target_dir" ]; then
        print_warning "$name already exists, skipping..."
        return 0
    fi
    
    print_info "Cloning $name..."
    git clone "$repo_url" "$target_dir"
    
    if [ $? -eq 0 ]; then
        print_success "$name cloned successfully"
        return 0
    else
        print_error "Failed to clone $name"
        return 1
    fi
}

# Function to add repository
add_repository() {
    local repo="$1"
    local name="$2"
    
    print_info "Adding $name repository..."
    sudo add-apt-repository -y "$repo"
    
    if [ $? -eq 0 ]; then
        print_success "$name repository added"
        return 0
    else
        print_error "Failed to add $name repository"
        return 1
    fi
}

# Function to update package lists
update_packages() {
    print_info "Updating package lists..."
    
    # Try to update package lists
    sudo apt update
    
    if [ $? -eq 0 ]; then
        print_success "Package lists updated successfully"
        return 0
    else
        print_warning "Failed to update package lists - repository servers may be down"
        print_info "Continuing with installation using cached package information..."
        
        # Don't fail the installation if update fails - we can still install many packages
        return 0
    fi
}

# Function to upgrade packages
upgrade_packages() {
    print_info "Upgrading packages..."
    
    # Try normal upgrade first
    sudo apt upgrade -y
    
    if [ $? -eq 0 ]; then
        print_success "Packages upgraded successfully"
        return 0
    else
        print_warning "Standard upgrade failed, trying with --fix-missing..."
        
        # Try upgrade with --fix-missing to skip problematic packages
        sudo apt upgrade -y --fix-missing
        
        local exit_code=$?
        if [ $exit_code -eq 0 ]; then
            print_success "Packages upgraded (some packages may have been skipped)"
            return 0
        else
            print_warning "Upgrade with --fix-missing also failed (exit code: $exit_code)"
            print_info "This is often due to temporary repository issues and won't affect the dotfiles installation"
            print_info "You can manually run 'sudo apt upgrade --fix-missing' later when repositories are stable"
            
            # Don't fail the entire installation for upgrade issues
            return 0
        fi
    fi
}

# Function to print installation summary
print_installation_summary() {
    local title="$1"
    shift
    local items=("$@")
    
    echo ""
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_info "$title"
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    for item in "${items[@]}"; do
        print_info "✅ $item"
    done
    
    print_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Function to setup dotfiles with stow
setup_dotfiles() {
    local script_dir="$1"
    
    print_info "Setting up dotfiles with stow..."
    
    # Check if stow is installed
    if ! command_exists "stow"; then
        print_error "Stow is not installed! Installing stow..."
        if install_package "stow" "Symlink farm manager"; then
            print_success "Stow installed successfully"
        else
            print_error "Failed to install stow. Cannot setup dotfiles."
            return 1
        fi
    fi
    
    # Change to the dotfiles directory (parent of scripts)
    cd "$(dirname "$script_dir")" || exit 1
    print_info "Working in dotfiles directory: $(pwd)"
    
    # Check if dotfiles are already stowed
    local dotfiles_stowed=true
    local sample_files=(".zshrc" ".gitconfig" "aliases.zsh")
    
    for file in "${sample_files[@]}"; do
        if [[ -f "$file" ]]; then  # File exists in dotfiles repo
            local target_path="$HOME/$file"
            if [[ -L "$target_path" ]]; then
                local link_target=$(readlink "$target_path")
                if [[ "$link_target" == *"dotfiles"* ]]; then
                    continue  # This file is properly stowed
                fi
            fi
            dotfiles_stowed=false
            break
        fi
    done
    
    if [[ "$dotfiles_stowed" == true ]]; then
        print_success "Dotfiles already appear to be stowed, skipping..."
        return 0
    fi
    
    # Check for conflicts before stowing
    print_info "Checking for potential stow conflicts..."
    
    # Run stow in simulation mode to detect conflicts
    stow_conflicts=$(stow . --target="$HOME" --no --verbose 2>&1)
    stow_check_exit=$?
    
    if [[ $stow_check_exit -ne 0 ]] && echo "$stow_conflicts" | grep -q "existing target is neither a link nor a directory"; then
        print_warning "Found conflicting files that need to be backed up"
        
        # Create a temporary file to store conflict paths
        local conflict_files=$(mktemp)
        echo "$stow_conflicts" | grep "existing target is neither a link nor a directory" | \
            sed 's/.*existing target is neither a link nor a directory: //' > "$conflict_files"
        
        # Back up conflicting files
        local timestamp=$(date +%Y%m%d_%H%M%S)
        while IFS= read -r conflict_file; do
            if [[ -n "$conflict_file" && -e "$HOME/$conflict_file" ]]; then
                local backup_file="$HOME/${conflict_file}.backup.$timestamp"
                print_info "Backing up $conflict_file to ${conflict_file}.backup.$timestamp"
                
                # Create backup directory if needed
                local backup_dir=$(dirname "$backup_file")
                mkdir -p "$backup_dir" 2>/dev/null
                
                # Move the conflicting file
                if mv "$HOME/$conflict_file" "$backup_file"; then
                    print_success "Backed up $conflict_file"
                else
                    print_error "Failed to backup $conflict_file"
                fi
            fi
        done < "$conflict_files"
        
        # Clean up temporary file
        rm -f "$conflict_files"
        
        print_info "All conflicting files backed up with timestamp: $timestamp"
    fi
    
    # Stow the dotfiles
    print_info "Using stow to symlink dotfiles..."
    
    # Run stow with verbose output and capture any errors
    stow_output=$(stow . --target="$HOME" --verbose 2>&1)
    stow_exit_code=$?
    
    if [[ $stow_exit_code -eq 0 ]]; then
        print_success "Dotfiles successfully symlinked with stow"
        
        # Show which files were linked
        if [[ -n "$stow_output" ]]; then
            print_info "Stow created these symlinks:"
            echo "$stow_output" | grep -E "(LINK|UNLINK)" | head -10
        fi
        
        return 0
    else
        print_error "Failed to stow dotfiles"
        print_info "Stow output:"
        echo "$stow_output"
        print_info "You may need to resolve conflicts manually"
        print_info "Use 'stow . --target=$HOME --verbose' to see detailed output"
        return 1
    fi
}

# Function to setup aliases
setup_aliases() {
    local script_dir="$1"
    
    print_info "Setting up custom aliases..."
    local zsh_custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    mkdir -p "$zsh_custom_dir"
    
    if [ -f "$(dirname "$script_dir")/../aliases.zsh" ]; then
        cp "$(dirname "$script_dir")/../aliases.zsh" "$zsh_custom_dir/aliases.zsh"
        print_success "aliases.zsh copied to Oh My Zsh custom directory"
        return 0
    else
        print_warning "aliases.zsh not found in dotfiles directory"
        return 1
    fi
}

# Export all functions for use in other scripts
export -f print_info print_success print_warning print_error print_header
export -f is_wsl command_exists package_installed
export -f install_package install_from_url clone_repo add_repository
export -f update_packages upgrade_packages print_installation_summary
export -f setup_dotfiles setup_aliases
