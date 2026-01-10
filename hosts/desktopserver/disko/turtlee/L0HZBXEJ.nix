{
  disko.devices.disk.sdd = {
    type = "disk";
    device = "/dev/disk/by-id/HUC10121CLAR1200_L0HZBXEJ";
    content = {
      zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "zroot";
        };
      };
    };
  };
}
