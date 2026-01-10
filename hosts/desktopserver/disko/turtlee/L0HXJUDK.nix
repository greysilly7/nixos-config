{
  disko.devices.disk.sdc = {
    type = "disk";
    device = "/dev/disk/by-id/HUC10121CLAR1200_L0HXJUDK";
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
