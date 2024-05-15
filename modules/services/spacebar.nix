{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = {
    systemd.services.spacebar = {
      description = "Spacebar Node.js application";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        ExecStart = "${inputs.spacebar}/bin/start-spacebar";
        Restart = "always";
        User = "node";
        Group = "node";
        AmbientCapabilities = lib.mkForce "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = lib.mkForce "CAP_NET_BIND_SERVICE";
      };
    };
  };
}
