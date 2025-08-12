#!/usr/bin/env bash
#
# https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL
#
# eval "$(/usr/sbin/wsl2-ssh-agent)"
#

user=$1

if [ -z "$user" ]; then
    echo 'No username provided'
    exit 1;
fi


if id "$user" >/dev/null 2>&1; then
    echo 'User already exists'
    exit 0;
fi

pacman -S --needed sudo xclip
groupadd sudo

# Enable sudoers: nano /etc/sudoers and uncomment lines %wheel ALL=(ALL) NOPASSWD: ALL and %sudo   ALL=(ALL) ALL
sudo sed 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL' /etc/sudoers
sudo sed 's/# %sudo ALL=(ALL:ALL) ALL/%sudo ALL=(ALL:ALL) ALL' /etc/sudoers

useradd -m -G wheel,sudo -s /bin/bash $user
passwd $user


# Add to /etc/wsl.conf
echo "[user]" >> /etc/wsl.conf
echo "default=$user" >> /etc/wsl.conf

# nano /etc/locale.gen
sudo sed 's/#da_DK.UTF-8 UTF-8/da_DK.UTF-8 UTF-8' /etc/locale.gen
sudo sed 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8' /etc/locale.gen

sudo locale-gen

sudo make --directory=/usr/share/git/credential/libsecret
# git config --global credential.helper /usr/share/git/credential/libsecret/git-credential-libsecret

sudo pacman -S --needed xclip

yay -S --needed wsl2-ssh-agent
