export GIT_DISCOVERY_ACROSS_FILESYSTEM="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
export COMPLETION_WAITING_DOTS="true"

SCRIPTS_DIR="${HOME}/.scripts"
SCRIPTS_LIB_DIR="${SCRIPTS_DIR}/lib"
[[ -d "${SCRIPTS_LIB_DIR}" ]] \
    && export SCRIPTS_LIB_DIR

SCRIPTS_BIN_DIR="${SCRIPTS_DIR}/bin"
[[ -d "${SCRIPTS_BIN_DIR}" ]] \
    && export PATH="${PATH}:${SCRIPTS_BIN_DIR}"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true
