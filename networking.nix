{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "51.158.139.28"
 ];
    defaultGateway = "51.15.8.1";
    defaultGateway6 = {
      address = "fe80::235:1aff:fe3f:1b67";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
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
}
