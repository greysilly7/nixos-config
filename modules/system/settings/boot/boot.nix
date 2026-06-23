_: {
  den.aspects.boot = {
    _.grub = _: {
      nixos =
        { lib, ... }:
        {
          boot.loader.grub = {
            enable = lib.mkDefault true;
            useOSProber = lib.mkDefault true;
          };
        };
    };

    _.systemd = _: {
      nixos =
        { lib, ... }:
        {
          boot = {
            initrd = {
              systemd.enable = lib.mkDefault true;
            };
            loader = {
              systemd-boot.enable = lib.mkDefault true;
              efi.canTouchEfiVariables = lib.mkDefault true;
            };
          };
        };
    };
  };
}
