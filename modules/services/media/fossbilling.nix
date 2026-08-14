_: {
  den.aspects.media._.fossbilling = {
    nixos = _: {
      systemd.tmpfiles.rules = [
        "d /var/lib/fossbilling 0750 root root -"
        "d /var/lib/fossbilling/db 0750 root root -"
        "d /var/lib/fossbilling/html 0750 root root -"
      ];

      virtualisation.oci-containers.containers."fossbilling-db" = {
        image = "docker.io/library/mariadb:11";
        environment = {
          MARIADB_ROOT_PASSWORD = "fossbilling";
          MARIADB_DATABASE = "fossbilling";
          MARIADB_USER = "fossbilling";
          MARIADB_PASSWORD = "fossbilling";
        };
        volumes = [
          "/var/lib/fossbilling/db:/var/lib/mysql"
        ];
      };

      virtualisation.oci-containers.containers.fossbilling = {
        image = "docker.io/fossbilling/fossbilling:latest";
        environment = {
          MYSQL_HOST = "fossbilling-db";
          MYSQL_DATABASE = "fossbilling";
          MYSQL_USER = "fossbilling";
          MYSQL_PASSWORD = "fossbilling";
        };
        ports = [ "8098:80" ];
        volumes = [
          "/var/lib/fossbilling/html:/var/www/html"
        ];
        dependsOn = [ "fossbilling-db" ];
      };
    };
  };
}
