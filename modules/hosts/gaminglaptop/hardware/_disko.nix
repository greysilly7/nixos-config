{
  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/nvme-WD_PC_SN740_SDDPNQD-512G-1002_24180T805385";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "2048M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              # Uncomment the following line if you want to use a password file for LUKS
              # passwordFile = "/tmp/secret.key"; # Interactive
              settings = {
                allowDiscards = true;
                crypttabExtraOpts = [
                  "tpm2-device=auto"
                  "tpm2-pcrs=0+2+7+12"
                ];
                keyFile = "/tmp/secret.key";
              };
              # Uncomment the following line if you want to use additional key files for LUKS
              # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                postCreateHook = ''
                  mntpoint=$(mktemp -d)
                  mount "/dev/mapper/crypted" "$mntpoint" -o subvol=/
                  trap 'umount $mntpoint; rm -rf $mntpoint' EXIT
                  btrfs subvolume snapshot -r $mntpoint/root $mntpoint/root-blank
                '';
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/var/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "16G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
