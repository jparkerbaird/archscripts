# Make sure you put a password on root

# Create non root user
useradd -m -g users -G wheel -s /bin/bash <username>
passwd <username>
# If I remember correctly you may have to edit a file to allow sudo access

# Install additional packages:
pacman -S man-db man-pages xorg-server xorg-xinit ttf-dejavu ttf-bitstream-vera i3-wm i3-status dmenu xterm pulseaudio pulseaudio-alsa pulseaudio-bluetooth pavucontrol
