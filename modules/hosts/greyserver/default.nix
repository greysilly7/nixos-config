{
  den,
  self,
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
        den.aspects.home-manager._.hmConfig
        den.aspects.secrets._.secretsHome
      ];
    };

    provides.greysilly7 = _: [
      den.aspects.system-type._.basic
      den.aspects.secrets._.secretsHome
      den.aspects.home-manager._.hmConfig
    ];

    nixos = {
      system.stateVersion = "26.11";
      networking.hostId = "deadbeef"; # Required by ZFS

      # Setup secrets
      sops.defaultSopsFile = self + "/secrets/greysilly7/secrets.yaml";

      # Enable networking for ethernet
      networking.useDHCP = true;

      # Bootloader configuration (EFI via systemd-boot)
      boot.loader.grub.enable = false;
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    };
  };
}
