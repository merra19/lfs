#!/bin/sh

mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars

grub-install  --recheck --efi-directory=/boot/EFI
efibootmgr

grub-mkconfig -o /boot/grub/grub.cfg
