{ config, ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      imagor = {
        image = "shumc/imagor";
        environmentFiles = [ config.sops.secrets."spacebar/imagorenv".path ];
        ports = [
          "8000:8000"
        ];
      };
    };
  };
}
