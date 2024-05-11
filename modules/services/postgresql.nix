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

      ensureDatabases = ["vaultwarden"];
      ensureUsers = [
        {
          name = "vaultwarden";
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
