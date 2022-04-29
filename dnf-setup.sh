#!/bin/bash

# Warning
echo "Warning: This may overwrite your dotfiles and install some new packages"
echo ""

# Gain root priviliges
sudo echo "Installing dotfiles for the user $USER"

read -p "Where do you want the dotfiles to be?" gitpath

echo "0. updating the system and enabling rpm fusion"
sudo dnf check-update && sudo dnf update
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf check-update && sudo dnf update

echo "1.  git, wget, python3"
sudo dnf install git wget python3

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
sudo dnf install zsh
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ln -sf "$gitpath/dotfiles/zshrc" ~/.zshrc 

echo "3.  nvim"
sudo dnf install neovim
mkdir -p ~/.config/nvim/plugged
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -sf "$gitpath/dotfiles/nvim/init.vim"           ~/.config/nvim/init.vim
ln -sf "$gitpath/dotfiles/nvim/init.coc.vim"       ~/.config/nvim/init.coc.vim
ln -sf "$gitpath/dotfiles/nvim/coc-settings.json"  ~/.config/nvim/coc-settings.json

echo "4. tmux"
sudo dnf install tmux
mkdir -p /home/$USER/.config/tmux/
git clone https://github.com/wfxr/tmux-power /home/$USER/.config/tmux/tmux-power
ln -sf "$gitpath/dotfiles/tmux.conf" ~/.tmux.conf

echo "5. libinput-gestures"
sudo gpasswd -a $USER input
sudo dnf install wmctrl xdotool
git clone https://github.com/bulletmark/libinput-gestures.git /home/$USER/libinput-gestures
cd /home/$USER/libinput-gestures
sudo make install
libinput-gestures-setup autostart start
ln -sf $gitpath/dotfiles/libinput-gestures.conf ~/.config/libinput-gestures.conf
libinput-gestures-setup service
libinput-gestures-setup autostart
cd ~

echo "5. guake"
sudo dnf install guake

echo "6.  chrome"
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable

echo "7.  kolourpaint"
sudo dnf install kolourpaint
echo "8.  gimp and inkscape"
sudo dnf install gimp inkscape
echo "9.  joplin"
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
echo "10. libreoffice suit"
sudo dnf install libreoffice
echo "11. sl"
sudo dnf install sl
echo "12. htop"
sudo dnf install htop
echo "13. visual studio code"
sudo dnf install code
echo "14. latex"
sudo dnf install texlive-scheme-full
echo "15. steam"
sudo dnf install steam
echo "16. node"
sudo dnf install nodejs
echo "17. maven"
sudo dnf install maven
echo "18. spotify"
sudo dnf install lpf-spotify-client
lpf update

echo "19. downloading discord"
cd ~
mkdir -p ~/.apps/discord
wget -c https://discord.com/api/download?platform=linux&format=tar.gz
mv discord*.tar.gz ~/.apps/discord/discord.tar.gz
cd ~/.apps/discord
tar -xf discord*.tar.gz
cd ~

echo "21. downloading postman"
cd ~
mkdir -p ~/.apps/postman
wget -c https://dl.pstmn.io/download/latest/linux64
mv postman*.tar.gz ~/.apps/postman/postman.tar.gz
cd ~/.apps/postman
tar -xf postman*.tar.gz
cd ~

echo "22. haskell"
sudo dnf install stack
sudo dnf install haskell-platform
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ghcup install hls

echo ""
echo "Done"
echo ""

echo "What to do next?:"
echo "1. Install jetbrains-toolbox, scid vs. pc, discord (~/.apps/discord) and postman (~/.apps/postman)"
echo "2. Login to google chrome, spotify, discord, joplin and steam"
echo "3. Set up all projects you work on on with jetbrains' tools"
echo '4. Do a ":PlugInstall" in neovim'
echo "5. Make guake and terminal font jetbrains mono"
echo "6. Uninstall preinstalled apps you didn't want to have"
echo "7. Set up the printer"
echo "8. Rice the DE"

echo ""

echo "Links:"
echo "1. https://www.jetbrains.com/toolbox-app/"
echo "2. http://scidvspc.sourceforge.net/"
