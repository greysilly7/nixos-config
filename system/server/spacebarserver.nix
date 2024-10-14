{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Define the spacebar user
  users.users.spacebar = {
    isSystemUser = true;
    group = "spacebar";
    extraGroups = ["postgres"];
  };

  # Define the spacebar group
  users.groups.spacebar = {};

  # Define the systemd service for Spacebar
  systemd.services.spacebar = {
    description = "Spacebar Node.js application";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    before = ["nginx.service"];
    preStart = ''
      ${pkgs.coreutils}/bin/mkdir -p /var/lib/spacebar
      ${pkgs.coreutils}/bin/chown spacebar:spacebar /var/lib/spacebar
      ${pkgs.coreutils}/bin/chmod 700 /var/lib/spacebar

      # Create /var/lib directory and copy necessary files
      ${pkgs.coreutils}/bin/mkdir -p /var/lib/spacebar/assets/public
      ${pkgs.coreutils}/bin/cp ${inputs.spacebarchat}/assets/public/logo.png /var/lib/spacebar/assets/public/logo.png
      ${pkgs.coreutils}/bin/cp ${inputs.spacebarchat}/assets/public/TOS.txt /var/lib/spacebar/assets/public/TOS.txt
      ${pkgs.coreutils}/bin/chown -R spacebar:spacebar /var/lib/spacebar
      ${pkgs.coreutils}/bin/chmod -R 755 /var/lib/spacebar
    '';
    serviceConfig = {
      ExecStart = "${inputs.spacebarchat.packages.${"x86_64-linux"}.default}/bin/start-bundle";
      Restart = "always";
      User = "spacebar";
      Group = "spacebar";
      AmbientCapabilities = lib.mkForce "CAP_NET_BIND_SERVICE";
      CapabilityBoundingSet = lib.mkForce "CAP_NET_BIND_SERVICE";
      Environment = [
        "DATABASE=postgres://spacebar@127.0.0.1:5432/spacebar"
        "STORAGE_LOCATION=/var/lib/spacebar"
      ];
    };
  };

  # Nginx virtual host configuration for Spacebar
  services.nginx.virtualHosts = {
    "spacebar.greysilly7.xyz" = {
      forceSSL = true;
      enableACME = true;
      http2 = true;
      http3 = true;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:3001";
          extraConfig = ''
            proxy_no_cache 1;
            proxy_cache_bypass 1;

            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
        "/media" = {
          proxyPass = "http://127.0.0.1:8000";
        };
        "/assets/public/logo.png" = {
          root = "/var/lib/spacebar";
          tryFiles = "$uri /assets/public/logo.png";
        };
        "/tos.txt" = {
          root = "/var/lib/spacebar";
          tryFiles = "$uri /assets/public/TOS.txt";
        };
      };
    };
  };

  # OCI container configuration for Imagor
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      imagor = {
        image = "shumc/imagor";
        environmentFiles = [config.sops.secrets.imagorenv.path];
        ports = [
          "8000:8000"
        ];
      };
    };
  };
}
