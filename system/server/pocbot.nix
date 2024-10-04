{config, ...}: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      imagor = {
        image = "ghcr.io/openplayverse/pocbot:latest ";
        environmentFiles = [config.sops.secrets.pocbot_token.path];
      };
    };
  };
}
