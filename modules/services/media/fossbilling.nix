_: {
  den.aspects.media._.fossbilling = {
    nixos =
      { pkgs, config, ... }:
      {
        systemd.tmpfiles.rules = [
          "d /var/lib/fossbilling 0750 root root -"
          "d /var/lib/fossbilling/db 0750 root root -"
          "d /var/lib/fossbilling/html 0750 root root -"
        ];

        sops.secrets."fossbilling/db_root_password" = { };
        sops.secrets."fossbilling/db_password" = { };

        sops.templates."fossbilling-db.env".content = ''
          MARIADB_ROOT_PASSWORD=${config.sops.placeholder."fossbilling/db_root_password"}
          MARIADB_DATABASE=fossbilling
          MARIADB_USER=fossbilling
          MARIADB_PASSWORD=${config.sops.placeholder."fossbilling/db_password"}
        '';

        sops.templates."fossbilling.env".content = ''
          MYSQL_HOST=fossbilling-db
          MYSQL_DATABASE=fossbilling
          MYSQL_USER=fossbilling
          MYSQL_PASSWORD=${config.sops.placeholder."fossbilling/db_password"}
        '';

        virtualisation.oci-containers.containers."fossbilling-db" = {
          image = "docker.io/library/mariadb:11";
          environmentFiles = [ config.sops.templates."fossbilling-db.env".path ];
          volumes = [
            "/var/lib/fossbilling/db:/var/lib/mysql"
          ];
        };

        virtualisation.oci-containers.containers.fossbilling = {
          image = "docker.io/fossbilling/fossbilling:latest";
          environmentFiles = [ config.sops.templates."fossbilling.env".path ];
          # Loopback-only publish; tailnet reachability on the same port
          # comes from the tailscale-serve-fossbilling unit below.
          ports = [ "127.0.0.1:8098:80" ];
          volumes = [
            "/var/lib/fossbilling/html:/var/www/html"
          ];
          dependsOn = [ "fossbilling-db" ];
        };

        systemd.services.tailscale-serve-fossbilling = {
          description = "Expose fossbilling on the tailnet via tailscale serve";
          after = [
            "tailscaled.service"
            "podman-fossbilling.service"
          ];
          wants = [ "tailscaled.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --tcp=8098 tcp://127.0.0.1:8098";
          };
        };
      };
  };
}
