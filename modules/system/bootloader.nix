{
  pkgs,
  lib,
  ...
}: {
  boot = {
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
    initrd = {
      verbose = false;
      systemd = {
        enable = true;
        tpm2.enable = true;
        emergencyAccess = false;
      };
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      # fix for suspend issues
      # see: https://www.reddit.com/r/archlinux/comments/e5oe4p/comment/fa8mzft/
      "snd_hda_intel.dmic_detect=0"
      "acpi_osi=linux"
      "nowatchdog"
      "8250.nr_uarts=0"
    ];
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
        memtest86.enable = true;
        configurationLimit = 3;
        editor = false;
      };
      # spam space to get to boot menu
      timeout = 0;
    };
    loader.efi.canTouchEfiVariables = true;
  };

  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a pristine state";
    wantedBy = ["initrd.target"];
    after = ["systemd-cryptsetup@crypted.service"];
    before = ["sysroot.mount"];
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
}
