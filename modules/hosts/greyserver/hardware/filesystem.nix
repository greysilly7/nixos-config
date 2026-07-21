_: {
  den.aspects.greyserver-filesystem = {
    disko = import ./_disko.nix;

    nixos = {
      fileSystems = {
        "/persist".neededForBoot = true;
        "/var/log".neededForBoot = true;
        "/data/rsdebrid" = {
          device = "tank/rsdebrid";
          fsType = "zfs";
        };
      };
      swapDevices = [
        { device = "/dev/zvol/zroot/swap"; }
      ];
    };
  };
}
