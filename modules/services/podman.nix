_: {
  den.aspects.podman = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.podman-compose
        ];

        virtualisation.podman = {
          enable = true;
          dockerCompat = true;

          defaultNetwork.settings = {
            dns_enabled = true;

            # Enable IPv6 on the default Podman network.
            ipv6_enabled = true;

            # Podman will hand containers addresses from this subnet.
            subnets = [
              {
                subnet = "10.88.0.0/16";
                gateway = "10.88.0.1";
              }
              {
                subnet = "fd00:dead:beef::/64";
                gateway = "fd00:dead:beef::1";
              }
            ];
          };
        };

        # Required for routing container IPv6 traffic through the host.
        boot.kernel.sysctl = {
          "net.ipv6.conf.all.forwarding" = 1;
          "net.ipv6.conf.default.forwarding" = 1;
        };

        # Keep container images/layers off the small root pool, on tank instead
        virtualisation.containers.storage.settings.storage = {
          driver = "overlay";
          graphroot = "/mnt/pool/podman/storage";
          runroot = "/run/containers/storage";
        };

        systemd.tmpfiles.rules = [
          "d /mnt/pool/podman/storage 0710 root root -"
        ];

        virtualisation.containers.registries.search = [
          "docker.io"
          "ghcr.io"
          "quay.io"
        ];

        hardware.nvidia-container-toolkit.enable = false;
      };
  };
}