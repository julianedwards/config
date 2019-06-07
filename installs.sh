SEPARATOR="\n=====================================\n"
CUR_USER=$1
if [[ "$CUR_USER" == "" ]]; then
    CUR_USER=julianedwards
fi
echo "User is $CUR_USER"

echo $SEPARATOR

# install homebrew
if [[ $(command -v brew) == "" ]]; then 
    echo "Installing Homebrew.. "
    sudo -u $CUR_USER ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating Homebrew.. "
    sudo -u $CUR_USER brew update
fi

echo $SEPARATOR

# install vim-plug
#       install plugins via vim -- :PlugInstall
#       install vim-go binaries: :GoInstallBinaries
VIMPLUG=~/.vim/autoload/plug.vim
if [[ -f "$VIMPLUG" ]]; then
    echo "vim-plug installed"
else
    echo "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo $SEPARATOR

# install mongo
MONGO_VERSION=4.0
if [[ $(command -v mongo) == "" ]]; then
    echo "Installing MongoDB version $MONGO_VERSION..."
    sudo -u $CUR_USER brew tap mongodb/brew
    sudo -u $CUR_USER brew install mongodb-community@$MONGO_VERSION
    mkdir /data
    mkdir /data/db
    chmod 0755 /data/db && chown $CUR_USER /data/db
else
    echo "MongoDB installed"
    mongod --version
fi
