#!/bin/bash

# Warning
echo "Warning: This may overwrite your dotfiles and install some new packages"
echo ""

# Gain root priviliges
sudo echo "Installing dotfiles for the user $USER"

read -p "Where do you want the dotfiles to be?" gitpath

echo "0. updating system"
sudo apt update && sudo apt upgrade

echo "1.  git, wget, python3"
sudo apt install git wget python3

read -p "What editor do you use?: " editor
git config --global core.editor "$editor"

read -p "What is your username in git?: " username
git config --global user.name "$username"

echo "What is your git email?"
read email
git config --global user.email "$email"

mkdir -p $gitpath
git clone https://www.github.com/AdamBalski/dotfiles.git "$gitpath/dotfiles"

echo "2.  zsh" 
sudo apt install zsh
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ln -sf "$gitpath/dotfiles/zshrc" ~/.zshrc 

echo "3.  nvim"
sudo apt install neovim
mkdir -p ~/.config/nvim/plugged
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -sf "$gitpath/dotfiles/nvim/init.vim"           ~/.config/nvim/init.vim
ln -sf "$gitpath/dotfiles/nvim/init.coc.vim"       ~/.config/nvim/init.coc.vim
ln -sf "$gitpath/dotfiles/nvim/coc-settings.json"  ~/.config/nvim/coc-settings.json

echo "4. tmux"
sudo apt install tmux
mkdir -p /home/$USER/.config/tmux/
git clone https://github.com/wfxr/tmux-power /home/$USER/.config/tmux/tmux-power
ln -sf "$gitpath/dotfiles/tmux.conf" ~/.tmux.conf

echo "5. libinput-gestures"
sudo gpasswd -a $USER input
sudo apt-get install wmctrl xdotool
sudo apt-get install libinput-tools
git clone https://github.com/bulletmark/libinput-gestures.git /home/$USER/libinput-gestures
cd /home/$USER/libinput-gestures
sudo make install
libinput-gestures-setup autostart start
ln -sf $gitpath/dotfiles/libinput-gestures.conf ~/.config/libinput-gestures.conf
libinput-gestures-setup service
libinput-gestures-setup autostart
cd ~


echo "5. guake"
sudo apt install guake
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
echo "11. sl"
sudo apt install sl
echo "12. htop"
sudo apt install htop
echo "13. visual studio code"
sudo apt install code
echo "14. calibre"
sudo apt install calibre
echo "15. steam"
sudo apt install steam
echo "16. latex"
sudo apt install texlive-full

echo "17. linuxbrew"
sudo apt-get install build-essential procps curl file git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin

echo "18. node via linuxbrew"
brew install node
echo "19. maven via linuxbrew"
brew install maven
echo "20. discord via flatpak"
flatpak install flathub com.discordapp.Discord
echo "21. spotify via flatpak"
flatpak install flathub com.spotify.Client
echo "22. postman via flatpak"
flatpak install flathub com.getpostman.Postman

echo "23. haskell"
brew install ghc
brew install cabal-install
curl -sSL https://get.haskellstack.org/ | sh
brew install ghcup
ghcup install hls

echo ""
echo "Done"
echo ""

echo "What to do next?:"
echo "1. Install jetbrains-toolbox, scid vs. pc"
echo "2. Login to google chrome, spotify, discord, joplin, configure calibre"
echo "3. Set up all projects you work on on with jetbrains' tools"
echo '4. Do a ":PlugInstall" in neovim'
echo "5. Make guake and terminal font jetbrains mono"
echo "6. Uninstall preinstalled apps you don't want to have"
echo "7. Set up the printer"
echo "8. Rice the DE"

echo ""

echo "Links:"
echo "1. https://www.jetbrains.com/toolbox-app/"
echo "2. http://scidvspc.sourceforge.net/"
