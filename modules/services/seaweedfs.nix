{ pkgs, ... }: {
  den.aspects.seaweedfs = {
    nixos = {
      systemd.tmpfiles.rules = [
        "d /data/rsdebrid 0700 root root -"
      ];

      systemd.services.seaweedfs = {
        description = "SeaweedFS distributed file system";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.seaweedfs}/bin/weed server -dir=/data/rsdebrid -s3 -master.port=9333 -volume.port=8080 -filer.port=8888 -s3.port=8333";
          User = "root";
          Restart = "always";
        };
      };

      systemd.services.seaweedfs-bucket-init = {
        description = "Create rsdebrid bucket in SeaweedFS";
        after = [ "seaweedfs.service" ];
        wants = [ "seaweedfs.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "seaweedfs-bucket-init" ''
            for i in $(seq 1 30); do
              if ${pkgs.curl}/bin/curl -sf http://127.0.0.1:8333/ > /dev/null 2>&1; then
                break
              fi
              sleep 1
            done
            ${pkgs.curl}/bin/curl -sf -X POST http://127.0.0.1:8333/rsdebrid || true
          '';
        };
      };

      networking.firewall.allowedTCPPorts = [
        8333 # S3 API
      ];
    };
  };
}
