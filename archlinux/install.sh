#!/bin/bash
#
# Run installation:
#
# - Connect to wifi via: `# iwctl station wlan0 connect WIFI-NETWORK`
# - Run: `# bash <(curl -sL https://github.com/cflye/dotfiles/blob/master/archlinux/install.sh)`

get_input() {
    title="$1"
    description="$2"

    input=$(dialog --clear --stdout --backtitle "$BACKTITLE" --title "$title" --inputbox "$description" 0 0)
    echo "$input"
}

get_password() {
    title="$1"
    description="$2"

    init_pass=$(dialog --clear --stdout --backtitle "$BACKTITLE" --title "$title" --passwordbox "$description" 0 0)
    : ${init_pass:?"password cannot be empty"}

    test_pass=$(dialog --clear --stdout --backtitle "$BACKTITLE" --title "$title" --passwordbox "$description again" 0 0)
    if [[ "$init_pass" != "$test_pass" ]]; then
        echo "Passwords did not match" >&2
        exit 1
    fi
    echo $init_pass
}

get_choice() {
    title="$1"
    description="$2"
    shift 2
    options=("$@")
    dialog --clear --stdout --backtitle "$BACKTITLE" --title "$title" --menu "$description" 0 0 0 "${options[@]}"
}

## - TODO: loadkeys dk


echo -e "\n### Checking UEFI boot mode"
if [ ! -f /sys/firmware/efi/fw_platform_size ]; then
    echo >&2 "You must boot in UEFI mode to continue"
    exit 2
fi

echo -e "\n### Setting up clock"
timedatectl set-ntp true
hwclock --systohc --utc


hostname=$(get_input "Hostname" "Enter hostname") || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

user=$(get_input "User" "Enter username") || exit 1
clear
: ${user:?"user cannot be empty"}

password=$(get_password "User" "Enter password") || exit 1
clear
: ${password:?"password cannot be empty"}


devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac | tr '\n' ' ')
read -r -a devicelist <<< $devicelist

device=$(get_choice "Installation" "Select installation disk" "${devicelist[@]}") || exit 1
clear


echo -e "\n### Setting up fastest mirrors"
reflector --latest 30 --sort rate --save /etc/pacman.d/mirrorlist

echo -e "\n### Setting up partitions"
umount -R /mnt 2> /dev/null || true


part_root="$(ls ${device}* | grep -E "^${device}p?1$")"
part_boot="$(ls ${device}* | grep -E "^${device}p?2$")"
part_swap="$(ls ${device}* | grep -E "^${device}p?3$")"


# Install essiential packages
pacstrap -K /mnt base base-devel linux linux-firmware sudo

#
# fdisk /dev/the_disk_to_be_partitioned
#
# o - clear partitions - create new MBR partition table
# n - p - 1 +512M       (boot)
# n - p - 2 +8G         (swap)
# n - p - 3 'the rest'  (linux)
#
# t - 1 - uefi
# t - 2 - swap
# 
# w - write partition table

echo '\n### Formatting partitions'
mkfs.fat  -F 32 $part_boot
mkfs.btrfs $part_root
mkswap $part_swap

echo '\n### Mounting partitions'
mount  $part_root /mnt
mount --mkdir  $part_boot /mnt/boot
swapon $part_swap


echo '\n### Installing bootloader'
# intel microcode updates used by grup
pacman -S grub-install efibootmgr intel-ucode
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux
grub-mkconfig -o /boot/grub/grub.cfg


# Setup packages
# TODO: check if xorg and xorg-server are needed for gnome ???

echo '\n### Installing additional packages'
pacman -S --needed xorg xorg-server gnome gnome-tweaks \
    git wl-clipboard ttf-jetbrains-mono-nerd\
    neovim \
    zoxide fzf fish starship \
    htop wget

systemctl enable gdm.service
systemctl enable NetworkManager.service

# keyboard layout
# vconsole.conf 
# KEYMAP=dk???

echo '\n### Setting system settings'
genfstab -L /mnt >> /mnt/etc/fstab
echo "FONT=jetbrains-mono-nerd" > /mnt/etc/vconsole.conf
echo "${hostname}" > /mnt/etc/hostname
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
echo "en_DK.UTF-8 UTF-8" >> /mnt/etc/locale.gen
ln -sf /usr/share/zoneinfo/Europe/Copenhagen /mnt/etc/localtime
hwclock --systohc
arch-chroot /mnt locale-gen


### Setup user
echo -e "\n### Creating user"
arch-chroot /mnt useradd -m -s /usr/bin/zsh "$user"
for group in wheel storage power network video input uinput; do
    arch-chroot /mnt groupadd -rf "$group"
    arch-chroot /mnt gpasswd -a "$user" "$group"
done
arch-chroot /mnt chsh -s /usr/bin/fish
echo "$user:$password" | arch-chroot /mnt chpasswd
arch-chroot /mnt passwd -dl root


# allow wheel group
# TODO: check if needed? EDITOR=nano visudo


# https://www.moonstreet.nl/post/arch-notes/
