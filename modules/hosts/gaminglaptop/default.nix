{
  den,
  self,
  ...
}:
{
  den.aspects.gaminglaptop = {
    includes = [
      den.aspects.persist
      den.aspects.boot._.systemd
      den.aspects.hardware._.amdcpu._.enable
      den.aspects.hardware._.amdcpu._.performance
      den.aspects.hardware._.amdgpu._.enable
      den.aspects.system-type._.desktop._.gaming
      den.aspects.desktop-type._.window-manager._.niri
    ];
    provides.to-users =
      _:
      {
        includes = [
          den.aspects.persist
          den.aspects.system-type._.desktop._.gaming
          den.aspects.desktop-type._.window-manager._.niri

          den.aspects.spotify
        ];
      };

    provides.greysilly7 =
      _:
      [
        # den.aspects.den._.primary-user
        den.aspects.system-type._.desktop._.gaming
      ];
    nixos = {
      hardware.facter.reportPath = ./facter.json;
      sops.defaultSopsFile = self + "/secrets/greysilly7/secrets.yaml";

      # Homebrew erase my darlings boot script
      boot.initrd.systemd.services.rollback = {
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
  };
}
