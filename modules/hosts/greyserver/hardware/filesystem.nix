_: {
  den.aspects.greyserver-filesystem = {
    disko = import ./_disko.nix;

    nixos = {
      boot.supportedFilesystems = [ "btrfs" ];
      fileSystems = {
        "/persist".neededForBoot = true;
        "/var/log".neededForBoot = true;
        "/mnt/speedy" = {
          device = "/dev/disk/by-uuid/5f3ecae9-52eb-4ccd-bd49-e6d04e5e6b01";
          fsType = "btrfs";
          options = [
            "compress=zstd"
            "nofail"
            "noatime"
          ];
        };
      };
      swapDevices = [
        { device = "/dev/zvol/zroot/swap"; }
      ];
    };
  };
}
