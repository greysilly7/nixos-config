_: {
  den.aspects.greyserver-filesystem = {
    disko = import ./_disko.nix;

    nixos = {
      boot.supportedFilesystems = [
        "xfs"
        "zfs"
      ];

      # tank is NOT auto-imported or mounted for now. It is the pre-existing
      # bare-metal pool; import it by hand once the box boots:
      #   zpool import -f -d /dev/disk/by-id tank
      # then re-enable `boot.zfs.extraPools` + the `/mnt/pool` mount.
    };
  };
}
