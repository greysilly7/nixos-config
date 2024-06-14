{
  lib,
  inputs,
  ...
}: {
  config = {
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
        ExecStart = "${inputs.spacebar.packages.${"x86_64-linux"}.default}/bin/start-bundle";
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
  };
}
