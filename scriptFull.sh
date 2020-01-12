# You should have the primary partitions set
    # and mirrors checked before this
    # and setup network connection


# Encrypt primary partiion and create logical partions
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 cryptlvm

# Create the logical partitions (swap and root)
pvcreate /dev/mapper/cryptlvm
vgcreate MyVolGroup /dev/mapper/cryptlvm
lvcreate -L 8G MyVolGroup -n swap
lvcreate -L 32G MyVolGroup -n root

# Format the logical partitions
mkfs.ext4 /dev/MyVolGroup/root
mkswap /dev/MyVolGroup/swap

# Format the boot partition
mkfs.ext4 /dev/sda1

# Put the logical partitions into use
mount /dev/MyVolGroup/root /mnt
swapon /dev/MyVolGroup/swap

# Mount the boot partition
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Install initial packages
pacstrap /mnt base linux linux-firmware dhcpcd wpa_supplicant netctl dialog vim grub lvm2


# Fstab
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

#---------------------------------------

ln -sf /usr/share/zoneinfo/US/Arizona /etc/localtime
hwclock --systohc
locale-gen

# Set locale:
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set keyboard:
# /etc/vconsole.conf
echo "KEYMAP=us" > /etc/vconsole.conf


# Set a hostname in /etc/hostname
echo "archlinux" > /etc/hostname 

# Set hosts in /etc/hosts
echo 127.0.1.1 archlinux.localdomain archlinux > /etc/hosts


# Edit /ect/mkinitcpio.conf HOOKS
sed -i 's/HOOKS=(.*/HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 filesystems fsck)/' /etc/mkinitcpio.conf

# Run config with new hooks
mkinitcpio -P linux

# Edit /ect/default/grub
sed -i 's/.*GRUB_ENABLE_CRYPTODISK.*/GRUB_ENABLE_CRYPTODISK="y"/' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="cryptdevice=\/dev\/sda2\:cryptlvm"/' /etc/default/grub

grub-install --recheck /dev/sda
grub-mkconfig --output /boot/grub/grub.cfg

