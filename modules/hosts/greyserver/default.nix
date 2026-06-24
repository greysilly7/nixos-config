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
      den.aspects.tailscale._.server
    ];

    provides = rec {
      to-users = _: {
        includes = [
          den.aspects.system-type._.basic
          den.aspects.home-manager._.hmConfig
          den.aspects.secrets._.secretsHome
          den.aspects.dev._.nixfmt
          den.aspects.dev._.nixd
          den.aspects.editors._.neovim
        ];
      };
      greysilly7 = u: (to-users u).includes;
    };

    nixos = {
      system.stateVersion = "26.11";
      networking.hostName = "greyserver";
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
