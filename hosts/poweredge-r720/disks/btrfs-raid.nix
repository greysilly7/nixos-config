{
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            root = {
              # in order for btrfs raid to work we need to do this
              size = "100%";
            };
          };
        };
      };
      disk2 = {
        type = "disk";
        device = "/dev/sdc";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                  "-m raid1"
                  "-d raid1"
                  "/dev/sdb1"
                ];
                mountpoint = "/turtle";
                mountOptions = [
                  "rw"
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
