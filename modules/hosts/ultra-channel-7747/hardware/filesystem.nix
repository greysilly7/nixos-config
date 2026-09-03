_: {
  den.aspects.ultra-channel-7747-filesystem = {
    disko = import ./_disko.nix;

    nixos = {
      swapDevices = [
        {
          device = "/var/lib/swapfile";
          size = 16 * 1024;
        }
      ];
    };
  };
}
