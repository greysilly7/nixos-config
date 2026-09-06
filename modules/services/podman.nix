_: {
  den.aspects.podman = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [
        pkgs.podman-compose
      ];

      virtualisation.podman = {
        enable = true;
        dockerCompat = true; # Create a `docker` alias for podman
        defaultNetwork.settings.dns_enabled = true;
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

      # Useful for rootless podman
      hardware.nvidia-container-toolkit.enable = false; # Assuming no nvidia GPU by default for NAS
    };
  };
}
