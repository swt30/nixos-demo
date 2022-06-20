#!/bin/sh

# This simple script is used to demo installing NixOS on a virtual machine.
# It uses a BIOS/GRUB install with no swap partition.
# Run it as root on the VM.
# You might have to change the drive below - for example, using qemu on mac,
# the disk is called /dev/sda, but under gnome-boxes on linux it is /dev/vda.

create_partitions () {
  parted /dev/sda -- mklabel msdos
  parted /dev/sda -- mkpart primary 1MiB 100%
}

create_and_mount_file_system () {
  mkfs.ext4 -L nixos /dev/sda1
  sleep 3
  mount /dev/disk/by-label/nixos /mnt
}

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
