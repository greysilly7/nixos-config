{
  den,
  ...
}:
{
  den.aspects.greyserver = {
    includes = [
      den.aspects.system-type._.basic
      den.aspects.avahi
      den.aspects.samba
      den.aspects.zfs
      den.aspects.podman
      den.aspects.greyserver-filesystem
      den.aspects.media
    ];

    provides.to-users = _: {
      includes = [
        den.aspects.system-type._.basic
      ];
    };

    provides.greysilly7 = _: [
      den.aspects.system-type._.basic
    ];

    nixos = {
      system.stateVersion = "24.05";
      networking.hostId = "deadbeef"; # Required by ZFS

      # Example sops configuration
      # sops.defaultSopsFile = self + "/secrets/greysilly7/secrets.yaml";
    };
  };
}
