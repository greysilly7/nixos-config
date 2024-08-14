{
  inputs,
  lib,
  ...
}: let
  device = "/dev/mapper/crypted";
in {
  imports = [inputs.impermanence.nixosModule];
  programs.fuse.userAllowOther = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories =
      [
        # dirty fix for "no storage left on device" while rebuilding
        # it gets wiped anyway
        "/tmp"
        "/var/db/sudo"
      ]
      ++ lib.forEach ["nixos" "NetworkManager" "nix" "ssh" "secureboot"] (x: "/etc/${x}")
      ++ lib.forEach ["bluetooth" "nixos" "pipewire" "libvirt" "fail2ban" "fprint" "sops-nix" "sddm" "cups" "upower" "fwupd"] (x: "/var/lib/${x}");
    files = ["/etc/machine-id"];
  };
  # for some reason *this* is what makes networkmanager not get screwed completely instead of the impermanence module
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
      set -x

      echo "Creating mount directory..."
      mkdir -p /mnt

      echo "Mounting BTRFS filesystem..."
      mount -t btrfs -o subvol=/ ${device} /mnt
      if [ $? -ne 0 ]; then
        echo "Failed to mount ${device} on /mnt"
        exit 1
      fi

      echo "Listing and deleting subvolumes..."
      btrfs subvolume list -o /mnt |
        grep 'path' |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "Deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
          if [ $? -ne 0 ]; then
            echo "Failed to delete subvolume /mnt/$subvolume"
          fi
        done

      echo "Deleting /root subvolume..."
      btrfs subvolume delete /mnt/root
      if [ $? -ne 0 ]; then
        echo "Failed to delete /mnt/root subvolume"
        exit 1
      fi

      echo "Restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root

      echo "Unmounting /mnt..."
      umount /mnt

      echo "Rollback completed successfully."
    '';
  };

  /*
  boot.initrd.postDeviceCommands = lib.mkBefore ''
    mkdir -p /mnt

    # We first mount the btrfs root to /mnt
    # so we can manipulate btrfs subvolumes.
    mount -o subvol=/ /dev/mapper/crypted /mnt

    # While we're tempted to just delete /root and create
    # a new snapshot from /root-blank, /root is already
    # populated at this point with a number of subvolumes,
    # which makes `btrfs subvolume delete` fail.
    # So, we remove them first.
    #
    # /root contains subvolumes:
    # - /root/var/lib/portables
    # - /root/var/lib/machines
    #
    # I suspect these are related to systemd-nspawn, but
    # since I don't use it I'm not 100% sure.
    # Anyhow, deleting these subvolumes hasn't resulted
    # in any issues so far, except for fairly
    # benign-looking errors from systemd-tmpfiles.
    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvolume..." &&
    btrfs subvolume delete /mnt/root

    echo "restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    # Once we're done rolling back to a blank snapshot,
    # we can unmount /mnt and continue on the boot process.
    umount /mnt
  '';
  */
}
