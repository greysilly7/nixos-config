{pkgs, ...}: {
  config = {
    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      settings = {
        listen_addresses = "*";
      };

      ensureDatabases = ["vaultwarden" "spacebar"];
      ensureUsers = [
        {
          name = "vaultwarden";
          ensureDBOwnership = true;
        }
        {
          name = "spacebar";
          ensureDBOwnership = true;
        }
      ];

      authentication = pkgs.lib.mkOverride 10 ''
        local all       all     trust
            
        #type database DBuser origin-address auth-method
        # ipv4
        host  all      all     127.0.0.1/32   trust
        # ipv6
        host all       all     ::1/128        trust      '';
    };
  };
}
