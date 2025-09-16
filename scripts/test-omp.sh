#!/bin/bash

# VozDeOuro Oh My Posh Test Script
# ===============================
# This script helps test the Oh My Posh installation and transient shell

echo "🎨 VozDeOuro Oh My Posh Test"
echo "============================"
echo ""

# Check if Oh My Posh is installed
if command -v oh-my-posh >/dev/null 2>&1; then
    echo "✅ Oh My Posh is installed"
    echo "   Version: $(oh-my-posh version)"
else
    echo "❌ Oh My Posh is not installed"
    exit 1
fi

# Check if config file exists
if [[ -f "$HOME/.config/oh-my-posh/vozdeoro-purple.omp.json" ]]; then
    echo "✅ VozDeOuro Purple theme config found"
else
    echo "❌ VozDeOuro Purple theme config not found"
    exit 1
fi

# Check if ZSH is configured
if grep -q "oh-my-posh init zsh" "$HOME/.zshrc" 2>/dev/null; then
    echo "✅ ZSH is configured for Oh My Posh"
else
    echo "⚠️  ZSH configuration may need updating"
fi

# Check if transient shell is enabled
if grep -q "enable_poshtransientprompt" "$HOME/.zshrc" 2>/dev/null; then
    echo "✅ Transient shell is enabled"
else
    echo "⚠️  Transient shell may not be enabled"
fi

# Test font installation
echo ""
echo "🔤 Font Test:"
echo "If you see symbols below clearly, your Nerd Font is working:"
echo "   Git: \ue0a0  Folder: \ue5ff  Node: \ue718  Python: \ue235"
echo "   Docker: \uf308  Kubernetes: \ufd31  Success: \uf00c  Error: \uf00d"

echo ""
echo "💡 To test transient shell:"
echo "   1. Start a new ZSH session: exec zsh"
echo "   2. Run some commands (ls, pwd, etc.)"
echo "   3. Notice how previous commands show minimal '❯' prompt"
echo "   4. Current command shows full colorful prompt"

echo ""
echo "🎨 To see colors: run 'colors' command"
echo "📊 To see system info: run 'fastfetch' or 'ff' command"
