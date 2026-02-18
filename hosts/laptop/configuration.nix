args@{
  config,
  pkgs,
  lib,
  flake,
  ...
}:
{
  imports = [
    ./disko.nix
    ../../system
    ../../modules
  ];

  staypls = {
    enable = true;
    dirs = [
      "/etc/ssh"
      "/etc/NetworkManager"
      "/etc/nix"
      "/var/lib/fprint"
      "/var/lib/pipewire"
      "/var/lib/bluetooth"
    ];
  };

  boot = {
    loader.efi.canTouchEfiVariables = true;
    blacklistedKernelModules = [ "k10temp" ];
    extraModulePackages = [ config.boot.kernelPackages.zenpower ];
    kernelModules = [ "zenpower" ];
    kernelParams = [ "amd_pstate=active" ];

    initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];
      after = [ "systemd-cryptsetup@crypted.service" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt

        # Mount the BTRFS root to /mnt to manipulate subvolumes
        mount -o subvol=/ /dev/mapper/crypted /mnt

        # Delete subvolumes under /root
        btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

        # Restore blank /root subvolume
        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Unmount /mnt and continue boot process
        umount /mnt
      '';
    };
  };

  environment.systemPackages =
    builtins.attrValues
      flake.packages."${pkgs.stdenv.hostPlatform.system}";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
  };

  hardware.amdgpu.initrd.enable = true;
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
