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

        # Setup secrets.
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

        # Proxmox serial console: kernel + boot logs on ttyS0, with VGA
        # retained on tty0.
        boot.kernelParams = [
          "console=tty0"
          "console=ttyS0,115200"
        ];

        # VM guest: no physical hardware, so skip firmware blobs entirely.
        hardware.enableAllFirmware = false;
        hardware.enableRedistributableFirmware = false;
        services.fwupd.enable = false;

        # Static networking. Match the interface by MAC because predictable
        # interface naming will not necessarily call it "eth0".
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
              {
                Gateway = "192.166.82.1";
              }

              # IPv6 gateway sits outside the on-link prefix.
              {
                Gateway = "2602:294:0:fe66::1";
                GatewayOnLink = true;
              }
            ];

            linkConfig.RequiredForOnline = "routable";
          };
        };

        # Virtualized guest: modules needed to find the root disk in initrd.
        boot.initrd.availableKernelModules = [
          "ata_piix"
          "ahci"
          "virtio_pci"
          "virtio_scsi"
          "virtio_blk"
          "sd_mod"
          "sr_mod"
        ];

        services.caddy = {
          enable = true;

          # Permit on-demand certificates only for Harbor control-plane
          # and tenant hosts.
          globalConfig = ''
            on_demand_tls {
              ask http://127.0.0.1:5555
            }
          '';

          virtualHosts = {
            # Caddy on-demand TLS authorization endpoint.
            "http://127.0.0.1:5555".extraConfig = ''
              @allowed expression `{query.domain}.endsWith(".harbor.greysilly7.xyz") || {query.domain} == "harbor.greysilly7.xyz"  || {query.domain}.endsWith(".aiostreams.greysilly7.xyz") || {query.domain} == "news.greysilly7.xyz"`
              respond @allowed 200
              respond 403
            '';

            # Tenant ingress:
            # front-tier Caddy -> Proxmox-side Caddy over Tailscale.
            "*.harbor.greysilly7.xyz".extraConfig = ''
              tls {
                on_demand
              }

              reverse_proxy http://100.111.93.13:80
            '';

            "*.aiostreams.greysilly7.xyz".extraConfig = ''
              tls {
                on_demand
              }

              reverse_proxy http://100.111.93.13:80
            '';

            # Harbor control plane:
            # front-tier Caddy -> Proxmox-side Caddy -> CT 103.
            #
            # The Proxmox-side Caddy must define:
            # harbor.greysilly7.xyz -> 192.168.2.103:3000
            "harbor.greysilly7.xyz".extraConfig = ''
              reverse_proxy http://100.111.93.13:80
            '';
          };
        };

        # Tier-1 ingress + ACME HTTP-01 challenges.
        # 563/80/443 may also be opened by the nntp-proxy aspect.
        # List options merge, so duplicates are harmless.
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        networking.firewall.allowedUDPPorts = [
          443
        ];

        # services.tailscale.enable is already true via
        # den.aspects.tailscale._.server.
      };
  };
}