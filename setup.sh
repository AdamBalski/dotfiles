#!/bin/bash

# Warning
echo "Warning: This may overwrite your dotfiles and install some new packages"
echo ""

# Gain root priviliges
sudo echo "Installing dotfiles for the user $USER"

read -p "Where do you want the dotfiles to be?" gitpath

echo "0. updating system"
sudo apt update && sudo apt upgrade

echo "1.  git, curl, wget"
sudo apt install git curl wget

read -p "What editor do you use?: " editor
git config --global core.editor "$editor"

read -p "What is your username in git?: " username
git config --global user.name "$username"

echo "What is your email in git?"
read email
git config --global user.email "$email"

mkdir -p $path
git clone https://www.github.com/AdamBalski/dotfiles.git "$path/dotfiles"

echo "2.  zsh" 
sudo apt install zsh
chsh -s /binzsh
ln -sf "$path/dotfiles/zshrc" ~/.zshrc 

echo "3.  nvim"
sudo apt install neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -sf "$path/dotfiles/nvim/init.vim"           ~/.config/nvim/init.vim
ln -sf "$path/dotfiles/nvim/init.coc.vim"       ~/.config/nvim/init.coc.vim
ln -sf "$path/dotfiles/nvim/coc-settings.json"  ~/.config/nvim/coc-settings.json

echo "4. guake"
sudo apt install guake
echo "5.  spotify"
sudo apt install spotify-client
echo "6.  chrome"
sudo apt install google-chrome-stable
echo "7.  kolourpaint"
sudo apt install kolourpaint
echo "8.  gimp"
sudo apt install gimp
echo "9.  joplin"
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
echo "10. libreoffice suit"
sudo apt install libreoffice
echo "11. discord"
sudo apt install discord
echo "12. sl"
sudo apt install sl
echo "13. htop"
sudo apt install htop
echo "14. visual studio code"
sudo apt install code
echo "15. calibre"
sudo apt install calibre
echo "16. steam"
sudo apt install steam

echo "17. linuxbrew"

sudo apt-get install build-essential procps curl file git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


echo "18. docker via linuxbrew"
brew install docker

echo "19. node via linuxbrew"
brew install node

echo "20. maven via linuxbrew"
brew install maven

echo ""
echo "Done"
echo ""

echo "What to do next?:"
echo "1. Install jetbrains-toolbox, postman, scid vs. pc"
echo "2. Login to google chrome, spotify, discord, joplin, configure calibre"
echo "3. Set up all projects you work on on jetbrains' tools"
echo '4. Do a ":PlugInstall" in neovim'
echo "5. Uninstall preinstalled apps you don't want to have"
echo "6. Set up the printer"

echo ""

echo "Links:"
echo "1. https://www.jetbrains.com/toolbox-app/"
echo "2. https://www.postman.com/downloads/"
echo "3. http://scidvspc.sourceforge.net/"

# Lib input gestures
# scid
# postman
