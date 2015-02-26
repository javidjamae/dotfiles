
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home

# For Kestrel
export STAGE=development

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH=/usr/local/bin:/Users/javid/.rvm/gems/ruby-2.0.0-p247/bin:/Users/javid/.rvm/gems/ruby-2.0.0-p247@global/bin:/Users/javid/.rvm/rubies/ruby-2.0.0-p247/bin:/Users/javid/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

source ~/.bash_prompt

export PATH=/usr/local/sbin:$PATH
export EDITOR=/usr/local/bin/mvim

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
