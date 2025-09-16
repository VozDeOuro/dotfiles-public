# VozDeOuro ZSH Aliases Configuration
# ===================================

# --- Directory Navigation ---
alias c..="cd .."
alias c...="cd ..;cd .."
alias c....="cd ..;cd ..;cd .."
alias c.....="cd ..;cd ..;cd ..;cd .."
alias c="z"
alias cdi="zi"

# GLOBAL aliases for referencing FILES in parent directories
alias -g ..='../'
alias -g ...='../../'
alias -g ....='../../../'
alias -g .....='../../../../'

# --- System Information ---
alias d="df -BG"
alias duu='du -sh'
alias h="htop"

# --- History ---
alias hs="history | grep"

# --- File Listing ---
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias lh='ls -lh --color=auto'

# --- File Operations ---
# Advanced cp/mv with progress bars (advcpmv)
#alias cp='/usr/local/bin/advcp -g'
#alias mv='/usr/local/bin/advmv -g'

# --- Text Processing ---
alias -g cat='ccat'
alias bat='batcat'

# --- Programming ---
alias python='python3'

# --- Git Shortcuts ---
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glog='git log --oneline --graph --decorate'

# --- SSH & Remote ---
alias tower='ssh -p 22 root@192.168.0.10'

# --- Modern CLI Tools ---
alias grep='rg'
alias top='htop'
alias du='dust'
alias df='duf'
alias ps='procs'
alias ls='eza --color=always --group-directories-first'
alias ll='eza -la --all --color=always --group-directories-first'
alias la='eza -a --all --color=always --group-directories-first'
alias lt='eza -aT --color=always --group-directories-first'
#alias find='fd'# breaks find command 

# --- Quick Edits ---
alias zshconfig="vim ~/.zshrc"
alias aliasconfig="vim ~/.oh-my-zsh/custom/aliases.zsh"
alias ohmyzsh="vim ~/.oh-my-zsh"

# --- System Shortcuts ---
alias reload='source ~/.zshrc'
alias cls='clear'
alias q='exit'
alias ports='netstat -tulanp'
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# --- VozDeOuro Custom ---
alias fastfetch='fastfetch --config $HOME/dotfiles/.config/fastfetch/config.jsonc'
alias ff='fastfetch'
alias superfile='spf'
alias m='zellij'
alias colors='source ~/colors.zsh && show_colors'
alias colors-test='source ~/colors.zsh && test_colors'

# --- Development ---
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'

# --- Docker ---
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop $(docker ps -aq)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'

# --- Kubernetes ---
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployment'
alias kdp='kubectl describe pod'
alias kds='kubectl describe svc'
alias kdd='kubectl describe deployment'
alias klog='kubectl logs -f'
alias kex='kubectl exec -it'

# --- Network ---
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'
alias myip='curl ipinfo.io/ip'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# --- Archive Operations ---
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# --- VozDeOuro Help System ---
alias vozhelp='bash ~/dotfiles/scripts/voz-help.sh'
alias tips='bash ~/dotfiles/scripts/voz-help.sh'

# --- Terminal Applications ---
# Ensure kitty is accessible even if PATH isn't fully configured
if [ -f "$HOME/.local/kitty.app/bin/kitty" ] && ! command -v kitty >/dev/null 2>&1; then
    alias kitty='$HOME/.local/kitty.app/bin/kitty'
fi
