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
        sops.secrets."airvpn/wireguard_private_key" = { };
        sops.secrets."airvpn/wireguard_public_key" = { };
        sops.secrets."airvpn/vpn_service_provider" = { };
        sops.secrets."airvpn/vpn_type" = { };
        sops.secrets."airvpn/wireguard_addresses" = { };
        sops.secrets."airvpn/ports" = { };
        sops.secrets."mousehole/webui_password" = { };

        sops.templates."airvpn.env".content = ''
          VPN_SERVICE_PROVIDER=${config.sops.placeholder."airvpn/vpn_service_provider"}
          VPN_TYPE=${config.sops.placeholder."airvpn/vpn_type"}
          WIREGUARD_PRIVATE_KEY=${config.sops.placeholder."airvpn/wireguard_private_key"}
          WIREGUARD_PUBLIC_KEY=${config.sops.placeholder."airvpn/wireguard_public_key"}
          WIREGUARD_ADDRESSES=${config.sops.placeholder."airvpn/wireguard_addresses"}
          FIREWALL_VPN_INPUT_PORTS=${config.sops.placeholder."airvpn/ports"}
        '';

        sops.templates."mousehole.env".content = ''
          MOUSEHOLE_AUTH_PASSWORD=${config.sops.placeholder."mousehole/webui_password"}
          MOUSEHOLE_ALLOWED_HOSTS=greyserver:5010
          MOUSEHOLE_ALLOWED_ORIGINS=http://greyserver:5010
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
          "d /var/lib/airvpn 0700 root root -"
          "d /var/lib/qbittorrent 0775 media media -"
          "d /var/lib/mousehole 0775 media media -"
        ];

        # airvpn (Gluetun VPN Gateway) Container
        virtualisation.oci-containers.containers.airvpn = {
          image = "docker.io/qmcgaw/gluetun:latest";
          environment = {
            TZ = config.time.timeZone;
            VPN_PORT_FORWARDING_UP_COMMAND = "/bin/sh -c '/usr/bin/wget -O- --retry-connrefused --post-data \"json={\\\"listen_port\\\":{{PORTS}},\\\"current_network_interface\\\":\\\"tun0\\\"}\" http://127.0.0.1:${qbitWebuiPort}/api/v2/app/setPreferences 2>&1'";
            VPN_PORT_FORWARDING_DOWN_COMMAND = "/bin/sh -c '/usr/bin/wget -O- --retry-connrefused --post-data \"json={\\\"listen_port\\\":0,\\\"current_network_interface\\\":\\\"lo\\\"}\" http://127.0.0.1:${qbitWebuiPort}/api/v2/app/setPreferences 2>&1'";
          };
          environmentFiles = [ config.sops.templates."airvpn.env".path ];
          volumes = [
            "/var/lib/airvpn:/gluetun"
          ];
          # Loopback-only publish; tailnet reachability on the same ports
          # comes from the tailscale-serve-qbittorrent unit below. 8889
          # (VPN HTTP proxy) is loopback-only, no direct tailnet access needed.
          ports = [
            "127.0.0.1:${qbitWebuiPort}:${qbitWebuiPort}"
            "127.0.0.1:5010:5010"
            "127.0.0.1:8889:8889"
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
          dependsOn = [ "airvpn" ];
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
            "--network=container:airvpn"
          ];
        };

        systemd.services.tailscale-serve-qbittorrent = {
          description = "Expose qbittorrent + mousehole on the tailnet via tailscale serve";
          after = [
            "tailscaled.service"
            "podman-airvpn.service"
          ];
          wants = [ "tailscaled.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = [
              "${pkgs.tailscale}/bin/tailscale serve --bg --tcp=${qbitWebuiPort} tcp://127.0.0.1:${qbitWebuiPort}"
              "${pkgs.tailscale}/bin/tailscale serve --bg --tcp=5010 tcp://127.0.0.1:5010"
            ];
          };
        };

        virtualisation.oci-containers.containers.mousehole = {
          image = "docker.io/tmmrtn/mousehole:edge"; # Or docker.io/tmart/mousehole
          dependsOn = [ "airvpn" ];
          environment = {
            TZ = config.time.timeZone;
            MOUSEHOLE_PORT = "5010"; # Ensure this doesn't conflict
          };
          environmentFiles = [
            config.sops.templates."mousehole.env".path
          ];
          volumes = [
            "/var/lib/mousehole:/data" # Persists the mam_id internally
          ];
          extraOptions = [
            "--network=container:airvpn"
          ];
        };
      };
  };
}
