_: {
  den.aspects.qbittorrent = {
    nixos =
      { pkgs, config, ... }:
      let
        qbitWebuiPort = "8085";
        mediaPath = "/mnt/pool/arr";
      in
      {
        # SOPS Secrets for VPN configuration
        sops.secrets."protonvpn/wireguard_private_key" = { };
        sops.secrets."protonvpn/vpn_service_provider" = { };
        sops.secrets."protonvpn/vpn_type" = { };
        sops.secrets."protonvpn/vpn_port_forwarding" = { };

        sops.templates."protonvpn.env".content = ''
          VPN_SERVICE_PROVIDER=${config.sops.placeholder."protonvpn/vpn_service_provider"}
          SERVER_COUNTRIES=Canada
          VPN_TYPE=${config.sops.placeholder."protonvpn/vpn_type"}
          WIREGUARD_PRIVATE_KEY=${config.sops.placeholder."protonvpn/wireguard_private_key"}
          VPN_PORT_FORWARDING=${config.sops.placeholder."protonvpn/vpn_port_forwarding"}
          PORT_FOWARD_ONLY=${config.sops.placeholder."protonvpn/vpn_port_forwarding"}
        '';

        # Dynamically generate PUID and PGID for the media user at service startup
        systemd.services."generate-qbittorrent-env" = {
          description = "Generate qbittorrent PUID and PGID environment file";
          wantedBy = [ "podman-qbittorrent.service" ];
          before = [ "podman-qbittorrent.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = pkgs.writeShellScript "gen-qbit-env" ''
              PUID=$(${pkgs.coreutils}/bin/id -u media)
              PGID=$(${pkgs.coreutils}/bin/id -g media)
              echo "PUID=$PUID" > /var/lib/qbittorrent/uid.env
              echo "PGID=$PGID" >> /var/lib/qbittorrent/uid.env
            '';
          };
        };

        systemd.tmpfiles.rules = [
          "d /var/lib/protonvpn 0700 root root -"
          "d /var/lib/qbittorrent 0775 media media -"
        ];

        # ProtonVPN (Gluetun VPN Gateway) Container
        virtualisation.oci-containers.containers.protonvpn = {
          image = "docker.io/qmcgaw/gluetun:latest";
          environment = {
            TZ = config.time.timeZone;
            PORT_FORWARD_ONLY = "on";
            VPN_PORT_FORWARDING_UP_COMMAND = "/bin/sh -c '/usr/bin/wget -O- --retry-connrefused --post-data \"json={\\\"listen_port\\\":{{PORTS}}}\" http://127.0.0.1:${qbitWebuiPort}/api/v2/app/setPreferences 2>&1'";
            VPN_PORT_FORWARDING_DOWN_COMMAND = "/bin/sh -c '/usr/bin/wget -O- --retry-connrefused --post-data \"json={\\\"listen_port\\\":0,\\\"current_network_interface\\\":\\\"lo\\\"}\" http://127.0.0.1:${qbitWebuiPort}/api/v2/app/setPreferences 2>&1'";
          };
          environmentFiles = [ config.sops.templates."protonvpn.env".path ];
          volumes = [
            "/var/lib/protonvpn:/gluetun"
          ];
          ports = [
            "${qbitWebuiPort}:${qbitWebuiPort}"
          ];
          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--cap-add=NET_RAW"
            "--device=/dev/net/tun:/dev/net/tun"
          ];
        };

        # qBittorrent Container
        virtualisation.oci-containers.containers.qbittorrent = {
          image = "lscr.io/linuxserver/qbittorrent:latest";
          dependsOn = [ "protonvpn" ];
          environment = {
            TZ = config.time.timeZone;
            WEBUI_PORT = qbitWebuiPort;
          };
          environmentFiles = [
            "/var/lib/qbittorrent/uid.env"
          ];
          volumes = [
            "/var/lib/qbittorrent:/config"
            "${mediaPath}/downloads:${mediaPath}/downloads"
            "${mediaPath}/downloads:/downloads"
          ];
          extraOptions = [
            "--network=container:protonvpn"
          ];
        };
      };
  };
}
