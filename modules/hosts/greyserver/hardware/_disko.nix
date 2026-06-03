let
  datasets = {
    root = "/";
    nix = "/nix";
    persist = "/persist";
    var_log = "/var/log";
    pool = "/mnt/pool";
  };

  # Replace these with your actual disk IDs
  diskIds = [
    "/dev/disk/by-id/CHANGE_ME_DISK_1"
    "/dev/disk/by-id/CHANGE_ME_DISK_2"
    "/dev/disk/by-id/CHANGE_ME_DISK_3"
    "/dev/disk/by-id/CHANGE_ME_DISK_4"
    "/dev/disk/by-id/CHANGE_ME_DISK_5"
    "/dev/disk/by-id/CHANGE_ME_DISK_6"
  ];

  # Helper to generate disk configurations dynamically
  mkDisk = id: index: {
    name = "disk${builtins.toString index}";
    value = {
      type = "disk";
      device = id;
      content = {
        type = "gpt";
        partitions = {
          # We create an EFI System Partition on every drive for redundancy
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              # Mount the first disk's ESP to /boot, and others to /boot1, /boot2, etc.
              mountpoint = "/boot${if index == 0 then "" else builtins.toString index}";
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
  };

  indexedDisks = builtins.genList (i: mkDisk (builtins.elemAt diskIds i) i) (builtins.length diskIds);
in
{
  disko.devices = {
    disk = builtins.listToAttrs indexedDisks;
    zpool = {
      zroot = {
        type = "zpool";
        mode = "raidz2"; # 6 drives is perfect for raidz2 (2 drives parity, 4 for data)
        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = builtins.mapAttrs (_: mountpoint: {
          type = "zfs_fs";
          inherit mountpoint;
          options.mountpoint = "legacy";
        }) datasets;
      };
    };
  };
}
