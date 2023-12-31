# Should be run right after arch-chroot
#########################################
# --- System config ---
ln -sf /usr/share/zoneinfo/US/Arizona /etc/localtime
hwclock --systohc
locale-gen

# Set locale:
echo LANG=en_US.UTF-8 > /etc/locale.conf

# Set keyboard:
# /etc/vconsole.conf
echo "KEYMAP=us" > /etc/vconsole.conf


# Set a hostname in /etc/hostname
echo "thinkpad" > /etc/hostname 

# Set hosts in /etc/hosts
echo 127.0.1.1 thinkpad.localdomain thinkpad > /etc/hosts


# Edit /ect/mkinitcpio.conf HOOKS
sed -i 's/HOOKS=(.*/HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 filesystems fsck)/' /etc/mkinitcpio.conf

# Run config with new hooks
mkinitcpio -P linux

# Edit /ect/default/grub
sed -i 's/.*GRUB_ENABLE_CRYPTODISK.*/GRUB_ENABLE_CRYPTODISK="y"/' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="cryptdevice=\/dev\/sda2\:cryptlvm"/' /etc/default/grub

grub-install --recheck /dev/sda
grub-mkconfig --output /boot/grub/grub.cfg

