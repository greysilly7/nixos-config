{
  config,
  lib,
  inputs,
  ...
}: {
  users.users.spacebar = {
    isSystemUser = true;
    group = "spacebar";
    extraGroups = ["postgres"];
  };

  users.groups.spacebar = {};

  systemd.services.spacebar = {
    description = "Spacebar Node.js application";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
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

  system.activationScripts.spacebarStorage = {
    text = ''
      mkdir -p /var/lib/spacebar
      chown spacebar:spacebar /var/lib/spacebar
      chmod 700 /var/lib/spacebar
    '';
  };

  services.nginx.virtualHosts = {
    "spacebar.greysilly7.xyz" = {
      forceSSL = true;
      enableACME = true;
      http2 = true;
      http3 = true;
      extraConfig = ''
        add_header_redefinition Cache-Control 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
      };
    };
  };
}
