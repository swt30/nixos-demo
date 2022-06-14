# A very basic NixOS configuration for a NixOS demo

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  
  networking.hostName = "nixos";
  
  time.timeZone = "Europe/London";
  
  users.users.nix = {
    password = "nix";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  
  environment.systemPackages = with pkgs; [
    nano
  ];
  
  system.stateVersion = "22.05";
}
