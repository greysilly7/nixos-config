{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
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
                  crypttabExtraOpts = ["tpm2-device=auto" "tpm2-pcrs=0+2+7+12"];
                  # Uncomment the following line if you want to use a key file for LUKS
                  # keyFile = "/tmp/secret.key";
                };
                # Uncomment the following line if you want to use additional key files for LUKS
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  postCreateHook = ''
                    mntpoint=$(mktemp -d)
                    mount "/dev/mapper/crypted" "$mntpoint" -o subvol=/
                    trap 'umount $mntpoint; rm -rf $mntpoint' EXIT
                    btrfs subvolume snapshot -r $mntpoint/root $mntpoint/root-blank
                  '';
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "var/log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["compress=zstd" "noatime"];
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
      secondary = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              type = "8300";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/data";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
