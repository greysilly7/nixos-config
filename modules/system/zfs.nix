_: {
  den.aspects.zfs = {
    nixos = _: {
      boot.supportedFilesystems = [ "zfs" ];
      services.zfs.autoScrub.enable = true;
      services.zfs.trim.enable = true;
    };
  };
}
