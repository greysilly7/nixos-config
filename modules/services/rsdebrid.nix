_: {
  den.aspects.rsdebrid = {
    nixos =
      { pkgs, ... }:
      let
        dataDir = "/mnt/pool/rsdebrid";
        rsdebridPkg = pkgs.callPackage ../../packages/rsdebrid { };
        commonServiceConfig = {
          User = "rsdebrid";
          Group = "rsdebrid";
          WorkingDirectory = dataDir;
          Environment = [ "CONFIG_FILE=${dataDir}/config.toml" ];
          Restart = "on-failure";
          RestartSec = 5;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          PrivateTmp = true;
          ReadWritePaths = [ dataDir ];
        };
      in
      {
        users.groups.rsdebrid = { };
        users.users.rsdebrid = {
          isSystemUser = true;
          group = "rsdebrid";
          home = dataDir;
          createHome = false;
        };

        systemd.tmpfiles.rules = [
          "d ${dataDir} 0750 rsdebrid rsdebrid -"
          "d ${dataDir}/data 0750 rsdebrid rsdebrid -"
          "d ${dataDir}/data/incomplete 0750 rsdebrid rsdebrid -"
        ];

        systemd.services.rsdebrid-api = {
          description = "rsdebrid API";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = commonServiceConfig // {
            ExecStart = "${rsdebridPkg}/bin/rsdebrid-api";
          };
        };

        systemd.services.rsdebrid-worker = {
          description = "rsdebrid worker";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = commonServiceConfig // {
            ExecStart = "${rsdebridPkg}/bin/rsdebrid-worker";
          };
        };
      };
  };
}
