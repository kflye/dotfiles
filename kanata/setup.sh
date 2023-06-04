#!/bin/bash

echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' >> /etc/udev/rules.d/95-kanata.rules

ln -s ~/.dotfiles/kanata/kanata.service ~/.config/systemd/user/kanata.service

wget https://github.com/jtroo/kanata/releases/download/v1.4.0-prerelease-2/kanata
chmod +x kanata
sudo mv kanata /usr/local/bin

systemctl --user start kanata.service
systemctl --user enable kanata.service
