#!/bin/sh

# This is a very simple script used to demo installing
# NixOS on a virtual machine.
# It uses a BIOS/GRUB install, no swap space.
# Run it as root on the VM.

# Create partitions
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MiB 100%
# Create and mount file system
mkfs.ext4 -L nixos /dev/sda1
mount /dev/disk/by-label/nixos /mnt
# Set nixos configuration
nixos-generate-config --root /mnt
cp configuration.nix /mnt/etc/nixos/configuration.nix
# Install
nixos-install
