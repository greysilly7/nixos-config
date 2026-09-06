let
  nvmeId = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
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
            swap = {
              size = "8G";
              content = {
                type = "swap";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
              };
            };
          };
        };
      };
    }
    // storageDisksAttrs;

    zpool = {
      tank = {
        type = "zpool";
        mode = "raidz2";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          mountpoint = "none";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            # No `mountpoint` here on purpose: disko then emits no fileSystems
            # entry, so a missing/un-imported tank cannot wedge boot. Mount it
            # manually (legacy mountpoint) once the pool is imported.
            options.mountpoint = "legacy";
          };

        };
      };
    };
  };
}
