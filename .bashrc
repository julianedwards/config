#Python
alias python=python3

# Limit the number of files and processes.
ulimit -n 65536
ulimit -u 2048

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
