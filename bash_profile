# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home

#################
# ENV Variables #
#################
export PATH=/usr/local/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/bin:$PATH
export PATH=/usr/bin:$PATH
export PATH=$HOME/.rvm/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

export EDITOR=/usr/local/bin/mvim

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
eval "$(thefuck --alias)" # https://github.com/nvbn/thefuck #

########
# TOUT #
########
# For Kestrel
export STAGE=development # for kestrel

remote() {
  if [ $# -eq 0 ] ; then
    echo "Usage: remote unit-env-name [optional-command]"
    echo
    echo "  Examples:"
    echo "    Launch a remote shell:"
    echo "      remote env-qa-kicktag"
    echo
    echo "    Run a remote rake task:"
    echo "      remote env-qa-kicktag ./kicktag/bin/rake db:migrate:status"
    echo
    echo "    Run multiple remote commands:"
    echo "      remote env-qa-kicktag \"bash -c 'cd kicktag; ./bin/console'\""
    echo
    return
  fi
  HOSTNAME=$1
  shift
  ssh jump -t "source /etc/profile; ssh-tag-host $HOSTNAME sudo -iu tout \"$@\""
}

console() {
  if [ $# -eq 2 ] ; then
    ssh jump -t "source /etc/profile; ssh-tag-host env-$1-$2 sudo -iu tout $2/bin/console"
  else
    echo "Usage: console environment unit"
    echo
    echo "  Examples:"
    echo "    console qa kicktag"
    echo "    console prod jigsaw"
    echo
  fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
