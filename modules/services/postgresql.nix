{
  config,
  lib,
  pkgs,
  inputs,
  sops,
  ...
}: {
  config = {
    services.postgresql = {
      enable = true;
      enableTCPIP = true;

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
        #type database  DBuser  auth-method
        local all       all     trust
      '';
    };
  };
}
