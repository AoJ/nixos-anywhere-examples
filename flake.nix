{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.disko.url = github:nix-community/disko;
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, disko, ... }@attrs: {
    nixosConfigurations.b = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({modulesPath, ... }: {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            disko.nixosModules.disko
          ];
          disko.devices = import ./disk-config.nix {
            lib = nixpkgs.lib;
          };
          boot.loader.grub = {
            devices = [ "/dev/sda" ];
            efiSupport = true;
            efiInstallAsRemovable = true;
          };
          services.openssh.enable = true;

          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnNW8yO3PT7c4QPxhLhKi3pxOKghyjPJ3Lk+piPwgTW aoj@mac13"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMgO3NYNEVQCQUzViAKoBjOSERArP6FpLVVSydH+nXC1 aoj@k.nxiii.cc"
          ];
          
            networking = {
    nameservers = [ "51.158.139.28"
 ];
    defaultGateway = "51.15.8.1";
    defaultGateway6 = {
      address = "fe80::235:1aff:fe3f:1b67";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="51.15.8.8"; prefixLength=24; }
        ];
        ipv6.addresses = [
          { address="fe80::207:cbff:fe0b:853c"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "51.15.8.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = "fe80::235:1aff:fe3f:1b67"; prefixLength = 128; } ];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="00:07:cb:0b:85:3c", NAME="eth0"

  '';
        })
      ];
    };
  };
}
