{
  lib,
  ...
}: {
  services.postgresql = {
    enable = true;
    ensureDatabases = ["spacebar"];
    ensureUsers = [
      {
        name = "spacebar";
        ensureDBOwnership = true;
      }
    ];
    enableTCPIP = true;
    # port = 5432;
    authentication = lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      # local connections
      local all       all     trust
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
    identMap = ''
      # ArbitraryMapName systemUser DBUser
         superuser_map      root      postgres
         superuser_map      postgres  postgres
         # Let other names login as themselves
         superuser_map      /^(.*)$   \1
    '';
  };
}
