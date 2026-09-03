{
  den,
  self,
  ...
}:
{
  den.aspects.ultra-channel-7747 = {
    includes = [
      den.aspects.system-type._.basic
      den.aspects.boot._.grub
      den.aspects.tailscale._.server
      den.aspects.fail2ban
      den.aspects.ultra-channel-7747-filesystem
      den.aspects.nntp-proxy
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

    nixos =
      { lib, ... }:
      {
        system.stateVersion = "26.11";
        networking.hostName = "ultra-channel-7747";

        # Setup secrets
        sops.defaultSopsFile = self + "/secrets/greysilly7/secrets.yaml";

        # SeaBIOS guest: GRUB on the disk, no EFI. disko registers the target
        # disk in boot.loader.grub.devices via the EF02 partition, so force the
        # legacy single-device option off to avoid a duplicate in mirroredBoots.
        boot.loader.grub = {
          device = lib.mkForce "nodev";
          efiSupport = false;
          useOSProber = false;
          # GRUB output to the Proxmox serial console as well as VGA.
          extraConfig = ''
            serial --unit=0 --speed=115200
            terminal_input --append serial
            terminal_output --append serial
          '';
        };

        # Proxmox serial console: kernel + boot logs on ttyS0, and a
        # serial-getty. tty0 kept first so VGA still works if attached.
        boot.kernelParams = [
          "console=tty0"
          "console=ttyS0,115200"
        ];

        # VM guest: no physical hardware, so skip firmware blobs entirely
        # (also dodges the large linux-firmware download over a flaky link).
        hardware.enableAllFirmware = false;
        hardware.enableRedistributableFirmware = false;
        services.fwupd.enable = false;

        # Static networking (Proxmox guest, no DHCP). Interface matched by MAC
        # since NixOS predictable naming will not call it "eth0".
        networking.useDHCP = false;
        systemd.network = {
          enable = true;
          networks."10-wan" = {
            matchConfig.MACAddress = "bc:24:11:7b:4b:14";
            address = [
              "192.166.82.3/24"
              "2a13:9500:3f:f::/64"
            ];
            routes = [
              { Gateway = "192.166.82.1"; }
              # IPv6 gateway sits outside the on-link prefix, so mark it on-link.
              {
                Gateway = "2602:294:0:fe66::1";
                GatewayOnLink = true;
              }
            ];
            linkConfig.RequiredForOnline = "routable";
          };
        };

        # Virtualised guest: modules needed to find the root disk in initrd.
        boot.initrd.availableKernelModules = [
          "ata_piix"
          "ahci"
          "virtio_pci"
          "virtio_scsi"
          "virtio_blk"
          "sd_mod"
          "sr_mod"
        ];
      };
  };
}
