export PS1='\$ '

# Homebrew
PATH=/opt/homebrew/bin:$PATH

# Golang
export GOPATH=$HOME/gocode
export GOSC=$GOPATH/src/github.com/julianedwards
export GOFLAGS=-ldflags="-w"
export GOMODCACHE="$(go env GOMODCACHE)"
PATH=$GOPATH/bin:$PATH

# Setting PGDATA for PSQL
export PGDATA=/usr/local/var/postgres

# SCONS
export SCONSFLAGS="-j4 -Q --cache=nolinked --implicit-cache"

# Protobuf
PATH="/usr/local/opt/protobuf@3.6/bin:$PATH"

export PATH=\
.:\
$PATH

if [ -f ~/.bashrc ];
then 
    .  ~/.bashrc; 
fi 
. "$HOME/.cargo/env"
