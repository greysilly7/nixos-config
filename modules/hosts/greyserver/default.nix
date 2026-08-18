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
      den.aspects.vaultwarden
      den.aspects.fail2ban
      den.aspects.qbittorrent
      den.aspects.mousesearch
      den.aspects.rsdebrid
      den.aspects.spacebar
      den.aspects.hardware._.amdcpu._.enable
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
      { pkgs, ... }:
      {
        system.stateVersion = "26.11";
        networking.hostName = "greyserver";
        networking.hostId = "deadbeef"; # Required by ZFS

        # Setup secrets
        sops.defaultSopsFile = self + "/secrets/greysilly7/secrets.yaml";

        # Enable networking for ethernet
        networking.networkmanager.enable = true;

        # Open port 25565 for Minecraft
        networking.firewall.allowedTCPPorts = [ 25565 ];
        networking.firewall.allowedUDPPorts = [ 25565 ];

        # Bootloader configuration (EFI via systemd-boot)
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        boot.kernelParams = [
          "amd_pstate=active"
          "amdgpu.runpm=0"
        ];

        boot.loader.systemd-boot.memtest86.enable = true;

        environment.systemPackages = [ pkgs.tmux ];
      };
  };
}
