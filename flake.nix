{
  description = "A barebones flake for a NixOS installation demo";

  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";

  outputs = { self, nixpkgs }: let
    system-config = { pkgs, ... }: {
      boot.loader.grub.enable = true;
      boot.loader.grub.version = 2;
      boot.loader.grub.device = "/dev/sda";

      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      environment.systemPackages = [ pkgs.nano ];

      users.users.nix = {
        password = "nix";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    }; in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware-configuration.nix
          system-config
        ];
      };
    };
}
