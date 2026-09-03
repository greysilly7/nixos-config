{
  disko.devices = {
    disk.main = {
      # Single 60G guest disk. Replace with a stable /dev/disk/by-id/* path
      # once the machine is up if one is available.
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # SeaBIOS/legacy boot: 1M BIOS boot partition for GRUB's core.img.
          boot = {
            size = "1M";
            type = "EF02";
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
