_: {
  den.aspects.mousesearch = {
    nixos =
      { pkgs, config, ... }:
      let
        dataDir = "/var/lib/mousesearch";
        port = "5000";
        mousesearchPkg = pkgs.callPackage ../../packages/mousesearch { };
      in
      {
        sops.secrets."mousesearch/quart_secret_key" = { };
        sops.secrets."mousesearch/mam_id" = { };

        sops.templates."mousesearch.env".content = ''
          QUART_SECRET_KEY=${config.sops.placeholder."mousesearch/quart_secret_key"}
          MAM_ID=${config.sops.placeholder."mousesearch/mam_id"}
          DATA_PATH=${dataDir}
          ADDRESS=0.0.0.0
          PORT=${port}
          # qBittorrent WebUI runs in the protonvpn container netns and is
          # published on the host at this port (see qbittorrent.nix).
          TORRENT_CLIENT_URL=http://127.0.0.1:8085
        '';

        users.groups.mousesearch = { };
        users.users.mousesearch = {
          isSystemUser = true;
          group = "mousesearch";
          home = dataDir;
          createHome = false;
        };

        systemd.tmpfiles.rules = [
          "d ${dataDir} 0750 mousesearch mousesearch -"
        ];

        systemd.services.mousesearch = {
          description = "MouseSearch - MyAnonamouse search UI";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            User = "mousesearch";
            Group = "mousesearch";
            WorkingDirectory = dataDir;
            EnvironmentFile = config.sops.templates."mousesearch.env".path;
            ExecStart = "${mousesearchPkg}/bin/mousesearch";
            Restart = "on-failure";
            RestartSec = 5;
            NoNewPrivileges = true;
            ProtectSystem = "strict";
            PrivateTmp = true;
            ReadWritePaths = [ dataDir ];
          };
        };
      };
  };
}
