#!/bin/sh

# This is a very simple script used to demo installing
# NixOS on a virtual machine.
# It uses a BIOS/GRUB install, no swap space.
# Run it as root on the VM.

create_partitions () {
  parted /dev/sda -- mklabel msdos
  parted /dev/sda -- mkpart primary 1MiB 100%
}

create_and_mount_file_system () {
  mkfs.ext4 -L nixos /dev/sda1
  mount /dev/disk/by-label/nixos /mnt
}

# Set nixos configuration
configure_nixos () {
  nixos-generate-config --root /mnt
  cp ./configuration.nix /mnt/etc/nixos/configuration.nix
}

install_nixos () {
  nixos-install --no-root-password
}

create_partitions
create_and_mount_file_system
configure_nixos
install_nixos
