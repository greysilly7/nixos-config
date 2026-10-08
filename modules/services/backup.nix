_:
{
  den.aspects.backup = {
    nixos =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.restic
          pkgs.rclone
        ];

        sops.secrets."backup/restic_password" = { };

        systemd.tmpfiles.rules = [
          "d /var/lib/greyserver-backup 0700 root root -"
        ];

        services.restic.backups.greyserver = {
          repository = "rclone:greyserver-gdrive:greyserver";
          rcloneConfigFile = "/var/lib/greyserver-backup/rclone.conf";
          passwordFile = config.sops.secrets."backup/restic_password".path;
          paths = [ "/mnt/pool" ];
          exclude = [ "/mnt/pool/podman/**" ];
          initialize = false;
          pruneOpts = [
            "--keep-daily"
            "7"
            "--keep-weekly"
            "4"
            "--keep-monthly"
            "12"
          ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };
        };

        # Do not schedule failed jobs until the host-specific rclone OAuth
        # configuration has been provisioned outside the Nix store.
        systemd.services."restic-backups-greyserver" = {
          path = [ pkgs.rclone ];
          unitConfig = {
            ConditionPathExists = "/var/lib/greyserver-backup/rclone.conf";
            RequiresMountsFor = [ "/mnt/pool" ];
          };
        };
      };
  };
}
