{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.impermanence.nixosModule];

  programs.fuse.userAllowOther = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories =
      [
        # Dirty fix for "no storage left on device" while rebuilding
        # It gets wiped anyway
        "/tmp"
        "/var/db/sudo"
      ]
      ++ lib.forEach ["nixos" "NetworkManager" "nix" "ssh" "secureboot"] (x: "/etc/${x}")
      ++ lib.forEach ["bluetooth" "cups" "fail2ban" "fprint" "fwupd" "libvirt" "nixos" "pipewire" "sddm" "sops-nix" "tailscale" "upower"] (x: "/var/lib/${x}");
    files = ["/etc/machine-id"];
  };

  # Ensure NetworkManager works correctly with impermanence
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];

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

  /*
  boot.initrd.postDeviceCommands = lib.mkBefore ''
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
  */
}
