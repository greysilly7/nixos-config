_: {
  den.aspects.greyserver-filesystem = {
    disko = import ./_disko.nix;

    nixos =
      { lib, ... }:
      {
        boot.supportedFilesystems = [
          "xfs"
          "zfs"
        ];

        # tank is past its bootstrap phase (greyserver runs production
        # services off /mnt/pool), so auto-import it and mount the pool from
        # the `tank/root` legacy dataset via a declarative systemd mount.
        #
        # `nofail` keeps a missing/un-imported pool from wedging boot:
        # multi-user.target only *wants* mnt-pool.mount, and mount.zfs fails
        # fast when the dataset is absent. Services that actually need the
        # pool gate on it through RequiresMountsFor below.
        boot.zfs.extraPools = [ "tank" ];

        systemd.mounts = [
          {
            what = "tank/root";
            where = "/mnt/pool";
            type = "zfs";
            options = "nofail";
            wantedBy = [ "multi-user.target" ];
            after = [ "zfs-import.target" ];
            requires = [ "zfs-import.target" ];
          }
        ];

        # Every unit that reads or writes the pool must (a) wait for
        # mnt-pool.mount and (b) be stopped *before* it on `nixos-rebuild
        # switch`. Without this the switch can't restart the mount (podman
        # overlay mounts and open fds pin it), the stop fails, and every
        # pool-backed service cascades into a failed state.
        systemd.services = lib.genAttrs [
          "rsdebrid-api"
          "rsdebrid-worker"
          "spacebar-api"
          "spacebar-cdn"
          "spacebar-gateway"
          "spacebar-sfu"
          "spacebar-webrtc"
          "podman"
          "podman-qbittorrent"
          "podman-protonvpn"
          "podman-mousehole"
          "podman-spacebar-db"
          "podman-spacebar-imagor"
          "audiobook-sort"
          "navidrome"
        ] (_: { unitConfig.RequiresMountsFor = [ "/mnt/pool" ]; });
      };
  };
}
