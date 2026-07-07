_: {
  den.aspects.media._.decypharr = {
    nixos = _: {
      virtualisation.oci-containers.containers.decypharr = {
        image = "cy01/blackhole:latest";
        ports = [ "8282:8282" ];
        volumes = [
          "/mnt/:/mnt:rshared"
          "/var/lib/decypharr:/app" # config.json must be in this directory
        ];
        extraOptions = [
          "--device=/dev/fuse:/dev/fuse:rwm"
          "--cap-add=SYS_ADMIN"
          "--security-opt=apparmor=unconfined"
        ];
      };
    };
  };
}
