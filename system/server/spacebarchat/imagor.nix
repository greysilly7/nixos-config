{config, ...}: {
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

  services.nginx.virtualHosts."spacebar.greysilly7.xyz".locations = {
    "/media" = {
      proxyPass = "http://127.0.0.1:8000";
    };
  };
}
