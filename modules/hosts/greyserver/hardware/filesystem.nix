_: {
  den.aspects.greyserver-filesystem = {
    disko = import ./_disko.nix;

    nixos = {
      boot.supportedFilesystems = [ "btrfs" ];
      fileSystems = {
        "/persist".neededForBoot = true;
        "/var/log".neededForBoot = true;
        "/mnt/speedy" = {
          device = "/dev/disk/by-uuid/26e8e2bb-267b-4bdb-8268-20ae841f3b88";
          fsType = "btrfs";
          options = [
            "compress=zstd"
            "nofail"
          ];
        };
      };
      swapDevices = [
        { device = "/dev/zvol/zroot/swap"; }
      ];
    };
  };
}
