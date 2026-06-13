let
  rootDatasets = {
    root = "/";
    nix = "/nix";
    persist = "/persist";
    var_log = "/var/log";
  };

  nvmeId = "/dev/disk/by-id/nvme-SKHynix_HFS256GEJ4X112N_4YC5N026115505I1R";

  storageDiskIds = [
    "/dev/disk/by-id/wwn-0x5000cca01d2069fc"
    "/dev/disk/by-id/wwn-0x5000cca0726c4420"
    "/dev/disk/by-id/wwn-0x5000cca0726c4548"
    "/dev/disk/by-id/wwn-0x5000cca0726f2630"
    "/dev/disk/by-id/wwn-0x5000cca0726f5c3c"
    "/dev/disk/by-id/wwn-0x5000cca0726f9d7c"
  ];

  mkStorageDisk = id: index: {
    name = "storage${builtins.toString index}";
    value = {
      type = "disk";
      device = id;
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank";
            };
          };
        };
      };
    };
  };

  indexedStorageDisks = builtins.genList (i: mkStorageDisk (builtins.elemAt storageDiskIds i) i) (
    builtins.length storageDiskIds
  );
  storageDisksAttrs = builtins.listToAttrs indexedStorageDisks;
in
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = nvmeId;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    }
    // storageDisksAttrs;

    zpool = {
      zroot = {
        type = "zpool";
        mode = ""; # single disk
        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = builtins.mapAttrs (_: mountpoint: {
          type = "zfs_fs";
          inherit mountpoint;
          options.mountpoint = "legacy";
        }) rootDatasets;
      };

      tank = {
        type = "zpool";
        mode = "raidz2";
        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/mnt/pool";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
