#!/bin/sh

# This simple script is used to demo installing NixOS on a virtual machine.
# It uses a BIOS/GRUB install with no swap partition.
# Run it as root on the VM.
# You might have to change the drive below - for example, using qemu on mac,
# the disk is called /dev/sda, but under gnome-boxes on linux it is /dev/vda.

set -euxo pipefail

device="/dev/sda"  # if changing, also change bootloader in flake.nix

create_partitions () {
  parted $device -- mklabel msdos
  parted $device -- mkpart primary 1MiB 100%
}

create_and_mount_file_system () {
  mkfs.ext4 -L nixos "${device}1"
  # ensure that the label is ready before continuing
  udevadm control --reload-rules
  udevadm trigger
  udevadm settle
  mount /dev/disk/by-label/nixos /mnt
}

configure_nixos () {
  nixos-generate-config --root /mnt
  cp ./flake.nix /mnt/etc/nixos/
}

install_nixos () {
  nixos-install --no-root-password --flake /mnt/etc/nixos#nixos
}

create_partitions
create_and_mount_file_system
configure_nixos
install_nixos
