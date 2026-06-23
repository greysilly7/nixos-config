_: {
  den.aspects.hardware = {
    _.firmware = _: {
      nixos =
        { lib, ... }:
        {
          services.fwupd.enable = lib.mkDefault true;
          hardware = {
            enableAllFirmware = lib.mkDefault true;
            enableRedistributableFirmware = lib.mkDefault true;
          };
        };

      persist.directories = [
        {
          directory = "/var/lib/fwupd";
          user = "fwupd-refresh";
          group = "fwupd-refresh";
        }
      ];
    };
  };
}
