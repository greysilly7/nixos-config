_: {
  den.aspects.zfs = {
    nixos =
      { pkgs, ... }:
      {
        boot.kernelPackages = pkgs.linuxPackages;
        boot.supportedFilesystems = [ "zfs" ];
        services.zfs.autoScrub.enable = true;
        services.zfs.trim.enable = true;
      };
  };
}
