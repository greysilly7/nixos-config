_: {
  den.aspects.media._.torboxarr = {
    nixos =
      { pkgs, config, ... }:
      {
        # TorBoxarr Service
        sops.secrets."torbox/api_key" = { };
        sops.secrets."torboxarr/qbit_passsword" = { };
        sops.secrets."torboxarr/sab_api_key" = { };

        sops.templates."torboxarr.env".content = ''
          TORBOXARR_TORBOX_API_TOKEN=${config.sops.placeholder."torbox/api_key"}
          TORBOXARR_QBIT_PASSWORD=${config.sops.placeholder."torboxarr/qbit_passsword"}
          TORBOXARR_SAB_API_KEY=${config.sops.placeholder."torboxarr/sab_api_key"}
        '';

        systemd.services.torboxarr = {
          description = "TorBoxarr Download Backend";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            User = "root"; # Needs root to write to /mnt/pool as media group if necessary, or we can use a dedicated user
            Group = "media";
            UMask = "0002"; # Allow group write access so Arr apps can manipulate downloads
            StateDirectory = "torboxarr";
            WorkingDirectory = "/var/lib/torboxarr";
            EnvironmentFile = config.sops.templates."torboxarr.env".path;
            Environment = [
              "TORBOXARR_SERVER_BASE_URL=http://localhost:8085"
              "TORBOXARR_DATA_ROOT=/mnt/pool/arr"
              "TORBOXARR_DATABASE_PATH=/var/lib/torboxarr/torboxarr.db"
            ];
            ExecStart = "${pkgs.callPackage ../../../packages/torboxarr/default.nix { }}/bin/torboxarr";
            Restart = "on-failure";
          };
        };
      };
  };
}
