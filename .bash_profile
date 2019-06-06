export PS1='\$ '

export PATH=\
.:\
$PATH

set -o vim


# added by Anaconda 2.1.0 installer
export PATH="/Users/julianedwards/anaconda/bin:$PATH"

# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH
alias python='python3'

# Setting PATH for Go
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin
export GOSC=$GOPATH/src/github.com/julianedwards

# Setting PGDATA for PSQL
export PGDATA=/usr/local/var/postgres
