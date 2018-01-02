fixagent() {
    eval $(tmux show-env -s | grep '^SSH_')
}
