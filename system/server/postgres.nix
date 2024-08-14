{
  config,
  pkgs,
  lib,
  ...
}: {
  services.postgresql = {
    enable = true;
    ensureDatabases = ["spacebar"];
    enableTCPIP = true;
    # port = 5432;
    authentication = lib.mkOverride 10 ''
      #...
      #type database DBuser origin-address auth-method
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE spacebar WITH LOGIN PASSWORD '${config.sops.secrets.spacebardbpass}' CREATEDB;
      GRANT ALL PRIVILEGES ON DATABASE spacebar TO spacebar;
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
