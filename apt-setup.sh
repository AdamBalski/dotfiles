#!/bin/bash

number=0
print_header() {
    number=$((number + 1))
    echo "$number. $1"
}

warning() {
    echo "WARNING: $1"
}

endl() {
    echo
}

print_header 313

# Warning
warning "This may overwrite your dotfiles and install some new packages"
endl

# Gain root priviliges
sudo echo "Installing dotfiles for the user $USER"

print_header "Updating system"
sudo apt update && sudo apt -y upgrade

print_header "Installing: git, wget, python3"
sudo apt -y install git wget python3

read -p "What editor do you use? (e.g.: 'nvim'): " editor
git config --global core.editor "$editor"

read -p "What is your username in git (e.g.: 'AdamBalski')?: " username
git config --global user.name "$username"

echo "What is your git email (e.g.: 'adambalski1@gmail.com')?"
read email
git config --global user.email "$email"

cd /home/$USER
git clone https://www.github.com/AdamBalski/dotfiles

echo "Do you wish to install cinnamon?"
installcinnamon() {
    sudo apt -y install cinnamon-core --no-install-recommends
    sudo systemctl enable lightdm
    sudo systemctl enable dbus
}
select yn in "Yes" "No"; do
    case $yn in
        Yes ) installcinnamon; break;;
        No ) break;;
    esac
done

print_header "zsh" 
sudo apt -y install zsh
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ln -sf "/home/$USER/dotfiles/zshrc" ~/.zshrc 

print_header "nvim config"
ln -sf "/home/$USER/dotfiles/nvim/lua"           /home/$USER/.config/nvim/lua
ln -sf "/home/$USER/dotfiles/init.lua"           /home/$USER/.config/nvim/init.lua
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

print_header "tmux and ~/.tmux.conf"
sudo apt -y install tmux
mkdir -p /home/$USER/.config/tmux/
git clone https://github.com/wfxr/tmux-power /home/$USER/.config/tmux/tmux-power
ln -sf "$gitpath/dotfiles/tmux.conf" ~/.tmux.conf

print_header "libinput-gestures"
sudo gpasswd -a $USER input
sudo apt-get -y install wmctrl xdotool
sudo apt-get -y install libinput-tools
git clone https://github.com/bulletmark/libinput-gestures.git /home/$USER/libinput-gestures
cd /home/$USER/libinput-gestures
sudo make install
libinput-gestures-setup autostart start
ln -sf /home/$USER/dotfiles/libinput-gestures.conf ~/.config/libinput-gestures.conf
libinput-gestures-setup service
libinput-gestures-setup autostart
cd ~


print_header "guake"
sudo apt -y install guake
print_header "kolourpaint"
sudo apt -y install kolourpaint
print_header "joplin"
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
print_header "libreoffice suit"
sudo apt -y install libreoffice
print_header "okular, eog and mpv"
sudo apt -y install okular eog mpv
print_header "htop"
sudo apt -y install htop
print_header "latex"
sudo apt -y install texlive-full

print_header "linuxbrew"
sudo apt-get -y install build-essential procps curl file git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
print_header "nvim via linuxbrew"
brew install neovim
sudo ln -sf "$/home/linuxbrew/.linuxbrew/bin/nvim" "/bin/nvim"
print_header "node via linuxbrew"
sudo brew install node
ln -sf "$/home/linuxbrew/.linuxbrew/bin/node" "/bin/node"
sudo ln -sf "$/home/linuxbrew/.linuxbrew/bin/npx" "/bin/npx"
sudo ln -sf "$/home/linuxbrew/.linuxbrew/bin/npm" "/bin/npm"
print_header "maven via linuxbrew"
brew install maven
sudo ln -sf "$/home/linuxbrew/.linuxbrew/bin/mvn" "/bin/mvn"

print_header "discord via flatpak"
flatpak install flathub com.discordapp.Discord
print_header "spotify via flatpak"
flatpak install flathub com.spotify.Client
print_header "postman via flatpak"
flatpak install flathub com.getpostman.Postman
print_header "Chrome via flatpak"
flatpak install flathub com.google.Chrome

print_header "Set-up the JetbrainsMono fonts"
sudo cp -a $gitpath/dotfiles/jebtrains-mono-medium-nerd-font.ttf /usr/share/fonts
fc-cache -f -v

echo ""
echo "Done, enjoy!"
echo ""

echo "What to do next?:"
echo "1. Install jetbrains-toolbox, scid vs. pc"
echo "2. Login to google chrome, spotify, discord, joplin, configure calibre"
echo "3. Set up all projects you work on on with jetbrains' tools"
echo "4. Make sure which neovim outputs the homebrew dir"
echo '5. Do a ":PackerInstall" in neovim'
echo "6. Make guake and terminal font jetbrains mono"
echo "7. Uninstall preinstalled apps you don't want to have"
echo "8. Set up the printer"
echo "9. Docker"
echo "10. Rice the DE"

echo ""
echo "Links:"
echo "1. https://www.jetbrains.com/toolbox-app/"
echo "2. http://scidvspc.sourceforge.net/"
echo "3. https://docs.docker.com/engine/install/debian/"
echo "4. https://docs.docker.com/compose/install/linux/#install-using-the-repository"
echo "5. https://github.com/vmatare/thinkfan/issues/45#issuecomment-658830584"
