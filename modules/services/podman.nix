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

      # Useful for rootless podman
      hardware.nvidia-container-toolkit.enable = false; # Assuming no nvidia GPU by default for NAS
    };
  };
}
