{
  description = "A barebones flake for a NixOS installation demo";

  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";

  outputs = { self, nixpkgs }: let
    system-config = { pkgs, ... }: {
      boot.loader.grub.enable = true;
      boot.loader.grub.version = 2;
      boot.loader.grub.device = "/dev/vda";

      networking.hostName = "nixos";

      time.timeZone = "Europe/London";

      users.users.nix = {
        password = "nix";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      environment.systemPackages = [ pkgs.nano ];

      system.stateVersion = "22.05";
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
