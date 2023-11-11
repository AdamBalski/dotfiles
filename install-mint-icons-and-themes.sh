#!/bin/bash

sudo echo "Gain priviliges"

cd /home/$USER
mkdir temporary
cd temporary

echo "Copy icon packs"
git clone https://github.com/linuxmint/mint-x-icons
git clone https://github.com/linuxmint/mint-l-icons
git clone https://github.com/linuxmint/mint-y-icons

sudo mkdir -p /usr/share/icons
sudo cp -r mint-x-icons/usr/share/icons/* /usr/share/icons
sudo cp -r mint-l-icons/usr/share/icons/* /usr/share/icons
sudo cp -r mint-y-icons/usr/share/icons/* /usr/share/icons

echo "Copy themes"
git clone https://github.com/linuxmint/mint-themes
sudo mkdir -p /usr/share/themes
sudo cp -r mint-themes/files/usr/share/themes/* /usr/share/themes

cd ..
rm -rf temporary
