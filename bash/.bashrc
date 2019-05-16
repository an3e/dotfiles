#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

FILE_GIT_AUTOCOMPLETION="/usr/share/git/completion/git-completion.bash";
FILE_GIT_PROMPT="/usr/share/git/completion/git-prompt.sh";
FILE_CMD_NOT_FOUND="/usr/share/doc/pkgfile/command-not-found.bash";
FILE_BASH_COLORS="${HOME}/.bash_colors"
__do_show_git_prompt=0

[[ -r "${FILE_GIT_AUTOCOMPLETION}" ]] && source "${FILE_GIT_AUTOCOMPLETION}";
[[ -r "${FILE_GIT_PROMPT}"         ]] && source "${FILE_GIT_PROMPT}" && __do_show_git_prompt=1;
[[ -r "${FILE_CMD_NOT_FOUND}"      ]] && source "${FILE_CMD_NOT_FOUND}";
[[ -f "${FILE_BASH_COLORS}"        ]] && source "${FILE_BASH_COLORS}";

unset FILE_GIT_AUTOCOMPLETION;
unset FILE_GIT_PROMPT;
unset FILE_CMD_NOT_FOUND;
unset FILE_BASH_COLORS;

#########################################################################################

EXIT_CODE_NOK=""
EXIT_CODE_OK=""
case $TERM in
    *xterm*)
        EXIT_CODE_NOK="\342\234\227"
        EXIT_CODE_OK="\342\234\223"
        ;;
    *)
        EXIT_CODE_NOK=":("
        EXIT_CODE_OK=":)"
        ;;
esac

PS1_PRE="\
${COLOR_BLD_CYN}[\D{%T}] \
${COLOR_BLD_WHT}\$? \
\$(if [ \$? == 0 ]; then echo \"${COLOR_BLD_GRN}${EXIT_CODE_OK}\"; else echo \"${COLOR_BLD_RED}${EXIT_CODE_NOK}\"; fi) \
${COLOR_BLD_GRN}\u\
${COLOR_BLD_RED}@\
${COLOR_BLD_GRN}\h\
${COLOR_BLD_RED}:\
${COLOR_BLD_BLU}\w\
${COLOR_RST}\
"
PS1_POST="\
${COLOR_BLD_BLK}\$ \
${COLOR_RST}\
"

#########################################################################################

man() {
    env \
    LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

set_git_bash_prompt() {
    local GIT_PS1_SHOWDIRTYSTATE="1"       # unstaged (*) and staged (+) changes
    local GIT_PS1_SHOWSTASHSTATE="1"       # '$'=stashed
    local GIT_PS1_SHOWUNTRACKEDFILES="1"   # '%'=untracked

    local GIT_PS1_SHOWUPSTREAM="auto"
    local GIT_PS1_DESCRIBE_STYLE="describe"

    local GIT_PS1_STATESEPARATOR=" "
    local GIT_PS1_SHOWCOLORHINTS="1"
    
    __git_ps1 "$PS1_PRE${COLOR_BLD_WHT}" "$PS1_POST" "${COLOR_BLD_YEL}(%s${COLOR_BLD_YEL})"
}

#########################################################################################

if [ ${__do_show_git_prompt} -gt 0 ]; then
    PROMPT_COMMAND=set_git_bash_prompt
else
    PROMPT_COMMAND=""
    PS1="${PS1_PRE}${PS1_POST}"
fi

#########################################################################################

[[ $(which fortune) ]] && [[ $(which cowsay) ]] && $(which fortune) | $(which cowsay) -f $(ls /usr/share/cows/ | shuf -n1)

alias lh='ls -lh'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias gitk='gitk --all'

