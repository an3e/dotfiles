#!/usr/bin/env bash

set -e  # exit immediately when a command exits with a non-zero status.
set -u  # exit when an undefined variable is referenced.

SCRIPTS_DIR="${HOME}/.scripts/"
[[ ! -d "${SCRIPTS_DIR}" ]] \
    && mkdir -p "${SCRIPTS_DIR}" \
    && git clone git@github.com:an3e/scripts.git "${SCRIPTS_DIR}"

source "${SCRIPTS_DIR%/}/lib/runtime.sh"

isExecuted || return 1;
isInstalled git stow || exit 3;

[[ $# -gt 0 ]] || set -- $(ls ./)

for __component in ${@}
do
    [[ -d "${__component}" ]] || continue;
    stow -v -R ${__component}
done

