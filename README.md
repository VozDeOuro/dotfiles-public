# 🎨 VozDeOuro Dotfiles

> *Modern, purple-themed terminal environment with comprehensive tooling*

A complete dotfiles ecosystem featuring Oh My Posh, modern CLI tools, and a beautiful purple aesthetic. Visually appealing terminal experience.

## ✨ Features

### 🎯 Core Components
- **Oh My Posh** with custom VozDeOuro Velvet theme
- **ZSH** with Oh My Zsh and powerful plugins
- **Kitty Terminal** with Hardcore theme and Nerd Font support
- **Fastfetch** system info with purple theming
- **Stow-based** dotfiles management

### 🛠️ Modern CLI Tools
- **eza** - Better `ls` with colors and icons
- **bat** - Better `cat` with syntax highlighting
- **fd** - Better `find` with intuitive syntax
- **ripgrep** - Better `grep` that's incredibly fast
- **fzf** - Fuzzy finder for everything
- **zoxide** - Smart `cd` that learns your habits
- **dust** - Better `du` disk usage analyzer
- **duf** - Better `df` filesystem viewer
- **thefuck** - Command correction tool
- **tldr** - Simplified man pages

### 🔥 Advanced Tools
- **Zellij** - Modern terminal multiplexer
- **superfile** - TUI file manager
- **advcpmv** - Copy/move with progress bars
- **Network tools** - nmap, traceroute, whois
- **Development tools** - build-essential, git, vim

### 🎨 Theming
- **VozDeOuro Purple** color scheme (`#a52aff`)
- **MesloLGS Nerd Font** for perfect icon rendering
- **Consistent purple theming** across all tools
- **Windows Terminal** compatibility

## 🚀 Quick Start

### One-Line Installation
```bash
git clone https://github.com/VozDeOuro/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/VozDeOuro/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Set up local environment (for API keys, credentials)
cp .settings_local.template .settings_local
# Edit .settings_local with your actual API keys and credentials

# Make scripts executable
chmod +x scripts/*.sh

# Run the main installer
./install.sh
```

## 📦 Installation Options

### Full Installation (Recommended)
```bash
./install.sh
```
Installs everything with interactive prompts for customization.

### Individual Components
```bash
# Core shell environment
./scripts/install-zsh.sh
./scripts/install-oh-my-posh.sh

# Modern CLI tools
./scripts/install-modern-cli.sh

# Advanced development tools
./scripts/install-advanced-tools.sh

# System information
./scripts/system-info-installer.sh

# Stow dotfiles
./scripts/stow-dotfiles.sh
```

## 🎨 Themes & Customization

### Oh My Posh Theme
The custom **VozDeOuro Velvet** theme features:
- Purple color scheme with pink background
- Git integration with branch and status
- Execution time and timestamp
- Root user indicator (skull symbol)
- Transient prompt support

### Kitty Terminal
- **Hardcore theme** with high contrast
- **MesloLGS Nerd Font** with full icon support
- Custom keybindings and window management
- GPU acceleration and modern features

### Fastfetch
- Custom purple-themed system info
- Box-style layout with VozDeOuro branding
- Windows Terminal compatibility
- Automatic logo selection

## 🔧 Configuration Files

```
dotfiles/
├── .config/
│   ├── kitty/kitty.conf           # Kitty terminal configuration
│   ├── oh-my-posh/                # Oh My Posh themes
│   ├── fastfetch/config.jsonc     # System info configuration
│   └── zellij/config.kdl          # Terminal multiplexer
├── .zshrc                         # ZSH configuration
├── aliases.zsh                    # Custom aliases
├── colors.zsh                     # VozDeOuro color scheme
└── scripts/                       # Installation scripts
    ├── install.sh                 # Main installer
    ├── install-zsh.sh             # ZSH setup
    ├── install-oh-my-posh.sh      # Prompt setup
    ├── install-modern-cli.sh      # Modern tools
    ├── install-advanced-tools.sh  # Development tools
    ├── system-info-installer.sh   # Fastfetch setup
    └── stow-dotfiles.sh           # Symlink management
```

## 🎯 Key Features Explained

### VozDeOuro Color Scheme
- **Primary**: `#a52aff` (Purple)
- **Secondary**: `#2b4fff` (Blue)
- **Accent**: `#28b9ff` (Cyan)
- Applied consistently across all tools and themes

### Smart Aliases
```bash
# Modern tool replacements
alias ls='eza --color=always --group-directories-first --icons'
alias cat='bat --paging=never'
alias find='fd'
alias grep='rg'

# Enhanced commands
alias ll='eza -la --icons --group-directories-first'
alias tree='eza --tree --icons'
alias top='htop'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
```

### Robust Installation
- **Multiple fallback methods** for each tool
- **Architecture detection** for ARM/x64 compatibility
- **Error handling** with clear feedback
- **Dependency resolution** automatic
- **Path management** seamless integration

## 🖥️ Compatibility

### Operating Systems
- ✅ Ubuntu 20.04+
- ✅ Debian 10+
- ✅ WSL2 (Windows Subsystem for Linux)
- ✅ Pop!_OS
- ⚠️ Kali Linux (limited terminal integration)

### Terminals
- ✅ Kitty (recommended)
- ✅ Windows Terminal
- ✅ GNOME Terminal
- ✅ Alacritty
- ⚠️ Basic terminals (limited icon support)

## 🆘 Help & Troubleshooting

### Built-in Help System
```bash
# Access help documentation
vozhelp
# or
tips

# View installation summary
~/dotfiles/scripts/voz-help.sh
```

### Common Issues

#### Stow Installation Failed
If the automatic stow process fails during installation:
```bash
# Navigate to dotfiles directory
cd ~/dotfiles

# Manually run stow to create symlinks
stow .

# If there are conflicts, backup existing files first
mkdir -p ~/.backup
mv ~/.zshrc ~/.backup/  # backup conflicting files
stow .
```

#### Missing Icons
```bash
# Install Nerd Font
./scripts/install-modern-cli.sh
# Restart terminal
```

#### Command Not Found
```bash
# Reload shell configuration
source ~/.zshrc
# or start new terminal
```

#### Fastfetch Colors
```bash
# Verify config path
fastfetch --config ~/.config/fastfetch/config.jsonc
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh My Posh](https://ohmyposh.dev/) - Cross-platform prompt theme engine
- [Oh My Zsh](https://ohmyz.sh/) - ZSH framework
- [Kitty](https://sw.kovidgoyal.net/kitty/) - Fast, feature-rich terminal
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch) - System information tool
- [Nerd Fonts](https://www.nerdfonts.com/) - Iconic font aggregator

## 🌟 Star History

If you found this helpful, please consider giving it a star! ⭐

---

<div align="center">
  <sub>Built with 💜 by VozDeOuro</sub>
</div>