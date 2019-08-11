#!/usr/bin/env bash

set -e  # exit immediately when a command exits with a non-zero status.
set -u  # exit immediately when an undefined variable is referenced.
#set -x

do_run() {
    stow --ignore=".directory" --adopt --verbose "${@}"
}

do_stow() {

    [[ -d "${1}" ]] || return 0;

    case "${1}" in
        htop)
            mkdir -p "${HOME}/.config"
            do_run "${1}" \
                -t "${HOME}/.config" \
                -d "${1}/.config"
            ;;

        scripts)
            mkdir -p "${HOME}/.scripts"
            do_run "${1}" \
                -t "${HOME}/.scripts"
            ;;

        *)
            do_run "${1}"
            ;;
    esac
}

do_setup() {

    local -r REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
    [[ -n "${REPO_ROOT}" ]] || return 1;

    export SCRIPTS_LIB_DIR="${REPO_ROOT%/}/scripts/lib"
    source "${SCRIPTS_LIB_DIR%/}/runtime.sh"

    isExecuted || return 3;
    isInstalled git stow || return 5;

    [[ $# -gt 0 ]] || set -- $(ls ./)

    for __component in ${@}
    do
        do_stow "${__component}"
    done
}

do_setup ${@}

