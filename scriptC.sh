# Should be run after exiting to the live usb
#############################################

# Close out
umount -R /mnt/boot
umout -R /mnt
cryptsetup close cryptlvm

