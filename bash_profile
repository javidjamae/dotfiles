# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home

# Silence macOS "default shell is now zsh" warning
export BASH_SILENCE_DEPRECATION_WARNING=1

#################
# ENV Variables #
#################

# Detect architecture and set Homebrew prefix accordingly
if [ "$(uname -m)" = "arm64" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
else
    HOMEBREW_PREFIX="/usr/local"
fi

export PATH=$HOMEBREW_PREFIX/bin:$PATH
export PATH=$HOMEBREW_PREFIX/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/bin:$PATH
export PATH=/usr/bin:$PATH
export PATH=$HOME/.rvm/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/texlive/2024/bin/universal-darwin:$PATH
export PATH=$HOME/.local/bin:$PATH

export EDITOR=/usr/local/bin/mvim

##########
# Docker #
##########
DOCKER_HOST=unix:///var/run/docker.sock

#######
# RVM #
#######
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

##########
# Prompt #
##########
source ~/.bash_prompt

###########
# thefuck #
###########
if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)" # https://github.com/nvbn/thefuck
fi

#######
# Git #
#######
git-prune() {
  git branch --merged main | grep -v '^[ *]*main$' | xargs git branch -d
}

#######
# NVM #
#######
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Also try Homebrew-installed NVM
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# Bash git completion
if command -v brew &>/dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    . "$(brew --prefix)/etc/bash_completion"
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
CONDA_BIN="$HOMEBREW_PREFIX/anaconda3/bin/conda"
if [ -f "$CONDA_BIN" ]; then
    __conda_setup="$("$CONDA_BIN" 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOMEBREW_PREFIX/anaconda3/etc/profile.d/conda.sh" ]; then
            . "$HOMEBREW_PREFIX/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOMEBREW_PREFIX/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi
# <<< conda initialize <<<


############
# OpenClaw #
############
# This is tunneling to my other machine that runs openclaw
# The `openclaw` machine is configured in ~/.ssh/config
openclaw-on() {
  ssh -fN -o ExitOnForwardFailure=yes openclaw-tunnel
  echo "OpenClaw tunnel started at http://127.0.0.1:18789 and http://127.0.0.1:4000"
}

openclaw-off() {
  pkill -f "ssh.*openclaw-tunnel"
  echo "OpenClaw tunnel stopped"
}

openclaw-status() {
  lsof -nP -iTCP:18789 -sTCP:LISTEN | grep ssh >/dev/null \
    && echo "Tunnel is running (ports 18789 and 4000)" \
    || echo "Tunnel is NOT running"
}

# Set SHELL to the correct bash for this architecture
export SHELL="$HOMEBREW_PREFIX/bin/bash"
