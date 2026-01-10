{
  disko.devices.disk.sde = {
    type = "disk";
    device = "/dev/disk/by-id/HUC10121CLAR1200_L0HZ7KRJ";
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
