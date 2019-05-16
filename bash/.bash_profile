#
# ~/.bash_profile
#

# do not store the same command multiple times in history
export HISTCONTROL=ignoredups
export EDITOR=$(which vim)
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/Projects/bash/.scripts" ]] && export SCRIPTS_LIB_DIR="$HOME/Projects/bash/.scripts"

[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.bashrc  ]] && . ~/.bashrc
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
