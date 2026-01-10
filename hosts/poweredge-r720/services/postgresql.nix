{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.postgresql = {
    enable = true;
    enableJIT = true;
    enableTCPIP = true;

    authentication = lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      local all       all     trust
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';

    initialScript = lib.mkIf config.services.spacebarchat-server.enable (
      pkgs.writeText "spacebar-init.sql" ''
        CREATE ROLE spacebar WITH LOGIN PASSWORD 'spacebar' CREATEDB;
        CREATE DATABASE sb OWNER spacebar;
        GRANT ALL PRIVILEGES ON DATABASE spacebar TO sb;
      ''
    );
  };
}
