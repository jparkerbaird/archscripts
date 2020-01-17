# You should have the primary partitions set
    # and mirrors checked before this
    # and setup network connection


# --- Encrypt primary partiion and create logical partions ---
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 cryptlvm

# Create the logical partitions (swap and root)
pvcreate /dev/mapper/cryptlvm
vgcreate MyVolGroup /dev/mapper/cryptlvm
lvcreate -L 8G MyVolGroup -n swap
lvcreate -l 100%FREE  MyVolGroup -n root

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
pacstrap /mnt base base-devel linux linux-firmware dhcpcd wpa_supplicant netctl dialog vim grub lvm2 

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

