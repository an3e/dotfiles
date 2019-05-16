# antigen set up
ZSH_ANTIGEN_VERSION="v2.2.3"
ZSH_ANTIGEN_LOCATION="${HOME}/.antigen"
[[ ! -d "${ZSH_ANTIGEN_LOCATION}" ]] \
    && git clone https://github.com/zsh-users/antigen.git "${ZSH_ANTIGEN_LOCATION}" \
    && cd "${ZSH_ANTIGEN_LOCATION}" &>/dev/null \
    && git checkout "${ZSH_ANTIGEN_VERSION}" &>/dev/null \
    && cd &>/dev/null

################################################################################

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

################################################################################

source "${ZSH_ANTIGEN_LOCATION}/antigen.zsh"
antigen use oh-my-zsh
antigen bundle chucknorris
antigen bundle colored-man-pages
antigen bundle command-not-found
antigen bundle common-aliases
antigen bundle git
antigen bundle history-substring-search
antigen bundle last-working-dir
antigen bundle tig
# use OS specific plugins
case $(cat /etc/os-release | grep ^NAME 2>/dev/null) in
    *Ubuntu*) antigen bundle ubuntu ;;
    *Debian*) antigen bundle debian ;;
    *Arch*)   antigen bundle archlinux ;;
    *) ;;
esac
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle MichaelAquilina/zsh-you-should-use
antigen theme afowler
# antigen theme agnoster
# antigen theme clean
# antigen theme evan
# antigen theme gallifrey
# antigen theme minimal
# antigen theme nicoulaj
# antigen theme obraun
# antigen theme philips
# antigen theme refined
# antigen theme risto
# antigen theme simple
antigen apply

################################################################################

chuck_cow 2>/dev/null

################################################################################

do_source() {
    while [ $# -gt 0 ]
    do
        local file_to_source="${1}";
        shift 1;

        [[ -f "${file_to_source}" ]] || continue;

        source "${file_to_source}";
    done
}

################################################################################

do_source \
    "${HOME}/.zshrc_ext" \
    "${HOME}/.aliases" \
    || true

